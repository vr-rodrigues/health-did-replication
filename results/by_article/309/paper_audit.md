# Paper fidelity audit: 309 — Johnson, Schwab, Koval (2024)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 2, Column 1 (TWFE with state+year FEs, aw=sh_emp1979, cluster state)"

Column 1 is the simplest and most parsimonious specification (state FE + year FE only, no division-year FE, no state trend, no additional controls beyond FEs). This matches the SKILL_profiler protocol (baseline / least-covariate column of the headline table).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | −0.137 | (0.046) | 1,077 | state | *** |
| Our stored results.csv | −0.13667 | 0.04608 | 1,077 | state | *** |
| Relative Δ | +0.24% | +0.17% | | | |

Relative Δ beta: (−0.13667 − (−0.137)) / |−0.137| = +0.33/137 ≈ +0.24%
Relative Δ SE: (0.04608 − 0.046) / 0.046 ≈ +0.17%

## Notes
- Paper reports β = −0.137 rounded to three decimal places; our stored value is −0.136670, consistent with rounding.
- SE reported as 0.046; our stored value is 0.046078, consistent with rounding.
- N = 1,077 state-year observations matches exactly.
- Cluster level is state (confirmed from Table 2 footnote: "robust standard errors clustered by state in parentheses").
- Analytic weights = sh_emp1979 (state employment share in 1979), confirmed in table note and metadata.
- Stars: *** (p < 0.01) in the paper; our estimate at SE ≈ 0.046 implies t ≈ −2.97, consistent with p < 0.01.
- No controls beyond state and year FEs in Column 1; metadata twfe_controls = [] confirms this.

## Verdict rationale
Our stored TWFE coefficient (−0.13667) differs from the paper's reported value (−0.137) by only 0.24%, well within the 1% EXACT threshold, with matching sign and significance.
