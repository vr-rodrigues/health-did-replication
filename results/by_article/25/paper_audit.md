# Paper fidelity audit: 25 — Carrillo, Feres (2019)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes and paper text: Table 2, Column 5 — "preferred specification that adjusts for all baseline controls." Outcome is total physicians per 1,000 residents (`physician_cpta`). Treatment is `Post × Treatment` (municipality-level DiD). Controls include all pre-MPP characteristics interacted with linear time trends, plus pre-MPP BHU physician rate, social spending, and state-specific linear time trends. Municipality and bimonth-by-year FEs included. SEs clustered at municipality level.

The paper explicitly labels Column 5 as the preferred specification in the text: "The estimated coefficient from our preferred specification that adjusts for all baseline controls is 0.116."

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 5) | 0.116 | (0.009) | 285,012 | municipality | *** |
| Our stored results.csv | 0.115942 | 0.008585 | — | municipality | *** |
| Relative Δ | -0.050% | -4.61% | | | |

## Notes

- Relative beta difference is 0.050%, well within the EXACT threshold of 1%.
- SE difference of -4.61% is within the 30% tolerance; the small divergence is consistent with minor numerical differences in clustering implementation between Stata (areg) and R (fixest::feols).
- N not stored in results.csv; paper reports 285,012 observations for Col 5.
- The paper reports SE to 3 decimal places (0.009); our value rounds to the same (0.009). The raw stored value (0.008585) rounds to 0.009, consistent.
- No unit/scale transformation needed; both paper and our estimate are in physicians per 1,000 residents.

## Verdict rationale

Our stored beta of 0.115942 differs from the paper's reported 0.116 by only 0.050%, which is well below the 1% EXACT threshold, with matching sign and significance level.
