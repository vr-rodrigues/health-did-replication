# HonestDiD Reviewer Report: Article 9 — Dranove et al. (2021)

**Verdict:** WARN
**Date:** 2026-04-18

---

## Applicability
- `has_event_study = true`: YES
- Pre-periods available: 8 (event_pre = 8, periods t=-9 to t=-2)
- **APPLICABLE** (≥ 3 pre-periods)

---

## Checklist

### 1. HonestDiD configuration
- Estimators tested: TWFE and CS-NT.
- Number of pre-periods used in sensitivity analysis: **2** (despite 8 being available).
- Target horizons: "first" (t=0), "avg" (t=0 to t=3), "peak" (t=3).
- This discrepancy between available pre-periods (8) and used pre-periods (2) is a limitation: with only 2 pre-periods, the relative magnitudes method (RM) has less data to calibrate the Mbar bound. With 8 pre-periods, the estimate of the pre-trend slope would be more precise.

### 2. Sensitivity results summary

**TWFE sensitivity (honest_did_v3.csv):**
| Target | Mbar=0 CI | Robust at Mbar=? |
|--------|-----------|-----------------|
| first (t=0) | [-0.104, +0.006] | Marginally (CI barely includes 0) |
| avg (t=0–3) | [-0.200, -0.040] | Robust through at least Mbar=0 |
| peak (t=3) | [-0.271, -0.090] | Robust through Mbar=0 |

**CS-NT sensitivity:**
| Target | Mbar=0 CI | Robust at Mbar=? |
|--------|-----------|-----------------|
| first (t=0) | [-0.133, +0.018] | Includes zero at Mbar=0 |
| avg (t=0–3) | [-0.208, -0.038] | Robust through Mbar=0 |
| peak (t=3) | [-0.260, -0.092] | Robust through Mbar=0 |

### 3. Critical sensitivity analysis (from honest_did_v3_sensitivity.csv)

**TWFE "avg" target:**
- At Mbar=0: CI = [-0.200, -0.040] — excludes zero.
- At Mbar=0.5: CI = [-0.218, -0.016] — still excludes zero.
- At Mbar=0.75: CI = [-0.231, +0.001] — barely includes zero.
- **Robust through Mbar ≈ 0.70.**

**TWFE "peak" target:**
- At Mbar=0: CI = [-0.271, -0.090] — excludes zero.
- At Mbar=0.75: CI = [-0.335, -0.018] — still excludes zero.
- At Mbar=1.0: CI = [-0.366, +0.016] — barely includes zero.
- **Robust through Mbar ≈ 0.95.**

**CS-NT "avg" target:**
- At Mbar=0: CI = [-0.208, -0.038] — excludes zero.
- At Mbar=1.0: CI = [-0.266, -0.006] — still excludes zero.
- At Mbar=1.25: CI = [-0.287, +0.006] — barely includes zero.
- **Robust through Mbar ≈ 1.1.**

**TWFE "first" (t=0) target:**
- At Mbar=0: CI = [-0.104, +0.006] — includes zero. The immediate impact estimate is fragile.
- This means the very first post-period effect is not robustly distinguishable from zero under HonestDiD.

### 4. Assessment of Mbar=0.5 benchmark
The RM method benchmarks Mbar as a multiple of the largest observed pre-trend coefficient. With 2 pre-periods used, the benchmark is calibrated from t=-2 and t=-1 (or t=-3 and t=-2). With 8 pre-periods available, the benchmark would incorporate a longer pre-period slope.

**The key finding:** The average post-treatment effect (avg target, t=0 to t=3) is robust to Mbar up to ~0.70 for TWFE and ~1.1 for CS-NT. This means the pre-trend would need to be 70–110% as large as the largest observed pre-trend (itself very small) before the estimate becomes statistically indistinguishable from zero. This is a meaningful level of robustness.

### 5. Concerns flagged
1. **Only 2 pre-periods used**: With 8 pre-periods available, the HonestDiD sensitivity analysis should ideally use all 8. Using only 2 limits the precision of the Mbar calibration. This is a methodological implementation concern (WARN-level), not a fatal flaw.
2. **"first" period fragility**: The immediate effect at t=0 is not robustly identified under honest pre-trend assumptions. This is expected for a gradual-rollout policy (managed care implementation takes time), but should be noted.
3. **Robustness of avg and peak**: The main substantive finding — a persistent average negative effect — is robust to moderate pre-trend violations (Mbar ~0.70). This partially mitigates concern 1.

---

## Summary
HonestDiD sensitivity analysis reveals that the average and peak treatment effects are robust to pre-trend violations up to Mbar=0.70–1.1 (TWFE and CS-NT respectively), providing meaningful evidence that the result is not driven by pre-existing trends. However, only 2 of 8 available pre-periods were used in the RM calibration, limiting the precision of the bound. The immediate (first-period) effect is fragile and does not robustly exclude zero. Overall, the core finding of a sustained negative effect on drug prices is moderately supported under honest inference, but the under-utilisation of pre-periods warrants a WARN.

**Verdict: WARN**

Specific issue: n_pre=2 used for HonestDiD despite 8 available pre-periods; recommend re-running with n_pre=8 for fuller sensitivity analysis.
