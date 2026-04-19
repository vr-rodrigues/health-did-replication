# Paper fidelity audit: 305 — Brodeur, Yousaf (2020)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes + paper text (p. 116, col. 3 discussion): **Table 2, Column 3** — 100*Log employment per capita; county FE + year FE + Division x Year FE; treatment = "successful" (Post-Treatment dummy); aroundms==1 sample; cluster at county (fips); N = 70,823.

The paper explicitly states on p. 116: *"Our preferred specification includes Census divisions x year fixed effects (columns 3, 6, and 9)."* Column 3 (ln_emp_pop, Division x Year FE) is therefore the headline per the SKILL_profiler "preferred" tier.

Note: The metadata `original_result` field documents Column 1 (beta = -2.658, plain county + year FE), which is the most parsimonious spec. However, because the paper explicitly designates Column 3 as "preferred," SKILL_profiler hierarchy elevates Column 3 to the headline for audit purposes. Our stored beta_twfe = -1.348 corresponds to Column 3, not Column 1.

## Comparison

| Source | β | SE | N | Cluster | Sig |
|---|---|---|---|---|---|
| Paper (Table 2, Col 3) | -1.348 | (0.523) | 70,823 | fips (county) | *** |
| Our stored results.csv | -1.34792 | 0.52295 | 70,823 | fips (county) | *** |
| Relative Δ | 0.006% | -0.010% | | | |

## Notes

- The paper's Table 2 presents nine columns across three outcomes (100*Log employment p.c., 100*Log real earnings p.c., 100*Log establishments p.c.) and three FE structures (county+year; county+year+Region×Year; county+year+Division×Year). Column 3 is the preferred spec for the primary outcome (employment per capita).
- Column 1 (beta = -2.658, SE = 0.533) is documented in metadata `original_result` but is not the preferred spec. Including Division × Year FEs is the paper's preferred approach because it absorbs division-specific economic cycles, eliminating spurious pre-trends visible in the Column 1 event study.
- SE convention: clustered at the county (fips) level, as documented in both the paper's Table 2 notes and our metadata. No discrepancy.
- N = 70,823 county-year observations (counties with a mass shooting + all other counties; ±6 years around shootings for treated counties, all years for others).
- The match is essentially numerical identity (< 0.01% divergence on both β and SE), indicating our template reproduces the exact Stata/R reghdfe estimate.

## Verdict rationale

Our stored beta_twfe (-1.34792) differs from the paper's preferred Table 2 Col 3 estimate (-1.348) by only 0.006%, well within the EXACT threshold of 1%; SE divergence is also negligible (0.010%). The specification — county + year FEs + Division×Year FEs, outcome = 100*ln(employment/population), treatment = Post-Treatment dummy, sample = aroundms==1, cluster = fips — is reproduced exactly.
