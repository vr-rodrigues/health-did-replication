# Paper fidelity audit: 233 — Kresch (2020)

**Verdict:** EXACT
**Date:** 2026-04-18

## Selected specification
From metadata notes: "Table 3 Col 1 (invest_total/1000). reghdfe invest_total muni_companyxlaw controls if balance2001==1, absorb(code year) vce(cluster company)."
Paper location: Table 3 ("WS Investment"), column 1 "Total investment", row "Self-run company, post-reform" (page 390).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 1) | 2,868 | (1,319) | 14,460 | WS company (149 clusters) | not reported |
| Our stored results.csv | 2,868.317 | 1,254.260 | 14,460 (implied) | company (metadata) | — |
| Relative Δ | +0.01% | -4.91% | — | — | — |

## Notes
- Paper reports investment in thousand reals; metadata confirms preprocessing `invest_total / 1000`, so units match exactly.
- Paper cluster is "WS company level" with 149 clusters; our cluster variable `company` uses `code` for Local municipalities and state-level aggregated codes for Regional, consistent with the paper's construct.
- SE differs by ~4.9%, well within the 30% leniency band for SE convention differences (likely minor degrees-of-freedom / small-sample correction differences between Stata's `reghdfe ... vce(cluster ...)` and R's `fixest::feols`). Not a flag.
- Paper does not print significance stars on this coefficient in Table 3 (only SE in parentheses).
- No ambiguity: Table 3 Col 1 is explicitly named in metadata and matches the paper's headline specification (§IV.A Empirical Results, "Table 3 presents the regression results using the difference-in-differences specification outlined in Section III").

## Verdict rationale
Point estimate matches the paper to within 0.02% (2,868.317 vs 2,868); SE diverges by <5% (well within tolerance for Stata/R clustering differences). Full numerical reproduction of the headline TWFE.
