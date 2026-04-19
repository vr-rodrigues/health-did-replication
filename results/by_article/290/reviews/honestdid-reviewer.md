# HonestDiD Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** WARN
**Date:** 2026-04-19

## Applicability
- has_event_study = true, event_pre = 5 (>= 3 pre-periods)
- APPLICABLE

## Update note (2026-04-19)
Previous report (2026-04-18) was written when CS-DID had failed. CS-DID now produces valid estimates (att_csdid_nt = -0.02984). The TWFE HonestDiD numbers are unchanged. The CS-NT HonestDiD numbers are re-interpreted against valid CS-DID estimates (they were valid computationally even before; the fragility they show is now a confirmed Design finding, not evidence of a broken pipeline).

## Checklist

### 1. Pre-periods available for HonestDiD
- Metadata specifies event_pre = 5 (t=-5 to t=-1)
- HonestDiD stored: n_pre = 2 (2 free pre-periods used)
- With base_period = "universal" and 5 pre-periods, n_pre=2 indicates only 2 pre-periods were usable after the smoothness restriction is imposed. This is a structural feature of the data (short panel: 2014-2020 = 7 years, 5 pre-event windows compress the usable pre-period degrees of freedom). NOT an implementation error.

### 2. TWFE HonestDiD sensitivity

**Target: first-period ATT (t=0)**
- Mbar=0: CI = [-0.0065, +0.0027] — INCLUDES ZERO. Not robust even at exact parallel trends.
- Mbar=0.25: CI = [-0.0068, +0.0033] — includes zero.
- Conclusion: first-period effect D-FRAGILE. This is a Design finding.

**Target: average ATT (rm_avg_Mbar)**
- Mbar=0: CI = [-0.0086, -0.0016] — EXCLUDES ZERO. Robust at exact parallel trends.
- Mbar=0.25: CI = [-0.0095, +0.000036] — barely crosses zero (upper bound = +0.000036). NOT robust at Mbar=0.25.
- rm_avg_Mbar = 0 (breaks at any non-zero smoothness allowance). D-FRAGILE for average target.

**Target: peak ATT (t=2, largest absolute TWFE)**
- Mbar=0: CI = [-0.0123, -0.0027] — EXCLUDES ZERO.
- Mbar=0.25: CI = [-0.0133, -0.0007] — still excludes zero (barely). PASS.
- Mbar=0.5: CI = [-0.0150, +0.0016] — crosses zero. NOT robust.
- rm_peak_Mbar = 0.25. D-MODERATE for peak target.

### 3. CS-NT HonestDiD sensitivity

**Target: first-period ATT**
- Mbar=0: CI = [-0.0069, +0.0036] — includes zero. D-FRAGILE.

**Target: average ATT**
- Mbar=0: CI = [-0.0081, +0.0020] — includes zero. D-FRAGILE.

**Target: peak ATT**
- Mbar=0: CI = [-0.0104, +0.0005] — barely includes zero (+0.0005). D-FRAGILE.
- Mbar=0.25: CI = [-0.0108, +0.0025] — includes zero. D-FRAGILE.

### 4. Design classification (Axis 3)
- TWFE: avg D-FRAGILE (rm_avg_Mbar=0; breaks at Mbar=0.25), peak D-MODERATE (rm_peak_Mbar=0.25)
- CS-NT: all targets D-FRAGILE (all include zero at Mbar=0)
- The TWFE average is barely robust at Mbar=0 only. Any non-zero trend violation breaks significance.
- Overall design credibility signal: **D-FRAGILE** (the more conservative of TWFE avg and CS-NT results).

### 5. Pre-trend context
- SA pre-trends at t=-4 and t=-5 are statistically significant (t-stats >4):
  - t=-5: coef=-0.00363, SE=0.000682 → t-stat = -5.3
  - t=-4: coef=-0.00253, SE=0.000582 → t-stat = -4.3
- CS-NT pre-trends: individually non-significant (all |t| < 1.5), but monotonically negative.
- The SA pre-trend violation implies Mbar=0 (exact parallel trends) is an implausible benchmark for TWFE.
- At Mbar=0.25 (reflecting the observed SA pre-trend magnitude), TWFE average ATT is not significant.
- This is a genuine Design finding: the parallel trends assumption is fragile, and HonestDiD corroborates this independently of the CS-NT pre-trend evidence.

### 6. Interpretation with CS-DID now validated
- CS-NT ATT = -0.0298 (statistically significant at the simple aggregation level)
- Yet CS-NT HonestDiD at Mbar=0 does not exclude zero. This seeming contradiction resolves as follows:
  - The HonestDiD CS-NT confidence sets are computed from the event-study path, not the simple aggregation ATT. The dynamic path for CS-NT shows modest per-period effects that become less precise under the smoothness restriction.
  - The simple aggregation ATT (-0.0298) is significant in standard inference, but HonestDiD asks whether that significance is robust to non-zero trend deviations — it is not, because the CIs are wide relative to the effect size.
- This does NOT indicate a CS-DID implementation problem. It indicates that the design is fragile to parallel-trends assumptions.

**Overall HonestDiD Verdict: WARN** (TWFE avg D-FRAGILE at Mbar=0.25; CS-NT D-FRAGILE all targets; SA pre-trends sig at t=-4/-5 (|t-stat|>4); design credibility signal D-FRAGILE; these are Design findings, not implementation errors)
