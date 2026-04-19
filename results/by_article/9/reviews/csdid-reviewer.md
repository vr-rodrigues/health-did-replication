# CS-DID Reviewer Report: Article 9 — Dranove et al. (2021)

**Verdict:** PASS
**Date:** 2026-04-18

---

## Checklist

### 1. Estimator configuration
- CS-NT (never-treated): `run_csdid_nt = true` — correct for staggered design where never-treated states form the control group.
- CS-NYT (not-yet-treated): `run_csdid_nyt = true` — correct for staggered design, expands control group to not-yet-adopted states.
- `cs_controls = []` (empty) — intentional and correct. Metadata notes confirm that including `xformla = ~exp` in `att_gt()` causes the did v2.3.0 balanced-panel code path to drop early cohorts (205–216), retaining only cohorts 220 and 225, drastically reducing the effective sample. The no-controls specification preserves all 10 cohorts.
- `base_period = 'universal'` — mandatory default per Pattern 26.
- Panel: balanced (29 states × 26 quarters = 754 rows), `allow_unbalanced = false`.

### 2. Group-time variable (gvar_CS) construction
- `gvar_CS` constructed as: for each state, take the mean of `yq` where `L0==1` (first quarter of treatment); untreated states receive 0.
- This correctly identifies the adoption quarter per cohort, forming the "g" variable for `att_gt()`.
- Construction is via `group_by(state_r) %>% mutate(gvar_CS_raw = mean(gvar_aux, na.rm=TRUE))` — correct state-level aggregation.

### 3. Numerical comparison
| Estimator | Our estimate | Paper estimate | Diff |
|-----------|-------------|----------------|------|
| CS-NT simple aggregate | -0.2084 | -0.2019 | 3.2% |
| CS-NYT simple aggregate | -0.2133 | -0.2084 | 2.4% |
| CS-NT dynamic aggregate | -0.1985 | — | — |
| CS-NYT dynamic aggregate | -0.2193 | — | — |

- CS-NT gap of 3.2% from the paper's -0.2019 is documented: paper ran with `xformla=~exp` using a different package version, which retains all cohorts but in our version (did v2.3.0) causes cohort dropping. Our no-controls version (-0.2084) is methodologically cleaner.
- All estimates are within a reasonable tolerance given the documented package version difference.

### 4. Pre-trend assessment (CS-NT event study)
| Period | Coeff | SE |
|--------|-------|----|
| -9 | -0.024 | 0.047 |
| -8 | -0.017 | 0.040 |
| -7 | -0.007 | 0.036 |
| -6 | -0.000 | 0.020 |
| -5 | -0.001 | 0.015 |
| -4 | +0.008 | 0.018 |
| -3 | +0.020 | 0.016 |
| -2 | +0.009 | 0.008 |

- All pre-trend coefficients are small in magnitude and statistically indistinguishable from zero.
- No evidence of differential pre-trends between treated and never-treated states.
- CS-NT pre-trends are cleaner than TWFE pre-trends (maximum |coeff| = 0.024 vs 0.069 for TWFE at t=-9), as expected since CS-DID uses a cleaner control group.

### 5. Cross-estimator consistency
| Estimator | Simple ATT |
|-----------|-----------|
| TWFE | -0.176 |
| CS-NT simple | -0.208 |
| CS-NYT simple | -0.213 |
| SA (event-study-based, tau 0–9 avg) | ~-0.177 |
| Gardner (event-study-based, tau 0–9 avg) | ~-0.183 |
| CS-NT dynamic | -0.198 |

- All estimators agree on sign and order of magnitude. The range is [-0.176, -0.213] — all substantially negative.
- CS-DID estimates are larger in magnitude than TWFE by ~20%, consistent with heterogeneous treatment effects where TWFE over-weights earlier-treated cohorts (who have had more time to accumulate effects but also serve as contaminated controls in TVT comparisons).
- The TWFE-CS-DID gap is directionally expected and not a red flag.

### 6. Cohort-level heterogeneity
All cohorts (205–225 in quarterly units) show negative treatment effects in the TVU comparisons from the Bacon decomposition, with the exception of cohort 205 (+0.047 vs untreated, weight=3.9%). The one positive cohort (205) has low weight; the remaining 9 cohorts all show negative effects ranging from -0.032 to -0.263. Heterogeneity is present but does not undermine the aggregate conclusion.

---

## Summary
CS-DID implementation is correctly specified with no controls to avoid cohort-dropping in did v2.3.0. Pre-trends are clean. All five estimators (TWFE, CS-NT, CS-NYT, SA, Gardner) agree on a substantial negative effect on log drug price per prescription. The 3.2% gap from the paper's CS-NT figure is explained by package version differences and is not a concern. No evidence of parallel trends violation.

**Verdict: PASS**
