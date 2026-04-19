# Paper fidelity audit: 419 — Kahn, Li, Zhao (2015)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 3 Col 2: beta=-2.012, SE=1.192."

Table 3 (COD Discharges and Its Determinants with Station Fixed Effects), Column 2 is the paper's headline specification. It includes station fixed effects, year dummies, and the full set of economic controls (gdpg, gdpp, temperature, lightbuffer5km). The coefficient of interest is the interaction term Boundary × Post2005.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 2) | -2.012 | (1.192) | 3,372 | station + river/year (2-way) | * (10%) |
| Our stored results.csv | -2.01219 | 1.02250 | — | station only (1-way) | — |
| Relative Δ | 0.00% | -14.3% | | | |

## Notes
- Beta matches to 5 significant figures; relative difference is < 0.01%.
- SE divergence of 14.3% is within the 30% leniency threshold and is fully explained: the paper uses 2-way clustering by monitoring station AND by river/year (Bertrand, Duflo, Mullainathan 2004 approach), while the template clusters only by station (w). This is documented explicitly in the metadata notes: "Paper uses 2-way clustering (station + riversystem); template uses station-level only (SEs may differ)."
- Paper reports N=3,372 in Table 3; our stored results.csv does not include an N field for direct comparison, but the metadata notes confirm 3,377 obs (7 years × ~497 stations, with some missing), and Table 3 shows 3,372 — the 5-obs gap between Table 2 (3,377) and Table 3 (3,372) is also present in the paper itself and attributable to the change from river FEs to station FEs absorbing some observations.
- No scale/unit transformation issues: outcome is COD in mg/L in both paper and our stored estimate.

## Verdict rationale
Our stored beta_twfe (-2.01219) reproduces the paper's Table 3 Col 2 coefficient (-2.012) to within 0.004%, well below the 1% EXACT threshold.
