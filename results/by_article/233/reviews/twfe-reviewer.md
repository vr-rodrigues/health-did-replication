# TWFE Review: 233 — Kresch (2020)

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** twfe-reviewer

## Specification

- Estimator: `feols(invest_total ~ muni_companyxlaw + [14 controls] | code + year, cluster = ~company)`
- Sample filter: `balance2001 == 1` (12-year balanced panel, 1,346 municipalities)
- Treatment variable: `muni_companyxlaw` = Local scope × (year > 2005) — binary, absorbing, single cohort
- Outcome: total water/sanitation investment (BRL thousands)
- β = 2,868.317, SE = 1,254.260, t ≈ 2.29 (significant at ~5%)

## Checklist

### 1. Design: staggered vs single-cohort
- Single-cohort (all Local municipalities treated in 2006). No heterogeneous timing contamination. TWFE = ATT in this design assuming parallel trends. No negative-weighting concern from staggered adoption. **PASS**

### 2. Treatment variable construction
- `muni_companyxlaw` is correctly constructed as the product of time-invariant `first_scope == "Local"` and `year > 2005`. Units that change scope over time use their first observed scope, which is the appropriate time-invariant assignment. **PASS**

### 3. Pre-trend visual inspection (event study)
Event study coefficients (omitted: t=-1):

| Period | β | SE | t-stat |
|--------|---|-----|--------|
| t=-5 | 387.5 | 673.5 | 0.58 |
| t=-4 | 455.1 | 611.5 | 0.74 |
| t=-3 | 714.6 | 433.7 | 1.65 |
| t=-2 | 599.0 | 364.3 | 1.64 |

Pre-period estimates are consistently positive and trend upward from t=-4 onward. While none is individually significant at 5%, the pattern suggests a pre-existing upward trend in treated relative to control units before the 2006 reform. This is consistent with the "slight pre-trend drift" noted in metadata. **WARN — pre-trend concern**

### 4. Controls specification
- 14 controls including `baseinvestTT` (baseline investment level × time trend). This Heckman-Hotz control is appropriate and standard for absorbing pre-treatment level heterogeneity interacted with time trends.
- Controls are time-varying economic covariates (population, GDP, taxes, agricultural variables, climate). All appear conceptually pre-determined or slowly-moving. **PASS**

### 5. Clustering
- Cluster: `company` variable (code for Local municipalities; state-level aggregated code for Regional municipalities). This matches the paper's 149 WS-company clusters. The clustering strategy correctly accounts for correlated errors within water/sanitation concession areas. **PASS**

### 6. Fixed effects
- Unit FE (code) + Year FE (year). Standard two-way specification. **PASS**

### 7. Parallel trends plausibility
- The pre-trend pattern (consistently positive pre-period coefficients of 400–715 BRL thousands) combined with a large post-treatment jump to ~1,500–5,600 suggests the pre-trend drift is non-trivial relative to the effect size. The HonestDiD analysis confirms fragility at Mbar=0.5 for the "first post-period" target. **WARN**

## Summary

The TWFE specification is correctly implemented and matches the paper exactly (β diverges by 0.01%). The design is single-cohort so no negative-weighting concern from staggered adoption. The main concern is a pre-trend pattern: pre-period estimates are uniformly positive (400–715 BRL) suggesting treated municipalities were already on a rising investment trajectory before the 2006 law. This pre-trend is non-trivial relative to the first post-period effect (~1,500 BRL). The HonestDiD sensitivity confirms the first-period estimate becomes fragile at Mbar=0.5.

**Verdict: WARN** (pre-trend pattern; specification otherwise clean)
