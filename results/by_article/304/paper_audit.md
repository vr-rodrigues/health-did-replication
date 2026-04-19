# Paper fidelity audit: 304 — Arthi, Beach & Hanlon (2022)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Column 1 baseline — no controls." This maps to Table 2 (Baseline Effects of the Shortage Using Linked Data), Column 1, AEJ:Applied Economics 2022, 14(2): 228–255. Column 1 is the simplest specification (no district controls), with district and period fixed effects, weighted by district population, clustering at the district level.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | 2.194 | (0.463) | 1,076 | district | n/a (perm. p=0.119) |
| Our stored results.csv | 2.19350 | 0.46350 | — | unit_id (district) | — |
| Relative Δ | −0.02% | +0.11% | | | |

## Notes
- The paper reports conventional SE-based t-stat ≈ 4.74 (highly significant), but the permutation test p-value = 0.119. No stars are printed in Table 2; the table uses permutation p-values at the bottom instead of conventional significance stars. This is not relevant to the fidelity check.
- N = 1,076 observations = 538 districts × 2 periods. The metadata documents 538 districts correctly.
- SE in the paper (0.463) rounds to three decimal places; our stored value is 0.46350, matching to four significant figures.
- No controls are included in this specification; metadata `twfe_controls: []` correctly reflects this.
- The paper's DV is deaths per 1,000 individuals per year (MORT/POP × 1,000, adjusted for linking rate). Our pipeline uses `census_mr_tot` which is the pre-scaled rate variable — consistent with the paper's outcome.

## Verdict rationale
Our stored beta (2.19350) matches the paper's Table 2 Column 1 value (2.194) to within 0.02% relative difference, well inside the 1% EXACT threshold; sign agreement confirmed.
