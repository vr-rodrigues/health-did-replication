# Bacon Decomposition Reviewer Report: Article 234 — Myers (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability check
- treatment_timing: staggered — YES
- data_structure: panel — YES
- allow_unbalanced: false (main spec) — YES
- APPLICABLE.

## Checklist

### 1. Decomposition completeness
Bacon components from bacon.csv:

| Type | Pairs | Weighted estimate (approx) |
|---|---|---|
| Treated vs Untreated | 5 pairs | Dominant weight |
| Earlier vs Later Treated | 12 pairs | Smaller weights |
| Later vs Earlier Treated | 5 pairs | Smallest weights |

- "Treated vs Untreated" weight: ~0.88 (sum of weights: 0.435+0.114+0.099+0.078+0.158 = 0.884). This is the dominant component — PASS (desirable; clean comparison).
- "Earlier vs Later Treated" + "Later vs Earlier Treated" combined weight: ~0.116.

### 2. Contamination from already-treated controls
- Later vs Earlier Treated pairs have small positive weights (sum ≈ 0.005).
- Earlier vs Later Treated pairs have mixed-sign estimates and small weights (sum ≈ 0.111).
- The contaminated 2x2 DiD share (~11.6%) is modest but non-trivial.

### 3. Sign patterns in contaminated comparisons
- Earlier vs Later Treated estimates: mostly positive (+0.057, +0.023, +0.039, +0.013, ...).
- Treated vs Untreated: 3 negative, 2 positive.
- The overall TWFE (-0.0033) is pulled toward zero/negative by negative T-vs-U estimates (cohort 1957: -0.0265; cohort 1956: -0.0304), despite positive contaminated comparisons.
- The sign reversal (TWFE negative, CSDID positive) is thus partially explained by the T-vs-U pairwise 2x2s showing negative estimates for early cohorts.

### 4. Forbidden comparisons assessment
- Cohort 1957 (weight: 0.434) has the largest weight in T-vs-U. Its estimate is -0.0265 and dominates the TWFE.
- Cohort 1958 (weight: 0.114): estimate -0.0062.
- These are the late-treated cohorts, which have short post-periods in the panel (1935-1958 range). Short post-periods reduce precision and can introduce bias.
- WARN: The late-treated cohort 1957 dominates the Bacon decomposition (43% weight) and drives the TWFE estimate negative, while earlier cohorts and CSDID suggest near-zero or positive effects.

### 5. Treatment effect heterogeneity signal
- Bacon estimates across T-vs-U pairs range from -0.030 to +0.034 — wide variation.
- Earlier vs Later estimates range -0.023 to +0.057.
- This heterogeneity is consistent with the null aggregate result but indicates that treatment effects vary substantially across cohorts and comparison groups.
- With all estimates well within noise (each individual 2x2 is imprecise), heterogeneity cannot be confirmed statistically.

### 6. Continuous treatment caveat
- WARN: Bacon decomposition is derived for binary treatment. Here, treatment `epillconsent18` is continuous (0–1 fractional). The decomposition has been applied but the theoretical justification assumes binary switching. The weights and estimates should be interpreted with this caveat.

## Summary
- Clean comparison (T-vs-U) dominates at 88% weight — generally favorable.
- Cohort 1957 (43% of total weight) drives a negative TWFE point estimate, explaining the sign divergence from CSDID.
- Contaminated comparisons are modest (12%) but mixed-sign.
- Continuous treatment makes Bacon decomposition technically approximate.

**Verdict: WARN** — late-treated cohort dominance (43% from cohort 1957) explains TWFE sign, and continuous treatment makes the decomposition technically approximate.
