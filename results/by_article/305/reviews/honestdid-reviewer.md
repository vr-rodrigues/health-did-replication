# HonestDiD Reviewer Report — Article 305 (Brodeur & Yousaf 2020)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- has_event_study: true — APPLICABLE
- event_pre: 5 (≥3) — APPLICABLE

## Setup
- n_pre used: 2 (periods t-2 to t-1, after normalising t-1=0)
- n_post used: 4 (periods t=0 to t=3... wait: rm_peak corresponds to t=3 per honest_did_v3.csv att_peak=-1.056)
- Sensitivity analysis run under the "relative magnitudes" restriction (Mbar)
- Three target parameters: first-post (t=0), avg (t=0 to t+max), peak (maximum absolute post-period)

## Results by estimator

### TWFE sensitivity
| Target | Mbar=0 lb | Mbar=0 ub | Interpretation |
|--------|-----------|-----------|----------------|
| first  | -0.565    | +0.326    | CI includes zero at M=0 — NOT ROBUST |
| avg    | -1.247    | +0.046    | CI barely includes zero at M=0 — FRAGILE |
| peak   | -1.973    | -0.143    | CI excludes zero at M=0 — ROBUST |

- TWFE first-post estimate (-0.121) is not significant and not robust to any pre-trend violations.
- TWFE average effect is marginally fragile — the upper bound is +0.046 at M=0, meaning even a tiny amount of pre-trend would include zero.
- TWFE peak effect (-1.056 at t=3) is robust to M=0 but the upper bound (-0.143) is barely negative.
- At M=0.25, the TWFE peak CI: lb=-2.163, ub=+0.029 — already crosses zero.

### CS-NT sensitivity
| Target | Mbar=0 lb | Mbar=0 ub | Interpretation |
|--------|-----------|-----------|----------------|
| first  | -0.806    | +0.213    | CI includes zero at M=0 — NOT ROBUST |
| avg    | -1.607    | -0.170    | CI excludes zero at M=0 — ROBUST |
| peak   | -2.231    | -0.121    | CI excludes zero at M=0 — ROBUST |

- CS-NT average and peak effects are robust to pre-trend violations of the observed pre-period magnitude (M=0).
- CS-NT first-post is not robust (similar to TWFE — the immediate effect is small and insignificant).
- At M=0.25: CS-NT avg lb=-1.948, ub=+0.156 — crosses zero, so not robust beyond M=0.

## Key findings
1. The immediate (t=0) effect is NOT robust under either estimator — consistent with a delayed treatment effect.
2. The average treatment effect is fragile for TWFE (barely includes zero at M=0) but robust for CS-NT at M=0.
3. The peak effect is robust at M=0 for both estimators, but breaks quickly (M=0.25) under TWFE.
4. The n_pre=2 is a limitation: HonestDiD is more powerful with more pre-periods. The sensitivity analysis here uses a narrow window.
5. The large pre-trend coefficients at t-5 and t-6 (well outside the n_pre=2 window used for HonestDiD) suggest that M=0 is an unrealistically optimistic scenario — the true M should be calibrated to the t-5/t-6 movement, which would be M>>1 for both TWFE and CS-NT, making ALL targets fragile.

## Verdict rationale
WARN: The peak effect is nominally robust at M=0 for both estimators, but the pre-trend evidence (t-5: +0.52/+1.70, t-6: +1.27/+2.63 for TWFE/CS-NT respectively) implies the realistic M calibration is well above 0. If M were calibrated to the t-5 or t-6 pre-trends, all targets would include zero in their sensitivity CIs. The HonestDiD analysis should be considered diagnostic only, and the large observed pre-trends are the dominant concern.

## Links
Full data: `results/by_article/305/honest_did_v3.csv`, `results/by_article/305/honest_did_v3_sensitivity.csv`
