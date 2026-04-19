# Paper fidelity audit: 213 — Estrada & Lombardi (2022)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table 2, Col 1. Expected negative coefficient (dismissal protection reduces turnover)."

Table 2 is the headline results table: "Impact of high dismissal protection on teacher turnover." Column 1 reports the effect on "Not in same school after one year" — the primary turnover outcome corresponding to equation (1) in the paper. The coefficient of interest is Treated x Post.

Confirmed by Section 3.3 text: "As shown in column 1, it reduces the probability that the teacher leaves the school after one year by 3.7 percentage points."

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | -0.037 | (0.010) | 24,002 | teacher | *** |
| Our stored results.csv | -0.037180 | 0.010253 | 24,002 | teacher (clave) | *** |
| Relative Δ | -0.49% | +2.53% | — | — | — |

## Notes

- The paper reports the coefficient rounded to three decimal places (-0.037); our stored value is -0.037180, matching to four significant figures.
- SE divergence of 2.53% is negligible; both cluster at the teacher level.
- The paper's N of 24,002 is consistent with the metadata sample filter (`sample_turnover == 1 & age < 55`).
- No unit-of-measurement mismatch: both are in percentage-point (linear probability) terms.
- Column 4 (after two years, Not in same school) reports -0.067 (SE 0.012); our pipeline runs the one-year horizon as the headline per metadata notes — this is the correct choice.
- The paper's Table 2 also includes a "Treated" main effect row; our TWFE coefficient corresponds only to the Treated x Post interaction (beta_twfe = treated_post variable), which is the DiD estimand of interest.

## Verdict rationale

Our stored beta_twfe of -0.03718 differs from the paper's -0.037 by only 0.49% with matching sign and identical N (24,002), placing this firmly in the EXACT category.
