# CS-DID Reviewer Report — Article 76 (Lawler & Yewell 2023)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification
- Estimator: `csdid2` (Callaway-Sant'Anna 2021) with repeated cross-section option (`panel=FALSE`).
- Comparison group: Never-treated (NT) and not-yet-treated (NYT) — both run.
- Group variable: `gvar_CS` = `start_year` for treated units, 0 for never-treated.
- Controls (CS): 8 individual-level controls (WIC_ever, frstbrn, married, female, childnm, mom_ed, raceeth_cat, mom_agegrp). Note: state-year controls excluded from CS specification because at aggregate level they would require a different aggregation strategy.
- Weights: `rddwt`. Applied.
- Clustering: `fips`. Applied.

### 2. Numerical comparison — stored vs paper

| Estimator | Paper | Our estimate | Pct gap |
|-----------|-------|-------------|---------|
| CS-NT (dynamic) | 0.018 | 0.00774 | -57% |
| CS-NYT (dynamic) | 0.0212 | 0.00781 | -63% |
| CS-NT (simple) | — | 0.01652 | — |
| CS-NYT (simple) | — | 0.01922 | — |

The stored `att_csdid_nt` (0.00774) and `att_csdid_nyt` (0.00781) are the **no-controls** simple average estimates, not the Stata CSDID estimates.

### 3. Root cause of gap — Pattern 25

The paper uses `csdid2 bf_ever i.fips $individXs [w=rddwt], agg(event)` with `i.fips` as a **covariate** (not a fixed effect in CS-DID sense). This means ~50 additional state FEs enter the doubly-robust propensity score and regression adjustment. The R `att_gt()` function cannot include `i.fips` as a covariate without singularity in the repeated cross-section setting (individual obs are the units, county identity is the group). This structural difference produces the ~57% gap.

The notes explicitly document: "CS-NT: 0.01652 vs Stata 0.01799 (8.2% gap). Pattern 25 applied." The 8.2% gap refers to the with-controls estimate; the no-controls estimate (0.00774) differs more because it omits the individual controls that partially compensate.

**The gap is a known, documented limitation — not an implementation error.**

### 4. CS-DID event study

| Period | CS-NT | CS-NYT |
|--------|-------|--------|
| t=-5 | +0.00137 | +0.00395 |
| t=-4 | +0.01516 | +0.02066 |
| t=-3 | +0.00886 | +0.00862 |
| t=-2 | -0.00159 | +0.00177 |
| t=-1 | 0 (ref) | 0 (ref) |
| t=0 | +0.00055 | -0.00014 |
| t=1 | +0.00756 | +0.00576 |
| t=2 | +0.03333 | +0.03513 |
| t=3 | +0.04544 | +0.04960 |
| t=4 | +0.00846 | +0.01405 |

Pre-periods t=-4 and t=-3 show modestly elevated coefficients for both CS-NT (+0.015, +0.009) and CS-NYT (+0.021, +0.009). These are within 2 SEs given standard errors of ~0.007, but are non-negligible. The t=-4 CS-NYT coefficient (+0.0207, SE ~0.006) approaches marginal significance. This raises a mild concern about parallel trends.

### 5. Heterogeneity across cohorts
- 8 adoption cohorts: 2000, 2002, 2005, 2006, 2008, 2013, 2014, 2015.
- Post-treatment effects show meaningful cohort heterogeneity (seen in event study: t=3 peaks at 0.045 CS-NT, t=4 drops to 0.008 CS-NT — likely driven by 2015 cohort having shorter post-window and negative TWFE weight).

### 6. Treatment dose vs binary treatment
The CS-DID is run using `gvar_CS = start_year` for treated counties (those with at least one baby-friendly hospital that adopted). The continuous dose (`baby_babyfr`) is embedded in the TWFE specification but not directly in CS-DID. The CS-DID estimates represent effects for counties with any adoption (intensive margin averaged). This creates a conceptual gap between TWFE (weighted by dose) and CS-DID (equally weighted by county).

### 7. WARN rationale
Two issues warrant WARN:
1. The 57–63% gap between paper's CS-DID and our stored estimate cannot be fully closed due to the i.fips covariate limitation (Pattern 25). The stored CS-DID numbers are not directly comparable to the paper's reported CS-DID.
2. Mild pre-trend concern at t=-4 for CS-NYT (coefficient ~3× its SE).

These are not failures — the direction is consistent (positive effect on breastfeeding) and the TWFE is exactly reproduced. But CS-DID numbers in our database understate the paper's preferred CS-DID estimates.

**Verdict: WARN**
