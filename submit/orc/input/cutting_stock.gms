Scalar
    c0      'cost per bundle'                                                   /20/
    M       'max number of output coils that can be processed in one month'     /10/
    L       'amount lost each time an input coil is cut'                        /1/;

Sets
    i       'number of input coils'                         /1*2/
    j       'number of output coils'                        /1*3/
    h       'number of input coils of type i purchased'     /1*20/
    t       'number of periods we consider'                 /1*3/
    s       'output coil size'                              /small, medium, large/
    a(j)    'number for small output coils'                 /1*1/
    b(j)    'number for medium output coils'                /2*2/
    k(j)    'number for large output coils'                 /3*3/
    small(s)  'small size'                                  /small/
    medium(s) 'medium size'                                 /medium/
    large(s)  'large size'                                  /large/;

Parameters
IW(i) Input Coil Widths
     /1         3
      2         0/

c(i) Input Coil Costs
     /1         5
      2        15/

n(i) Input Coil per Bundle
     /1        2
      2        1/

OW(j) Output Coil Widths
     /1         2
      2         3
      3        30/

P(j)  Product coil Price
     /1        10
      2        20
      3        40/

Cap(i) The inventory capacity for each input coil
     /1        30
      2        20/

O(s) inventory capacity for output coil
    /small       50
     medium      60
     large       40/

Table d(j,t) Expected Demand
         1         2           3
1       10         0           0
2        0        20           0
3        0         0           0;


Variables
x(i,t)        'number of input coil i purchased in month t'
y(i,h,j,t)    'number of output coil j produced by input coil i in month t'
sold(j,t)     'number of output coil j sold in month t'
r(i,t)        'total number of unused input coil i in month t'
Out(j,t)      'number of inventory for type j output coil from month t'
In(i,t)       'number of inventory for type i input coil from month t'
BP(t)         'number of bundles purchased in month t'
v(i,t)        'number of individual input coil i purchased in month t'
count(i,h,t)
z total profit;

binary variables
count;

integer variables
x
y
sold
BP
r
In
Out
v;

Equations
profit              the objective function
totOut(t)      the total output constraint
cut(i,t)            the cutting constraint
inputLimA(i,t)     the process for the input constraint
inputLimB(i,t)     the limit for the input inventory
storageA(j,t)
storageB(i,t)
storageS(small,t)
storageM(medium,t)
storageL(large,t)
orderA(j,t)
orderB(j,t)
chckWdth(i,j,h,t)
chckShve(i,j,t)
chckWste(i,h,t)
blahA(i,h,t)
blahB(i,h,t)
blahC(i,t)
bundle(i,t)         the bundle constraint;

*------------------
* Set upper bounds
*------------------
x.up(i,t) = 1000000;
y.up(i,h,j,t) = 1000000;
sold.up(j,t) = d(j,t);
r.up(i,t) = 1000000;
BP.up(t) = 1000000;
v.up(i,t) = 1000000;

*------------------
* Set lower bounds
*------------------
In.lo(i,t) = 0;
Out.lo(j,t) = 0;
r.lo(i,t) = 0;
sold.lo(j,t) = 0;
v.lo(i,t) = 0;
BP.lo(t) = 0;
x.lo(i,t) = 0;
y.lo(i,h,j,t) = 0;

*-----------
* Equations
*-----------
profit .. z =e= sum(t, sum(j,P(j)*sold(j,t))- BP(t)*c0 - sum(i,v(i,t)*c(i)));

totOut(t) .. sum((i,j,h),y(i,h,j,t)) =l= M;

cut(i,t) .. (In(i,t-1) + x(i,t))*IW(i) =g= sum ((j,h), OW(j)*y(i,h,j,t)) + (sum((j,h), y(i,h,j,t)$(IW(i) - OW(j) gt L)) -x(i,t))*L + r(i,t)*IW(i);

chckWste(i,h,t).. IW(i) =g= sum(j, y(i,h,j,t)*OW(j)) + (sum(j, y(i,h,j,t))-1)*L;

storageA(j,t) .. Out(j,t-1) + sum((i,h), y(i,h,j,t)) - sold(j,t) =g= Out(j,t);
storageB(i,t) .. r(i,t) =g= In(i,t);

storageS(small,t) .. sum(a(j), Out(j,t)) =l= O(small);
storageM(medium,t) .. sum(b(j), Out(j,t)) =l= O(medium);
storageL(large,t) .. sum(k(j), Out(j,t)) =l= O(large);

orderA(j,t) .. Out(j,t-1) + sum((i,h), y(i,h,j,t)) =g= sold(j,t);
orderB(j,t) .. sold(j,t) =l= d(j,t);

inputLimA(i,t) .. In(i,t) =l= Cap(i);

inputLimB(i,t) .. r(i,t) =l= x(i,t) + In(i, t-1);

bundle(i,t) .. BP(t)*n(i) + v(i,t) =e= x(i,t);

chckWdth(i,j,h,t) .. y(i,h,j,t)$(OW(j) ge IW(i)+1) =e= 0;

chckShve(i,j,t) .. sum(h, y(i,h,j,t))$(IW(i) - OW(j) le L) =l= In(i,t-1) + x(i,t);

blahA(i,h,t) .. sum(j, y(i,h,j,t)) =l= 10000001*count(i,h,t);
blahB(i,h,t) .. sum(j, y(i,h,j,t)) =g= count(i,h,t);
blahC(i,t) .. sum(h, count(i,h,t)) + r(i,t) =e= In(i,t-1) + x(i,t);

Model coil /all/;
coil.optfile = 1;

Solve coil using mip maximizing z;
