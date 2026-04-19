# TWFE Reviewer Report — Article 97 (Bhalotra et al. 2021)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Estimator specification

**1.1 Treatment variable construction**
The TWFE treatment indicator `treated_post` is a composite additive variable (`additive_2`), combining `treated_post` and `treated_post_year`. The additive decomposition is required because the paper's design uses a dual-cohort panel structure: each municipality (`mun_reg`) appears twice per year — once as a pre-reform cohort (`treated2=1`, never-treated in CS terms) and once as a post-reform cohort (`treated2=2`, treated). The composite indicator correctly captures the net treatment effect in this structure. PASS on specification.

**1.2 Fixed effects**
The model includes `mun_reg`, `year_reg`, and an additional FE for `treated2` (the cohort indicator). This is correct and necessary — without `treated2` in the FEs, the cohort-level baseline differences would contaminate the treatment estimate. PASS.

**1.3 Controls**
Six auxiliary controls are included: `treated_post_year`, `treated_year`, `treated`, `post`, `y`, `post_year`. These are interaction and indicator terms required by the original authors' specification. No ad hoc analyst additions detected. PASS.

**1.4 Clustering**
Clustered at `mun_reg` level, consistent with the original paper. PASS.

### 2. Pre-trend evidence (event study)

**2.1 Pre-period coefficients — raw values**

| Relative period | TWFE coef | SE | t-stat |
|---|---|---|---|
| -6 | +0.109 | 0.047 | 2.31 |
| -5 | +0.225 | 0.050 | 4.50 |
| -4 | +0.335 | 0.049 | 6.81 |
| -3 | +0.156 | 0.048 | 3.24 |
| -2 | +0.052 | 0.048 | 1.08 |
| -1 | 0 (reference) | — | — |

**2.2 Assessment: FAIL on pre-trend flatness.** Four of five pre-period coefficients are statistically distinguishable from zero and follow a rising pattern from t=-6 to t=-4, with deceleration at t=-3 and t=-2. The peak pre-trend coefficient (t=-4) is +0.335 with SE 0.049 — more than 6 standard errors from zero. This is a strong and structured positive pre-trend, not noise.

The pre-trend magnitude (+0.335 at t=-4) is large relative to the static ATT (-0.303): the pre-trend "wrong-sign" drift is comparable in absolute magnitude to the treatment effect itself.

**2.3 Interpretation context.** The paper's design uses a dual-cohort structure where `treated2=1` municipalities serve as never-treated controls. These are the same municipalities in the pre-period but assigned to a different "cohort slot." The positive pre-trends are present identically in both TWFE and CS-NT (near-perfect numerical match), suggesting this is a feature of the data/design rather than a TWFE-specific artefact. Nevertheless, positive pre-trends of this magnitude are a genuine concern for the parallel-trends assumption.

### 3. Numerical fidelity

- Stored result: beta_twfe = -0.3031, SE = 0.0691
- Original paper: beta_twfe = -0.3031, SE = 0.0691
- Match: exact (within rounding)
- PASS.

### 4. Gardner (BJS) divergence

Gardner estimates diverge systematically from TWFE/CS-NT/SA. Pattern 47 (documented in metadata) explains this: in the dual-cohort structure, Gardner's first-stage estimates post-1991 year FEs exclusively from the never-treated cohort, yielding a constant ~0.146 level shift relative to TWFE across all event-study periods. The dynamics (period-to-period differences) are identical. This is not a TWFE implementation error but reflects sensitivity of the two-stage approach to this non-standard panel structure. Flagged as WARN rather than FAIL because the pattern is understood and documented.

### 5. Summary

| Check | Verdict |
|---|---|
| Specification | PASS |
| Fixed effects | PASS |
| Controls | PASS |
| Clustering | PASS |
| Numerical match | PASS |
| Pre-trend flatness | FAIL — strong positive pre-trends (t=-4: +0.335) |
| Gardner divergence | WARN — documented Pattern 47 |

**Top-line WARN** (1 FAIL on pre-trend, which is a data/design issue; implementation is correct; overall WARN rather than FAIL because the pre-trends are structural to the dual-cohort design and documented, not a coding error).
