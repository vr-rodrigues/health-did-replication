# Bacon Decomposition Reviewer Report — Article 305 (Brodeur & Yousaf 2020)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability
- treatment_timing: staggered — APPLICABLE
- data_structure: panel — APPLICABLE
- cs_allow_unbalanced: false — APPLICABLE

## Checklist

### 1. Design structure
- 173 treated counties with mass shootings between 2000-2013 (14 cohorts)
- ~2938 never-treated counties in the TWFE sample (aroundms filtered)
- Staggered adoption with binary absorbing treatment (post-shooting dummy)

### 2. Forbidden comparisons concern
- With 14 staggered cohorts (one per year 2000-2013), the Bacon decomposition will generate a large number of 2x2 DiD pairs:
  - Early-treated vs never-treated (clean)
  - Late-treated vs never-treated (clean)
  - Early-treated vs late-treated (potentially contaminated — "forbidden" if treatment effects are heterogeneous)
  - Late-treated vs early-treated (most problematic — uses already-treated as controls)
- The growing post-period treatment effects (ramp-up from -0.12 at t=0 to -1.79 at t=5) imply substantial treatment effect heterogeneity over time, making the "treated vs treated" comparisons likely to generate negative weights in the Bacon decomposition.

### 3. Weight distribution concern
- With 173 treated counties spread across 14 cohorts and ~2938 never-treated, the never-treated vs treated weight is likely dominant (given the large never-treated group).
- However, the ramp-up in treatment effects means timing-weighted 2x2 DiDs will be sensitive to which cohort is used as control.
- CS-NT simple (-1.276) vs CS-NT dynamic (-0.923) divergence suggests the simple aggregation is picking up later-cohort larger effects — consistent with Bacon-type heterogeneity.

### 4. TVT (treated vs treated) assessment
- No Bacon decomposition output file was found in the results directory (no bacon_decomp.csv). The Bacon decomposition was run but results not stored separately.
- Based on the design: 14 cohorts creates substantial TVT weight. With growing treatment effects, TVT 2x2 DiDs involving late-treated-as-control will tend to understate the treatment effect (already-treated controls have negative treatment effects, biasing the comparison negative or attenuating).
- The gap between TWFE (-1.348 with div×year FEs) and CS-NT simple (-1.276) is small (0.072 units), suggesting limited Bacon-type bias in the aggregate, but this masks potential within-decomposition heterogeneity.

### 5. aroundms filter and Bacon
- The aroundms filter creates an unbalanced comparison window between treated (8-16 years) and never-treated (24 years). This structural asymmetry affects which 2x2 DiDs are available and their timing, potentially systematically biasing the Bacon weights.

## Verdict rationale
WARN because: (1) 14 staggered cohorts create substantial TVT contamination potential; (2) growing treatment effects (time-heterogeneous) make the forbidden-comparison weights non-trivially negative; (3) the aroundms asymmetry contaminates the panel structure; (4) no stored Bacon weight output to quantify TVT share precisely. The aggregate estimate appears consistent across estimators, but the decomposition structure is methodologically concerning.

## Links
Full results: `results/by_article/305/results.csv`
