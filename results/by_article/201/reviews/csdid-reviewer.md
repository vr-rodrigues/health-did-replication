# CSDID review: 201 — Maclean & Pabilonia (2025)

**Verdict:** WARN
**Date:** 2026-04-19 (updated for monthly CS-DID run — panel=FALSE directly on 78k obs)

## Summary

CS-DID NT now runs directly on the 78,080 monthly individual-level ATUS observations via `panel=FALSE`, assigning a fresh `row_id__` pseudo-ID to each row. The 2026-04-19 template update removed the prior state×year pre-aggregation step that had (a) collapsed 78k individual records to ~880 state-year cells, (b) destroyed all 19 individual-level TWFE controls (age, female, education, etc.) in the process, and (c) produced a less informative att_gt(g,t) cell structure. The updated run gives CS-NT group aggregation = -15.265 (SE = 6.257, t = -2.44), CS-NT dynamic = -14.188 (SE = 7.413), CS-NT simple = -22.806 (SE = 8.612). The sign reversal vs TWFE (+4.609) is thus amplified from 7.7 min (old) to ~20 min (new). WARN is retained because: (1) Spec A (CS with controls) returns an anomalous zero — Pattern 42; (2) the event-study pre-trend pattern in CS-NT is erratic (t=-8: -34.2, t=-5: -34.3, t=-4: +10.8) with 8 pre-periods of noisy variation; (3) the dramatic magnitude difference across aggregations (simple=-22.8, dynamic=-14.2, group=-15.3) signals cohort composition effects.

## Checks

| # | Check | Status | Note |
|---|---|---|---|
| 1.1 | idname = fips valid | PASS | 44 state FIPS codes, time-invariant |
| 1.2 | tname = time (monthly numeric) | PASS | 239 monthly periods, strictly ordered |
| 1.3 | gvar = gvar_CS (year of first treatment) | PASS | Constructed from pslm_state_lag2==1; gvar=0 for never-treated |
| 1.4 | panel=FALSE (RCS) | PASS | row_id__ pseudo-ID; correct for RCS data |
| 2.1 | No pre-balance filter | PASS | Template does not filter to balanced pseudo-panel |
| 2.2 | cs_sample_filter justified | PASS | Same sample_filter (hh_child==1) as TWFE; no separate cs_sample_filter |
| 2.3 | cs_construct_vars | PASS | gvar construction only (join to get first_t); restored correctly |
| 2.4 | cs_allow_unbalanced | PASS | allow_unbalanced=FALSE at TWFE level; RCS uses panel=FALSE so balancing irrelevant |
| 2.5 | Late-treated drop (Pattern 25) | PASS | gvar > max(time) check applied; no late-treated obs in this sample |
| 3.1 | yname = carehh_k | PASS | Matches outcome |
| 3.2 | tname / idname / gname args | PASS | All correctly mapped |
| 3.3 | xformla = ~1 (unconditional) | PASS | cs_controls = [] per metadata |
| 3.4 | weightsname = wt06 | PASS | Survey weights applied |
| 3.5 | clustervars = fips | PASS | State-level cluster matches TWFE |
| 3.6 | control_group = "nevertreated" | PASS | 34 never-treated states |
| 3.7 | panel = FALSE | PASS | RCS correctly set |
| 3.8 | base_period = "universal" | PASS | Standard; required for HonestDiD compatibility |
| 3.9 | Three-way controls decomposition | WARN | Spec A (CS with twfe_controls) returns 0/anomalous (Pattern 42). See below. |
| 4.1 | aggte type="group","simple","dynamic" | PASS | All three computed |
| 4.2 | cs_max_e = 5 clipping | PASS | Declared in metadata; dynamic aggregation clipped at e=5 |
| 5.1 | Sign concordance | WARN | TWFE=+4.609 (sig) vs CS-NT group=-15.265 (sig). Both significant, opposite signs. MATERIAL reversal. |
| 5.2 | Magnitude divergence | WARN | |CS-NT/TWFE| = 3.3; well outside [0.5, 2] threshold |
| 5.3 | CS SE vs TWFE SE ratio | WARN | SE ratio = 6.257/1.799 = 3.48; CS SEs are 3.5x TWFE. RCS pseudo-ID means CS VCV estimated over 78k rows but effective clustering is 44 states. |
| 6.1 | Event study window check | PASS | 8 pre-periods, 7 post-periods per event_study_data.csv |
| 6.2 | Estimates at every egt | PASS | All 16 event-time cells present |
| 6.3 | At least 3 pre-periods | PASS | 8 pre-periods (t=-8 to t=-1, reference t=-1) |
| 7.1 | Parallel trends pre-test | WARN | CS-NT pre-periods highly erratic: t=-8=-34.2, t=-7=-17.6, t=-6=-32.6, t=-5=-34.3, t=-4=+10.8, t=-3=+14.8, t=-2=-27.9. Non-flat, large magnitudes relative to post-treatment. |

## Three-way controls decomposition

| Spec | TWFE β (SE) | CS-DID NT ATT (SE) | Status |
|---|---|---|---|
| (A) both with controls | — | 0 / NA | Pattern 42 — CS DR estimator with 19 controls collapses to 0 on individual-level RCS |
| (B) both without controls | 1.820 (2.352) | -15.265 (6.257) | OK |
| (C) TWFE with, CS without | 4.609 (1.799) | -15.265 (6.257) | Headline (current) |

Key ratios:
- Estimator margin (protocol-matched Spec A): NOT AVAILABLE (Pattern 42)
- Covariate margin (TWFE side): (4.609 - 1.820) / |4.609| = **+60.5%** — controls substantially raise TWFE estimate
- Covariate margin (CS side): Spec A unavailable
- Total gap (Spec B): (1.820 - (-15.265)) / |1.820| = **+939%** — enormous gap even without controls

Interpretation: The estimator gap is not driven by the controls asymmetry. Even in the matched unconditional Spec B, TWFE (+1.820) and CS-NT (-15.265) differ by over 17 minutes with opposite signs. This is a pure cohort-weighting divergence: TWFE/Gardner give disproportionate weight to the large, COVID-contaminated Cohort 2020 (ATT=+10.12, Bacon weight=34%), while CS-NT uses uniform group×time weighting which downweights this cohort relative to Cohorts 2017 (ATT=-3.97) and 2022 (ATT=-21.49). Spec A failure (Pattern 42) is an implementation limitation of doubly-robust CS on individual-level RCS with 19 controls across thin group×time cells.

## Pattern 42 documentation

Spec A (CS-NT with 19 twfe_controls, doubly-robust est_method="dr") reports `att_cs_nt_with_ctrls = 0 / NA` with status = "OK" in results.csv. This is anomalous — a zero ATT with status OK indicates numerical collapse in the DR propensity score estimation rather than a true null effect. Root cause: at the individual RCS level, 19 controls (including binary demographics) create thin or degenerate group×time×control cells for the 6 cohorts, causing propensity score near-saturation. The template catches this as `status = "OK"` because it does not distinguish a genuine null from a numerical zero; the DR aggte=0 is a Pattern 42 artifact, not evidence that PSL has zero effect.

## Critical issues

- **Spec A returns anomalous zero (Pattern 42):** The doubly-robust CS-NT with 19 twfe_controls produces `att_cs_nt_with_ctrls = 0`. This is a known numerical failure mode for DR estimation on thin individual-level RCS cells, not a true effect estimate. The `cs_nt_with_ctrls_status = "OK"` field should ideally flag this as `"FAIL_thin_cells"` or `"WARN_dr_collapse"`. Recommend: update status field logic to detect near-zero att_gt aggregates.

## Recommendations

- Update failure-pattern detection in Spec A block to distinguish genuine nulls from numerical collapses (add check: if abs(att) < 0.001 and est_method="dr", set status="WARN_dr_collapse").
- Document in metadata notes that Spec A is unavailable for this paper due to Pattern 42.
- For meta-analysis: use the paper's Gardner (4.45**) estimate, not CS-NT (-15.265) which captures the aggregate of all cohorts including the COVID-contaminated Cohort 2020 under uniform weighting.

## Reproducible snippets

```r
# CS-DID NT (updated: panel=FALSE, monthly RCS)
att_gt(yname="carehh_k", tname="time", idname="row_id__",
       gname="gvar_CS", xformla=~1, weightsname="wt06",
       clustervars="fips", control_group="nevertreated",
       panel=FALSE, allow_unbalanced_panel=FALSE,
       base_period="universal", data=df_cs_nt)
# → aggte("group")$overall.att = -15.265 (SE = 6.257)
# → aggte("dynamic", max_e=5)$overall.att = -14.188 (SE = 7.413)
```
