/*
THE TASK IN THIS SAS IS TO IMPOORT AND MUNIPULATE DATA MAKING IT'S EASY TO INTERPRET.
*/
/*
PATHNAME IS A MACRO VARIABLE POINT TO THE FORMAT AND DATA FILE FOLDER.
USE USER DEFINED FORMAT[BILI] SAVING IN CHANG_SHEN_FORMAT.SAS
V1-V20  —— THE VARIABLES NAME GIVEN AT IMPORTING.
LABELS OF V1-V20 -- TRUE MEANING OF EACH VARIABLES 
NEW VARIABLES:
age_in_years —— TRANSFORMATION OF age in days(DIVIDED BY AVERAGE DAYS IN A YEAR)
month_diff ——  months between registration and earlier of death transplantation()
			   TRANSFORMATION OF Number of days between registration and the earlier of death, transplantation,
or study analysis time in July, 1986"(DIVIDED BY AVERAGE DAYS IN A MONTH)
endma_new —— NEW ENDMA VARIABLES WHICH COMBINE THE .5 AND 1 CLASS.
*/
/*
VIEWTABLE OUTPUT
1. MEAN OF age_in_years AND MEAN OF month_diff
2. FREQENCY OF endma_new AND ENDMA
3. PRINTED THE CONTENTS OF ANALYSIS DATA SET
*/



%let pathname =\\Client\H$\Desktop\SAS\Assignment 1\ ;
 



%include "&pathname.SHEN_CHANG_FORMATS.sas";
options fmtsearch=(Work.bili);
data analysis;
 infile "&pathname.Bili dataset.txt" DSD DLM =" " firstobs=2;
 input V1-V20;
 age_in_years = (V5/365.25);
 month_diff = V2/30.5 ;
 endma_new = V10;
 if V12 = 99 then V12 = .;
 if V10 = .5 then endma_new = 1;
 drop  V2 V5;

 label V1="Case number";
 label V2="Number of days between registration and the earlier of death, transplantation,
or study analysis time in July, 1986";
 label V3="Status";
 label V4="Drug";
 label V5="Age in days";
 label V6="Sex";
 label V7="Presence of Ascites";
 label V8="Presence of Hepatomegaly";
 label V9="Presence of Spiders";
 label V10="Presence of Edema";
 label V11= "Serum Bilirubin in mg/dl";
 label V12="Serum Cholesterol in mg/dl";
 label V13="Albumin in gm/dl";
 label V14="Urine Copper in ug/day";
 label V15="Alkaline Phosphatase in U/liter";
 label V16="SGOT in U/ml"; 
 label V17="Triglicerides in mg/dl";
 label V18="Platelets per cubic ml / 1000";
 label V19="Prothrombin time in seconds";
 label V20="Histologic stage of disease"; 
 label age_in_years = "Age in years";
 label month_diff = "months between registration and earlier of death transplantation,transplantation,
or study analysis time in July, 1986";
 label endma_new = "edema that combines 0.5 and 1 into single category, where 0 indicates no and 1 indicates yes";
 format v3 Status. v4 Drug. v6 Sex. v7 Ascites. v8 Hepatomegaly. v9 Spiders. v10 Edema.  endma_new Endma_new. ;
run;

title "mean of age_in_years and months between registration and earlier of death transplantation ";
proc means data = analysis;
 var  age_in_years month_diff;
run;

title 'Frequencies and percentages of original and new edema variables';
proc freq data = analysis;
  table V10 endma_new;
run;

title 'contents of the analysis dataset';
proc contents data= analysis varnum;
run;

