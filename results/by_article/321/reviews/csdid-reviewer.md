# CS-DID Reviewer Report — Article 321 (Xu 2023)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Estimator applicability
- Single treatment timing (`treatment_timing = "single"`). All treated towns adopt in 1918. `gvar_CS` is set to 1918 for treated, 0 for never-treated. This is a valid CS-DiD setup — the single adoption cohort is compared against never-treated controls.
- `run_csdid_nyt = false`: correct, no not-yet-treated group exists in single-timing designs.
- `run_csdid_nt = true`: correct.

### 2. ATT estimates
| Estimator | ATT | SE | t-stat | Significant? |
|-----------|-----|----|--------|--------------|
| TWFE | -0.142 | 0.041 | -3.47 | YES |
| CS-NT (simple) | -0.110 | 0.077 | -1.43 | No |
| CS-NT (dynamic) | -0.110 | 0.072 | -1.54 | No |

**Gap between TWFE and CS-NT: 22% smaller magnitude.** CS-NT loses statistical significance (t=-1.4 vs t=-3.5). This is a meaningful divergence.

The gap is partly expected in single-timing designs when treated/never-treated pools differ in composition (1061 towns, 205 districts). The larger SE in CS-NT reflects efficiency loss from the non-parametric aggregation.

### 3. CS-NT pre-trends (event study)
| Period | Coef | SE | t-stat | Significant? |
|--------|------|----|--------|--------------|
| t=-5 | -0.065 | 0.075 | -0.87 | No |
| t=-4 | -0.167 | 0.076 | -2.20 | **YES** |
| t=-3 | -0.156 | 0.070 | -2.23 | **YES** |
| t=-2 | -0.116 | 0.054 | -2.15 | **YES** |

**Three of four pre-periods are statistically significant in CS-NT**, a stronger signal than TWFE. This is concerning: the non-parametric CS-DiD estimator, which is less susceptible to contamination from post-periods, still shows significant pre-trends. This suggests genuine pre-treatment differences in outcome trajectories between Indian-DM towns and never-treated towns.

### 4. Controls
- `cs_controls = []`: no controls. `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`. Consistent with specification.
- CS-NYT not attempted: `"NOT_ATTEMPTED"` status — correct for single-timing.

### 5. Post-period dynamics (CS-NT event study)
| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| t=0 | -0.174 | 0.096 | -1.81 |
| t=1 | -0.306 | 0.152 | -2.01 |
| t=2 | -0.131 | 0.129 | -1.02 |
| t=3 | -0.145 | 0.097 | -1.49 |

Post-period effects in CS-NT are directionally consistent with TWFE, but individually only t=1 reaches conventional significance (t=-2.01). The pattern (peak at t=1, then attenuation) mirrors TWFE.

### 6. Concerns
- **Significant CS-NT pre-trends at t=-4, t=-3, t=-2**: three consecutive pre-periods statistically significant. This is a fundamental parallel trends concern that is not resolved by the CS-DiD estimator.
- **22% TWFE-to-CS-NT gap**: CS-NT ATT=-0.110 vs TWFE=-0.142. CS-NT loses significance (SE nearly doubles). Part of this is efficiency loss; part may reflect composition differences.
- **No never-treated contamination risk** given single timing — the control group quality depends entirely on never-treated towns being comparable to treated towns in pre-period trends, which the event study casts doubt on.

## Summary
CS-DiD direction is consistent with TWFE, but pre-trends are clearly violated in three pre-periods. The 22% magnitude gap and loss of statistical significance in CS-NT, combined with the pre-trend evidence, constitutes a genuine credibility concern.

**Verdict: WARN** (three significant CS-NT pre-periods; 22% TWFE-CS gap; CS-NT not significant)
