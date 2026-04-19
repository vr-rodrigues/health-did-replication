# TWFE Reviewer Report: Article 262

**Verdict:** WARN
**Date:** 2026-04-18
**Article:** Anderson, Charles, Rees (2020) — Hospital Desegregation & Black Postneonatal Mortality

---

## Checklist

### 1. Specification Fidelity

The TWFE specification matches the Stata original closely:
- Outcome: `post_neonatal_rate` (Black postneonatal mortality rate)
- Treatment: `medicare` (binary, staggered 1967–1973)
- Controls: `hs_deg_imp`, `health_per_cap`, `emp_to_pop` (time-varying county covariates)
- Unit FE: `state_county_fips`
- Time FE: `year`
- Clustering: `state_county_fips`
- Weight: `births_ave` (birth-weighted regression, `pweight`)
- Sample filter: `race == 3 & balanced == 1 & no_births == 0`

The R template correctly implements this as a two-way FE regression. **PASS** on specification fidelity.

### 2. Statistical Significance

- beta_twfe = 1.221, SE = 0.888, implied t = 1.376
- **Not statistically significant at the 5% level** (|t| < 1.96)
- With 95% CI approximately [−0.52, 2.96], the null of no effect is not rejected
- The TWFE headline result is directionally positive (Black postneonatal mortality reduced by ~1.2 deaths per 1,000 births) but imprecisely estimated

### 3. Pre-trend Assessment (TWFE Event Study)

Event study coefficients for TWFE (relative to t=−1):

| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| −6 | 0.256 | 1.986 | 0.13 |
| −5 | 0.919 | 1.703 | 0.54 |
| −4 | 0.043 | 1.510 | 0.03 |
| −3 | 0.468 | 1.500 | 0.31 |
| −2 | −0.211 | 0.916 | −0.23 |

All pre-trend t-statistics are well below 1.96. No individual period shows a significant pre-trend. **Pre-trends appear flat for TWFE.**

However, note the large SEs (1.5–2.0), meaning null pre-trends is a low bar — modest violations would be undetectable.

### 4. Post-treatment Pattern

Post-treatment TWFE coefficients:
- t=0: 1.214 (SE 1.028)
- t=1: 1.917 (SE 1.194) — largest effect
- t=2: 0.854 (SE 1.534)
- t=3: 0.375 (SE 1.774)
- t=4: −0.366 (SE 1.943)
- t=5: 1.499 (SE 2.452)

The post-treatment pattern is noisy and non-monotone. The apparent effect at t=1 fades by t=3–4 and then has a large SE spike at t=5. This is **consistent with heterogeneous treatment effects across cohorts** and large standard errors from the small late-cohort sample sizes noted in the metadata (1967=85%, 1970–1973<1% each).

### 5. Staggered DiD Concern

**WARN:** With staggered adoption and 7 cohorts (1967–1973), TWFE uses previously-treated cohorts as implicit controls when comparing later cohorts against earlier ones. The metadata notes that cohort 1967 accounts for ~85% of all treated units, making the 1967 cohort the de facto comparison group for virtually all later cohorts. This is not a pure control group comparison — it constitutes a "forbidden comparison" risk in TWFE. Although CS-DID estimates are broadly consistent (both positive, similar magnitude), the TWFE SE is roughly double the CS-NT SE, consistent with contaminated comparisons inflating variance.

### 6. Control Variable Concern

The TWFE specification includes time-varying controls (`hs_deg_imp`, `health_per_cap`, `emp_to_pop`) but the CS-DID is estimated without controls (`cs_controls: []`). This asymmetry means the two estimators are not directly comparable. However, the uncontrolled TWFE (`beta_twfe_no_ctrls = 1.206, SE = 0.892`) is nearly identical to the controlled version, suggesting controls add little information in this setting.

---

## Summary

The TWFE specification is faithful to the original paper. Pre-trends are flat but imprecisely measured. The main concern is the staggered design with extreme cohort imbalance (1967 dominates at 85%), which means TWFE implicitly uses the large early-adopting cohort as a control for all others — a valid but potentially heterogeneity-contaminating comparison. The headline TWFE result (1.221, SE 0.888) is not statistically significant at 5%, though CS-NT is (0.995, SE 0.404).

**Verdict: WARN** — staggered design with cohort imbalance creates forbidden comparison risk in TWFE, and the headline result is statistically marginal (p≈0.17).
