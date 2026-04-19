# TWFE Reviewer Report: Article 333 — Clarke & Muhlrad (2021)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Design validity
- Single treated unit (estado=9, Mexico DF). Treatment is binary and absorbing (ILE law, March 2007, gvar_CS=207).
- 12 never-treated control states remain after `regressiveState==0` filter.
- N=2496 observations (13 states × 192 months, with some attrition from missing abortionRelated).
- No controls or additional FEs in the baseline specification (Table 2, Panel A, Col 1).
- With a single treated unit, TWFE is equivalent to a simple 2×2 DID — no heterogeneous treatment effect contamination is possible.

### 2. Pre-trend assessment (event study, 36 pre-periods)
- **WARN: Visible pre-trend violation.** Multiple pre-period coefficients are large and positive with apparent significance, particularly at t=-29 (+0.097), t=-31 (+0.076), t=-27 (+0.068), t=-32 (+0.060), t=-23 (+0.056), t=-17 (+0.062), t=-19 (+0.072).
- The pre-treatment path is not flat around zero. Coefficients fluctuate substantially and several early pre-period estimates exceed post-period estimates in magnitude.
- This pattern raises concern about parallel trends assumption validity. It may reflect seasonal or structural differences between Mexico DF and control states rather than a common trend.
- The normalization at t=-1 (coef=0, SE=0) is standard.

### 3. Treatment timing
- Single adoption timing — no staggered adoption concern. Bacon decomposition not applicable.
- Treatment begins at time=207 (March 2007). The ILE indicator in the raw data turns on at time=205 (January 2007), but the paper centers the event study at t=207. The metadata notes this alignment and confirms gvar_CS=207 is correct per the paper's definition.

### 4. Point estimate fidelity
- beta_twfe = -0.0636 vs. paper's -0.064 (Table 2, Panel A, Col 1). Difference < 1%. Essentially exact.
- SE: our clustered SE = 0.0126 vs. paper's wild-bootstrap SE = 0.013. SE discrepancy is expected and noted in metadata.

### 5. Effect size and sign
- Effect is negative (reduction in abortion-related mortality), consistent with the paper's theoretical prediction that ILE (legal abortion access) reduces unsafe abortion mortality.
- Post-period coefficients become increasingly negative from t=24 onward, with some heterogeneity in the early post-period (t=0 to t=23 shows mixed signs).

### 6. Concerns flagged
- **WARN:** The pre-treatment coefficients show a non-flat pattern, suggesting potential parallel trends violation. With 36 pre-periods and a single treated unit, any pre-trend contamination directly undermines the causal interpretation.
- The ESW weights note in metadata that "ESW weights at L_36 are ~0 (uninformative: single treated unit with 73 event-time dummies causes severe multicollinearity in weight decomposition)." This limits weight-based diagnostics.
- Post-treatment heterogeneity: many post-period coefficients are near zero or positive in the first 2 years, with the negative effect accumulating later. This could reflect a delayed policy effect or mean-reversion.

## Summary
TWFE produces beta = -0.0636, matching the paper's -0.064. However, the event study pre-trends are visually concerning — multiple pre-period coefficients depart substantially from zero, raising doubt about the parallel trends assumption. Because there is only one treated unit, TWFE is otherwise methodologically clean (no decomposition contamination). The pre-trend issue is the primary concern.

**Full report saved to:** `reviews/twfe-reviewer.md`
