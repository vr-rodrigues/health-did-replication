# HonestDiD Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- has_event_study = true, event_pre = 2 → only 2 pre-periods available.
- The applicability rule requires "at least 3 pre-periods." This design has only 2 pre-periods (t=-3 and t=-2, with t=-1 as the normalised reference period = 0).
- HonestDiD was run (honest_did_v3.csv exists), but the sensitivity analysis has reduced power with only 2 pre-periods. Results are reported with this caveat.

## HonestDiD results

### TWFE sensitivity (target = first post-period, ATT_first = -13.53)
| Mbar | Lower | Upper | Sign-reversal? |
|---|---|---|---|
| 0 (no violation) | -23.14 | -4.04 | No |
| 0.5 | -26.69 | -0.89 | No |
| 0.75 | -30.04 | +2.26 | Yes (CI crosses zero) |
| 1.0 | -33.97 | +6.20 | Yes |
| 1.5 | -42.44 | +14.48 | Yes |

- At Mbar = 0.75 (trend can deviate by up to 75% of the observed pre-trend slope), the CI crosses zero.
- **The first-period effect is not robust to modest violations of parallel trends.**

### TWFE sensitivity (target = average post-period, ATT_avg = -34.05)
| Mbar | Lower | Upper | Sign-reversal? |
|---|---|---|---|
| 0 | -45.39 | -22.75 | No |
| 0.5 | -60.09 | -10.39 | No |
| 0.75 | -70.83 | +0.12 | Marginal |
| 1.0 | -81.80 | +10.85 | Yes |

- Average post-period effect is robust up to Mbar ≈ 0.75 but fails at Mbar = 1.0.

### TWFE sensitivity (target = peak post-period, ATT_peak = -56.47)
| Mbar | Lower | Upper | Sign-reversal? |
|---|---|---|---|
| 0 | -73.11 | -39.86 | No |
| 0.5 | -98.21 | -19.85 | No |
| 0.75 | -115.51 | -2.88 | No |
| 1.0 | -133.15 | +14.42 | Yes |

- Peak effect (period +3) is robust to Mbar ≈ 0.75.

### CS-NT sensitivity (target = first post-period, ATT_first = -15.40)
| Mbar | Lower | Upper | Sign-reversal? |
|---|---|---|---|
| 0 | -25.14 | -5.66 | No |
| 0.75 | -30.50 | -1.09 | No |
| 1.0 | -33.28 | +1.69 | Marginal |
| 1.25 | -36.46 | +4.87 | Yes |

- CS-NT first-period effect is robust up to Mbar ≈ 1.0, slightly better than TWFE.

### CS-NT sensitivity (target = average, ATT_avg = -40.96)
| Mbar | Lower | Upper | Sign-reversal? |
|---|---|---|---|
| 0 | -54.48 | -27.59 | No |
| 0.75 | -72.78 | -11.51 | No |
| 1.0 | -81.37 | -2.91 | No |
| 1.25 | -90.25 | +5.68 | Yes |

- CS-NT average effect is robust up to Mbar ≈ 1.0.

## Assessment
- With only 2 pre-periods, HonestDiD sensitivity bounds are wider and the robustness conclusions are weaker than they would be with 3+ pre-periods. The rm_first_Mbar (break-even) for TWFE first period is ~0.5–0.75 — moderate robustness.
- The sign of the negative effect is consistent across all estimators and robust under parallel trends (Mbar=0), but the effect becomes insignificant when allowing moderate pre-trend violations (Mbar≥0.75 for first period, Mbar≥1.0 for average).
- For the CS-NT average ATT (-40.96), robustness extends to Mbar≈1.0, which is more convincing.
- **The limited pre-period count (n=2) is the main limitation; conclusions should be qualified.**

## Summary
HonestDiD analysis is informative but limited by only 2 pre-periods. The core negative finding (DEA crackdowns reduce MME per capita) is robust under the maintained parallel trends assumption and survives modest violations. However, sensitivity breaks down at Mbar≈0.75 for the immediate post-period effect. The longer-run average effect (CS-NT) shows better robustness to Mbar≈1.0. The 2-pre-period limitation deserves explicit acknowledgment.

**Overall:** WARN (only 2 pre-periods limits sensitivity analysis power; first-period robustness modest at Mbar~0.75)
