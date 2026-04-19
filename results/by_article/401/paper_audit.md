# Paper fidelity audit: 401 — Rossin-Slater (2017)

**Verdict:** WITHIN_TOLERANCE
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table 3 col 5 coefficient = -0.0281 (SE 0.0088) — includes state-specific linear time trends (tt_state_*) NOT replicated here; our estimate will be closer to col 4 (without trends)."

Table 3 — Effects of IHVPE on Parental Marriage: CPS-CSS 1994–2008, Column 5. Dependent variable: indicator for mother being married to child's biological father. All controls included: mother/child controls, year FEs, state FEs, state time-varying controls, child support law controls, state EITC implementation, AFDC/TANF implementation, and state-specific linear time trends. Observations = 36,241. Weighted by CPS person weights. Robust SEs clustered at the state level.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 col 5) | -0.0281 | (0.0088) | 36,241 | state | *** |
| Our stored results.csv | -0.028539 | 0.007566 | — | state | *** |
| Relative Δ | -1.56% | -14.0% | | | |

## Notes

- The metadata explicitly documents that col 5 is the headline spec (state-specific linear time trends included) but that our pipeline does NOT replicate those trends. Col 4 (without trends) is -0.0286 (SE 0.0076), which is even closer to our stored estimate. The 1.56% gap in beta is attributable to this known specification difference.
- SE divergence of -14.0% is within the 30% tolerance threshold. It likely reflects the exclusion of state-specific linear time trends from our model, which affects residual variance and hence the clustered SE.
- Our estimate (-0.02854) falls between col 4 (-0.0286) and col 5 (-0.0281) of Table 3, consistent with the documented partial implementation of the headline spec.
- N is not directly stored in results.csv for this article; the paper reports 36,241 for cols 3-5.
- Sign matches: both negative.
- The comparison is structurally imperfect because our template cannot include state-specific linear time trends, as documented in metadata notes. Given this known limitation, the 1.56% beta gap is well-explained.

## Verdict rationale

Our stored TWFE estimate (-0.02854) reproduces the paper's Table 3 col 5 headline coefficient (-0.0281) within 1.56%, a difference that is fully explained by the documented omission of state-specific linear time trends from our pipeline; the coefficient is within 0.4% of the col 4 value (-0.0286) which is the closest comparable spec we implement.
