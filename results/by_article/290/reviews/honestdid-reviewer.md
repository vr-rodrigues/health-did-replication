# HonestDiD Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- has_event_study = true, event_pre = 5 (>= 3 pre-periods)
- APPLICABLE

## Checklist

### 1. Pre-periods available for HonestDiD
- Metadata specifies event_pre = 5 (t=-5 to t=-1)
- HonestDiD stored: n_pre = 2 (only 2 free pre-periods used)
- Note: With base_period = "universal" and 5 pre-periods, HonestDiD by default uses all available pre-periods for the smoothness restriction. The n_pre=2 indicates only 2 pre-periods were usable after balancing — consistent with the reconstructed dataset having fewer pre-periods in some cohorts.

### 2. TWFE HonestDiD sensitivity

**Target: first-period ATT (t=0)**
- Mbar=0: CI = [-0.0065, +0.0027] — INCLUDES ZERO. Not robust even at Mbar=0.
- Mbar=0.25: CI = [-0.0068, +0.0033] — includes zero.
- Conclusion: first-period effect D-FRAGILE.

**Target: average ATT (rm_avg_Mbar)**
- Mbar=0: CI = [-0.0086, -0.0016] — EXCLUDES ZERO. Robust at Mbar=0.
- Mbar=0.25: CI = [-0.0095, +0.000036] — just barely crosses zero (upper bound = +0.000036). NOT robust at Mbar=0.25.
- Conclusion: rm_avg_Mbar = 0 (breaks at any non-zero smoothness allowance). D-FRAGILE for average target.

**Target: peak ATT (t=2, largest absolute)**
- Mbar=0: CI = [-0.0123, -0.0027] — EXCLUDES ZERO. Robust at Mbar=0.
- Mbar=0.25: CI = [-0.0133, -0.0007] — still excludes zero (barely).
- Mbar=0.5: CI = [-0.0150, +0.0016] — crosses zero. NOT robust at Mbar=0.5.
- Conclusion: rm_peak_Mbar = 0.25 (D-MODERATE for peak target).

### 3. CS-NT HonestDiD sensitivity

**Target: first-period ATT**
- Mbar=0: CI = [-0.0069, +0.0036] — includes zero. D-FRAGILE.

**Target: average ATT**
- Mbar=0: CI = [-0.0081, +0.0020] — includes zero. D-FRAGILE.

**Target: peak ATT**
- Mbar=0: CI = [-0.0104, +0.0005] — barely includes zero (+0.0005). D-FRAGILE.
- Mbar=0.25: CI = [-0.0108, +0.0025] — includes zero. D-FRAGILE.

### 4. Design classification
- TWFE: avg D-FRAGILE (rm_avg_Mbar=0; breaks at Mbar=0.25), peak D-MODERATE (rm_peak_Mbar=0.25)
- CS-NT: all targets D-FRAGILE (all include zero at Mbar=0)
- The TWFE average is barely robust at Mbar=0 only. Any non-zero trend violation breaks significance.
- Note: This is partly structural — with only 2 usable pre-periods, the pre-trend test has limited power to bound violations.

### 5. Pre-trend context
- SA pre-trends at t=-4 and t=-5 are statistically significant (t-stats >4), which is highly relevant:
  - If pre-trends are already large, Mbar=0 (exact parallel trends) is an implausible assumption.
  - The HonestDiD sensitivity should be interpreted at Mbar reflecting observed pre-trend magnitude.
  - SA pre-trend at t=-4: coef=-0.00253, SE=0.000582 → Mbar implied ~0.25-0.50.
  - At Mbar=0.25, TWFE average CI crosses zero. This is a real concern.

### 6. Overall assessment
- The TWFE peak effect is moderately robust (survives Mbar=0.25), but the average ATT is fragile.
- CS-NT results are fragile across all targets at all Mbar values.
- Given that SA pre-trends indicate actual pre-trend violations exist, results at Mbar=0 are not the right benchmark.
- At Mbar=0.25 (plausible given observed SA pre-trends), TWFE average is not significant.

**Overall HonestDiD Verdict: WARN** (TWFE avg D-FRAGILE at Mbar=0.25; CS-NT D-FRAGILE all targets; SA pre-trends confirm non-zero Mbar is the right benchmark)
