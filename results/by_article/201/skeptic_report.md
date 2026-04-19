# Skeptic report: 201 - Maclean & Pabilonia (2025)

**Overall rating:** LOW
**Methodology score:** M-LOW (3 applicable reviewers: twfe, csdid, honestdid - all WARN)
**Fidelity score:** F-HIGH (WITHIN_TOLERANCE - our TWFE=4.609 matches Appendix Table 10)
**Design credibility:** D-FRAGILE (HonestDiD: all Mbar breakevens=0 for TWFE and CS-NT)
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (NOT_APPLICABLE), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (WITHIN_TOLERANCE)

## Executive summary

Maclean & Pabilonia (2025) study the effect of state paid sick leave (PSL) mandates on parental childcare time using ATUS data (2004-2023). Their Gardner (did2s) headline is +4.45 min/day (5.8%); our TWFE replication (4.609, SE=1.799) matches Appendix Table 10 exactly (F-HIGH). Three methodological concerns earn LOW. (1) CS-NT sign reversal: TWFE=+4.61** vs CS-NT=-1.92 (ns), driven by COVID-contaminated Cohort 2020 -- the 2-year PSL lag maps 2018 adoptions to 2020 activation, coinciding with COVID lockdowns; Cohort 2020 carries 34% TWFE weight with ATT=+10.12 but is down-weighted by CS uniform cohort averaging, flipping the sign. (2) HonestDiD D-FRAGILE: all event-study sensitivity CIs include zero at Mbar=0 for both TWFE and CS-NT; design credibility cannot be established under the event-study specification. (3) CS controls failure: all 19 TWFE covariates absent from the yearly-collapsed panel, making CS-NT unconditional. The paper is methodologically sophisticated -- Gardner is primary, TWFE is explicitly labelled a robustness check, and the authors conduct their own Bacon test (98.5% reasonable comparisons). Users should rely on Gardner (4.45**) for meta-analysis; the stored TWFE=4.609 is correctly replicated but limited.

## Per-reviewer verdicts

### TWFE (WARN)
- TWFE is Appendix Table 10 robustness only; Gardner (did2s) is the primary estimator.
- Sign reversal: TWFE=+4.61** vs CS-NT=-1.92 (ns). Cohort 2020 (ATT=+10.12, weight=34%) is COVID-confounded.
- TWFE event-study pre-trends non-flat (t=-5: -34.6, t=-6: -31.2 min) though imprecise (ATUS small samples).
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)
- All CS-NT estimates insignificant: simple=-1.92, dynamic=-3.04, att_csdid_nt=+0.64 (all ns).
- 19 TWFE covariates absent from yearly-collapsed panel; CS-NT is unconditional.
- Mild positive pre-trend pattern in CS-NT event study (t=-8 to t=-4: +5 to +8 min, none significant); endpoint artefact at t=+7 (+21.6 min).
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- Skipped: data_structure=repeated_cross_section, allow_unbalanced=true.
- Informational results confirm COVID-contamination: Cohort 2020 weight=33.9%, ATT=+10.12; Cohort 2017 weight=47.7%, ATT=-3.97; Cohort 2022 weight=10.4%, ATT=-21.49.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN)
- All sensitivity CIs include zero at Mbar=0 for TWFE and CS-NT; D-FRAGILE on all targets (first, avg, peak).
- n_pre=2 used despite 7 pre-periods specified; TWFE t=-2 pre-period=-21.02 min (SE=15.52).
- Design credibility: D-FRAGILE (event-study spec; static Gardner result is more stable).
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard binary absorbing staggered design. DID_M adds no value beyond CS-DID.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (WITHIN_TOLERANCE)
- Our TWFE=4.609 (SE=1.799) matches metadata-recorded Appendix Table 10 value (0% deviation).
- Cross-check vs Gardner main result (4.45): 3.6% gap -- within tolerance.
- Full report: reviews/paper-auditor.md

## Material findings (sorted by severity)

**WARN -- COVID contamination of TWFE via Cohort 2020:** The 2-year PSL lag maps 2018 mandate adoptions to 2020 activation, coinciding with COVID-19 lockdowns. Cohort 2020 has ATT=+10.12 and 33.9% TWFE weight, inflating TWFE and explaining sign reversal vs CS-NT.

**WARN -- Sign reversal TWFE vs CS-NT:** TWFE=+4.61 (p<0.05) vs CS-NT=-1.92 (ns), a 6.5-minute reversal. CS uniform cohort weighting down-weights COVID-contaminated Cohort 2020; result becomes negative and insignificant.

**WARN -- D-FRAGILE design (HonestDiD):** All sensitivity CIs include zero at Mbar=0 for event-study specs. Event-study ATTs (TWFE: -11 to -19 min; CS-NT: -5 to -8 min) cannot survive even zero deviation from parallel trends.

**WARN -- CS controls failure and RCS-to-panel collapse:** All 19 TWFE controls lost in yearly-collapsed CS panel. CS-NT is unconditional; reduced precision from small ATUS state-year cells.

**WARN -- HonestDiD n_pre=2 despite 7 specified:** Sensitivity analysis calibrated on minimal pre-period information; weakens diagnostic value.


## Recommended actions

**For the repo-custodian agent:**
- Add covid_confound_cohort flag to metadata for Cohort 2020 (pslm_state_lag2 activation year 2020).
- Document explicitly in metadata why cs_controls is empty (RCS-to-yearly-panel collapse loses individual-level variables).

**For the pattern-curator:**
- Add Pattern: RCS-to-yearly-panel collapse causes control variable loss in CS-DID (ATUS individual-level controls unavailable at state-year level, CS-NT must run unconditionally).
- Add Pattern: COVID-contamination via treatment lag (multi-year PSL lags cause 2018-cohort treatment indicator=1 throughout 2020, coinciding with COVID emergency PSL and lockdowns).

**For the user:**
- Use Gardner estimate (4.45**) for meta-analysis, not TWFE=4.609.
- Key unresolved tension: CS-NT (-1.92 ns) suggests PSL effect may be zero or negative once COVID-confounded Cohort 2020 is down-weighted -- this is a genuine finding, not an artefact.
- Investigate whether excluding March 18-May 9, 2020 diary days fully resolves COVID confound for 2018-adopting cohort: pslm_state_lag2=1 throughout all of 2020 for these states, not just the excluded weeks.
- D-FRAGILE from HonestDiD applies to the event-study spec (n_pre=2, noisy post-periods); the static Gardner result is more reliable for inference.


## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
