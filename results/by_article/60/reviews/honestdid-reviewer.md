# HonestDiD Reviewer Report — Article 60 (Schmitt 2018)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- has_event_study = true, event_pre = 4 (>= 3 pre-periods): APPLICABLE.
- Data from `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv`.

## Summary statistics from honest_did_v3.csv
| Estimator | n_pre | n_post | rm_first_Mbar | rm_avg_Mbar | rm_peak_Mbar | att_first | att_avg | att_peak |
|-----------|-------|--------|---------------|-------------|--------------|-----------|---------|----------|
| TWFE | 3 | 5 | 0 | 0 | 0 | 0.0421 | 0.0590 | 0.0679 |
| CS-NT | 3 | 5 | 0.25 | 0 | 0 | 0.0438 | 0.0585 | 0.0746 |

Note: The `rm_first_Mbar` for TWFE = 0 means the "first period ATT" sign is robust only at Mbar=0 (zero trend violation allowed). For CS-NT, rm_first_Mbar = 0.25 means the first-period ATT is robust up to Mbar=0.25.

## Robustness analysis (from sensitivity CSV)

### TWFE targets
**First-period ATT (att_first = 0.0421):**
- Mbar=0: CI = [-0.00329, +0.08687] — includes zero. NOT robust even at Mbar=0.
- rm_first_Mbar = 0 confirms this: the first-period ATT is fragile.

**Average ATT (att_avg = 0.0590):**
- Mbar=0: CI = [+0.01937, +0.09848] — fully positive. ROBUST at Mbar=0.
- Mbar=0.25: CI = [-0.03914, +0.15699] — includes zero. Breaks at Mbar=0.25.
- rm_avg_Mbar = 0: robust only at zero trend violation assumption.

**Peak ATT (att_peak = 0.0679):**
- Mbar=0: CI = [+0.02615, +0.10931] — fully positive. ROBUST at Mbar=0.
- Mbar=0.25: CI = [-0.00472, +0.14103] — includes zero. Breaks at Mbar=0.25.
- rm_peak_Mbar = 0 confirms: barely robust at Mbar=0 only.

### CS-NT targets
**First-period ATT (att_first = 0.0438):**
- Mbar=0: CI = [+0.01518, +0.07234] — fully positive. ROBUST.
- Mbar=0.25: CI = [+0.00685, +0.07888] — still fully positive.
- Mbar=0.50: CI = [-0.00566, +0.09020] — includes zero.
- rm_first_Mbar = 0.25 confirmed.

**Average ATT (att_avg = 0.0585):**
- Mbar=0: CI = [+0.02767, +0.08938] — fully positive. ROBUST.
- Mbar=0.25: CI = [-0.00732, +0.12119] — includes zero.
- rm_avg_Mbar = 0 confirmed.

**Peak ATT (att_peak = 0.0746):**
- Mbar=0: CI = [+0.03552, +0.11375] — fully positive. ROBUST.
- Mbar=0.25: CI = [-0.00998, +0.15844] — includes zero.
- rm_peak_Mbar = 0 confirmed.

## Design credibility classification
Under the Lal et al. (2024) framework:
- **TWFE avg/peak**: robust at Mbar=0 only → **D-FRAGILE** for average and peak targets.
- **CS-NT first**: robust to Mbar=0.25 → **D-MOD** for first-period target (border of FRAGILE/MODERATE).
- **CS-NT avg/peak**: robust at Mbar=0 only → **D-FRAGILE**.

The overall design credibility is **D-FRAGILE** for the aggregate ATT measures. At Mbar=0.25 (a modest assumption of 25% trend violation per period beyond pre-period), all average and peak CIs include zero.

## Mitigating factors
1. The pre-trend pattern in both TWFE and CS-NT shows negative drift at t=-4/-3 (both around -1.05 to -1.22 t-stats). This systematic negative drift is precisely why HonestDiD inflates CIs quickly — the pre-trend violations are non-trivial in magnitude even if not statistically significant.
2. The first-period CS-NT target is more robust (Mbar=0.25), and the contemporary effect at t=0 is consistently around 0.042–0.044 across all estimators. The first-period effect is the most credible part of the identification.
3. Mbar=0 corresponds to "parallel trends is exactly satisfied" — the CI being positive at Mbar=0 for most targets confirms the point estimates are sensible. The fragility emerges from allowing even a small pre-trend.

## Summary
HonestDiD reveals that Schmitt (2018)'s results are **D-FRAGILE** for average and peak ATT targets: CIs include zero at Mbar=0.25 for all estimators. The contemporary (first-period) effect is more robust under CS-NT (holds to Mbar=0.25). The systematic negative pre-trend at t=-4/-3 is the main driver of fragility — it sets a baseline "pre-trend magnitude" that HonestDiD extrapolates to post-treatment periods. The underlying effect direction is consistently positive, but the magnitude cannot be stated with confidence beyond the zero-violation case.

**Verdict: WARN** (D-FRAGILE overall; contemporaneous effect more robust; pre-trend drift is the binding constraint)
