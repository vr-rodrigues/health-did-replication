# Skeptic report: 201 - Maclean & Pabilonia (2025)

**Overall rating:** MODERATE  *(built from Fidelity x Implementation)*
**Design credibility:** FRAGILE  *(separate axis - a finding about the paper, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; design: sign reversal + Pattern 42), bacon (NOT_APPLICABLE; informational TvT<1%), honestdid (impl=WARN n_pre=2/7; Mbar=0 all targets), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT)

## Executive summary

Maclean & Pabilonia (2025) study state paid sick leave (PSL) mandates and parental primary childcare time using ATUS repeated cross-section data (2004-2023; N=78,080 adults with children in the household). Their primary estimator is Gardner (did2s), reporting +4.45 min/day. TWFE appears only in Appendix Table 10 as one of five alternative estimators. Our stored TWFE = +4.609 (SE=1.799) reproduces the paper exactly (F-HIGH, EXACT; deviation 0.03%). Implementation is clean on all axes except one: the HonestDiD runner feeds only n_pre=2 of 7 available pre-periods, giving I-MOD and an overall rating of MODERATE. Rating corrected from prior LOW (old conflated rubric counted design findings as Axis-2 implementation issues). The sign reversal (TWFE=+4.61 vs CS-NT=-15.27), all-zero HonestDiD Mbar values, erratic pre-trends, and COVID contamination of Cohort 2020 are design findings (Axis 3, D-FRAGILE) -- not demerits against our reanalysis. Use the paper Gardner estimate (+4.45**) for meta-analysis; the stored TWFE=4.609 is correctly reproduced and reveals genuine cohort-weighting heterogeneity when placed alongside CS-NT.

## Per-reviewer verdicts

### TWFE (PASS on implementation)

- TWFE = +4.609 (SE=1.799, t=2.56); faithfully implements Appendix Table 10 (fips+time FEs, 19 controls, state-cluster, wt06). Pattern 50 ALIGNED: CS-DID runs on same 78k monthly rows.
- Design finding: TWFE post-treatment event-study coefficients uniformly negative (t=0: -11.6, t=1: -16.6, t=2: -18.9 min), opposite to the static estimate. Controls add +60.5% to TWFE (Spec B: +1.820 vs Spec C: +4.609), reflecting individual-respondent composition effects across PSL/non-PSL states.
- Design finding: COVID contamination of Cohort 2020 (ATT=+10.12, Bacon wt=34%) drives positive TWFE. Size-weighted estimators (TWFE, Gardner) concentrate on this cohort; CS-NT uniform group weighting distributes weight across majority-negative cohorts.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (PASS on implementation; design findings: sign reversal, Pattern 42)

- CS-NT runs directly on 78k monthly individual-level observations via panel=FALSE (2026-04-19 update). All specification checks PASS: gvar construction, panel=FALSE for RCS, weights and cluster match TWFE.
- Spec A (doubly-robust CS-NT with 19 controls) returns att=0, status=OK -- Pattern 42 (DR propensity near-saturation on thin RCS group-by-time cells), a structural property analogous to articles 47, 79, 335, 358. Not a pipeline error; misleading OK label is a minor labelling issue, not a material implementation fault.
- Design finding: CS-NT group=-15.265 (SE=6.257, t=-2.44); dynamic=-14.188 (SE=7.413); simple=-22.806 (SE=8.612). All significant and negative, opposite sign to TWFE. Confirmed unconditional in Spec B (TWFE=+1.820 vs CS-NT=-15.265, ~17 min), ruling out controls asymmetry as cause.
- Design finding: CS-NT pre-periods highly erratic (t=-8: -34.2, t=-5: -34.3, t=-4: +10.8 min).
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE; informational decomposition)

- Formally inapplicable: data_structure=repeated_cross_section.
- Informational state-year pseudo-panel: TvT (forbidden) <1% of TWFE weight -- negligible. Cohort 2017 (ATT=-3.97, wt=47.7%), Cohort 2020 (ATT=+10.12, wt=34.0%), Cohort 2022 (ATT=-21.49, wt=10.4%). COVID contamination of Cohort 2020 confirmed as primary identification threat.
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (impl=WARN; design signal: D-FRAGILE)

- Implementation WARN (Axis 2): runner uses n_pre=2 of 7 available pre-periods. Mbar calibrated on a single pre-trend comparison, understating full pre-trend variation (range: -34.6 to +14.8 min across t=-8 to t=-3). This is a runner implementation limitation in our pipeline.
- Design finding (Axis 3): all six Mbar breakdown values = 0 (TWFE first/avg/peak, CS-NT first/avg/peak). TWFE peak CI at Mbar=0: [-39.17, +1.05]; CS-NT first CI: [-19.59, +2.90]. D-FRAGILE applies to the event-study specification, not the paper primary static Gardner ATT (+4.45**).
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design; CS-DID covers this design. No informational gain from DIDmultiplegtDYN.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (EXACT)

- TWFE = 4.6086 (SE=1.799) matches Appendix Table 10 (4.61, SE=1.80) within 0.03% on beta and 0.06% on SE. Fidelity: F-HIGH (EXACT).
- Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

## Three-way controls decomposition

variables.twfe_controls is non-empty (19 individual- and state-level covariates).

| Spec | TWFE beta (SE) | CS-DID NT ATT (SE) | Status |
|---|---|---|---|
| (A) both with controls | N/A | 0 / NA | Pattern 42 -- DR collapse on individual-level RCS thin cells; status=OK misleading |
| (B) both without controls | 1.820 (2.352) | -15.265 (6.257) | OK |
| (C) TWFE with, CS without | 4.609 (1.799) | -15.265 (6.257) | Headline (current default) |

Key ratios:
- Estimator margin (protocol-matched Spec A): NOT AVAILABLE (Pattern 42)
- Covariate margin TWFE side (C vs B): (4.609 - 1.820) / |4.609| = +60.5%
- Total gap headline (Spec C): (4.609 - (-15.265)) / |4.609| = +431%
- Total gap unconditional (Spec B): (1.820 - (-15.265)) / |1.820| = +939%

Verbal interpretation: The estimator gap is not driven by controls asymmetry. Even in matched unconditional Spec B, TWFE (+1.820) and CS-NT (-15.265) have opposite signs with a ~17-min gap. The reversal is a pure cohort-weighting divergence: COVID-contaminated Cohort 2020 (ATT=+10.12, wt=34%) dominates size-weighted estimators (TWFE, Gardner), while CS-NT uniform group weighting surfaces the majority-negative cohort picture (Cohorts 2017, 2022). Spec A unavailability is a known structural limitation for DR CS-DID on individual-level RCS with many controls.

## Material findings (sorted by severity)

**Implementation WARN -- HonestDiD n_pre=2 of 7 (Axis 2):** Runner feeds only last 2 pre-periods to HonestDiD rather than all 7 available. Mbar calibration understates full pre-trend variation (range -34.6 to +14.8 min). HonestDiD CIs are wider and less discriminating than they would be with n_pre=7.

**Design finding -- COVID contamination of Cohort 2020 (Axis 3, D-FRAGILE):** 2-year PSL lag maps 2018 mandate adoptions to 2020 treatment activation, coinciding with COVID-19 lockdowns. Cohort 2020 ATT=+10.12 with Bacon weight=34% dominates size-weighted estimators. Paper sample restriction (excl. March 18-May 9 2020 diary days) may not fully resolve the confound since pslm_state_lag2=1 throughout all 12 months of 2020 for these states.

**Design finding -- Amplified sign reversal (Axis 3):** CS-NT dynamic=-14.19 (SE=7.41, t=-1.91) vs TWFE=+4.61 (SE=1.80, t=2.56). Both significant; opposite signs; ~19 min/day gap. Confirmed in unconditional Spec B (~17 min), ruling out controls asymmetry.

**Design finding -- All HonestDiD Mbar=0 (Axis 3, D-FRAGILE):** Event-study-based estimates not robust to any deviation from parallel trends. Applies to event-study specification only; paper primary static Gardner ATT has better power and is the appropriate inference target.

**Design finding -- Erratic pre-trends (Axis 3):** Both TWFE and CS-NT pre-periods span ~50 min across t=-8 to t=-3. ATUS thin state-year cells create high noise; difficult to distinguish genuine violations from sampling variation.

**Design finding -- Pattern 42 Spec A zero (Axis 3):** DR CS-NT with 19 controls returns att=0 with status=OK -- structural property of doubly-robust estimation on thin individual-level RCS cells, not a pipeline error.

## Recommended actions

**For the repo-custodian agent:**
- Update Spec A status-detection in the template: if abs(att_cs_nt_with_ctrls) < 0.001 and est_method=dr, set status=WARN_dr_collapse rather than OK. Article 201 is the canonical reference case.

**For the pattern-curator:**
- Confirm Pattern 42 covers the att=0/status=OK variant from DR propensity collapse on individual-level RCS with thin group-by-time cells. Article 201 (19 controls, 239 monthly periods, 6 cohorts) is a clean reference case.

**For the user:**
- Use Gardner estimate (+4.45**, SE=1.76) for meta-analysis, not TWFE=+4.609. Gardner is the paper primary estimator and is heterogeneity-robust.
- The substantive tension (CS-NT=-15.27 sig vs TWFE/Gardner=+4.45/+4.61 sig) is a genuine empirical finding about PSL effect heterogeneity driven by COVID contamination of Cohort 2020. Both estimates are valid for their respective estimands.
- Investigate whether the 2-year PSL lag creates confounds beyond 2018 adopters: Cohort 2022 (ATT=-21.49) may partly reflect post-pandemic return-to-work dynamics.
- D-FRAGILE from HonestDiD applies only to the event-study specification. Static Gardner ATT has better power and is the appropriate inference target.

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
