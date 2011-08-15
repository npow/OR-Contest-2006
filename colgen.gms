Sets
i   'number of input coils'   /1*1/
j   'widths'                  /w1*w4/
t   'months'                  /1*2/;

Scalar
c0 cost per bundle /20/
M  Maxiumum number of input coils that can be processed in any given month (regardless of length) /1/
L  Amount lost each time a Input Coil is cut /1/;

Parameter
r    raw width /100/

c(i) Input Coil Costs
     /1         5/

OW(j) width
    /w1  45
     w2  36
     w3  31
     w4  14/

Price(j)  Product coil Price
    /w1        10
     w2        20
     w3        40
     w4        50/;

Table d(j,t) Expected Demand
       1   2   
w1     0   0  
w2     0   0 
w3     0   0  
w4     0   0;

* Gilmore-Gomory column generation algorithm

Set  p        possible patterns  /p1*p1000/
     pp(p)    dynamic subset of p
Parameter
     aip(j,p,t) number of width j in pattern growing in p;


* Master model
Variable
xp(p,t)                 'patterns used'
z                       'objective variable';

Integer variable xp; xp.up(p,t) = sum(j, d(j,t));
Integer variables
sold;

Variable  y(j,t) new pattern;
Integer variable y; y.up(j,t) = ceil(r/OW(j));

Equation
numpat                  'number of patterns used'
demand(j,t)             'meet demand'
totalOutput(t);
*soldConstraintA(j,t)    'number of output coil of type j sold'
*soldConstraintB(j,t);   

numpat..     z =e= sum((pp,t), xp(pp,t));

*numpat..     z =e= sum(t, sum(j, Price(j)*sold(j,t)));
*numpat..     z =e= sum(t, sum(j, Price(j)*sold(j,t)) - sum((i,pp), xp(pp,t)*c(i)));

*totalOutput(t).. sum((j,pp), xp(pp,t)*y(j,t)) =l= M;

*demand(j,t)..  sum(pp, aip(j,pp,t)*xp(pp,t)) =g= sold(j,t);
*soldConstraintA(j,t).. sold(j,t) =l= d(j,t);
*soldConstraintB(j,t).. sold(j,t) =g= 0;

demand(j,t)..  sum(pp, aip(j,pp,t)*xp(pp,t)) =e= d(j,t);

model master /numpat, demand/

* Pricing problem - Knapsack model

Equation
defobj(t)
knapsack(t)       'knapsack constraint';

defobj(t)..     z =e= 1 - sum(j, demand.m(j,t)*y(j,t));
knapsack(t)..   sum(j, OW(j)*y(j,t) + (y(j,t)-1)*L) =l= r;

model pricing /defobj, knapsack/;

* Initialization - the initial patterns have a single width
pp(p) = ord(p)<=card(j);
aip(j,pp(p),t)$(ord(j)=ord(p)) = floor(r/OW(j));
*display aip;

Scalar done  loop indicator /0/
Set    pi(p) set of the last pattern; pi(p) = ord(p)=card(pp)+1;

option optcr=0,limrow=0,limcol=0,solprint=off;

While(not done and card(pp)<card(p),
   solve master using rmip minimizing z;
   solve pricing using mip minimizing z;

* pattern that might improve the master model found?
   if(z.l < -0.001,
      aip(j,pi,t) = round(y.l(j,t));
      pp(pi) = yes; pi(p) = pi(p-1);
   else
      done = 1;
   );
);
display 'lower bound for number of rolls', master.objval;

option solprint=on;
solve master using mip minimizing z;

Parameter patrep Solution pattern report
          demrep Solution demand supply report;

patrep('# produced',p,t) = round(xp.l(p,t));
patrep(j,p,t)$patrep('# produced',p,t) = aip(j,p,t);
patrep(j,'total',t) = sum(p, patrep(j,p,t));
patrep('# produced','total',t) = sum(p, patrep('# produced',p,t));

demrep(j,'produced',t) = sum(p,patrep(j,p,t)*patrep('# produced',p,t));
demrep(j,'demand',t) = d(j,t);
demrep(j,'over',t) = demrep(j,'produced',t) - demrep(j,'demand',t);

display patrep, demrep;

