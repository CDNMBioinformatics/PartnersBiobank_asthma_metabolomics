/*
Prepare metabolites within measurement batch
*/

*settings
clear all
set more off
set type double
cd "V:\Programme1_DiabetesAetiology\Data\Case-Cohort T2D\EPICN_metabolon_LL\newcohort_Mar2017\analysis\Asthma\"
set maxvar 20000


use "V:\Programme1_DiabetesAetiology\Data\Case-Cohort T2D\EPICN_metabolon_LL\newcohort_Mar2017\source_data\version24012018\data24012018metabolomics_dist.dta", clear

*keep measurement batch 
keep if BatchMTBL == 2

*drop individuals with a high amount of missing values


drop M00_hc

*log transformation, winsorisation 5SD, and standardisation 
foreach var of varlist M????? {

	count if `var' != .
	if r(N) != 0 {	
		gen ln_`var' = ln(`var')
		zscore ln_`var'
		gen w_`var' = ln_`var'
		quietly su ln_`var' if (z_ln_`var' >= -5 & z_ln_`var' <= 5)
		replace w_`var' = r(max) if (z_ln_`var' > 5 & w_`var' != .)
		replace w_`var' = r(min) if (z_ln_`var' < -5 & w_`var' != .)
		egen s_`var' = std(w_`var')
		drop z_ln_`var'
	}

	else {

		drop `var'
		
	}

}

*save 
save "epicn_metabolon_batch2_temp.dta", replace 

use "V:\Programme1_DiabetesAetiology\Data\Case-Cohort T2D\EPICN_metabolon_LL\newcohort_Mar2017\source_data\version24012018\data24012018metabolomics_dist.dta", clear

*keep measurement batch 
keep if BatchMTBL == 3

drop M00_hc 

*drop individuals with a high amount of missing values


*rename metabolites 
drop	M15958
drop	M33937
drop	M38667
drop	M04970
drop	M47703
drop	M47705
drop	M49535
drop	M47721
drop	M47964
drop	M46672
drop	M49704

rename M57745	M15958
rename M46537	M33937
rename M57747	M38667
rename M57746	M04970
rename M47909	M47703
rename M46985	M47705
rename M46628	M49535
rename M46318	M47721
rename M54677	M47964
rename M47815	M46672
rename M49014	M49704


drop M52049
drop M47391
drop M47709
drop M47933
drop M47715
drop M46894
drop M49647
drop M52278
drop M46471
drop M46740
drop M47594
drop M46410
drop M46403

rename M57814	M52049
rename M57655	M47391
rename M55072	M47709
rename M55017	M47933
rename M57461	M47715
rename M54923	M46894
rename M57636	M49647
rename M55015	M52278
rename M54907	M46471
rename M57577	M46740
rename M57463	M47594
rename M57687	M46410
rename M57564	M46403


*log transformation, winsorisation 5SD, and standardisation 
foreach var of varlist M????? {

	count if `var' != .
	if r(N) != 0 {	
		gen ln_`var' = ln(`var')
		zscore ln_`var'
		gen w_`var' = ln_`var'
		quietly su ln_`var' if (z_ln_`var' >= -5 & z_ln_`var' <= 5)
		replace w_`var' = r(max) if (z_ln_`var' > 5 & w_`var' != .)
		replace w_`var' = r(min) if (z_ln_`var' < -5 & w_`var' != .)
		egen s_`var' = std(w_`var')
		drop z_ln_`var'
	}

	else {

		drop `var'
		
	}

}


*save 

append using epicn_metabolon_batch2_temp.dta

drop ln_M?????
drop w_M?????

save epicn_metabolon_batch2&3_asthma.dta, replace
