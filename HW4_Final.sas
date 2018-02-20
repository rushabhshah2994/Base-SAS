PROC IMPORT OUT= bank 
            DATAFILE= "C:\Users\Rushabh Shah\Desktop\MKT\HM4\bank.csv" 
            DBMS=CSV REPLACE;
			DELIMITER=";";
            GETNAMES=YES;
            RUN;
proc print data=bank (obs=5);
run;

/*percent of customers in data subscribed to a term deposit*/
proc freq data = bank;
tables y;
run;
/*Logit model*/

proc logistic data= bank descending;
class job marital education default housing loan contact month poutcome / param=ref;
model y= age balance day duration campaign pdays previous job marital education
default housing loan contact month poutcome;
run;

/*Score*/

PROC IMPORT OUT= bankF
            DATAFILE= "C:\Users\Rushabh Shah\Desktop\MKT\HM4\bank-full.csv" 
            DBMS=CSV REPLACE;
			DELIMITER=";";
            GETNAMES=YES;
            RUN;
proc logistic data= bank descending;
class job marital education default housing loan contact month poutcome /param=ref;
model y= age balance day duration campaign pdays previous job marital education default housing loan contact month poutcome;
score  data=bankF out= bankFull;
run;

proc print data=bankFull(obs=5);
run;
/*where age=33 and job="unknown"*/
/* without score*/
proc logistic data= bank descending;
class job marital education default housing loan contact month poutcome / param=ref;
model y= age balance day duration campaign pdays previous job marital education
default housing loan contact month poutcome;
output out=sam1 predicted = plogit;
run;
proc print data=sam1;
where age=33 and job="unknown" and ;
run;


/*Q2*/

PROC IMPORT OUT= PDA1
            DATAFILE= "C:\Users\Rushabh Shah\Desktop\MKT\HM4\pda_2001.csv" 
            DBMS=CSV REPLACE;
			DELIMITER=",";
            GETNAMES=YES;
            RUN;
/*all STD DATAT*/
PROC STANDARD DATA=PDA1 MEAN=0 STD=1 OUT=zPDA1;
  VAR Innovator Use_message Use_cell Use_PIM Inf_passive INF_active remote_access 
Share_info Monitor Email Web M_media ergonomic monthly price ;
RUN;
/*Cluster*/
PROC CLUSTER data=zPDA1 ccc pseudo RMSSTD METHOD = ward OUTTREE = TREE;
VAR Innovator Use_message Use_cell Use_PIM Inf_passive INF_active remote_access 
Share_info Monitor Email Web M_media ergonomic monthly price ;
id ID;
run;


/*Print Data*/
proc print data=pda1 (obs=5);
run;

proc print data=zPDA1 (obs=5);
run;

/* Tree statemant*/

proc tree data=TREE nclusters=4 out=TREE1;
copy Innovator Use_message Use_cell Use_PIM Inf_passive INF_active
remote_access Share_info Monitor Email Web M_media ergonomic monthly price;
id ID;
run;

proc print data=TREE1;
run;
/* Merge File*/
PROC IMPORT OUT= PDA2
            DATAFILE= "C:\Users\Rushabh Shah\Desktop\MKT\HM4\pda_disc2001.csv" 
            DBMS=CSV REPLACE;
			DELIMITER=",";
            GETNAMES=YES;
            RUN;
proc sort data= PDA2 out=SPDA2;
by id;
Run;
proc sort data= Tree1 out=STREE1;
by id;
Run;
Data Mcluster;
merge STREE1 SPDA2;
by id;
run;
proc print data=Mcluster (obs=5);
run;
proc sort; by cluster;
proc print; by cluster;
run;
proc means ;by cluster;
run;


/*Non-Hierarchical Cluster Analysis */
proc fastclus data=zPDA1
out=Nontree
maxclusters=4
maxiter=100
converge=0
radius=0
distance;
var Innovator Use_message Use_cell Use_PIM Inf_passive INF_active
remote_access Share_info Monitor Email Web M_media ergonomic monthly price;
id ID;
run;
proc print data=Nontree (obs=5);
run;

/*Merge file with Demographic data*/
proc sort data= PDA2 out=SPDA2;
by id;
Run;
proc sort data=Nontree out=SNontree;
by id;
Run;
Data Mcluster2;
merge SNontree SPDA2;
by id;
run;
proc print data=Mcluster2 (obs=5);
run;
proc sort; by cluster;
proc print; by cluster;
run;
proc means ;by cluster;
run;
