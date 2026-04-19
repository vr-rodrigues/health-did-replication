# Paper fidelity audit: 60 — Schmitt (2018)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes + SKILL_profiler protocol: Table 2 Panel A, Column 2 (Post only, equation (2); All control group with control variables). This is the paper's headline specification: hospital and year FEs, 6 control variables (log case mix index, percent Medicaid, log beds, for-profit status, HHI, count of other system members), cluster SE by hospital, weighted by inpatient discharges, sample restricted to indirect==0. Matches Stata command in metadata notes exactly.

## Comparison

| Source | β | SE | N (obs) | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Panel A Col 2) | 0.070 | (0.018) | 39,080 | hospital | *** |
| Our stored results.csv | 0.07017 | (0.01715) | not stored | hospital | *** |
| Relative Δ | +0.25% | -4.70% | — | — | — |

## Notes

- Paper reports rounded to 3 decimal places (0.070); our stored value is 0.07017, difference is sub-rounding.
- SE divergence of -4.70% is within the 30% tolerance. Both use clustered SEs at the hospital level. Minor difference may arise from slight differences in software implementation (Stata areg vs R fixest feols), both cluster at hospital.
- N (observations=39,080; hospitals=2,943) is reported in the table but not stored in results.csv — no N comparison possible.
- The PDF is located at pdf/replicados/60.pdf (not pdf/60.pdf); applicability gate passed after verifying the file at its actual path.
- Column 2 is unambiguously the headline: it is the "all controls" version of the all-control-group specification, which the paper text references first and whose results drive the "6 to 7 percent" abstract claim.

## Verdict rationale

Our stored beta_twfe (0.07017) matches the paper's Table 2 Panel A Col 2 coefficient (0.070) to within 0.25%, which is below the 1% EXACT threshold; the SE divergence (-4.70%) is well within tolerance.
