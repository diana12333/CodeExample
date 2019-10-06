/* HW 2 SEP.22TH 2019

  - DATASET Mydata1 Mydata2 Mydata3 correspond to Demographics, Assessment_original,Assessment_makeup respectively
  - DATASET 
  -	finaldata merged by Mydata1-3 with the final scores and evaulation of which method has highest score
  - FORMAT Qol
*/

*Set the pathname for HW 2;
%let pathname = \\Client\H$\Desktop\SAS\Assignment 2\;

*include the format file;
%include "&pathname.SHEN_CHANG_FORMATS.sas";
options fmtsearch=(Work.Qol);

*import Demographics.csv with format to temp dataset mydata1;
data mydata1;
 infile "&pathname.Demographics.csv" DSD DLM="," firstobs=2;
 input PATNO Year Gender Residency Major;
 format Year Schoolyear. Gender Gender. Residency Residency. Major Major.;;
 run;

*import Assessment_original.csv to temp dataset mydata2;
data mydata2;
  infile "&pathname.Assessment_original.csv" DSD DLM="," firstobs=2;
  input PATNO QOL SCALE;
run;

*import Assessment_makeup.csv to temp dataset mydata3;
data mydata3;
  infile "&pathname.Assessment_makeup.csv" DSD DLM="," firstobs=2;
  input PATNO QOL SCALE;
run;

*sort the 3 data set such that we can apply functions including 'by' to dataset ;
proc sort data=mydata1;
	by PATNO;
run;

proc sort data=mydata2;
	by PATNO;
run;

proc sort data=mydata3;
	by PATNO;
run;

*transfer dataset mydata2 and mydata3 from long format to wide format by different subjects;
proc transpose data=mydata2 out=mydata2 prefix=grade;
 by PATNO;
 id SCALE;
 var QOL;
run;
proc transpose data=mydata3 out=mydata3 prefix=grade;
 by PATNO;
 id SCALE;
 var QOL;
run;

/*
1.merge mydata1-mydata3 by PATNO create new dataset finaldata;
2.fill miss data indicator in orignal scales with makeup scales if appliable;
3.create Author_A_Score,Author_B_Score,Author_C_Score by different algorithms;
4.calculate which assessment method would achieve the highest score
5.in step variables
	-miss :indicator of the number of missing scales
	-Highest_ :The highest score among Author_A_Score,Author_B_Score,Author_C_Score
	-i :iteration varaible 
	-_NAME_ :generate when transposing
*/
data merge_12;
*1;
merge mydata1 mydata2;
by PATNO;
run;

data finaldata;
*1;
update merge_12 mydata3;
by PATNO;
*2;
miss=0;
array grad {*} grade1-grade5;
*calculate miss;
do i=1 to 5;
	if grad{i}eq"." then do;
	   miss = miss + 1;
	end;
end;
*3;
if miss eq 0 then do;
  Author_A_Score=round(.7*mean(OF grade1-grade4)+.3*grade5,.01);
end;
if miss le 1 then do;
  Author_B_Score=round(.5*mean(OF grade1-grade3)+.5*mean(OF grade4-grade5),.01);
end;
if Residency eq 2 then
  Author_C_Score= round(.5*mean(OF grade1-grade5)+25,.01) ;
else if Residency eq 1 then do;
  do i=1 to 5;
	if grad{i}eq"." then
	  grad{i} =50;
  end;
  Author_C_Score=round(mean(OF grade1-grade5),.01);
end;
*4;
Highest_=max(Author_A_Score,Author_B_Score,Author_C_Score);
if Author_A_Score= Highest_ then Highest='A';
else if Author_B_Score= Highest_ then Highest='B';
else Highest='C';
drop grade1-grade5 grade_make1-grade_make5 _NAME_ i miss Gender Highest_;
format Author_A_Score 6.2 Author_B_Score 6.2 Author_C_Score 6.2;
output;
run;

*print the sorted final version of data set;
title 'The sorted final data set';
proc print data=finaldata(obs=15);
run;

