/*
Meta analyse effects of the 2 measurement batches
*/

*settings
clear all
set more off
set type double
cd "V:\Programme1_DiabetesAetiology\Data\Case-Cohort T2D\EPICN_metabolon_LL\newcohort_Mar2017\analysis\Asthma"
tempfile f0 f1
set maxvar 20000

*open file, annotate and save
use "epicn_metabolon_batch2_asthma_res.dta", clear
gen batch = "batch2"
save ids32_temp, replace

*open file, annotate and save
use "epicn_metabolon_batch3_asthma_res.dta", clear
gen batch = "batch3"
append using ids32_temp
levelsof xvar, local(levelsxvar) 
 
save ids32_temp, replace

***run meta-analysis
tempname observational 
postfile observational str20 yvar str20 xvar str40 adj N Ncase batches beta se het_p i2 str10 model using tempidsres, replace

foreach trait in asthma_prev {

foreach met of local levelsxvar {
	
					*open file
					use "ids32_temp", clear
					keep if yvar== "`trait'"
					keep if xvar== "`met'"
					di "`trait'"
					di "`met'"
					su beta
					su n_tot
					local N = r(sum)
					sum n_cases
					local Ncase = r(sum)
					count
					local nbatch = r(N)
					if r(N) > 0 {						
							*run analysis and post results
							metan beta se, label(namevar=batch) nograph
							post observational ("`trait'") ("`met'") ("age,sex,bmi,smok01") (`N') (`Ncase') (`nbatch') (r(ES)) (r(seES)) (r(p_het)) (r(i_sq)) ("logistic")
									
						}
							
}	
}


postclose observational

*add pvalue and OR and save
use tempidsres, clear
gen study = "meta-analysis"
gen p = 2*(normprob(-abs(beta/se)))
gen or = exp(beta) if yvar=="asthma_prev"
gen or_95l = exp(beta - 1.96 * se) if yvar=="asthma_prev"
gen or_95h = exp(beta + 1.96 * se) if yvar=="asthma_prev"

*save
save "EpicNorfolk_asthma_ma.dta", replace
export delimited using "EpicNorfolk_asthma_ma.txt", delimiter(tab) replace

