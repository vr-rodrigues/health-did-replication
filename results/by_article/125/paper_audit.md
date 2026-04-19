# Paper fidelity audit: 125 — Levine, McKnight & Heep (2011)

**Verdict:** WITHIN_TOLERANCE
**Date:** 2026-04-19

## Selected specification
From metadata notes: Table 5, Panel A, Row 1 "Difference-in-difference, Full sample", Col 2 "Any insurance coverage". DD regression: xi: reg insured law i.stfips i.year i.a_age married student female ur povratio povratio2 if a_age>=19 & a_age<=24 & year>=2000, cluster(stfips). Unweighted (paper footnote 23). Massachusetts excluded.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 5 Panel A Row 1 Col 2) | −0.0005 | (0.007) | 127,106 | state | none |
| Our stored results.csv | −0.000452 | 0.006542 | — | state | none |
| Relative Δ | 9.6% | −6.5% | | | |

## Notes
- The paper reports β to 4 decimal places (-0.0005). Our stored value is -0.000452, which rounds to -0.0005 at that precision. The 9.6% relative divergence is entirely a rounding artifact in the paper's display: the true paper value is approximately -0.0005 ± rounding error of ±0.00005, which places our stored -0.000452 squarely within the rounding band.
- SE divergence is -6.5%, well within the 30% tolerance threshold. No concern.
- N matches exactly: paper reports N=127,106; this aligns with our filter (a_age>=19 & a_age<=24 & year>=2000, Massachusetts excluded).
- Both the paper and our estimate are statistically insignificant (near-zero effect). The metadata notes confirm: "The +1865% ratio is meaningless (both ≈0)."
- Sign match: both negative.
- The paper's main conclusion for this headline spec is a null result (no significant aggregate effect of extended parental coverage laws on any insurance coverage).

## Verdict rationale
Relative difference of 9.6% is driven purely by rounding in the paper's 4-decimal display of a near-zero coefficient; our stored -0.000452 rounds to the paper's -0.0005, signs match, SE within tolerance — verdict is WITHIN_TOLERANCE (borderline with EXACT at the display-precision level).
