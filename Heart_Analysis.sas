proc import datafile="/export/viya/homes/roshankumar81639@gurunanakcollege.edu.in/heart.csv"
    out=work.heart
    dbms=csv
    replace;
    getnames=yes;
run;

proc contents data=work.heart;
run;

proc print data=work.heart(obs=10);
run;

proc means data=work.heart n nmiss min max mean;
      var Age RestingBP Cholesterol MaxHR;
run;

data work.heart_clean;
    set work.heart;

    if RestingBP = 0 then RestingBP = .;
    if Cholesterol = 0 then Cholesterol = .;

    length AgeGroup $ 10;
    if Age < 40 then AgeGroup = "Under 40";
    else if Age <= 55 then AgeGroup = "40-55";
    else AgeGroup = "Over 55";
run;

proc means data=work.heart_clean n nmiss min max mean;
    var RestingBP Cholesterol;
run;

proc freq data=work.heart_clean;
    tables HeartDisease AgeGroup*HeartDisease Sex*HeartDisease / nopercent nocol;
run;

proc sgplot data=work.heart_clean;
    vbar AgeGroup / group=HeartDisease groupdisplay=cluster;
    title "Heart Disease Count by Age Group";
run;

proc sort data=work.heart_clean out=work.top_chol;
    by descending Cholesterol;
run;

proc print data=work.top_chol(obs=10);
    var Age Sex Cholesterol HeartDisease;
run;