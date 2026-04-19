# CS-DID Reviewer Report — Article 305 (Brodeur & Yousaf 2020)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Sample construction
- CS-DID requires a balanced panel to avoid segfault. The aroundms-filtered sample causes extreme imbalance (3111 fips with varying observation windows) that causes att_gt() to crash.
- Fix applied: use all 2613 fips with full 24-year coverage (2486 never-treated + 127 treated), WITHOUT the aroundms filter.
- **Concern:** This is a significant departure from the paper's sample specification. The 127 treated counties in the CS-DID sample vs 173 in TWFE represents a 27% reduction in treated units. Counties that only appear in narrow windows around their shooting (i.e., those excluded by the balanced-panel requirement) may have systematically different treatment effects.

### 2. ATT estimates
- CS-NT simple: -1.276 (SE=0.708) — consistent with TWFE -1.348
- CS-NYT simple: -1.257 (SE=0.693) — consistent
- CS-NT dynamic: -0.923 (SE=1.090)
- CS-NYT dynamic: -0.910 (SE=1.013)
- The simple and dynamic aggregations differ (simple more negative), suggesting cohort-time heterogeneity in the aggregation.
- Direction and order of magnitude are consistent with TWFE (with div×year FEs). This is a positive signal.

### 3. Pre-trends in CS-DID event study
- CS-NT pre-periods: t-6=+2.630 (SE=0.730), t-5=+1.704 (SE=0.653), t-4=+1.368 (SE=0.568), t-3=+0.519 (SE=0.450), t-2=+0.012 (SE=0.345)
- CS-NYT shows virtually identical pattern.
- **Critical concern:** Pre-trends are large and statistically distinguishable from zero at t-5 and t-6. The t-6 coefficient (+2.63) is larger than the treatment effect itself (-1.49 at t=5). This pattern suggests that counties hit by mass shootings were experiencing employment GROWTH relative to controls before the shooting — which raises concerns about selection into treatment or common trend violations.
- These pre-trends are LARGER in magnitude than those in the TWFE (div×year FEs spec), suggesting that controlling for division×year trends is important but CS-DID on the balanced panel (without those controls) cannot replicate that absorption.
- Note: CS-controls were not run (cs_controls=[]), so division×year trends are not absorbed in CS-DID.

### 4. Control group
- Never-treated control group: 2486 counties (large and credible).
- Not-yet-treated also shows similar results, suggesting the CS-DID is not driven by 2x2 DiD between late-treated and early-treated units.

### 5. Cohort-time heterogeneity
- With staggered adoption from 2000-2013, there are multiple cohorts. The convergence of CS-NT and CS-NYT estimates suggests limited contamination from forbidden comparisons.

## Verdict rationale
WARN because: the large pre-trends in CS-DID event study (t-5: +1.70, t-6: +2.63) represent a genuine parallel trends concern that is not resolved by the CS-DID methodology itself. The ATT point estimates are consistent with TWFE, but the pre-trend pattern undermines confidence in the identifying assumption. The sample deviation (127 vs 173 treated) adds further uncertainty.

## Links
Full data: `results/by_article/305/event_study_data.csv`, `results/by_article/305/results.csv`
