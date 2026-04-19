# HonestDiD Reviewer Report: Article 401 — Rossin-Slater (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Applicability
- has_event_study = true; event_pre = 5 (>= 3) — APPLICABLE
- n_pre used by honest_did_v3: 4 (periods t=-5 through t=-2; t=-1 is reference)
- n_post: 6 (periods t=0 through t=5)

### 2. TWFE sensitivity results

**Target: first post-period (t=0), ATT = -0.0180**

| Mbar | Lower | Upper | Robust? |
|------|-------|-------|---------|
| 0    | -0.048 | +0.012 | NO (zero included) |
| 0.25 | -0.051 | +0.017 | NO |
| 0.50 | -0.054 | +0.024 | NO |
| 1.0  | -0.067 | +0.040 | NO |

**Target: average post-period, ATT = -0.0106**

| Mbar | Lower | Upper | Robust? |
|------|-------|-------|---------|
| 0    | -0.030 | +0.009 | NO (zero included) |
| 0.25 | -0.046 | +0.032 | NO |
| 0.50 | -0.074 | +0.063 | NO |
| 1.0  | -0.134 | +0.125 | NO |

**Target: peak effect (t=1), ATT = -0.0201**

| Mbar | Lower | Upper | Robust? |
|------|-------|-------|---------|
| 0    | -0.041 | +0.001 | BORDERLINE (barely excludes zero) |
| 0.25 | -0.047 | +0.012 | NO |
| 0.50 | -0.061 | +0.027 | NO |
| 1.0  | -0.093 | +0.061 | NO |

**rm_first_Mbar = 0, rm_avg_Mbar = 0, rm_peak_Mbar = 0 (peak borderline at 0)**

Design classification: **D-FRAGILE** — all targets fail at Mbar=0; not robust even to zero pre-trend violations.

### 3. CS-NYT sensitivity results

**Target: first post-period (t=0), ATT = -0.0097**

| Mbar | Lower | Upper | Robust? |
|------|-------|-------|---------|
| 0    | -0.048 | +0.029 | NO |
| 0.25 | -0.061 | +0.042 | NO |
| 0.50 | -0.074 | +0.057 | NO |

**Target: average post-period, ATT = -0.0034**

All CIs encompass zero even at Mbar=0 (LB=-0.064, UB=+0.058).

**Target: peak effect (t=5), ATT = -0.0170**

CI at Mbar=0: [-0.207, +0.172] — extremely wide (poor precision in CS-NYT event study).

CS-NYT: rm_first = rm_avg = rm_peak = 0. Also D-FRAGILE.

### 4. Interpretation

The pre-trend pattern for TWFE shows a systematic positive upward drift (all 4 pre-periods positive: +0.027, +0.010, +0.018, +0.021), which is the reason HonestDiD CIs widen quickly. Even at Mbar=0, the first-period CI [-0.048, +0.012] already spans zero, indicating the point estimate of -0.018 is not distinguishable from zero under the assumption of exactly parallel trends.

The peak effect (t=1, -0.020) barely excludes zero at Mbar=0 (UB=+0.001), but this is on the boundary and any non-zero violation of parallel trends eliminates significance.

**This is a classic D-FRAGILE result: the headline causal claim is not robust to even minimal pre-trend violations.**

### 5. Verdict justification
WARN (not FAIL): The point estimates are consistently negative (direction plausible), and the pre-trends are not individually significant. However, the lack of robustness at even Mbar=0 for all targets except peak means the effect cannot be claimed as established under honest sensitivity analysis.

## References
- Sensitivity data: `results/by_article/401/honest_did_v3_sensitivity.csv`
- Summary: `results/by_article/401/honest_did_v3.csv`
- Plot: `results/by_article/401/honest_did_v3.pdf`
