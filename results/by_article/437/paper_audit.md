# Paper fidelity audit: 437 — Hausman (2014)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

Metadata `table_reference` field states "Table 6, Column 1 (personrem, no exposure normalization)." However, Table 6 in the paper is "State-Level Selection" (a robustness table with multiple state-exclusion rows); personrem appears as Column 4 there, not Column 1. The stored `original_result` values (β = -42.245, SE = 66.098) match **Table 3, Panel A, Column 4** (Collective worker radiation exposure, OLS, not normalized) exactly. The `table_reference` labeling in metadata contains an internal coding error — "Column 1" likely refers to the first OLS radiation column in the author's own ordering, not the literal printed column number. The audited number is Table 3, Panel A, Col 4 (personrem, OLS, facility + year FEs, N = 1,749, cluster by plant).

## Comparison

| Source | β | SE | N | Cluster | Sig |
|---|---|---|---|---|---|
| Paper (Table 3 Panel A Col 4) | −42.2 | (67.3) | 1,749 | Plant | none |
| Our stored results.csv | −42.2450 | 66.098 | 1,749 | facility_num | none |
| Relative Δ | −0.58% | −1.79% | | | |

## Notes

- The metadata `table_reference` says "Table 6, Column 1" but Table 6 is the state-level robustness table; personrem is Col 4 there, with varying coefficients by state exclusion row (−32.9 to −50.0). The stored original_result matches Table 3 Panel A Col 4, not any cell in Table 6.
- Paper reports SE = 67.3; our stored SE = 66.098. Relative difference = −1.79%, well within the 30% tolerance. The minor SE gap is consistent with differences in how facility FEs are specified (tab-generated dummies in Stata vs feols factor() in R) and the fractional `divested` treatment in the divestiture year.
- Paper text (p. 194) explicitly states: "For collective worker radiation exposure, divestiture is associated with a drop of 42 person-rems." This confirms the Table 3 Panel A number is the correct reference.
- Coefficient is statistically insignificant in both paper and our stored result (large SE relative to β).
- The paper's main headline results are Poisson/NB for count outcomes (Tables 3–5); the OLS personrem result is a secondary finding. Our TWFE pipeline correctly targets this secondary OLS specification as the only OLS-compatible outcome.

## Verdict rationale

Our stored β = −42.245 matches the paper's Table 3 Panel A Col 4 value of −42.2 with a relative difference of 0.58%, well within the 1% EXACT threshold, and signs agree.
