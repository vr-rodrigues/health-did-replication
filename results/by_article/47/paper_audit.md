# Paper fidelity audit: 47 — Clemens (2015)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes + Table 5 of the paper: Table 5, Panel A, Column 1 — DiD estimate of community-rating regulation on private insurance coverage, stable-regulation states (Maine, New York, Vermont) vs. all non-community-rating control states, sample years 1987–1992 (pre) and 1996–1997 (post), restricted to households with at least one child and one full-time employed adult at a small firm (parentsmallfirm==1), excluding states MA, NJ, KY, NH (unstable regulators) and four excluded states (FIPS 25, 34, 21, 33). Outcome: `priv_ins_cov_supp`. Treatment variable: `Post_avg` (communityratingstate2 × post1). Controls: kid, kidlt2, kidlt6, femhead, black, poverty_percent, region×femhead, region×black, region×poverty_percent interactions, plus FEs for educ_category, workersB, ownershp, householdocc1990. Standard errors: block bootstrap, clusters at state level.

## Comparison

| Source | β | SE | N | Cluster | Sig |
|---|---|---|---|---|---|
| Paper (Table 5, Panel A, Col 1) | -0.0962 | (0.0206) | 127,554 | State (block bootstrap) | *** |
| Our stored results.csv | -0.09617 | 0.009738 | — | State (analytical) | — |
| Relative Δ | 0.03% | -52.7% | | | |

## Notes

- Beta match is essentially perfect: rel_diff = (-0.09617 − (−0.0962)) / 0.0962 = +0.03%. Well within the EXACT threshold of 1%.
- SE divergence is large (−52.7%), but this is expected: the paper uses a **block bootstrap** clustered at the state level (Bertrand, Duflo, Mullainathan 2004), while our stored SE uses analytical clustering via `fixest`. With only 3 treated states, block bootstrap SEs are typically much larger than analytical cluster-robust SEs. This does not affect the beta verdict.
- N = 127,554 is confirmed in Table 5 Panel A Col 1. Our results.csv does not separately store N for this specification, but the metadata notes document this exact match was achieved using the full 8-year sample (1987–1992, 1996–1997).
- The metadata `notes` field explicitly records "Round 4 EXACT MATCH" with the Stata replication code result of -0.0962, providing additional confirmation.
- No sign flip. Both paper and our estimate are negative and significant.

## Verdict rationale

Our stored beta (-0.09617) matches the paper's Table 5 Panel A Col 1 value (-0.0962) to within 0.03%, well inside the EXACT threshold; SE divergence reflects the paper's block bootstrap vs. our analytical cluster SE and does not affect the beta verdict.
