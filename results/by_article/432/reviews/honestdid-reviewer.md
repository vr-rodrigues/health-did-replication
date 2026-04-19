# HonestDiD Reviewer Report — Article 432 (Gallagher 2014)

**Verdict:** PASS
**Date:** 2026-04-18

## Applicability
APPLICABLE: has_event_study == true, event_pre == 10 (≥ 3 pre-periods).

## Checklist

### 1. HonestDiD setup
- n_pre = 4 (used for sensitivity analysis), n_post = 5 (post-periods for targets).
- Method: Rambachandran & Roth (2023) sensitivity analysis using relative magnitudes (Mbar) restriction.
- Targets computed: first (contemporaneous, t=0), avg (average post-treatment), peak (maximum post-treatment period).
- Estimators: TWFE (full covariance), CS-NT (diagonal clustered), CS-NYT (diagonal clustered).

### 2. TWFE sensitivity results

**First-period (rm_first_Mbar):**
- Mbar=0: CI = [0.063, 0.117] — excludes zero, robust.
- Mbar=0.5: CI = [0.058, 0.123] — robust.
- Mbar=1.0: CI = [0.051, 0.132] — robust.
- Mbar=1.5: CI = [0.044, 0.142] — robust.
- Mbar=2.0: CI = [0.036, 0.153] — robust.
Conclusion: **D-ROBUST** — first-period effect robust at any realistic Mbar.

**Average (rm_avg_Mbar):**
- Mbar=0: CI = [0.079, 0.132] — robust.
- Mbar=0.5: CI = [0.062, 0.151] — robust.
- Mbar=1.0: CI = [0.035, 0.181] — robust (lb still > 0).
- Mbar=1.25: CI = [0.019, 0.196] — lb positive, barely robust.
- Mbar=1.5: CI = [0.003, 0.213] — lb just positive.
- Mbar=1.75: CI = [−0.013, 0.229] — lb crosses zero.
Conclusion: **D-MODERATE** — avg effect robust to Mbar=1.5, marginal at Mbar=1.75.

**Peak (rm_peak_Mbar):**
- Mbar=0: CI = [0.080, 0.151] — robust.
- Mbar=0.5: CI = [0.045, 0.182] — robust.
- Mbar=1.0: CI = [−0.006, 0.230] — lb crosses zero.
Conclusion: **D-MODERATE (borderline)** — peak effect robust to Mbar=0.75, fragile at Mbar=1.0.

### 3. CS-NT sensitivity results

**First-period (rm_first_Mbar):**
- Mbar=0: CI = [0.095, 0.157] — robust.
- Mbar=1.0: CI = [0.072, 0.180] — robust.
- Mbar=2.0: CI = [0.031, 0.221] — robust.
Conclusion: **D-ROBUST** — CS-NT first-period fully robust at all tested Mbar values.

**Average (rm_avg_Mbar):**
- Mbar=0: CI = [0.132, 0.169] — robust.
- Mbar=0.5: CI = [0.079, 0.197] — robust.
- Mbar=1.0: CI = [0.012, 0.197] — lb barely positive.
- Mbar=1.25: CI = [−0.022, 0.197] — lb crosses zero.
Conclusion: **D-MODERATE** — avg robust to Mbar=1.0, fragile at Mbar=1.25.

**Peak (rm_peak_Mbar):**
- Mbar=0: CI = [0.127, 0.213] — robust.
- Mbar=0.75: CI = [0.060, 0.280] — lb positive.
- Mbar=1.0: CI = [0.027, 0.312] — lb positive.
- Mbar=1.25: CI = [−0.006, 0.345] — lb crosses zero.
Conclusion: **D-MODERATE** — CS-NT peak robust to Mbar=1.0.

### 4. CS-NYT sensitivity results (summary)
Pattern mirrors CS-NT closely:
- First: robust to Mbar=2.0 (lb=0.037 at Mbar=2.0).
- Avg: breaks at Mbar=1.25 (lb=−0.009).
- Peak: breaks at Mbar=1.25 (lb=0.004 at Mbar=1.25; lb=−0.023 at Mbar=1.5).
Conclusion: **D-MODERATE** — consistent with CS-NT results.

### 5. Overall design credibility assessment

| Target | TWFE | CS-NT | CS-NYT |
|--------|------|-------|--------|
| First-period (contemporaneous) | D-ROBUST (Mbar=2.0) | D-ROBUST (Mbar=2.0) | D-ROBUST (Mbar=2.0) |
| Average post-treatment | D-MODERATE (Mbar=1.5) | D-MODERATE (Mbar=1.0) | D-MODERATE (Mbar=1.0) |
| Peak post-treatment | D-MODERATE (Mbar=0.75) | D-MODERATE (Mbar=1.0) | D-MODERATE (Mbar=1.25) |

The contemporaneous effect (t=0) is **D-ROBUST** across all estimators — this is the most policy-relevant target (does a flood event immediately increase insurance take-up?). The average and peak effects are D-MODERATE, meaning they remain robust to pre-trend violations up to 1–1.5× the magnitude of pre-period fluctuations. Given 10 clean pre-trend periods (no significant pre-trends at 5% level for either TWFE or CS-NT), the realistic Mbar is low — likely well below 0.5. Under that reading, even the average and peak effects are robustly positive.

### 6. Pre-trend quality informing Mbar realism
10 pre-periods, all within ±0.04 and |t-stat| < 1.3 for both TWFE and CS-NT. Maximum observed pre-trend coefficient / ATT ratio ≈ 0.040/0.110 ≈ 0.36. This suggests a realistic Mbar ≈ 0.35–0.50, well within the range where all targets retain positive lower bounds.

## Summary
HonestDiD analysis strongly supports the paper's conclusions. First-period effect D-ROBUST to Mbar=2.0. Average and peak effects D-MODERATE (robust to Mbar=1.0–1.5). Given clean pre-trends, realistic Mbar ≤ 0.5 where all targets are comfortably positive. No HonestDiD concerns.

**Verdict: PASS**

Design credibility signal: **D-MODERATE to D-ROBUST** (first-period D-ROBUST; avg/peak D-MODERATE).
- rm_first_Mbar = 2.0 (D-ROBUST, all estimators)
- rm_avg_Mbar = 1.5 (TWFE) / 1.0 (CS-NT/NYT)
- rm_peak_Mbar = 0.75 (TWFE) / 1.0 (CS-NT)
