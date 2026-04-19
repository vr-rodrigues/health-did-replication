# HonestDiD Reviewer Report — Article 147 (Greenstone & Hanna 2014)

**Verdict:** FAIL
**Date:** 2026-04-18

## Checklist

### 1. Applicability
- `has_event_study: true` — condition met
- Pre-periods available: 4 (h=-5, -4, -3, -2) >= 3 — condition met
- HonestDiD is applicable.

### 2. Pre-trend magnitudes (baseline assessment)
The observed pre-trends are large relative to the post-treatment estimates:

**TWFE pre-trends:**
- h=-5: -35.55 µg/m³ (SE=17.77) — statistically significant
- h=-4: -30.14 µg/m³ (SE=23.70) — borderline significant
- h=-3: -12.33 µg/m³ (SE=18.09) — not significant
- h=-2: -5.74 µg/m³ (SE=14.11) — not significant

**CS-NT pre-trends:**
- h=-5: -55.25 µg/m³ (SE=20.30) — statistically significant
- h=-4: -49.07 µg/m³ (SE=31.47) — borderline
- h=-3: -24.14 µg/m³ (SE=25.81) — not significant
- h=-2: -4.38 µg/m³ (SE=14.16) — not significant

The TWFE pre-trend at h=-5 is significant (t≈-2.0) and at h=-4 is borderline (t≈-1.27). The CS-NT pre-trend at h=-5 is clearly significant (t≈-2.72). These are not small pre-trends that could be dismissed as sampling noise.

### 3. Sensitivity analysis results (Mbar approach)

**TWFE, target=first (h=0 estimate = +1.44 µg/m³):**
| Mbar | Lower bound | Upper bound | Includes zero? |
|------|------------|------------|----------------|
| 0.00 | -34.80 | +37.80 | YES |
| 0.50 | -41.54 | +49.02 | YES |
| 1.00 | -54.26 | +65.49 | YES |

At Mbar=0 (no pre-trend allowed), the robust CI for the first post-period already spans zero (-34.80, +37.80). This means the result is not robust to ANY degree of pre-trend violation — even in the idealized case where we assume the pre-trend violations we observed are purely sampling error, the CI is uninformative.

**TWFE, target=avg (average post-treatment = -7.94 µg/m³):**
| Mbar | Lower bound | Upper bound | Includes zero? |
|------|------------|------------|----------------|
| 0.00 | -35.64 | +19.99 | YES |
| 0.50 | -79.69 | +73.32 | YES |

The average post-treatment effect is negative (-7.94 µg/m³) but not significant. At Mbar=0, the CI (-35.64, +19.99) already crosses zero.

**TWFE, target=peak (h=3, estimate = -30.15 µg/m³):**
| Mbar | Lower bound | Upper bound | Includes zero? |
|------|------------|------------|----------------|
| 0.00 | -68.50 | +8.32 | YES |

Crosses zero even without any pre-trend violation assumption.

**CS-NT, target=first (h=0 estimate = +29.16 µg/m³):**
| Mbar | Lower bound | Upper bound | Includes zero? |
|------|------------|------------|----------------|
| 0.00 | -16.84 | +75.53 | YES |
| 0.25 | -23.57 | +83.22 | YES |

Even the most optimistic post-period estimate for CS-NT (+29.16) fails to produce a robust CI that excludes zero, even at Mbar=0.

**CS-NT, target=peak (h=1, estimate = +36.23 µg/m³):**
| Mbar | Lower bound | Upper bound | Includes zero? |
|------|------------|------------|----------------|
| 0.00 | -4.56 | +76.67 | YES |

Crosses zero even at Mbar=0.

### 4. Breakdown value
No breakdown value can be computed — all CIs include zero starting from Mbar=0. The pre-trends are so large that even the assumption of zero pre-trend violation fails to deliver a robust positive effect.

### 5. Cross-estimator consistency
Both TWFE and CS-NT fail the HonestDiD sensitivity check at every Mbar level examined. The SA estimator (from event_study_data.csv) shows similarly large pre-trends (h=-5: -61.29, h=-4: -52.98). Gardner (BJS) shows smaller pre-trends but is an imputation estimator that handles them differently.

### 6. Assessment
The HonestDiD analysis reveals that the paper's main finding (positive effect of catalytic converter policy on SPM reduction) is not robust to pre-trend violations. The pre-trend pattern is monotonically declining toward h=-1, which is consistent with mean reversion or selection: cities that adopt the policy tend to be those with deteriorating air quality, which then reverts. Any conclusion about the causal effect of the policy is highly uncertain.

## Summary
Every target ATT (first, average, peak) and both estimators (TWFE, CS-NT) yield CIs that cross zero at Mbar=0. The observed pre-trends are large (35-55 µg/m³ at h=-5) relative to the post-treatment effect (8 µg/m³ TWFE ATT). The sensitivity analysis provides no informative lower bound on the treatment effect. Parallel trends is fundamentally questionable here.

**Verdict: FAIL** — HonestDiD bounds uninformative at all Mbar levels; pre-trends dominate; no robust evidence of a causal effect.
