Scalar c0 cost per bundle /400000/
    M  Maxiumum number of input coils that can be processed in any given month (regardless of length) /220/
    L  Amount lost each time a Input Coil is cut /3/;

Sets
  i  Number of Input Coils  /1*3/
  j  Number of Output Coils /1*9/
  h  Number of input coils of type i bought /1*440/
  t  Number of Periods we consider /1*12/
  s  Size /small, medium, large/
  a(j)  number for small /1*2/
  b(j)  number for medium /3*7/
  k(j)  number for large  /8*9/
  small(s) small size /small/
  medium(s) medium size /medium/
  large(s) large size /large/;

Parameters
IW(i) Input Coil Widths
   /1     3500
    2     5000
    3     6500 /

c(i) Input Coil Costs
  /1     45500
   2     65000
   3     84500/

n(i) Input Coil per Bundle
  /1     4
   2     2
   3     2/

OW(j) Output Coil Widths
  /1     750
   2     800
   3     1000
   4     1250
   5     1500
   6     1800
   7     2000
   8     2250
   9     2500/

P(j)  Product coil Price
  /1     11350
   2     12100
   3     14600
   4     18225
   5     21850
   6     26200
   7     28700
   8     32275
   9     35850/

O(s) inventory capacity for output coil
 /small     50
  medium   220
  large     40/



Cap(i) The inventory capacity for each input coil
  /1     300
   2     200
   3     200/;

Table d(j,t) Expected Demand
      1      2     3     4     5     6    7    8    9   10    11    12
1     0      5     0    10     0     0   10   12    5    0    12     0
2     0      0     7    12     0    15   12    0    0    6     0     0
3    44     61    68    60    62    40   68   70   61   69    60    60
4    40     50    19    23    30    52   19   15   46   66    68    67
5    47     55    60    55    23    32   45   55   72   72    75    62
6     8      0     4     2     7     0    3    4    7    3     5     0
7    35     37    30    28    26    21   18   20   55   65    60    30
8     5      5     7     0     0     0    0    5    7    9    10     7
9     1      1     4     0     0     0    4    0    8    2    2      2;

Variables
x(i,t)     'number of input coil i purchased in month t'
y(i,h,j,t)    'number of output coil j produced by input coil i in month t'
sold(j,t)  'number of output coil j sold in month t'
r(i,t)     'total number of unused input coil i in month t'
Out(j,t)   'number of inventory for type j output coil from month t'
In(i,t)    'number of inventory for type i input coil from month t'
BP(t)      'number of bundles purchased in month t'
v(i,t)     'number of individual input coil i purchased in month t'
z total profit;

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
profit        the objective function
totOut(t)   the total output constraint
cut(i,t)      the cutting constraint
inputLimA(i,t)  the process for the input constraint
inputLimB(i,t)  the limit for the input inventory
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
bundle(i,t)      the bundle constraint;

*------------------
* Set upper bounds
*------------------
x.up(i,t) = 1000000;
y.up(i,h,j,t) = 1000000;
sold.up(j,t) = 1000000;
r.up(i,t) = 1000000;
BP.up(t) = 1000000;
v.up(i,t) = 1000000;

*------------------
* Set lower bounds
*------------------
In.l(i,t) = 0;
Out.l(j,t) = 0;
r.l(i,t) = 0;
sold.l(j,t) = 0;

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

Model coil /all/;

Solve coil using mip maximizing z;
