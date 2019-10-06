/*
FORMAT DEFINITION FILE FOR BILI
*/

proc format library =Work.bili;
value Status 1="Death"
		      2="Transplantation"
 			  0="Censored";
value Drug 1="D-penicillamine"
			2="placebo";
value Sex 0="Male"
		   1="Female";
value Ascites  0="No" 
				1="Yes";
value Hepatomegaly 0="No" 
					1="Yes";
value Spiders  0="No" 
				1="Yes";
value Edema 0="No edema and no diuretic therapy for edema"
  			 0.5="Edema present without diuretics, or edema resolved by diuretics"
			 1="Edema despite diuretic therapy"; 
value Endma_new 0 ="No"
				1 = "Yes";
run; 
