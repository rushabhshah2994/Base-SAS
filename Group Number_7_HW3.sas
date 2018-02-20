/* Question 1*/

Data a1;
input week	sales;
cards;
1	160
2	390
3	800
4	995
5	1250
6	1630
7	1750
8	2000
9	2250
10	2500
;run;

proc print data = a1;run;

data new;set a1;
cums + sales;lags =lag(cums);sqrs=lags*lags;
proc reg outest=coeff;model sales = lags sqrs;run;
proc print data=coeff;run;

data a2;set coeff;
M=(-lags-(sqrt(lags*lags-4*intercept*sqrs)))/(2*sqrs);
p=intercept/m;
q=p+lags;
tstar=log(q/p)*1/(p+q);
sstar=M*(p+q)*(p+q)/(4*q);
proc print;run;

data new2;set new;
M=26225.01;p=0.020581;q=0.33071;
array nt{10} t1-t10 (0 0 0 0 0 0 0 0 0 0);
do i = 1 to 10;
Predicted_Sales=p*(M-nt[i])+ q*(nt[i]/M)*(M-nt[i]);
nt[i]=nt[i]+Predicted_Sales;
end;
proc gplot;plot Predicted_Sales*week sales*week/overlay;
title "Actual Vs Predicted sales per Week";
proc print data=new2; var week sales Predicted_Sales;
run;


/*Question 2*/
data a2;
set work.import;
run;

data q2;set a2;
If Brand = 'Smile' then dsmile = 1;else dsmile = 0;
If Brand = 'Wave' then dwave = 1 ; else dwave = 0;
If Scent = 'lemon' then dlemon = 1; else dlemon = 0;
If Scent = 'U' then dunscented = 1; else dunscented = 0;
If soft = 'y' then dsoft= 1 ; else dsoft = 0;
If oz = '48' then doz48 = 1; else doz48 = 0;
If oz = '64' then doz64 = 1; else doz64 = 0;
If pr = '3.99' then dpr3 = 1; else dpr3 = 0;
If pr = '4.99' then dpr4 = 1; else dpr4 = 0;
run;

proc reg outest=est; model s1-s5 = dsmile dwave dlemon dunscented dsoft doz48 doz64 dpr3 dpr4;run;
**proc print data=est( keep=dsmile dwave);run; 

data takenout;
set est;
keep dsmile dwave;run;
data tempUnit;
input p;
cards;
0
0
0
0
0
;
run;
data combined;
set takenout; 
set tempUnit;
run;

data combined;
merge takenout tempUnit;
run;


proc iml;
use combined;
read all into MSTR;
close combined;
PRINT MSTR;
a = {1 0 -1, 0 1 -1, 1 1 1}; /* 2 x 3 numeric matrix */
ainv = inv(a);
c=MSTR;

Brand = ainv*c`;
print Brand;run;


/*--------dlemon-dunscented---------------------------------*/

data takenout1;
set est;
keep dlemon dunscented;run;
data tempUnit;
input p;
cards;
0
0
0
0
0
;
run;
data combined1;
set takenout1; 
set tempUnit;
run;

data combined1;
merge takenout1 tempUnit;
run;


proc iml;
use combined1;
read all into MSTR;
close combined1;
PRINT MSTR;
a = {1 0 -1, 0 1 -1, 1 1 1}; /* 2 x 3 numeric matrix */
ainv = inv(a);
c=MSTR;

Scent = ainv*c`;
print Scent;run;

/*---------------d0z48-doz64--------------------*/

data takenout2;
set est;
keep doz48 doz64;run;
data tempUnit;
input p;
cards;
0
0
0
0
0
;
run;
data combined2;
set takenout2; 
set tempUnit;
run;

data combined2;
merge takenout2 tempUnit;
run;


proc iml;
use combined2;
read all into MSTR;
close combined2;
PRINT MSTR;
a = {1 0 -1, 0 1 -1, 1 1 1}; /* 2 x 3 numeric matrix */
ainv = inv(a);
c=MSTR;

Oz = ainv*c`;
print Oz;run;

/*---------------dpr3-dpr4--------------------*/

data takenout3;
set est;
keep dpr3 dpr4;run;
data tempUnit;
input p;
cards;
0
0
0
0
0
;
run;
data combined3;
set takenout3; 
set tempUnit;
run;

data combined3;
merge takenout3 tempUnit;
run;


proc iml;
use combined3;
read all into MSTR;
close combined3;
PRINT MSTR;
a = {1 0 -1, 0 1 -1, 1 1 1}; /* 2 x 3 numeric matrix */
ainv = inv(a);
c=MSTR;

Price = ainv*c`;
print Price;run;

/*---------------dsoft_y--------------------*/

PROC PRINT DATA=ESt;RUN;

data takenout4;
set est;
keep dsoft;run;
data tempUnit;
input p;
cards;
0
0
0
0
0
;
run;
data combined4;
set takenout4; 
set tempUnit;
run;

data combined4;
merge takenout4 tempUnit;
run;


proc iml;
use combined4;
read all into MSTR;
close combined4;
PRINT MSTR;
a = {1 -1, 1 1}; /* 2 x 2 numeric matrix */
ainv = inv(a);
c=MSTR;

Softner = ainv*c`;
print Softner;run;
