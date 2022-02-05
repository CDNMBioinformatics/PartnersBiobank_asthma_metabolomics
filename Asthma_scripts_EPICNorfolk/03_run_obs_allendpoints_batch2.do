/*
Perform logistic regression for prevalent asthma status in measurement batch 2
*/

*settings
clear all
set more off
set type double
cd "V:\Programme1_DiabetesAetiology\Data\Case-Cohort T2D\EPICN_metabolon_LL\newcohort_Mar2017\analysis\Asthma\"
set maxvar 20000

use "epicn_metabolon_batch2&3_incidentdisease_asthma.dta", clear 

drop if BatchMTBL == 3

tempname observational 
postfile observational  str15 yvar str20 xvar str45 adj n_tot n_cases beta se r2_pseudor2 r2_adj str10 model using tempids2501, replace

*All analyses should exclude COPD.
drop if copd_prev==1


foreach var of varlist s_M* {

			local met = "`var'"
			qui count if asthma_prev == 1 & `met' != . & age != . & sex != . & bmi != . & cigstat != .
			local cases = r(N)
			if `cases' > 30 {
				
				di "running regression for `met' & `exp'"
				logit asthma_prev `met' age i.sex bmi i.cigstat  
				local beta = _b[`met']
				local se = _se[`met']
				post observational ("asthma_prev") ("`met'") ("age,sex,bmi,smok01") (e(N)) (`cases') (`beta') (`se') (e(r2_p)) (-9) ("logistic")
				
				}
				}


postclose observational

*add pvalue and OR and save
use tempids2501, clear
gen p = 2*(normprob(-abs(beta/se)))
gen or = exp(beta) if model=="logistic"
gen or_95l = exp(beta - 1.96 * se) if model=="logistic"
gen or_95h = exp(beta + 1.96 * se) if model=="logistic"

*save
save "epicn_metabolon_batch2_asthma_res.dta", replace
export delimited using "epicn_metabolon_batch2_asthma_res.txt", delimiter(tab) replace


