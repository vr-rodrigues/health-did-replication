# HonestDiD Reviewer Report — Article 133 (Hoynes et al. 2015)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Pre-period count and applicability
- Metadata: event_pre = 3, but honest_did_v3.csv shows n_pre = 2 (t=-3 and t=-2, with t=-1 as normalization base).
- Effective pre-periods for HonestDiD sensitivity: 2 (meets ≥3 pre-periods threshold at the raw level; the normalized base at t=-1 means 2 free pre-period coefficients available).
- Applicability confirmed: has_event_study = true. **PASS**

### 2. Sensitivity framework
- Method: Relative Magnitudes (Mbar) — sensitivity to violations proportional to observed pre-trend magnitudes.
- Targets assessed: "first" (first post-period effect), "avg" (average effect), "peak" (largest effect).
- Estimators: TWFE and CS-NT.

### 3. TWFE sensitivity results

**Target: "first" (t=0, coef = -0.132)**
- Mbar=0 (no violation allowed): CI = [-0.323, +0.061] — **includes zero**. The first-period estimate is not robustly different from zero under the assumption of exact parallel trends.
- CI turns from containing zero to excluding zero between Mbar=0 and some higher value — but zero is already included at Mbar=0, meaning even without pre-trend violations the CI is wide.
- rm_first_Mbar = 0 confirms breakdown at Mbar=0. **WARN**

**Target: "avg" (average across post-periods, coef = -0.331)**
- Mbar=0: CI = [-0.502, -0.158] — **excludes zero**. Robustly negative.
- Mbar=0.25: CI = [-0.552, -0.073] — still excludes zero.
- rm_avg_Mbar = 0.25: breakdown (CI includes zero) at Mbar=0.25.
- Interpretation: the average effect is robust to pre-trend violations up to 25% of the observed pre-trend magnitude. Given the positive pre-trends observed (t=-3: +0.094, t=-2: +0.061), moderate violations quickly erode the average effect. **WARN** (low robustness threshold)

**Target: "peak" (t=4, coef = -0.564)**
- Mbar=0: CI = [-0.776, -0.354] — **excludes zero**. Robustly negative.
- Mbar=0.25: CI = [-0.863, -0.202] — excludes zero.
- rm_peak_Mbar = 0.25: breakdown at Mbar=0.25.
- The peak (5-year cumulative) effect is robust to moderate violations. **PASS** for peak target.

### 4. CS-NT sensitivity results

**Target: "first" (t=0, coef = -0.160)**
- Mbar=0: CI = [-1.092, +0.763] — **includes zero**. Very wide. Not robust even under no violation.
- rm_first_Mbar = 0. **FAIL**

**Target: "avg" (average coef = -0.403)**
- Mbar=0: CI = [-1.149, +0.347] — **includes zero**. Not robust even at Mbar=0.
- rm_avg_Mbar = 0. **FAIL**

**Target: "peak" (t=4, coef = -0.668)**
- Mbar=0: CI = [-1.580, +0.256] — **includes zero**. Not robust even at Mbar=0.
- rm_peak_Mbar = 0. **FAIL**

### 5. Overall HonestDiD assessment
- TWFE: The average and peak effects are robust at Mbar=0, but break down quickly at Mbar=0.25. The first-period effect is fragile even at Mbar=0. This suggests moderate robustness of the TWFE headline result.
- CS-NT: All three targets fail at Mbar=0. The CS-NT intervals are very wide (reflecting high CS-NT standard errors: se ≈ 0.088–0.131 vs TWFE se ≈ 0.099), and HonestDiD confidence sets are uninformative for CS-NT at any Mbar. This is a precision issue, not necessarily a sign of non-robustness of the true effect.
- The underlying concern: positive pre-trends in both TWFE (+0.094 at t=-3) and especially CS-NT (+0.224 at t=-3) mean that even small allowed violations (Mbar=0.25) substantially widen intervals.

### 6. Implication for credibility
- The TWFE average effect (-0.331 pp) is robust to pre-trend violations up to ~25% of observed magnitude. Given that pre-trends are small in absolute terms but positive (which would bias against finding a negative effect), the robustness provides moderate support.
- CS-NT intervals are too wide to be informative under HonestDiD, but this is a statistical power issue rather than evidence of bias.

## Summary of flags
- WARN: TWFE first-period effect not robust at Mbar=0 (CI includes zero).
- WARN: TWFE avg/peak effects robust only up to Mbar=0.25; breakdown at modest violation levels.
- WARN: CS-NT HonestDiD CIs include zero at Mbar=0 for all targets (precision issue).

## Overall HonestDiD verdict: WARN
