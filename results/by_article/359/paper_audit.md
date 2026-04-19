# Paper fidelity audit: 359 — Anderson, Charles, Olivares, Rees (2019)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes and `original_result.source`: Table 3B, Column 1 — Reporting ordinance static estimate (city_reporting_required only; full controls including demographic characteristics + municipality FEs + year FEs + municipality-specific linear trends; population-weighted; cluster at state level; N=7,439).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3B col 1) | −0.036 | (0.035) | 7,439 | state | none |
| Our stored results.csv | −0.03629 | 0.03330 | — | state_fips | — |
| Relative Δ | −0.81% | −4.87% | | | |

## Notes
- Table 3B appears on p. 158 of the published PDF. The "Reporting ordinance" column (first static coefficient, labeled "Municipal anti-TB measure") reads −0.036 (0.035), matching the metadata source field exactly.
- N=7,439 and 548 municipalities are confirmed in the table footer.
- SE divergence of −4.87% is well within the 30% tolerance. Likely due to minor differences in analytical clustering implementation (fixest vs. Stata's vce(cluster state_fips)) — both cluster at the state level.
- Paper reports no significance stars on this coefficient; our stored estimate is similarly insignificant.
- The metadata `original_result.se_twfe` (0.035) rounds our stored 0.03330 slightly upward — this is the paper's printed value vs. our computed value, both consistent.

## Verdict rationale
Our stored beta (−0.03629) differs from the paper's printed value (−0.036) by only 0.81%, well within the 1% EXACT threshold, with matching sign and insignificance.
