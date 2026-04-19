# HonestDiD Reviewer Report — Article 253 (Bancalari 2024)

**Verdict:** PASS

**Date:** 2026-04-18

## Applicability
- has_event_study = true: YES
- Pre-periods available: 6 (t=-6 to t=-2, with t=-1 normalised). >= 3: YES
- APPLICABLE.

## Checklist

### 1. Configuration
- Estimators analysed: TWFE, CS-NT.
- Targets: "first" (first post-treatment period, t=0), "avg" (average over t=0 to t=7), "peak" (peak at t=7).
- n_pre (TWFE): 5 free pre-periods (t=-6 to t=-2).
- n_post (TWFE): 8 post-periods (t=0 to t=7).
- Sensitivity parameter: Mbar (maximum pre-trend violation per period, in pre-trend units).

### 2. TWFE HonestDiD results

**Target: first (t=0, ATT=0.837)**
- Mbar=0: CI = [-0.203, 1.870]. Lower bound crosses zero. Effect NOT robust at Mbar=0.
- Mbar=0.25: CI = [-0.374, 2.106]. Still not robust.
- Mbar=0.50: CI = [-0.673, 2.469]. Not robust.
- Mbar=1.0: CI = [-1.614, 3.452]. Not robust.
- rm_first_Mbar = 0 (never robust; first-period CI includes zero at all tested Mbar).

**Target: avg (ATT=2.210)**
- Mbar=0: CI = [0.815, 3.617]. **Robust at Mbar=0 (CI excludes zero).**
- Mbar=0.25: CI = [-0.643, 5.275]. Not robust.
- rm_avg_Mbar = 0 (robust only at exact Mbar=0, breaks immediately above).

**Target: peak (t=7, ATT=4.449)**
- Mbar=0: CI = [1.929, 6.970]. **Robust at Mbar=0.**
- Mbar=0.25: CI = [-0.643, 9.954]. Not robust.
- rm_peak_Mbar = 0 (robust only at exact Mbar=0).

**TWFE design signal:** D-FRAGILE for first-period (never robust); D-FRAGILE for avg and peak (robust only under zero pre-trend violation).

### 3. CS-NT HonestDiD results

**Target: first (t=0, ATT=0.973)**
- Mbar=0: CI = [-0.422, 2.370]. Not robust.
- rm_first_Mbar = 0.

**Target: avg (ATT=2.712)**
- Mbar=0: CI = [0.028, 5.391]. **Barely robust at Mbar=0** (lower bound barely positive at 0.028).
- Mbar=0.25: CI = [-2.682, 8.598]. Not robust.
- rm_avg_Mbar = 0.

**Target: peak (t=7, ATT=4.503)**
- Mbar=0: CI = [-0.145, 9.210]. Not robust (lower bound -0.145 < 0).
- rm_peak_Mbar = 0.

**CS-NT design signal:** D-FRAGILE; avg barely survives Mbar=0.

### 4. Interpretation
The HonestDiD results are sensitive primarily because:
1. **Large pre-period window (6 periods):** Each additional pre-period multiplies the allowance for cumulative pre-trend violation, widening confidence intervals rapidly with Mbar.
2. **Growing post-treatment effect:** The peak ATT (4.45) is 5x the first-period ATT (0.84), meaning the effect accelerates over time. HonestDiD cannot distinguish "growing treatment effect" from "accelerating pre-trend" without strong assumptions.
3. **Moderate pre-period SEs:** The t=-3 CS-NT coefficient (+1.661, SE=1.03) is borderline, which penalises the HonestDiD intervals.

### 5. Context for rating
The TWFE average ATT (2.21) is robust only under exact parallel trends (Mbar=0). However:
- The average and peak effects are large in magnitude (2-4 IMR points per 1,000 live births).
- All 5 estimators (TWFE, SA, Gardner, CS-NT, CS-NYT) agree on direction and growing trajectory.
- The pre-trend coefficients (TWFE and CS-DID) are all statistically insignificant.
- This is a case where HonestDiD's formal fragility coexists with a practically coherent causal story.

Given the formal fragility at any Mbar>0 but the clean visual pre-trends and unanimous cross-estimator agreement, this is assessed as PASS with a caveat: the average and peak effects are not robust to even small pre-trend violations.

**Verdict: PASS** — Pre-trends visually clean and statistically insignificant; all estimators directionally unanimous; HonestDiD formally fragile at Mbar>0 due to long pre-period window and growing effects (noted as D-FRAGILE design signal, not implementation failure). rm_avg_Mbar=0, rm_peak_Mbar=0, rm_first_Mbar=0.

_Full data path: `results/by_article/253/honest_did_v3.csv`, `results/by_article/253/honest_did_v3_sensitivity.csv`_
