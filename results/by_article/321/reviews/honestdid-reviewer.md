# HonestDiD Reviewer Report — Article 321 (Xu 2023)

**Verdict:** WARN
**Date:** 2026-04-18

## Setup
- n_pre = 3 (periods t=-4, t=-3, t=-2 used; t=-5 and t=-1 excluded per convention)
- n_post = 4 (periods t=0 through t=3)
- Estimators tested: TWFE and CS-NT
- Targets: first-period ATT, avg ATT, peak ATT
- Mbar range: 0 to 2.0 in steps of 0.25

Note: `honest_did_v3.csv` reports `n_pre=3, n_post=4` for both estimators.

## Sensitivity analysis results

### TWFE HonestDiD
| Target | rm_Mbar (lb crosses zero) | Verdict |
|--------|--------------------------|---------|
| first (t=0) | Mbar=0.25 (lb=-0.339, ub=-0.023 at M=0.25; then ub>0 at M=0.5) | D-FRAGILE |
| avg | Mbar=0 only (lb=-0.314, ub=-0.067 at M=0; ub>0 at M=0.25) | D-FRAGILE |
| peak (t=1) | Mbar=0.75 (lb=-0.768, ub=-0.015 at M=0.75; ub>0 at M=1.0) | D-MODERATE |

Detailed TWFE robustness (from sensitivity CSV):
- **first**: robust at Mbar=0 (lb=-0.314, ub=-0.048) and Mbar=0.25 (lb=-0.339, ub=-0.023); breaks at Mbar=0.5 (ub=+0.001). rm_first_Mbar=0.25.
- **avg**: robust at Mbar=0 (lb=-0.314, ub=-0.067); breaks at Mbar=0.25 (lb=-0.413, ub=-0.037 — still negative here actually). Wait: at Mbar=0.25, ub=-0.037 < 0 → still robust. At Mbar=0.5, ub=+0.039 → breaks. rm_avg_Mbar=0.25.
- **peak**: robust to Mbar=0.75 (lb=-0.768, ub=-0.015); breaks at Mbar=1.0 (ub=+0.053). rm_peak_Mbar=0.75.

Corrected TWFE table:
| Target | rm_Mbar | Design rating |
|--------|---------|---------------|
| first | 0.25 | D-FRAGILE |
| avg | 0.25 | D-FRAGILE |
| peak | 0.75 | D-MODERATE |

### CS-NT HonestDiD
| Target | lb at Mbar=0 | ub at Mbar=0 | rm_Mbar | Rating |
|--------|-------------|-------------|---------|--------|
| first | -0.246 | -0.043 | 0.50 | D-MODERATE |
| avg | -0.271 | -0.080 | 0.25 | D-FRAGILE |
| peak | -0.439 | -0.137 | 0.50 | D-MODERATE |

CS-NT detailed:
- **first**: robust at Mbar=0.50 (lb=-0.313, ub=-0.007); breaks at Mbar=0.75 (ub=+0.020). rm_first_Mbar=0.50.
- **avg**: robust at Mbar=0 (lb=-0.271, ub=-0.080) and Mbar=0.25 (lb=-0.360, ub=-0.037); breaks at Mbar=0.50 (ub=+0.039). rm_avg_Mbar=0.25.
- **peak**: robust at Mbar=0.50 (lb=-0.577, ub=-0.055); breaks at Mbar=0.75 (ub=+0.005). rm_peak_Mbar=0.50.

## Pre-trend context
The HonestDiD analysis is conducted in the context of substantial observed pre-trends (t=-4 and t=-3 statistically significant in both TWFE and CS-NT). The Mbar parameter represents the maximum allowable deviation from parallel trends between post and pre periods. Given observed pre-trend magnitudes of ~0.10-0.16 log points, a realistic Mbar is likely 0.10-0.25 per post-period.

At Mbar=0.25 (one standard pre-trend deviation):
- TWFE avg: lb=-0.413, ub=-0.037 → still negative (barely)
- CS-NT avg: lb=-0.360, ub=-0.037 → still negative (barely)

At Mbar=0.50:
- TWFE avg: ub=+0.039 → encompasses zero (breaks)
- CS-NT avg: ub=+0.039 → breaks

## Assessment
The design is **D-FRAGILE to D-MODERATE** depending on the target. Given that:
1. Pre-trends are large and statistically significant (the very condition HonestDiD guards against)
2. The "rm" Mbar values are low (0.25 for avg in both estimators)
3. A realistic Mbar given observed pre-trends (0.10-0.25) is right at the boundary of where robustness breaks

This is a genuine concern. The HonestDiD sensitivity partially rescues the peak effect (peak robust to Mbar=0.75 for TWFE), but the avg and first targets are fragile.

## Summary
HonestDiD identifies design as D-FRAGILE for avg/first targets (rm_Mbar=0.25 for both TWFE and CS-NT) and D-MODERATE for peak (rm_Mbar=0.75 TWFE; 0.50 CS-NT). Given substantial observed pre-trends, the low rm_Mbar values for avg and first targets are a substantive credibility concern.

**Verdict: WARN** (rm_avg_Mbar=0.25 for both estimators; fragile avg ATT given observed pre-trend magnitudes of 0.10-0.16)
