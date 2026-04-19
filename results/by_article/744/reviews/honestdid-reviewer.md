# HonestDiD Reviewer Report — Article 744

**Article:** Jayachandran, Lleras-Muney & Smith (2010) — "Modern Medicine and the 20th Century Decline in Mortality"
**Reviewer:** honestdid-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Checklist

### 1. Applicability
- [PASS] `has_event_study = true`, `event_pre = 12` (≥ 3 pre-periods) — HonestDiD applicable
- [PASS] Data available: `honest_did_v3.csv` and `honest_did_v3_sensitivity.csv` present

### 2. Pre-period structure
- [PASS] 11 pre-periods used (t = -12 to -2, with t=-1 normalised to 0), 7 post-periods (t=0 to 6)
- [WARN] The pre-trend pattern shows strong monotonic drift — NOT a random pre-period fluctuation around zero. TWFE pre-period coefficients: t=-12: -0.259, t=-11: -0.243, t=-10: -0.218, ..., t=-4: -0.012, t=-3: +0.013, t=-2: +0.026. This is a smooth monotonic trend from strongly negative to near-zero, characteristic of a pre-existing differential trend between MMR and TB mortality that is partially (but not fully) controlled by the `treatedXyear_c` linear trend control in the TWFE.

### 3. Sensitivity results — TWFE

**Target: first post-period ATT (t=0)**
| Mbar | Lower | Upper | Zero included? |
|---|---|---|---|
| 0.00 | -0.186 | -0.071 | NO — robust |
| 0.25 | -0.198 | -0.059 | NO — robust |
| 0.50 | -0.210 | -0.044 | NO — robust |
| 0.75 | -0.224 | -0.030 | NO — robust |
| 1.00 | -0.240 | -0.012 | NO — robust |
| 1.25 | -0.256 | +0.007 | YES — breaks |

- `rm_first_Mbar = 1.0` for TWFE: the first-period effect remains significant allowing up to Mbar=1.0 deviation in pre-trends.

**Target: average ATT**
| Mbar | Lower | Upper | Zero included? |
|---|---|---|---|
| 0.00 | -0.359 | -0.271 | NO — robust |
| 0.75 | -0.448 | -0.048 | NO — robust |
| 1.00 | -0.448 | +0.037 | YES — breaks |

- `rm_avg_Mbar = 0.75` for TWFE: the average effect holds up to Mbar=0.75.

**Target: peak ATT**
| Mbar | Lower | Upper | Zero included? |
|---|---|---|---|
| 0.00 | -0.647 | -0.470 | NO — very robust |
| 1.00 | -0.901 | -0.033 | NO — robust |
| 1.25 | -0.901 | +0.093 | YES — breaks |

- `rm_peak_Mbar = 1.0` for TWFE: peak effect robust up to Mbar=1.0.

### 4. Sensitivity results — CS-NT

**Target: first post-period (t=0)**
- `rm_first_Mbar = 1.0` for CS-NT (breaks at Mbar=1.25): same robustness as TWFE
- At Mbar=1.0: CI [-0.272, -0.001] — just barely excludes zero

**Target: average ATT**
- `rm_avg_Mbar = 0.5` for CS-NT (breaks at Mbar=0.75)

**Target: peak ATT**
- `rm_peak_Mbar = 0.75` for CS-NT (breaks at Mbar=1.0)

### 5. Assessment

- [WARN] The pre-trend pattern is strongly systematic (monotonic drift), not random noise. This means the Mbar sensitivity analysis is the relevant test — and the pre-trend slope is quite steep. The linear trend control (`treatedXyear_c`) in the TWFE is designed to handle exactly this kind of differential trend, but it introduces parametric assumptions.
- [PASS] Despite the pre-trend concerns, the results show meaningful robustness: the first-period effect is robust up to Mbar=1.0 (TWFE) and Mbar=1.0 (CS-NT), the average effect up to Mbar=0.75 (TWFE) and Mbar=0.5 (CS-NT).
- [WARN] CS-NT is less robust than TWFE on the average and peak targets. At Mbar=0.5 the average CS-NT estimate's CI includes zero. Since CS-NT is the preferred estimator for robustness to heterogeneous treatment effects, its weaker HonestDiD performance is the binding constraint.
- [NOTE] The strong pre-trend (large negative coefficients 12 years before treatment) is partially a mechanical feature of the disease-level DiD: MMR and TB mortality were on different long-run trajectories before sulfa drugs. The linear trend control corrects for this in TWFE but CS-DID does not use this parametric control.

### 6. Design credibility signal

Given the monotonic pre-trend drift with amplitude ~0.26 log-points over 12 years (slope ~0.022/year), the maximum allowable deviation Mbar must be compared against the observed pre-trend magnitude. The observed pre-trend slope (~0.022/year) translates to a meaningful Mbar when normalised to the post-period magnitude. Results are robust only if one accepts that post-period violations could be up to 75-100% as large as pre-period violations — a moderate but not trivial assumption.

**Design credibility: D-FRAGILE** — the conclusion holds, but depends on the parallel-trends assumption holding better post-1937 than it did pre-1937, which is a non-trivial belief given the pre-trend evidence.

---

## Summary

| Target | TWFE rm_Mbar | CS-NT rm_Mbar |
|---|---|---|
| First post | 1.00 | 1.00 |
| Average | 0.75 | 0.50 |
| Peak | 1.00 | 0.75 |

Verdict: **WARN** — Results are statistically robust up to Mbar=0.5–1.0, but the strong monotonic pre-trend drift is a material concern that makes the parallel-trends assumption non-trivially difficult to defend without the parametric trend control. The CS-NT average ATT is only robust to Mbar=0.5.
