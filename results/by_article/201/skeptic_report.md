# Skeptic report: 201 -- Maclean and Pabilonia (2025)

**Overall rating:** LOW

Axis breakdown: Fidelity = F-HIGH; Implementation = I-LOW (2 implementation WARNs)

**Design credibility:** FRAGILE (separate axis -- a finding about the paper)

**Date:** 2026-04-19

**Reviewers run:** twfe (impl=WARN), csdid (impl=WARN-Pattern42), bacon (NOT_APPLICABLE), honestdid (impl=WARN-n_pre=2/7; Mbar=0 all targets), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT)

## Executive summary

Maclean and Pabilonia (2025) study the effect of state paid sick leave mandates on parental primary childcare time using ATUS repeated cross-section data from 2004 to 2023, with N=78,080 adults with children. Their primary estimator is Gardner did2s, reporting +4.45 min/day. TWFE appears only in Appendix Table 10 as one of five alternative estimators. Our stored TWFE = +4.609 (SE = 1.799) reproduces the paper exactly (F-HIGH, EXACT; deviation: 0.03 percent). Following the 2026-04-19 template update -- which removed the prior state-by-year pre-aggregation step and runs CS-DID directly on the 78k monthly individual-level observations via panel=FALSE -- the CS-NT dynamic estimate shifted from -3.04 (old, state-year-collapsed) to -14.19 (new, monthly), amplifying the sign reversal vs TWFE from approximately 7.7 to approximately 19 minutes per day. The LOW rating reflects two confirmed implementation concerns: first, Spec A with doubly-robust CS-NT with 19 twfe_controls returns an anomalous zero due to Pattern 42 rather than a genuine null, with misleading status=OK; second, the HonestDiD runner uses only n_pre=2 of 7 available pre-periods. Design credibility is FRAGILE: all six HonestDiD targets return Mbar=0; Cohort 2020 (34 percent TWFE weight, ATT=+10.12) is COVID-contaminated; and pre-trend coefficients are large and erratic. Users should rely on the paper Gardner estimate (4.45**) for meta-analysis; the stored TWFE = 4.609 is correctly replicated but masks severe cohort heterogeneity that CS-NT properly surfaces.

## Per-reviewer verdicts

### TWFE (WARN)

- TWFE = +4.609 (SE = 1.799, t = 2.56) matches Appendix Table 10 exactly; specification faithfully implemented (Pattern 50: ALIGNED -- CS runs on same 78k monthly rows as TWFE).
- Sign reversal: TWFE = +4.61 vs CS-NT group = -15.27 (t = -2.44). Both statistically significant. Cohort 2020 (ATT = +10.12, Bacon weight = 34 percent) drives positive TWFE. The 2-year PSL lag maps 2018 mandate adoptions to 2020 treatment activation, coinciding with COVID-19 lockdowns.
- Spec B (TWFE no controls) = +1.820 (SE = 2.352); controls add +60.5 percent to TWFE point estimate -- individual respondent composition effects absorbed.
- Design finding (pre-trends): TWFE event-study at t=-5: -34.6 min, t=-6: -31.1 min; large imprecise negatives, no monotonic drift. Post-treatment uniformly negative (t=0: -11.6, t=1: -16.6, t=2: -18.9 min) -- opposite to static TWFE estimate.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- CS-NT group = -15.265 (SE = 6.257, t = -2.44) on monthly RCS; dynamic = -14.188 (SE = 7.413); simple = -22.806 (SE = 8.612). All statistically significant and negative -- opposite sign to TWFE.
- Spec A (CS with 19 controls, doubly-robust) returns att = 0 with status = OK. Pattern 42 numerical collapse (DR propensity score degeneracy on thin individual-level RCS group-by-time cells), not a genuine null. Status should read WARN_dr_collapse.
- Design finding (pre-trends): CS-NT event-study at t=-8: -34.2 min, t=-5: -34.3 min, t=-4: +10.8 min; highly erratic, non-flat.
- CS SE (6.26) is 3.5x TWFE SE (1.80) -- expected for RCS pseudo-panel (44 effective state clusters vs 78k individual rows).
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)

- Formally inapplicable: data_structure = repeated_cross_section.
- Informational decomposition (state-year pseudo-panel): Cohort 2017 (ATT = -3.97, wt = 47.7 percent), Cohort 2020 (ATT = +10.12, wt = 34.0 percent), Cohort 2022 (ATT = -21.49, wt = 10.4 percent). Forbidden TvT comparisons: less than 1 percent total weight -- negligible.
- COVID contamination of Cohort 2020 confirmed as the key identification threat.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN)

- Implementation WARN: runner uses n_pre = 2 of 7 available pre-periods; calibrates relative-magnitudes Mbar on minimal pre-trend information.
- All six breakdown values (TWFE first/avg/peak, CS-NT first/avg/peak) = 0: even zero deviation from parallel trends makes event-study CIs include zero.
- TWFE peak CI at Mbar=0: [-39.17, +1.05] (barely includes zero); CS-NT first CI at Mbar=0: [-19.59, +2.90].
- D-FRAGILE verdict applies to the event-study specification. The paper primary static Gardner ATT (4.45**) is not tested by this HonestDiD run.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design; CS-DID covers this design. No informational gain from DIDmultiplegtDYN.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (EXACT)

- Our TWFE = 4.6086 (SE = 1.799) matches Appendix Table 10 TWFE row (4.61, SE = 1.80) to within 0.03 percent on beta and 0.06 percent on SE.
- The 2026-04-19 CS-DID update does not affect the TWFE estimate; fidelity verdict unchanged: EXACT.
- Full report: reviews/paper-auditor.md

## Three-way controls decomposition

variables.twfe_controls is non-empty (19 individual and state-level covariates). Decomposition applies.

| Spec | TWFE beta (SE) | CS-DID NT ATT (SE) | Status |
|---|---|---|---|
| (A) both with controls | N/A | 0 / NA | Pattern 42 -- DR CS collapses on thin individual-level RCS cells; status=OK misleading |
| (B) both without controls | 1.820 (2.352) | -15.265 (6.257) | OK -- both run cleanly |
| (C) TWFE with, CS without | 4.609 (1.799) | -15.265 (6.257) | Headline (current default) |

Key ratios:
- Estimator margin (protocol-matched Spec A): NOT AVAILABLE (Pattern 42)
- Covariate margin TWFE side (C vs B): (4.609 - 1.820) / 4.609 = +60.5 percent
- Covariate margin CS side (A vs B): NOT AVAILABLE (Spec A unavailable)
- Total gap headline (C): (4.609 - (-15.265)) / 4.609 = +431 percent
- Total gap unconditional (B): (1.820 - (-15.265)) / 1.820 = +939 percent

Verbal interpretation: The estimator gap is not driven by the controls asymmetry. Even in matched unconditional Spec B, TWFE (+1.820) and CS-NT (-15.265) have opposite signs with a gap of approximately 17 minutes. Controls in Spec C add +2.79 min to TWFE (absorbing individual respondent composition effects across PSL and non-PSL states) but CS-NT is negative with or without controls. This confirms the sign reversal is a pure cohort-weighting phenomenon: COVID-contaminated Cohort 2020 large positive ATT (+10.12, weight=34 percent) dominates size-weighted estimators (TWFE, Gardner) while uniform CS-NT group-averaging down-weights it in favour of the majority-negative Cohorts 2017 (ATT=-3.97, weight=48 percent) and 2022 (ATT=-21.49, weight=10 percent). Spec A unavailability (Pattern 42) prevents a fully protocol-matched comparison and is the primary residual implementation gap for this paper.

## Material findings (sorted by severity)

**WARN -- Spec A Pattern 42 anomalous zero (implementation):** CS-NT with 19 TWFE controls (doubly-robust, est_method=dr) returns att_cs_nt_with_ctrls = 0 with cs_nt_with_ctrls_status = OK. This is a numerical collapse of the DR propensity score estimator on thin individual-level RCS group-by-time-by-control cells, not a true null effect. The OK status is misleading and should flag WARN_dr_collapse. Blocks protocol-matched Spec A comparison.

**WARN -- HonestDiD n_pre = 2 of 7 (implementation):** The runner feeds only the last 2 pre-periods to HonestDiD rather than all 7 available. Mbar calibration is based on a single pre-trend comparison, understating the full pre-trend variation (range: -34.6 to +14.8 min across t=-8 to t=-3). HonestDiD CIs at Mbar=0 are wider and less discriminating than they would be with n_pre=7.

**Design finding -- D-FRAGILE (event-study HonestDiD):** All six breakdown values (TWFE and CS-NT, three targets each) equal zero. Event-study-based estimates cannot survive any deviation from parallel trends. This applies to the event-study specification; the paper primary static Gardner ATT (4.45**) is estimated more efficiently and is not covered by this sensitivity analysis.

**Design finding -- COVID contamination of Cohort 2020:** States that adopted PSL in 2018 have pslm_state_lag2=1 from 2020 onward due to the 2-year lag construction. Treatment activation coincides exactly with COVID-19 lockdowns, which independently drove unprecedented increases in parental childcare time. The paper exclusion of March 18 to May 9, 2020 diary days may not fully resolve this confound since pslm_state_lag2=1 throughout all 12 months of 2020 for these states.

**Design finding -- Amplified sign reversal (2026-04-19 update):** CS-NT dynamic = -14.19 (SE = 7.41, t = -1.91) vs TWFE = +4.61 (SE = 1.80, t = 2.56). Gap approximately 18.8 min/day (previously approximately 7.7 min/day in the old state-year-collapsed run). Both estimates statistically significant at 10 percent or better. The reversal reflects genuine cohort-weighting divergence: COVID-contaminated Cohort 2020 large positive ATT dominates size-weighted estimators while uniform CS-NT group-averaging surfaces the majority-negative picture across other cohorts.

**Design finding -- Erratic pre-trends:** Both TWFE and CS-NT event-study pre-periods span approximately 50 minutes across t=-8 to t=-3, with no monotonic drift. ATUS thin state-year cells create high estimation noise, making it difficult to distinguish true pre-trend violations from sampling variation.

## Recommended actions

**For the repo-custodian agent:**
- Update metadata notes to explicitly document that cs_nt_with_ctrls_status = OK with att = 0 is a Pattern 42 occurrence, not a genuine null effect.
- Add WARN_dr_collapse detection logic to the template Spec A block: if abs(att_cs_nt_with_ctrls) < 0.001 and est_method = dr, set status = WARN_dr_collapse rather than OK.

**For the pattern-curator:**
- Confirm Pattern 42 covers the att = 0 with status OK variant from DR propensity score collapse on individual-level RCS with thin group-time cells (distinct from collinear-controls FAIL_collinear). Article 201 is a clean reference case for this variant.

**For the user:**
- Use Gardner estimate (4.45**, SE = 1.76) for meta-analysis, not TWFE = 4.609. Gardner is the paper primary estimator and handles staggered-timing heterogeneity appropriately.
- Key unresolved substantive tension: CS-NT (-15.27, sig) vs TWFE/Gardner (+4.45/+4.61, sig). Both are valid for their estimands. CS-NT reveals that the majority of PSL-adopting cohorts show negative effects once COVID-contaminated Cohort 2020 is down-weighted. This is a genuine empirical finding about PSL effect heterogeneity, not a methodological artefact.
- Investigate whether the 2-year PSL lag creates a structural confound beyond 2018 adopters: Cohort 2022 ATT = -21.49 may partly reflect post-pandemic return-to-work dynamics rather than a PSL effect.
- D-FRAGILE from HonestDiD applies only to the event-study specification. The static Gardner estimate has better statistical power and is the appropriate inference target for this paper.

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
