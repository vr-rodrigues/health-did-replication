# CS-DID Reviewer Report — Article 380
## Kuziemko, Meckel & Rossin-Slater (2018)

**Verdict:** WARN
**Date:** 2026-04-18

---

## 1. Estimate Comparison

| Estimator | ATT | SE | Significant? |
|---|---|---|---|
| TWFE (with controls) | +0.0683 | 0.0733 | No |
| CS-NT (no controls) | -0.0234 | 0.3701 | No |
| CS-NYT (no controls) | -0.1184 | 0.3623 | No |
| CS-NT (with controls) | +0.6599 | 1.5399 | No |
| CS-NYT (with controls) | +0.4593 | 1.1183 | No |
| CS-NT simple (no ctrls) | -0.0242 | 0.3714 | No |
| CS-NT dynamic (no ctrls) | +0.0721 | 0.3170 | No |
| CS-NYT simple (no ctrls) | -0.1292 | 0.3575 | No |
| CS-NYT dynamic (no ctrls) | -0.0246 | 0.3226 | No |

---

## 2. Sign Reversal Assessment

The TWFE estimate is positive (+0.068) while CS-NT and CS-NYT without controls are negative (-0.023, -0.118). This constitutes a sign reversal, though all estimates are statistically indistinguishable from zero. The sign reversal suggests potential heterogeneous treatment effects across cohorts that TWFE is averaging in a misleading direction, or simply noise given the large standard errors.

---

## 3. Control Variable Asymmetry

A significant methodological concern: the metadata specifies `cs_controls: []` (no controls for CS estimation) while TWFE uses 4 controls (`ln_pop`, `ln_inc`, `ln_tran`, `unemp`). This creates an apples-to-oranges comparison between TWFE (conditional on controls) and CS-DID (unconditional).

Evidence of extreme sensitivity to controls:
- CS-NT without controls: -0.023 (SE=0.371)
- CS-NT with controls: +0.660 (SE=1.540)

The sign flips and the SE more than quadruples when controls are added to CS-DID. This instability suggests either multicollinearity between controls and group-time cells, or that the conditional parallel trends assumption is poorly satisfied. The imputed CS-with-controls estimates are not reliable for inference.

---

## 4. CS Event Study Pre-Trends

| Period | CS-NT Coef | CS-NT SE | CS-NYT Coef | CS-NYT SE |
|---|---|---|---|---|
| t=-6 | +0.641 | 0.461 | +0.739 | 0.412 |
| t=-5 | -0.447 | 0.688 | -0.040 | 0.645 |
| t=-4 | -0.135 | 0.540 | -0.061 | 0.492 |
| t=-3 | -0.634 | 0.476 | -0.457 | 0.363 |
| t=-2 | +0.616 | 0.469 | +0.296 | 0.392 |

CS event-study pre-periods are volatile with alternating signs and large SEs. The t=-6 period shows a large positive coefficient for both CS-NT (+0.641, SE=0.461) and CS-NYT (+0.739, SE=0.412), which are statistically marginal (t≈1.39, 1.79). This raises pre-trend concerns even for the CS estimator, which is supposed to be more robust to heterogeneous timing.

---

## 5. Post-Period Patterns

CS-NT post-period (t=0 to t=5): -0.168, +0.343, +0.245, -0.445, +0.105, +0.677 — oscillating with no clear treatment effect direction. The t=5 estimate (+0.677, SE=0.495) is potentially large but imprecise.

---

## 6. Never-Treated vs Not-Yet-Treated Comparison

- CS-NT ATT: -0.023 (SE=0.371)
- CS-NYT ATT: -0.118 (SE=0.362)

The difference between NT and NYT estimators is small (-0.095) relative to SEs, suggesting contamination from using not-yet-treated as controls is not severe in aggregate, though individual cohort estimates may differ.

---

## 7. Verdict Rationale

**WARN** issued on three grounds:
1. Sign reversal relative to TWFE (though both insignificant): raises concern that TWFE averaging masks heterogeneous effects
2. Extreme sensitivity to control inclusion in CS-DID: estimates swing from -0.023 to +0.660 — the control-variable asymmetry between TWFE and CS specifications undermines comparability
3. Volatile CS pre-period event-study coefficients (especially t=-6) suggest even the CS estimator may not fully satisfy parallel trends in this setting

The all-around statistical insignificance provides some comfort, but means we cannot confidently characterize whether MMC had any effect on Black infant mortality.

---

*Full data: `results/by_article/380/results.csv`, `results/by_article/380/event_study_data.csv`*
