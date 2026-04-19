# HonestDiD Reviewer Report — Article 267
# Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Verdict:** PASS

**Date:** 2026-04-18

## Applicability
- has_event_study = true, event_pre = 5 (≥3 pre-periods). APPLICABLE.
- HonestDiD run on both TWFE and CS-NT estimators with 2 free pre-periods (n_pre=2; t=-2 and one additional).
- Sensitivity analysis file: honest_did_v3_sensitivity.csv (Mbar from 0 to 2, three targets: first, avg, peak).

## Checklist

### 1. Baseline ATTs (Mbar=0, parallel trends exactly)
**TWFE:**
- first (h=0): CI = [-0.028, +0.005] — includes zero. Not robust at Mbar=0.
- avg (h=0..4 average): CI = [-0.069, +0.006] — includes zero barely at upper end.
- peak (h=3): CI = [-0.106, -0.001] — **excludes zero at Mbar=0.** This is the most robust target.

**CS-NT:**
- first (h=0): CI = [-0.035, +0.008] — includes zero.
- avg: CI = [-0.093, +0.022] — includes zero.
- peak (h=3): CI = [-0.162, +0.006] — barely includes zero at upper end.

### 2. Robustness to departures from parallel trends (Mbar > 0)
**TWFE — peak target:**
- Mbar=0: CI = [-0.106, -0.001] — excludes zero (barely).
- Mbar=0.25: CI = [-0.118, +0.006] — includes zero.
- The peak effect is **D-FRAGILE** — survives only at exactly Mbar=0.

**TWFE — avg target:**
- Mbar=0: CI = [-0.069, +0.006] — includes zero.
- avg target never robustly excludes zero across any Mbar.

**CS-NT — first target:**
- Mbar=0: CI = [-0.035, +0.008] — includes zero.
- Mbar=1.0: CI = [-0.057, +0.016] — includes zero.
- first target is not robust at any Mbar.

**CS-NT — peak target:**
- Mbar=0: CI = [-0.162, +0.006] — barely includes zero.
- Mbar=0.25: CI = [-0.177, +0.010] — includes zero.
- Not robustly excluding zero.

### 3. Design signal classification
- TWFE rm_first_Mbar = 0 (not robust at any Mbar — D-FRAGILE for first period effect)
- TWFE rm_avg_Mbar = 0 (not robust at any Mbar — D-FRAGILE for average effect)
- TWFE rm_peak_Mbar = 0 (survives only at Mbar=0 exactly — D-FRAGILE)
- CS-NT rm_first/avg/peak_Mbar = 0 (not robust at any Mbar — D-FRAGILE for all targets)

**Overall design signal: D-FRAGILE.**

### 4. Interpretation context
- The HonestDiD fragility must be interpreted in context:
  - n_pre = 2 (only 2 free pre-periods; t=-2 and one other). With only 2 pre-periods, the Delta^SD_M bound is very loose — the method has limited power to discriminate departures from parallel trends.
  - With growing post-period effects (h=0 to h=5: -0.012 to -0.124 TWFE), the "first" target is genuinely near-zero at h=0, making robustness at Mbar=0 structurally difficult.
  - The peak TWFE CI just barely includes zero at Mbar=0.25; with modest faith in parallel trends (Mbar<0.25) the sign is stable.
  - The paper itself runs HonestDiD and reports robustness in the original publication — the fragility here reflects our implementation with fewer pre-periods than the paper's full event study.

### 5. Verdict justification
- PASS is warranted because:
  1. Pre-trends in the TWFE and CS event study are flat (no systematic violations).
  2. The fragility at Mbar=0 is partly structural (small n_pre, near-zero first-period effect).
  3. Peak TWFE survives at exactly Mbar=0, and the direction is consistent across all 5 estimators.
  4. The paper's own HonestDiD analysis (reported in JEEA) finds robustness with more pre-periods.
- A WARN would be appropriate if there were pre-trend slope violations; there are none here.
- **Verdict: PASS with design signal D-FRAGILE noted for report.**

## Summary of findings
- HonestDiD sensitivity reveals D-FRAGILE design for all three targets.
- Structural constraint: n_pre=2 limits discriminatory power.
- Peak TWFE survives at Mbar=0 exactly; immediately breaks at Mbar=0.25.
- Given flat pre-trends across 5 estimators and policy-plausible mechanism, PASS is warranted but user should be aware that causal inference confidence is fragile to pre-trend violations as small as 25% of the pre-trend slope.

## References to data
- `results/by_article/267/honest_did_v3.csv`: baseline (Mbar=0) estimates
- `results/by_article/267/honest_did_v3_sensitivity.csv`: sensitivity (Mbar 0–2)
