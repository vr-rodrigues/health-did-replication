# HonestDiD review: 201 — Maclean & Pabilonia (2025)

**Implementation verdict:** WARN
**Design credibility signal:** FRAGILE
**Date:** 2026-04-19 (updated with monthly CS-NT run)

*(Implementation WARN is for n_pre=2 of 7 available pre-periods used, not for low Mbar values — those are design findings.)*

## Applicability

- has_event_study: YES (event_pre=7, event_post=7)
- n_pre used in HonestDiD: 2 (of 7 available pre-periods in event_study_data.csv)
- n_post used: 4
- First post-period (TWFE t=0) point estimate: -11.65 (SE = 10.95), t = -1.06 (NOT significant at 5%)
- First post-period (CS-NT t=0) point estimate: -13.22 (SE = 10.84), t = -1.22 (NOT significant at 5%)

## Input construction (our implementation)

| Check | Status | Note |
|---|---|---|
| betahat vector excludes reference period (t=-1) | PASS | t=-1 excluded by construction; "universal" base |
| sigma matrix from event-study VCV | PASS | Internally consistent per estimator |
| numPrePeriods = 2 | WARN | Only 2 of 7 available pre-periods used. Likely runner truncates to last 2 pre-periods. HonestDiD with n_pre=2 calibrates Mbar on a minimal pre-trend window, understating potential trend violations. Sensitivity CIs are wider and less discriminating than with n_pre=7. |
| numPostPeriods = 4 | PASS | cs_max_e=5 declared; 4 post-periods in dynamic output |
| base_period = "universal" for CS-NT | PASS | att_gt call uses base_period="universal" |
| l_vec for "first" | PASS | basisVector(1, 4) |
| l_vec for "peak" | WARN | Peak selection: runner identifies peak by max |betahat/SE| among post-periods. For TWFE: t=2 has ATT=-18.90, SE=10.46, t=-1.81 → peak. For CS-NT: all positive targets overlap; peak = first (t=0: -13.22, t=2: -28.29, SE=6.98, t=-4.05; CS peak is t=2). Stored peak target in honest_did_v3.csv shows mbar_peak_twfe=0 and mbar_peak_cs=0, consistent with t=2 being a noisy large negative for TWFE. |
| Restriction type = Relative Magnitudes | PASS | createSensitivityResults_relativeMagnitudes confirmed |
| Mbarvec = seq(0, 2, 0.25) | PASS | Sensitivity file has 9 Mbar levels (0, 0.25, ..., 2.0) |

## Stored breakdown values (design-credibility evidence)

From `results/by_article/201/honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`:

| Metric | TWFE | CS-NT | Runner convention |
|---|---|---|---|
| first M̄ | 0 | 0 | basisVector(1, 4) |
| avg M̄ | 0 | 0 | equal-weight average |
| peak M̄ | 0 | 0 | basisVector(argmax|t|, 4) |

Sensitivity CIs at Mbar=0 (no violation tolerance):
- TWFE first: [-33.10, +9.86] → includes zero → FRAGILE
- TWFE avg: [-29.52, +6.87] → includes zero → FRAGILE
- TWFE peak: [-39.17, +1.05] → includes zero (barely) → FRAGILE
- CS-NT first: [-19.59, +2.90] → includes zero → FRAGILE
- CS-NT avg: [-13.73, +3.68] → includes zero → FRAGILE
- CS-NT peak: [-19.59, +2.90] → includes zero → FRAGILE

All CIs include zero at Mbar=0, meaning even zero violation of parallel trends is insufficient to establish a significant effect under the event-study specification.

## Interpretation narrative

All six HonestDiD targets (TWFE: first/avg/peak; CS-NT: first/avg/peak) return Mbar=0, indicating that the event-study-based estimates are not robust even to zero deviation from parallel trends. This is a design fragility finding: the event-study ATTs (TWFE post-period range: -11.6 to -18.9 min; CS-NT post-period range: -13.2 to -28.3 min) all have wide confidence intervals that comfortably include zero at every Mbar value in the sensitivity grid. The fragility is partially structural: with n_pre=2 (only last 2 of 7 pre-periods fed to HonestDiD), the calibration of the relative-magnitudes bound is less informative than it would be with n_pre=7. The wide event-study CIs also reflect the fundamental limitation of ATUS: state-year cells are thin (few diary days per state per period), making individual-event-time estimates noisy. The static Gardner estimate (4.45**) benefits from aggregating over all post-periods and is more stable than any single event-time ATT.

**Critical distinction:** The paper's headline Gardner estimate IS significant (+4.45, t≈2.5). HonestDiD here tests the event-study specification, which is less efficient. The D-FRAGILE verdict applies to the event-study framework's ability to pin down causal effects under sensitivity analysis, not to the paper's headline Gardner static ATT.

## Critical issues

- **n_pre=2 of 7:** The runner uses only the last 2 pre-periods before treatment (t=-2, t=-1 implicitly). This means the relative-magnitudes bound M is calibrated on a 1-step pre-trend comparison, when in fact the event study has 7 pre-periods with substantial variation (range: -34.6 to +10.8 min). With n_pre=7, the reference max pre-trend |β| would be much larger, making Mbar=0 relative magnitudes correspond to a meaningfully different absolute tolerance. The n_pre=2 truncation is a runner implementation limitation that makes the HonestDiD analysis informationally sparse.

## Recommendations

- Investigate why the runner truncates to n_pre=2. If technical (memory or solver stability with n_pre=7 and monthly CS-DID), document this as a known limitation.
- Treat all Mbar=0 findings as D-FRAGILE (event-study spec fragile), not as D-BROKEN (no feasible causal claim), because the paper's primary Gardner estimate is statistically significant.
- For the dissertation's HonestDiD chapter: cite this as an example where event-study-based sensitivity analysis has low power due to noisy pre-treatment estimates (ATUS small cells), while the aggregated static estimate is more informative.

## Reproducible snippets

```r
# From honest_did_v3_sensitivity.csv — TWFE peak CI at Mbar=0:
# lb = -39.17, ub = +1.05  (barely includes zero — most fragile target)
# CS-NT first CI at Mbar=0:
# lb = -19.59, ub = +2.90  (includes zero — CS also fragile)
```
