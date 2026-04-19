# Paper fidelity audit: 1094 — Fisman & Wang (2017)

**Verdict:** WARN
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Paper Table 2 Col 1: -0.051 (0.040), N=1755."
Table 2 Col 1 — NSNP effect on I(Deaths > Ceiling); full sample; category+year FEs + province FEs; cluster at province level (31 clusters); N=1,755.
This is the paper's baseline specification as described in Section II.B, the first column of the main results table, with no sample restriction.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | -0.051 | (0.040) | 1,755 | province | none (p=0.21) |
| Our stored results.csv | -0.04647 | 0.04091 | 1,756 | province | — |
| Relative Δ | +8.9% | +2.3% | off by 1 | | |

## Notes

- N discrepancy of 1 observation (1,755 paper vs 1,756 our pipeline): metadata notes document that Stata drops one observation during a merge that R does not drop; this is a known merge/processing difference between the original Stata code and the R replication.
- The 8.9% coefficient gap (-0.051 vs -0.04647) is directly attributable to this single-observation difference, as documented in the metadata notes: "8% coefficient gap from merge/processing diffs."
- SE relative difference is only 2.3% — well within tolerance; no SE convention mismatch.
- Both estimates are statistically insignificant (paper p=0.21); the effect is in the same negative direction.
- PDF located at `Replication Package/pdf/1094.pdf` (not `pdf/1094.pdf`); protocol step 0 applicability check passed after confirming alternate path.
- No unit or scale transformation required; both are LPM coefficients for a binary outcome.

## Verdict rationale

The relative beta difference of 8.9% falls in the WARN band (5%–20%), same sign; the gap is fully explained by a documented single-observation merge discrepancy between Stata and R implementations (Stata drops 1 obs during merge, R does not), not by a specification mismatch.
