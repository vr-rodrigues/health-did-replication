# HonestDiD Reviewer Report — Article 271

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** honestdid-reviewer

---

## 1. Applicability check

- `has_event_study`: true
- `event_pre`: 5 (5 pre-periods in the data)
- HonestDiD uses n_pre = 2 (from honest_did_v3.csv) due to CS-NT infeasibility with universal base period (single cohort). TWFE-only analysis.
- n_pre = 2 meets the ≥ 2 requirement but is less than the 5 physically available. This is a structural constraint, not a coding error.

## 2. Sensitivity analysis — "first" target (t=0, ATT=3.017)

| Mbar | lb | ub | Significant? |
|---|---|---|---|
| 0 | 0.448 | 5.565 | YES |
| 0.25 | 0.290 | 5.724 | YES |
| 0.50 | 0.079 | 5.882 | YES (barely) |
| 0.75 | -0.132 | 6.040 | NO |
| 1.00 | -0.343 | 6.198 | NO |
| 2.00 | -1.398 | 7.042 | NO |

- `rm_first_Mbar` = 0.50 (significance preserved up to Mbar=0.5, breaks at 0.75).
- Design signal: **D-MODERATE** for the first-period effect.
- Note: the first-period effect (3.02) is economically small — it is the initial year of treatment when seed adoption was just beginning. The fragility of this specific target is economically expected and not concerning.

## 3. Sensitivity analysis — "avg" target (avg ATT over t=0..3 = 20.84)

| Mbar | lb | ub | Significant? |
|---|---|---|---|
| 0 | 13.015 | 28.730 | YES |
| 0.5 | 12.360 | 29.385 | YES |
| 1.0 | 11.378 | 30.204 | YES |
| 1.5 | 10.232 | 31.186 | YES |
| 2.0 | 9.086 | 32.332 | YES |

- `rm_avg_Mbar` > 2.0: CIs remain entirely positive even at Mbar=2.0.
- Design signal: **D-ROBUST** for the average effect.

## 4. Sensitivity analysis — "peak" target (t=3, ATT=39.384)

| Mbar | lb | ub | Significant? |
|---|---|---|---|
| 0 | 23.119 | 55.386 | YES |
| 0.5 | 22.121 | 56.384 | YES |
| 1.0 | 21.123 | 57.715 | YES |
| 1.5 | 19.460 | 59.046 | YES |
| 2.0 | 17.797 | 60.709 | YES |

- `rm_peak_Mbar` > 2.0: Peak effect robust to extreme pre-trend violations.
- Design signal: **D-ROBUST** for the peak effect.

## 5. Design signal summary

| Target | rm_Mbar | Design rating |
|---|---|---|
| First (t=0) | 0.50 | D-MODERATE |
| Avg (t=0..3) | >2.0 | D-ROBUST |
| Peak (t=3) | >2.0 | D-ROBUST |

## 6. CS-NT HonestDiD feasibility

- CS-NT with universal base period returns SE=NA for all pre-treatment ATTs — making HonestDiD infeasible for CS-NT. This is documented in the metadata notes.
- Only TWFE HonestDiD is available. This is adequate given TWFE = CS-NT by construction for single-cohort designs.

## 7. Verdict rationale

The economically meaningful targets (average and peak) are D-ROBUST, surviving up to Mbar=2.0 with confidence intervals well above zero. The first-period target is D-MODERATE, but this is structurally expected (the first year of Green Revolution had minimal immediate seed adoption). HonestDiD provides strong support for the causal interpretation of the growing post-1966 HYV expansion. **PASS.**
