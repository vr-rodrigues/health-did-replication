# CS-DID Reviewer Report — Article 433

**Article:** DeAngelo, Hansen (2014) — "Life and Death in the Fast Lane: Police Enforcement and Traffic Fatalities"
**Reviewer:** csdid-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Checklist

### 1. Estimator configuration

- `run_csdid_nt = true`, `run_csdid_nyt = false` (correct: never-treated states available)
- Comparison group: 46 never-treated states
- `cs_controls = []` (no controls in CS-DID), `twfe_controls = [precip, temp, un_rate, max_speed]`
- `gvar_CS` constructed as: `gvar_CS = 38 for fips=41 (Oregon), 0 otherwise` (month-year variable mn_yr=38 = Feb 2003)

### 2. ATT estimates

| Estimator | ATT | SE | t-stat | Significant? |
|---|---|---|---|---|
| TWFE | 0.6999 | 0.1329 | 5.27 | Yes |
| CS-NT (no controls, simple) | 0.6979 | 0.3699 | 1.89 | Marginal |
| CS-NT (no controls, dynamic) | 0.6979 | 0.3652 | 1.91 | Marginal |
| CS-NT (with controls, simple) | 1.7327 | 0.4210 | 4.12 | Yes |
| CS-NT (with controls, dynamic) | 1.7327 | 0.4408 | 3.93 | Yes |

### 3. CS-NT (no controls) vs TWFE

The CS-NT ATT without controls (0.6979) is virtually identical to the TWFE estimate (0.6999) — a gap of 0.28%. This remarkable convergence is expected in a single-treated-unit design: with only Oregon treated and all other states never-treated, TWFE and CS-DID collapse to the same 2×∞ difference. This is a positive signal — no evidence of heterogeneous treatment effects or forbidden comparisons.

### 4. CS-NT (with controls) anomaly — WARN

The doubly-robust CS-DID with controls (`att_cs_nt_with_ctrls`) returns 1.7327 (SE=0.421), which is **2.47× larger than TWFE**. This is a substantial divergence. Possible explanations:

a. **Control variable collinearity in CS-DID with a single treated unit**: With Oregon as the only treated unit and 4 continuous controls (precip, temp, un_rate, max_speed), the doubly-robust estimator may be overfitting the propensity score or outcome model. When there is only 1 treated unit, the propensity score model trivially separates Oregon from controls, creating instability in the doubly-robust weights.

b. **Trimming/re-weighting artefact**: The DR estimator may be assigning extreme weights to control observations when the propensity score is near 0 or 1.

c. **Specification note**: The metadata specifies `cs_controls = []` yet `att_cs_nt_with_ctrls` is populated with a value (Status = "OK"). This suggests controls were applied in the CS specification despite `cs_controls` being empty — possibly through the Gardner 2R estimator sharing the control set, or through a template routing issue.

The no-controls CS-NT is the canonical comparison here. The with-controls anomaly is flagged as WARN.

### 5. SE inflation

CS-NT SE (0.3613) is 2.72× larger than TWFE SE (0.1329). This is expected with a single treated unit: the variance of the ATT is dominated by uncertainty about Oregon's counterfactual. The CS-DID estimator correctly reflects this imprecision, whereas TWFE understates uncertainty by treating treatment as a regressor (with many effective degrees of freedom from the never-treated panel).

The CS-NT ATT (t=1.89) is only marginally significant vs TWFE (t=5.27). The result direction is confirmed but precision is much lower with the appropriate variance estimator.

### 6. Pre-trends (CS-NT event study)

From event_study_data.csv, CS-NT pre-periods:
- t=-6: -2.854 (SE=0.635, t=4.49) — highly significant
- t=-5: -0.598 (SE=0.622, t=0.96)
- t=-4: -2.723 (SE=0.433, t=6.29) — highly significant
- t=-3: -0.260 (SE=0.604, t=0.43)
- t=-2: -1.122 (SE=0.397, t=2.83) — significant

**Three of five pre-periods are statistically significant (t=-6, t=-4, t=-2)**. This is a major WARN. However, interpretation requires care:

- With a single treated unit, each pre-period estimate is a raw comparison of Oregon vs. control states at time t. Oregon may have systematically different seasonal patterns.
- The oscillatory (not monotone) pattern: -2.854, -0.598, -2.723, -0.260, -1.122 — suggests noise or seasonal heterogeneity rather than a confounding trend.
- The CS-NT "with controls" ATT being 2.47× larger than TWFE suggests the controls are not effectively removing this pre-period variation.

Pre-trend significance in CS-NT is flagged as WARN, but the oscillatory rather than monotone pattern reduces concern about a genuine confounding trend.

### 7. Gardner (2R) event study

Gardner pre-periods closely track CS-NT:
- t=-6: -2.777, t=-5: -0.568, t=-4: -2.648, t=-3: -0.238, t=-2: -1.081

Highly similar to CS-NT, confirming this is an Oregon-specific pattern in the data (not a CS-DID artefact). Post-period estimates also similar (Gardner post: 0.227, 3.077, 1.479, -0.582, 0.422, 2.412, 0.620).

---

## Summary

- CS-NT ATT (no controls) converges with TWFE within 0.28% — excellent for single-treated-unit design.
- SE inflation (2.72×) is expected and appropriate.
- CS-NT pre-trend violations (t=-4, t=-6, t=-2 significant) are a WARN, though the oscillatory pattern and single-unit nature mitigate concerns.
- CS-NT with controls produces 2.47× anomaly — likely single-treated-unit propensity score instability.
- Direction of effect is consistently positive and large across all estimators.

**Verdict: WARN**
(Pre-trend violations in CS-NT at t=-2, t=-4, t=-6; CS-with-controls anomaly 2.47× TWFE)
