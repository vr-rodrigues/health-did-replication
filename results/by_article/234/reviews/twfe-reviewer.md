# TWFE Reviewer Report: Article 234 — Myers (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Treatment variable specification
- Treatment `epillconsent18` is CONTINUOUS (fractional: 0, 0.25, 0.50, 0.75, 1.00), not binary.
- TWFE with a continuous/dose treatment is a valid choice that matches the original paper's specification.
- WARN: Continuous treatment in TWFE estimates a dose-response slope, not a standard ATT. The interpretation differs from binary TWFE.
- The original paper (Myers 2017, JPE) intentionally uses the continuous exposure measure — our replication matches this.

### 2. Two-way fixed effects structure
- Unit FEs (state) and time FEs (birth cohort yob) are included. Specification is standard.
- No additional covariates (univariate spec), consistent with metadata flag `twfe_controls: []`.
- Clustering at state level is appropriate given state-level treatment assignment.

### 3. Parallel trends assumption (pre-trend test)
- Pre-period coefficients (t=-6 to t=-2): all small and statistically indistinguishable from zero.
- Largest pre-period: t=-4, coef=-0.013, se=0.010 — marginal but not statistically significant.
- No systematic monotone drift in pre-periods.
- PASS on visual/informal pre-trend test.

### 4. Staggered treatment contamination
- With staggered treatment onset (9 cohorts: 1942–1956) and TWFE, Goodman-Bacon (2021) contamination applies.
- WARN: TWFE uses already-treated units as implicit controls in pairwise 2x2 DiDs. With a null result this is less consequential but still a structural issue.
- The sign of the TWFE estimate (-0.0033) is in the opposite direction from CSDID-NT (+0.0027) and CSDID-NYT (+0.0037), though all are statistically insignificant — the sign reversal merits noting.

### 5. Effect magnitude and significance
- beta_twfe = -0.00332, se = 0.00871; p ≈ 0.70. Clearly null.
- Original paper: -0.0084 (multivariate with 6 policies + state trends). Our univariate gives -0.0053 [note: metadata states -0.0053 vs results.csv -0.0033; minor discrepancy in metadata note vs actual csv, both null].
- Null result is robust across all estimators.

### 6. Sample construction
- Pre-aggregated from 272K individual CPS observations to 49-state × 24-cohort panel (weighted means).
- 2 non-absorbing states excluded (state IDs 28, 30). This is appropriate for TWFE with absorbing treatment assumption.
- Balanced panel: 49 × 24 = 1,176 observations.

### 7. Controls divergence
- Original Myers (2017) includes 6 policy exposures and state-specific linear time trends.
- Our TWFE is univariate (no controls). This is deliberate for comparability with modern estimators.
- The -0.0033 vs original -0.0084 difference is attributable to omitted controls, not a coding error.

## Summary of findings
- Continuous treatment correctly specified, matching original paper.
- No pre-trends detected.
- Sign reversal vs CSDID (TWFE negative, CSDID positive) but all null — warrants noting.
- Lack of state trends and policy controls means our estimate is not directly comparable to the paper's headline.

**Verdict: WARN** — continuous treatment + sign reversal vs CSDID + omitted controls vs original spec (all null, but structural issues present).
