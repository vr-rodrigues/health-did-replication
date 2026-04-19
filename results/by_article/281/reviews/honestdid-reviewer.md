# HonestDiD Reviewer Report: Article 281 — Steffens, Pereda (2025)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. HonestDiD applicability
- `has_event_study = true`: YES.
- Pre-periods available: 4 (t = -4, -3, -2, -1 [omitted reference]). With 3 usable pre-periods (t=-4, -3, -2), the applicability threshold (≥ 3) is met.

### 2. Sensitivity analysis results (from `honest_did_v3.csv` and `_sensitivity.csv`)

**TWFE — "first" target (ATT at first post-period):**
- At Mbar=0 (no violations allowed): CI = [-0.00357, 0.00235]. Includes zero.
- At Mbar=1.0: CI = [-0.00534, 0.00443]. Still includes zero.
- At Mbar=2.0: CI = [-0.00828, 0.00748]. Still includes zero.
- The identified set always includes zero regardless of how much pre-trend violation is permitted.

**TWFE — "avg" target (average ATT):**
- At Mbar=0: CI = [-0.00352, 0.00299]. Includes zero.
- At Mbar=1.0: CI = [-0.01178, 0.01084]. Wider but still includes zero.

**CS-NT — "first" target:**
- At Mbar=0: CI = [-0.00291, 0.00171]. Includes zero.
- At Mbar=1.0: CI = [-0.00531, 0.00392]. Includes zero.
- At Mbar=2.0: CI = [-0.00872, 0.00723]. Includes zero.

**CS-NT — "avg" target:**
- At Mbar=0: CI = [-0.00391, 0.00346]. Includes zero.

### 3. Robustness interpretation
- The headline estimate (near-zero, insignificant) is **robust to pre-trend violations** in the sense that the sensitivity intervals remain consistent with zero across all Mbar values tested (0 to 2).
- However, this also means that HonestDiD cannot rule out effects of meaningful magnitude — the intervals are wide enough to be consistent with both negative and positive effects even at Mbar=0.
- `rm_first_Mbar = rm_avg_Mbar = rm_peak_Mbar = 0` in `honest_did_v3.csv`: the breakdown Mbar (smallest Mbar at which the confidence interval includes zero for the restricted model) is 0 for both TWFE and CS-NT, confirming the point estimates are already statistically indistinguishable from zero without any pre-trend allowance.

### 4. Flags
- PASS: HonestDiD implemented correctly for both TWFE and CS-NT.
- PASS: The null result is robust — sensitivity intervals always include zero, consistent with the paper's null finding.
- NOTE: The wide CIs reflect limited statistical power (state-level clustering with relatively few treated clusters — 12 states treated in 2009) rather than a design flaw.
- NOTE: Pre-trend at t=-4 (-0.0112 for CS-NT, -0.0072 for TWFE) is the largest, but even allowing Mbar=2 (twice the maximum observed pre-trend) the CI still includes zero, so pre-trend magnitude does not undermine the null conclusion.

## Summary
HonestDiD sensitivity analysis confirms the null result is robust to pre-trend violations. The breakdown Mbar=0 means zero is already in the CI before any pre-trend allowance, and the null persists at Mbar=2. No HonestDiD concerns to flag for the stored result.

Full data: `results/by_article/281/honest_did_v3.csv`, `results/by_article/281/honest_did_v3_sensitivity.csv`
