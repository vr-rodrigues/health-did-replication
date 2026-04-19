# Paper fidelity audit: 201 — Maclean & Pabilonia (2025)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Paper's MAIN estimator is Gardner (did2s). TWFE is reported only in Appendix Table 10 as one of 5 alternative estimators. Appendix Table 10, row 'Two-way fixed effects difference-in-differences', outcome: primary childcare (carehh_k), all adults 22–59 with children in household, N=78,080, cluster at state, weighted by ATUS survey weights."

Per protocol Edge Case 2: the paper does not use TWFE as its main estimator; we compare against the TWFE row of Appendix Table 10, which is the only location in the paper where a standalone TWFE coefficient for the primary outcome is reported.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (App. Table 10, TWFE row) | 4.61 | (1.80) | 78,080 | state | ** |
| Our stored results.csv | 4.6086 | 1.7990 | 78,080 (implied) | state (fips) | ** |
| Relative Δ | -0.03% | -0.06% | | | |

## Notes

- The main text and all main tables (Tables 2–5) use the Gardner (2022) two-stage DID estimator; TWFE appears only in the robustness table (Appendix Table 10).
- Appendix Table 10 reports 5 estimators: Gardner (4.45**, SE 1.76), Borusyak et al. (7.96**, SE 3.64), Wooldridge (5.14***, SE 1.23), Stacked DiD (1.98, SE 3.31), and TWFE (4.61**, SE 1.80).
- Our stored beta_twfe = 4.60862 matches the paper's 4.61 to within 0.03% — essentially rounding to the displayed two-decimal precision.
- Our stored se_twfe = 1.79897 matches the paper's 1.80 to within 0.06%.
- Both the paper and our estimate use state-level clustering and ATUS survey weights (wt06).
- N=78,080 is consistent with the full sample (hh_child==1), matching Appendix Table 3 and Appendix Table 10.
- The 2026-04-19 CS-DID update (monthly panel=FALSE run) does not affect the TWFE estimate, which is unchanged.

## Verdict rationale

Our stored TWFE estimate (4.6086, SE 1.799) reproduces the paper's Appendix Table 10 TWFE value (4.61, SE 1.80) to within rounding precision (< 0.1% relative difference on both β and SE). Fidelity axis: F-HIGH (EXACT).
