# TWFE Reviewer Report — Article 380
## Kuziemko, Meckel & Rossin-Slater (2018)

**Verdict:** WARN
**Date:** 2026-04-18

---

## 1. Estimate Summary

| Statistic | Value |
|---|---|
| beta_twfe | 0.0683 |
| se_twfe | 0.0733 |
| t-statistic | 0.93 |
| Significant at 5%? | No |
| beta_twfe_no_ctrls | 0.0613 |
| se_twfe_no_ctrls | 0.0697 |

The TWFE static ATT estimate is small (+0.068 percentage points of Black infant mortality per 100 births) and statistically insignificant. Adding controls barely changes the point estimate (+0.068 vs +0.061), suggesting controls have minimal impact on the TWFE aggregate estimate.

---

## 2. Pre-Trend Assessment (Event Study)

| Period | Coef | SE | t-stat |
|---|---|---|---|
| t=-6 | -0.055 | 0.158 | -0.35 |
| t=-5 | -0.292 | 0.296 | -0.99 |
| t=-4 | -0.298 | 0.317 | -0.94 |
| t=-3 | -0.425 | 0.219 | -1.94 |
| t=-2 | +0.026 | 0.257 | +0.10 |

**Pre-trend concern:** The t=-3 coefficient (-0.425, SE=0.219) is economically large — approximately 6x the static ATT — and borderline significant (t≈-1.94, p≈0.053). Periods t=-5 and t=-4 also show moderate downward drift. This pattern is consistent with a pre-existing negative trend in Black infant mortality among treated counties relative to controls prior to MMC adoption, which would bias the post-period estimates.

The t=-2 coefficient is close to zero (+0.026), which partially offsets the t=-3 concern, but the overall pre-period profile is not flat.

---

## 3. Post-Period Heterogeneity

| Period | Coef | SE |
|---|---|---|
| t=0 | -0.475 | 0.232 |
| t=1 | -0.194 | 0.252 |
| t=2 | +0.125 | 0.275 |
| t=3 | -0.292 | 0.231 |
| t=4 | -0.150 | 0.292 |
| t=5 | -0.024 | 0.158 |

Post-period effects are highly variable in sign and magnitude, with no consistent evidence of a treatment effect. The TWFE static estimate (+0.068) aggregates these inconsistent post-period effects into a near-zero estimate that provides little guidance on the underlying causal mechanism.

---

## 4. Model Specification Concerns

The metadata notes a significant simplification relative to the original paper:

- **Paper's FE structure:** Year FE + Month FE + Year×Month interaction FEs (fully absorbing seasonal-secular trends)
- **Template's FE structure:** Single integer-month time FE (`time_int`)

This simplification means the template does not absorb month-within-year seasonal patterns separately from year trends. In a county-month panel spanning ~13 years (1992-2006), seasonal patterns in infant mortality could be material. This likely introduces residual confounding not present in the original specification. The magnitude of this bias is unknown without running the exact specification.

---

## 5. Verdict Rationale

**WARN** issued on two grounds:
1. Pre-trend at t=-3 is borderline significant and economically large relative to the static ATT, undermining parallel trends credibility
2. Template uses simplified time FEs vs. the paper's multi-dimensional time FE structure, potentially biasing estimates

The static TWFE estimate is statistically insignificant, which limits the policy concern somewhat — but the pre-trend pattern means the null result should not be taken at face value as evidence of no effect.

---

*Full data: `results/by_article/380/results.csv`, `results/by_article/380/event_study_data.csv`*
