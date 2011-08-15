Scalar c_0 cost per bundle /400000/
       M  Maxiumum number of input coils that can be processed in any given month (regardless of length) /220/
       L  Amount lost each time a Input Coil is cut /3/;

Sets
     i  Number of Input Coils  /1*3/
     j  Number of Output Coils /1*9/
     h  Number of input coils of type i bought /1*440/
     t  Number of Periods we consider /1*12/
     s  Size /small, medium, large/
     g  number of inventory room /1*3/
     a(j)  number for small /1*2/
     b(j)  number for medium /3*7/
     k(j)  number for large  /8*9/
     small(s) small size /small/
     medium(s) medium size /medium/
     large(s) large size /large/;

Parameters
IW(i) Input Coil Widths
      /1        3500
       2        5000
       3        6500 /

c(i) Input Coil Costs
     /1        45500
      2        65000
      3        84500/

n(i) Input Coil per Bundle
     /1        4
      2        2
      3        2/

OW(j) Output Coil Widths
     /1        750
      2        800
      3        1000
      4        1250
      5        1500
      6        1800
      7        2000
      8        2250
      9        2500/

P(j)  Product coil Price
     /1        11350
      2        12100
      3        14600
      4        18225
      5        21850
      6        26200
      7        28700
      8        32275
      9        35850/

O(s) inventory capacity for output coil
    /small        50
     medium      220
     large        40/



Cap(g) The inventory capacity for each input coil
     /1        300
      2        200
      3        200/;

Table d(j,t) Expected Demand
         1         2           3          4          5          6          7          8          9         10          11        12
1        0         5           0          10         0          0          10         12         5          0          12         0
2        0         0           7          12         0          15         12         0          0          6          0          0
3        44        61          68         60         62         40         68         70         61         69         60         60
4        40        50          19         23         30         52         19         15         46         66         68         67
5        47        55          60         55         23         32         45         55         72         72         75         62
6        8         0           4          2          7          0          3          4          7          3          5          0
7        35        37          30         28         26         21         18         20         55         65         60         30
8        5         5           7          0          0          0          0          5          7          9          10         7
9        1         1           4          0          0          0          4          0          8          2          2          2  ;

Variables
x(i,t) number of input coil i purchased in month t
y(i,h,j,t) number of output coil j produced by input coil i in month t
sold(j,t)
r(i,t) total number of unused input coil i in month t
Out(j,t) number of inventory for type j output coil from month t
In(i,t) number of inventory for type i input coil from month t
BP(t)  number of Bundles purchased in month t
v(i,t) number of individual input coil i purchased in month t
*numCut(i,t)
z total profit;

integer variables
x
y
BP
sold
r
*numCut
v;

Equations
profit              the objective function
totalOutput(t)      the total output constraint
Cut(i,t)            the cutting constraint
*cut(i,h,t)
InputProcess(g,t)     the process for the input constraint
InputLimit(i,t)     the limit for the input inventory
StorageConstraintA(j,t)
StorageConstraintB(i,t)
StorageProcessA(small,t)
StorageProcessB(medium,t)
StorageProcessC(large,t)
OrderConstraintA(j,t)
OrderConstraintB(j,t)
checkWidth(i,j,h,t)
checkShaveA(i,j,t)
*checkShaveB(i,j,t)
*numCutConstraintA(i,j,t)
*numCutConstraintB(i,t)
SoldConstraint(j,t)
checkWaste(i,h,t)
*newCut(i,t)
test(i,t)
*blah(i,h,j,t)
Bundle(i,t)         the bundle constraint;

x.up(i,t) = 1000000;
y.up(i,h,j,t) = 1000000;
sold.up(j,t) = 1000000;
r.up(i,t) = 1000000;
BP.up(t) = 1000000;
*numCut.up(i,t) = 1000000;
v.up(i,t) = 1000000;

profit .. z =e= sum(t, sum(j,P(j)*sold(j,t))- BP(t)*c_0 - sum(i,v(i,t)*c(i)));

totalOutput(t) .. sum((i,j,h),y(i,h,j,t)) =l= M;

cut(i,t) .. (In(i,t-1) + x(i,t))*IW(i) =g= sum ((j,h), OW(j)*y(i,h,j,t)) + (sum((j,h), y(i,h,j,t)$(IW(i) - OW(j) gt L)) -x(i,t))*L + r(i,t)*IW(i);
*cut(i,h,t) .. (In(i,t-1) + x(i,t))*IW(i) =g= sum (j, OW(j)*y(i,h,j,t)) + (sum(j, y(i,h,j,t)$(IW(i) - OW(j) gt L)) -x(i,t))*L + r(i,t)*IW(i);

checkWaste(i,h,t).. IW(i) =g= sum(j, y(i,h,j,t)*OW(j)) + (sum(j, y(i,h,j,t))-1)*L;

StorageConstraintA(j,t) .. Out(j,t-1) + sum((i,h), y(i,h,j,t)) - sold(j,t) =g= Out(j,t);
StorageConstraintB(i,t) .. r(i,t) =g= In(i,t);

StorageProcessA(small,t) .. sum(a(j), Out(j,t)) =l= O(small);
StorageProcessB(medium,t) .. sum(b(j), Out(j,t)) =l= O(medium);
StorageProcessC(large,t) .. sum(k(j), Out(j,t)) =l= O(large);

OrderConstraintA(j,t) .. Out(j,t-1) + sum((i,h), y(i,h,j,t)) =g= sold(j,t);
OrderConstraintB(j,t) .. sold(j,t) =l= d(j,t);

InputProcess(g,t) .. sum(i, In(i,t)) =l= Cap(g);

InputLimit(i,t) .. r(i,t) =l= x(i,t) + In(i, t-1);

Bundle(i,t) .. BP(t)*n(i) + v(i,t) =e= x(i,t);

checkWidth(i,j,h,t) .. y(i,h,j,t)$(OW(j) ge IW(i)+1) =e= 0;

checkShaveA(i,j,t) .. sum(h, y(i,h,j,t))$(IW(i) - OW(j) le L) =l= In(i,t-1) + x(i,t);

*newCut(i,t).. x(i,t)*IW(i) =g= sum((j,h), OW(j)*y(i,h,j,t)) + r(i,t)*IW(i);

*checkShaveB(i,j,t)$(IW(i) - OW(j) gt L) .. bogus(i,t) =e= 1;
*numCutConstraintA(i,j,t) .. numCut(i,t) =l= ;
*numCutConstraintB(i,t) .. numCut(i,t) =l= sum(j, y(i,j,t));

SoldConstraint(j,t) .. sold(j,t) =g= 0;

test(i,t) .. r(i,t) =g= 0;

*blah(i,h,j,t) .. y(i,h,j,t)$(ord(h) gt ord (x(i,t))) =e= 0;

Model coil /all/;

Solve coil using mip maximizing z;
