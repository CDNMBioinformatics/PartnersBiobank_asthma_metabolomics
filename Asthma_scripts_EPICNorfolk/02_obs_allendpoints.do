/*
Prepare prevalent asthma and copd variables
*/

*settings
clear all
set more off
set type double
cd "V:\Programme1_DiabetesAetiology\Data\Case-Cohort T2D\EPICN_metabolon_LL\newcohort_Mar2017\analysis\Asthma\"
set maxvar 20000

use "epicn_metabolon_batch2&3_asthma.dta", clear 

	gen asthma_prev = asthma
	replace asthma_prev = 0 if asthma == 2
	
	gen copd_prev = bronchitis 
	replace copd_prev = 0 if bronchitis == 2
	
	save "epicn_metabolon_batch2&3_incidentdisease_asthma.dta", replace