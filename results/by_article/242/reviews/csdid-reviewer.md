# CS-DID Reviewer Report — Article 242

**Verdict:** WARN
**Date:** 2026-04-18

## Specification

- Estimator: Callaway-Sant'Anna (2021) `att_gt`
- Comparison groups: Never-treated (NT) and Not-yet-treated (NYT)
- Controls: NONE (cs_controls empty — baseline-×-year interactions cannot be used in att_gt)
- Aggregation: simple ATT, dynamic ATT (restricted to max_e=5)
- gvar_CS construction: `ifelse(tquartile1==1, splayyear1, 0)` (entry year for top-quartile counties)

## Numerical results

| Estimator | ATT (simple) | SE | ATT (dynamic) | SE |
|---|---|---|---|---|
| CS-NT (no controls) | 0.0168 | 0.0081 | 0.0182 | 0.0078 |
| CS-NYT (no controls) | 0.0167 | 0.0083 | 0.0180 | 0.0085 |
| CS-NT (with controls) | FAIL | — | FAIL | — |
| CS-NYT (with controls) | FAIL | — | FAIL | — |

## Checklist

### 1. Group variable construction
- [PASS] `gvar_CS` correctly assigns adoption year for treated units, 0 for never-treated. Construction matches paper's staggered cohort structure.
- [PASS] 9 cohorts identified (2001–2012 adoption years).

### 2. Comparison group selection
- [PASS] Never-treated (NT): 407 control counties in same shale plays with lower RPI — appropriate comparison.
- [PASS] Not-yet-treated (NYT): uses not-yet-treated as controls — appropriate for staggered design.
- [INFO] NT and NYT results are nearly identical (0.0168 vs 0.0167), suggesting the not-yet-treated controls are not adding contamination.

### 3. Controls handling
- [WARN] cs_controls is empty because baseline-×-year interaction controls (`c.X1990#i.year`) cannot be passed to `att_gt`. This creates a methodological gap: TWFE uses 7 important baseline controls (income, education, manufacturing, marriage rate, rurality, veteran status, race), CS-DID does not. If these controls are important (they are — motivated by potential confounding by pre-fracking socioeconomic characteristics), the CS-DID estimate may be confounded.
- [FAIL-controls] CS-NT with controls fails: `"FAIL_other: in i(year, medianhhinc1990): Argument 'var' could not be evaluated. PROBLEM: objeto 'medianhhinc199"` — R environment variable scoping issue. This means the with-controls CS-DID estimates are unavailable.

### 4. Pre-trend assessment (CS-NT dynamic)
- [PASS] Pre-treatment CS-NT coefficients: t=-6: 0.000, t=-5: -0.007, t=-4: -0.006, t=-3: -0.002, t=-2: -0.007, t=-1: 0 (ref). Small magnitudes, no clear trend. Pre-trends appear clean.

### 5. ATT consistency with TWFE
- [PASS] CS-NT simple ATT = 0.0168 vs TWFE = 0.0194. Difference = -0.0026. Within one standard error of each other. The two estimators broadly agree, which is reassuring given the staggered design.

### 6. Dynamic restriction (max_e=5)
- [PASS] CS-DID dynamic restricted to e<=5 per metadata note (Pattern 37): treatment turns off at e~6, so e>=6 captures post-treatment rebound, not causal effect. Restriction is methodologically justified. Unrestricted ATT would be contaminated by de-adoption effects.

### 7. Post-treatment dynamics (CS-NT)
- [WARN] Post-treatment CS-NT coefficients show delayed ramp-up: t=0: -0.005, t=1: 0.004, t=2: 0.005, t=3: 0.016, t=4: 0.041, t=5: 0.049. The effect only becomes meaningfully positive at t=3+. This is consistent with the economic story (blue-collar labor market adjustment takes time) but the near-zero estimates at t=0,1,2 mean the first 2-3 years show essentially no earnings effect.

## Key concerns

1. **Missing controls in CS-DID**: The primary TWFE uses 7 baseline-×-year controls that cannot be incorporated into att_gt. If these covariates explain selection into top-quartile RPI status, the CS-DID estimate is less reliable than TWFE.

2. **Controls implementation failure**: The attempt to include controls failed due to a variable scoping error. This is a technical gap — the with-controls CS-DID estimates are missing entirely.

3. **Delayed effect pattern**: The CS-NT dynamic shows effects concentrated at t=3-5, suggesting potentially small effects in early post-treatment years.

## Verdict justification

WARN: CS-DID without controls broadly confirms TWFE (0.0168 vs 0.0194). However, the inability to control for baseline socioeconomic characteristics in att_gt, combined with the controls-with implementation failure, creates a methodological gap. The delayed ramp-up in post-treatment coefficients is economically plausible but warrants attention.

[Full data: `results/by_article/242/results.csv`, `results/by_article/242/event_study_data.csv`]
