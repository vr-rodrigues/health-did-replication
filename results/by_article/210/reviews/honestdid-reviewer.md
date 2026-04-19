# HonestDiD Reviewer Report — Article 210 (Li et al. 2026)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability assessment
- `has_event_study`: true — YES
- Pre-periods available: 11 (t=-12 to t=-2, with t=-1 normalised to 0) — well above threshold of 3
- Applicable: YES

## HonestDiD results summary

### TWFE sensitivity
From honest_did_v3.csv and honest_did_v3_sensitivity.csv:

**att_first** (effect at t=0: +0.00317):
| Mbar | LB | UB | Verdict |
|------|----|----|---------|
| 0 | -0.000774 | +0.007125 | Includes zero even at Mbar=0 |
| 0.25 | -0.00151 | +0.00843 | Includes zero |
| 0.5 | -0.00248 | +0.00989 | Includes zero |
| 1.0 | -0.00485 | +0.01323 | Includes zero |

**att_avg** (average post-period ATT = +0.01365):
| Mbar | LB | UB | Verdict |
|------|----|----|---------|
| 0 | +0.00568 | +0.02165 | **Fully positive** |
| 0.25 | +0.00387 | +0.02494 | Fully positive |
| 0.5 | +0.00156 | +0.02873 | Fully positive |
| 0.75 | -0.00140 | +0.03318 | **Crosses zero** |
| 1.0 | -0.00502 | +0.03746 | Crosses zero |
| 2.0 | -0.02214 | +0.05622 | Crosses zero |

**att_peak** (peak post-period ATT = +0.02199 at t=3):
| Mbar | LB | UB | Verdict |
|------|----|----|---------|
| 0 | +0.01001 | +0.03397 | Fully positive |
| 0.25 | +0.00729 | +0.03916 | Fully positive |
| 0.5 | +0.00358 | +0.04583 | Fully positive |
| 0.75 | -0.00136 | +0.05275 | **Crosses zero** |
| 1.0 | -0.00729 | +0.05991 | Crosses zero |

### CS-NYT sensitivity
**att_avg** (CS-NYT average ATT = -0.00440):
| Mbar | LB | UB | Verdict |
|------|----|----|---------|
| 0 | -0.02058 | +0.01155 | **Crosses zero at Mbar=0** |
| 0.5 | -0.03364 | +0.02058 | Crosses zero |
| 1.0 | -0.05271 | +0.03832 | Crosses zero |

**att_peak** (CS-NYT peak ATT = -0.01052 at t=3):
| Mbar | LB | UB | Verdict |
|------|----|----|---------|
| 0 | -0.03539 | +0.01442 | **Crosses zero at Mbar=0** |
| 1.0 | -0.08730 | +0.05794 | Crosses zero |

**att_first** (CS-NYT first ATT = +0.00399 at t=0):
| Mbar | LB | UB | Verdict |
|------|----|----|---------|
| 0 | -0.00741 | +0.01541 | Crosses zero at Mbar=0 |
| 1.0 | -0.01682 | +0.02435 | Crosses zero |

## Assessment

### TWFE HonestDiD
- att_avg is robust at Mbar=0 (fully positive), but breaks at Mbar=0.75 — **D-MODERATE** rating
- att_peak is also robust at Mbar=0 but breaks at Mbar=0.75 — **D-MODERATE**
- att_first is NOT robust at Mbar=0 (CI includes zero)
- Given that TWFE has large systematic pre-trends (all 11 pre-periods significant), the HonestDiD exercise using TWFE pre-trends to calibrate Mbar is particularly concerning: the large pre-trend magnitudes (up to 0.036 at t=-12) suggest Mbar>>1 is realistic, at which point all targets lose significance

### CS-NYT HonestDiD
- All three targets (first, avg, peak) include zero even at Mbar=0
- This means the CS-NYT confidence set for the drug price effect is centered on null under the restriction that pre-trends are perfectly parallel
- **D-FRAGILE**: the CS-NYT ATT cannot be distinguished from zero under the most conservative assumption

### Key concern: TWFE pre-trend calibration
The TWFE event study shows monotone negative pre-trends of magnitude 0.005 to 0.036 across 11 pre-periods. The maximum pre-trend at t=-12 relative to t=-2 is 0.031 (|−0.036 − (−0.005)|). Using this to calibrate Mbar = 0.031/0.019 ≈ 1.6, which is well above the robustness threshold of 0.75. At Mbar=1.5, all TWFE targets cross zero.

**Verdict: WARN** — TWFE average/peak effects are robust at Mbar=0 but lose significance at realistic pre-trend magnitudes (Mbar≥0.75); CS-NYT already null at Mbar=0. The dual estimator picture is mixed: TWFE suggests a positive but fragile effect; CS-NYT is consistent with zero.
