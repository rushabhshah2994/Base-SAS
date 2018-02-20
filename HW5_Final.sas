data Neuralgia;
   input Treatment $ Sex $ Age Duration Pain $ @@;
   datalines;
P  F  68   1  No   B  M  74  16  No  P  F  67  30  No
P  M  66  26  Yes  B  F  67  28  No  B  F  77  16  No
A  F  71  12  No   B  F  72  50  No  B  F  76   9  Yes
A  M  71  17  Yes  A  F  63  27  No  A  F  69  18  Yes
B  F  66  12  No   A  M  62  42  No  P  F  64   1  Yes
A  F  64  17  No   P  M  74   4  No  A  F  72  25  No
P  M  70   1  Yes  B  M  66  19  No  B  M  59  29  No
A  F  64  30  No   A  M  70  28  No  A  M  69   1  No
B  F  78   1  No   P  M  83   1  Yes B  F  69  42  No
B  M  75  30  Yes  P  M  77  29  Yes P  F  79  20  Yes
A  M  70  12  No   A  F  69  12  No  B  F  65  14  No
B  M  70   1  No   B  M  67  23  No  A  M  76  25  Yes
P  M  78  12  Yes  B  M  77   1  Yes B  F  69  24  No
P  M  66   4  Yes  P  F  65  29  No  P  M  60  26  Yes
A  M  78  15  Yes  B  M  75  21  Yes A  F  67  11  No
P  F  72  27  No   P  F  70  13  Yes A  M  75   6  Yes
B  F  65   7  No   P  F  68  27  Yes P  M  68  11  Yes
P  M  67  17  Yes  B  M  70  22  No  A  M  65  15  No
P  F  67   1  Yes  A  M  67  10  No  P  F  72  11  Yes
A  F  74   1  No   B  M  80  21  Yes A  F  69   3  No
;
proc logistic data=Neuralgia;
   class Treatment Sex;
   model Pain= Treatment Sex Treatment*Sex Age Duration / expb;
run;

PROC IMPORT OUT= credit 
            DATAFILE= "C:\Users\Rushabh Shah\Desktop\MKT\HW5\cc_data2 (4).xls" 
            DBMS=EXCEL REPLACE;
     RANGE="cc_data$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
proc means;run;
proc print data=credit (obs=10);
run;
proc freq data=credit;
table active*affinity;
run;

data Dcredit(keep = active Affinity Rewards limit numcard ddm dds dts dgold dplatinum dquantum );
set credit;
  If dm = 1 then ddm = 1;else ddm = 0;
  If ds = 1 then dds = 1;else dds = 0;
  If ts = 1 then dts = 1;else dts= 0;
  If gold = 1 then dgold = 1;else dgold = 0;
  If platinum = 1 then dplatinum = 1;else dplatinum = 0;
  If quantum = 1 then dquantum = 1;else dquantum = 0;
  run;

/* logit model*/
proc logistic data= Dcredit descending;
model active = Affinity Rewards limit numcard ddm dds dts dgold dplatinum dquantum;
output out=pcred predicted = plogit;
run;

proc print data=pcred (obs=10);
run;



/*Tobit model*/

data Tcredit(keep = tfee tfee1 profit profit1 active Affinity Rewards limit1 limit2 numcard ddm dds dts dgold dplatinum dquantum );
set credit;
  If dm = 1 then ddm = 1;else ddm = 0;
  If ds = 1 then dds = 1;else dds = 0;
  If ts = 1 then dts = 1;else dts= 0;
  If gold = 1 then dgold = 1;else dgold = 0;
  If platinum = 1 then dplatinum = 1;else dplatinum = 0;
  If quantum = 1 then dquantum = 1;else dquantum = 0;
  limit1=limit/10000;
  tfee=totalfee*1.0;
  limit2=limit/100;
  tfee1=tfee/100;
  profit1=profit/1000;
  run;

proc qlim data=Tcredit; 
  Model profit = tfee affinity rewards limit1 numcard ddm dds dts dgold dplatinum dquantum;
  endogenous profit ~ censored (lb=0);
run;

/* Selection Model */
proc qlim data=Tcredit plots=none; 
	Model active = affinity rewards limit1 numcard ddm dds dts dgold dplatinum dquantum /discrete;
	Model profit = tfee affinity rewards limit2 numcard ddm dds dts dgold dplatinum dquantum /select(active=1);
run;
proc means;var limit;class active;run;


/*logit*/

PROC IMPORT OUT= credit 
            DATAFILE= "C:\Users\Rushabh Shah\Desktop\MKT\HW5\cc_data2 (4).xls" 
            DBMS=EXCEL REPLACE;
     RANGE="cc_data$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
Data cc;
set credit;
tfee=totalfee*1.0;run;    /*convert character variable into numeric*/

/* binary Logit */
proc logistic data=cc descending;
model active=affinity rewards limit numcard dm ds ts gold platinum quantum;run;

/* Most active mode*/
proc freq data= credit;
table active*dm active*ds active*ts active*net /NOROW NOCOL;
run;

/*Most active card type*/
proc freq data= credit;
table active*gold active*platinum active*quantum active*standard /NOROW NOCOL;
run;

/*Tobit Model*/

data cc;set cc;
limit1=limit/10000;
limit2=limit/100;
tfee1=tfee/100;
profit1=profit/1000;
run;

proc qlim data=cc; 
  Model profit = tfee affinity rewards limit1 numcard dm ds ts gold platinum quantum;
  endogenous profit ~ censored (lb=0);
run;

/* Selection Model */
proc qlim data=cc plots=none; 
	Model active = affinity rewards limit1 numcard dm ds ts gold platinum quantum /discrete;
	Model profit = tfee affinity rewards limit2 numcard dm ds ts gold platinum quantum /select(active=1);
run;
proc means;var limit;class active;run;


/*Ketch-up data*/
 Data Ketchup;
infile 'C:\Users\Rushabh Shah\Desktop\MKT\HW5\ketmk1l20 (3).dat';
input HID STID WEEK BR P1  P2 P3 P4 D1 D2 D3 D4 F1 F2 F3 F4 INC NMEMB TOT DOLSPENT KID L1 L2 L3 L4;
run;

data newdata (keep=hid tid decision mode price display feature loyalty inc nmemb kid);
set ketchup;
array pvec{4} p1 - p4;
array dvec{4} d1 - d4;
array fvec{4} f1 - f4;
array lvec{4} l1 - l4;
retain tid 0;
tid+1;
do i = 1 to 4;
	mode=i;
	price=pvec{i};
	display=dvec{i};
	feature=fvec{i};
	loyalty=lvec{i};
	decision=(br=i);
	output;
end;
run;

data newdata;
set newdata;
br1=0;
br2=0;
br3=0;
if mode = 1 then br1 = 1;
if mode = 2 then br2 = 1;
if mode = 3 then br3 = 1;
inc1=inc*br1;
inc2=inc*br2;
inc3=inc*br3;
kid1=kid*br1;
kid2=kid*br2;
kid3=kid*br3;
nmemb1=nmemb*br1;
nmemb2=nmemb*br2;
nmemb3=nmemb*br3;
run;

/* MNL model */
proc mdc data=newdata;
model decision = br1 br2 br3 price display feature loyalty inc1-inc3 nmemb1-nmemb3 kid1-kid3/ type=clogit 
	nchoice=4;
	id tid;
	output out=probdata pred=p;
run;
proc means data=newdata;run;

proc print data=probdata (obs=20);
run;

/*Bechoice model*/

proc bchoice data=newdata seed=123 nmc=20000 thin=4 alg=rwm nthreads=8;
class HID tid;
model decision = br1 br2 br3 price / choiceset=(HID tid);
run;
