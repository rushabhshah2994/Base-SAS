/*Defining Temporary Variables for Analysis*/
data dmef;
set work.import;
retailTotal=sum(RetF07Dollars,RetS07Dollars,RetF06Dollars,RetS06Dollars,RetF05Dollars,RetS05Dollars,RetF04Dollars,RetS04Dollars,RetPre04Dollars);
internetTotal=sum(IntF07GDollars,IntF07NGDollars,IntS07GDollars,IntS07NGDollars,IntF06GDollars,IntF06NGDollars,IntS06GDollars,IntS06NGDollars,IntF05GDollars,IntF05NGDollars,IntS05GDollars,IntS05NGDollars,IntF04GDollars,IntF04NGDollars,IntS04GDollars,IntS04NGDollars,IntPre04GDollars,IntPre04NGDollars);
catalogTotal=sum(CatF07GDollars,CatF07NGDollars,CatS07GDollars,CatS07NGDollars,CatF06GDollars,CatF06NGDollars,CatS06GDollars,CatS06NGDollars,CatF05GDollars,CatF05NGDollars,CatS05GDollars,CatS05NGDollars,CatF04GDollars,CatF04NGDollars,CatS04GDollars,CatS04NGDollars,CatPre04GDollars,CatPre04NGDollars);
totalSale=sum(retailTotal,internetTotal,catalogTotal);
EmailCount=sum(EmailsF07,EmailsS07,EmailsF06,EmailsS06,EmailsF05,EmailsS05);
CatCount=sum(CatCircF07,CatCircS07,CatCircF06,CatCircS06,CatCircF05,CatCircS05);
PromoCount=sum(EmailCount,CatCount);
Sale07=sum(RetF07Dollars,RetS07Dollars,IntF07GDollars,IntF07NGDollars,IntS07GDollars,IntS07NGDollars,CatF07GDollars,CatF07NGDollars,CatS07GDollars,CatS07NGDollars);
email07=sum(EmailsF07,EmailsS07);
Sale06=sum(RetF06Dollars,RetS06Dollars,IntF06GDollars,IntF06NGDollars,IntS06GDollars,IntS06NGDollars,CatF06GDollars,CatF06NGDollars,CatS06GDollars,CatS06NGDollars);
Sale05=sum(RetF05Dollars,RetS05Dollars,IntF05GDollars,IntF05NGDollars,IntS05GDollars,IntS05NGDollars,CatF05GDollars,CatF05NGDollars,CatS05GDollars,CatS05NGDollars);
email06=sum(EmailsF06,EmailsS06);
email05=sum(EmailsF05,EmailsS05);
run;

/*Question 2*/

/*Hypothesis 1*/
/*Here, a new .csv file containing two columns has been prepared. It contains Dollar data for Retail and Internet that have been summed up and put together in a single column as Sale_Total. Another column is type of Sale_Total which indicates retail or internet.*/
data c1;
set work.import;
proc ttest; var Sale_Total; class type; run; 

/*Hypothesis 2*/
proc ttest; var totalSale; class Travel; run;
 
/*Hypothesis 3*/
proc ttest; var totalSale; class carowner; run;

/*Question 3*/
/*Proc Means*/
proc means; var retailTotal internetTotal catalogTotal;run;
proc means; var FirstDollar;run;

/*Proc Freq*/
proc freq;table firstchannel;run;

/*Proc Corr*/
proc corr;var totalSale EmailCount CatCount;run;
proc corr;var catalogTotal CatCount;run;
proc corr;var retailTotal StoreDist;run;

/*Correlation between Email sent and total sale(yearwise)*/
proc corr;var Sale07 email07;run;


/*Visulization*/
data a1;run;
PROC IMPORT OUT= WORK.A1 
            DATAFILE= "<H:\DMEFExtractSummaryV01.CSV>" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN; 

data dmef;
set work.a1;
retailTotal=sum(RetF07Dollars,RetS07Dollars,RetF06Dollars,RetS06Dollars,RetF05Dollars,RetS05Dollars,RetF04Dollars,RetS04Dollars,RetPre04Dollars);
internetTotal=sum(IntF07GDollars,IntF07NGDollars,IntS07GDollars,IntS07NGDollars,IntF06GDollars,IntF06NGDollars,IntS06GDollars,IntS06NGDollars,IntF05GDollars,IntF05NGDollars,IntS05GDollars,IntS05NGDollars,IntF04GDollars,IntF04NGDollars,IntS04GDollars,IntS04NGDollars,IntPre04GDollars,IntPre04NGDollars);
catalogTotal=sum(CatF07GDollars,CatF07NGDollars,CatS07GDollars,CatS07NGDollars,CatF06GDollars,CatF06NGDollars,CatS06GDollars,CatS06NGDollars,CatF05GDollars,CatF05NGDollars,CatS05GDollars,CatS05NGDollars,CatF04GDollars,CatF04NGDollars,CatS04GDollars,CatS04NGDollars,CatPre04GDollars,CatPre04NGDollars);
totalSale=sum(retailTotal,internetTotal,catalogTotal);
EmailCount=sum(EmailsF07,EmailsS07,EmailsF06,EmailsS06,EmailsF05,EmailsS05);
CatCount=sum(CatCircF07,CatCircS07,CatCircF06,CatCircS06,CatCircF05,CatCircS05);
PromoCount=sum(EmailCount,CatCount);
run;
data dmef1;
set dmef;
proc sql;
 insert into dmef1(retailTotal,internetTotal,catalogTotal) select sum(retailTotal),sum(internetTotal),sum(catalogTotal) from dmef;
 quit; 
run;


proc transpose data=dmef1 out=traspose;
var retailTotal internetTotal catalogTotal;run;


proc gchart data=traspose;
pie _name_/freq=col100052 type=percent ;run;

data Year;
set work.a1;
Year_07=sum(RetF07Dollars,RetS07Dollars,IntF07GDollars,IntF07NGDollars,IntS07GDollars,IntS07NGDollars,CatF07GDollars,CatF07NGDollars,CatS07GDollars,CatS07NGDollars);
Year_06=sum(RetF06Dollars,RetS06Dollars,IntF06GDollars,IntF06NGDollars,IntS06GDollars,IntS06NGDollars,CatF06GDollars,CatF06NGDollars,CatS06GDollars,CatS06NGDollars);
Year_05=sum(RetF05Dollars,RetS05Dollars,IntF05GDollars,IntF05NGDollars,IntS05GDollars,IntS05NGDollars,CatF05GDollars,CatF05NGDollars,CatS05GDollars,CatS05NGDollars);
Year_04=sum(RetF04Dollars,RetS04Dollars,IntF04GDollars,IntF04NGDollars,IntS04GDollars,IntS04NGDollars,CatF04GDollars,CatF04NGDollars,CatS04GDollars,CatS04NGDollars);
Year_Pre04=sum(RetPre04Dollars,IntPre04GDollars,IntPre04NGDollars,CatPre04GDollars,CatPre04NGDollars);
run;

data year_new;
set Year;
proc sql;
 insert into year_new(Year_07,Year_06,Year_05,Year_04,Year_Pre04) select sum(Year_07),sum(Year_06),sum(Year_05),sum(Year_04),sum(Year_Pre04) from year;
 quit; 
run;

proc transpose data=year_new out=traspose_year;
var Year_07 Year_06 Year_05 Year_04 Year_Pre04;run;


proc gchart data=traspose_year;
vbar _name_/type=sum sumvar=col100052 ;run;



