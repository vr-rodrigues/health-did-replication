# HonestDiD Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19
**Re-run reason:** Applicability gate re-evaluated post-fix.

## Applicability gate
- has_event_study = true, event_pre = 2.
- Applicability rule: "at least 3 pre-periods." This design has only 2 pre-periods (t=-3 and t=-2, with t=-1 as the normalised reference = 0).
- **Verdict: NOT_APPLICABLE.** Protocol gate not met.

## Informational note (not part of formal rating)
Although the applicability gate was not met, honest_did_v3.csv was produced in a prior run. The breakdown M̄ values are informative for the design-credibility axis and are reported here for completeness. They are NOT counted in the implementation score.

From honest_did_v3.csv:
| Estimator | M̄_first | M̄_avg | M̄_peak |
|---|---|---|---|
| TWFE | 0.50 | 0.50 | 0.75 |
| CS-NT | 0.75 | 1.00 | 0.75 |

Interpretation: CS-NT average effect is robust to M̄ ≈ 1.0 (the pre-trend can grow by 100% of its pre-trend magnitude while the sign of the average effect is preserved). CS-NT first-period effect breaks at M̄ ≈ 0.75. These values are in the D-MODERATE range (M̄ in [0.5, 1.0]).

Caution: with only 2 pre-periods, sensitivity bounds are wider and less precise than with 3+ pre-periods. The M̄ values above should be interpreted conservatively.

**Overall:** NOT_APPLICABLE (applicability gate: only 2 pre-periods)
