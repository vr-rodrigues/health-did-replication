# CS-DID Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** FAIL
**Date:** 2026-04-18

## Checklist

### 1. CS-DID estimation status
- att_csdid_nt: NA — status: "FAIL_other: argumento de comprimento zero"
- att_csdid_nyt: NA — status: "FAIL_other: argumento de comprimento zero"
- att_cs_nt_with_ctrls_status: "FAIL_other: argumento de comprimento zero"
- att_cs_nyt_with_ctrls_status: "FAIL_other: argumento de comprimento zero"
- ALL CS-DID variants failed to estimate. This is a hard FAIL.

### 2. Error diagnosis
- Error: "argumento de comprimento zero" (Portuguese R error: "argument of length zero")
- This error arises when `did::att_gt()` or downstream aggregation receives an empty group-time set.
- Root causes: 
  a) The gvar variable (newpolicydate) may produce cohorts with insufficient never-treated/not-yet-treated control units.
  b) The sample filter (year >= 2014 & year <= 2020) combined with 12 distinct treatment cohorts may leave some cohorts with zero valid comparison units.
  c) Data reconstruction from Census API (not original IPUMS ACS) may produce structural differences that break the cohort construction.
  d) cs_controls=[] (empty controls) should be simpler, yet still failed — suggesting the issue is in group-time cell construction, not control estimation.

### 3. Comparison to paper target
- Paper reports csdid_att_simple = -0.031.
- We cannot reproduce or validate this value.
- Paper uses aggte(type='simple'); our protocol uses aggte(type='dynamic') — but neither ran.

### 4. Impact on analysis
- Without CS-DID estimates, the key robustness check for TWFE negative-weight bias cannot be performed.
- The bacon decomposition shows 10 Treated-vs-Untreated pairs (clean; combined weight ~94.7%), suggesting that most of the TWFE identification is clean — but this cannot be verified against CS-DID.
- The paper's headline result (-0.031 CS simple vs -0.017 TWFE) suggests CS-DID would show a larger effect, but this is unverifiable from stored results.

### 5. Pattern classification
- This failure matches Pattern characteristics of empty group-time cells in reconstructed datasets.
- The metadata notes explicitly: "Dataset reconstructed from Census API... ACS.dta (IPUMS) not redistributable."
- Reconstructed data may not perfectly reproduce the original sample balance across cohorts.

**Overall CS-DID Verdict: FAIL** (complete estimation failure across all CS-DID variants; cannot validate paper's CS-DID ATT of -0.031)
