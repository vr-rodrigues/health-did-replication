# CS-DID Reviewer Report — Article 359

**Article:** Anderson, Charles, Olivares, Rees (2019) — "Was the First Public Health Campaign Successful?"
**Reviewer:** csdid-reviewer
**Date:** 2026-04-18
**Verdict:** FAIL

---

## Checklist

### 1. CS-DID estimation completed
- CS-NT (never-treated control): ATT = +0.0175 (SE = 0.1012). **Sign reversal** relative to TWFE (-0.036). **WARN**
- CS-NYT (not-yet-treated control): ATT = +0.0182 (SE = 0.1036). Also positive. **Sign reversal**. **WARN**
- Both estimates are statistically indistinguishable from zero (t < 0.18).

### 2. Controls version
- `att_cs_nt_with_ctrls = 0`, `att_cs_nyt_with_ctrls = 0`, status = "OK".
- Zero point estimates with NA standard errors indicate the controls version **did not converge or returned a degenerate result**. This is consistent with the repeated cross-section structure making covariate conditioning in the CS-DID framework problematic (CS-DID requires panel or clustered repeated cross-section with stable covariates). **FAIL**

### 3. Event study sign and direction
- CS-NT post-period coefficients: t=0: -0.029, t=1: +0.003, t=2: +0.014, t=3: +0.014, t=4: +0.019, t=5: +0.017.
- After an initial small negative effect at adoption, subsequent periods show small positive (or zero) effects — the opposite direction from TWFE.
- CS-NYT post-period: t=0: -0.030, t=1: +0.002, t=2: +0.012, t=3: +0.014, t=4: +0.020, t=5: +0.018.
- Pattern is nearly identical — cohort-group ATTs are positive in most post-periods.

### 4. Pre-trend assessment (CS-DID)
- CS-NT pre-periods: t=-6: -0.013, t=-5: -0.022, t=-4: -0.006, t=-3: +0.021, t=-2: +0.003.
- Pre-trends are small and non-monotonic — much better parallel trends support than TWFE.
- This suggests TWFE's positive pre-trend was partly driven by compositional issues in the staggered design, not true differential pre-trends. **PASS**

### 5. Sign divergence interpretation
- TWFE: -0.036 (negative, TB reduced). CS-NT: +0.018 (positive, TB increased). CS-NYT: +0.018 (same).
- This is a **substantive sign reversal** — the direction of the headline policy conclusion changes.
- The TWFE estimate appears biased negative (toward finding an effect) due to heterogeneous treatment effects combined with negative weights in the Bacon decomposition.
- The Gardner/BJS event study (-0.051 at t=0, growing to -0.060 at t=5) partially contradicts the CS sign reversal, suggesting cohort-group weighting drives the divergence.

### 6. Precision
- CS-DID standard errors (SE ≈ 0.10) are 3x larger than TWFE (SE = 0.033). This is expected with only 42 state clusters and 91 treated cities spread across 16 cohorts — many cohort-group cells are sparse.
- None of the CS estimates are significant at any conventional level.

---

## Summary

The CS-DID estimates deliver a **sign reversal** relative to TWFE: both NT and NYT variants show a positive (or zero) ATT where TWFE shows a negative effect. Controls-augmented CS-DID failed to converge (returns 0 with NA SEs), likely due to data structure incompatibility (repeated cross-section with time-varying covariates). CS pre-trends are flat, suggesting TWFE's apparent pre-trend was an artifact of staggered aggregation. The policy conclusion is genuinely ambiguous: anti-TB reporting mandates show no robust negative effect on TB mortality in the CS framework.

**Verdict: FAIL** — Sign reversal from TWFE, controls version degenerate, policy conclusion reverses direction.

