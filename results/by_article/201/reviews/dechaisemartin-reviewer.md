# de Chaisemartin review: 201 — Maclean & Pabilonia (2025)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-19

## Applicability

- Treatment absorbing: YES (PSL adoption is absorbing; no state has repealed its mandate in the sample)
- Treatment binary: YES (pslm_state_lag2 is 0/1)
- Staggered: YES (6 cohorts: 2014, 2017, 2018, 2019, 2020, 2022)
- Reversible: NO
- Recommended for de Chaisemartin reanalysis: NO

This is a standard absorbing binary staggered design. CS-DID (Callaway–Sant'Anna) handles this design correctly and provides the appropriate estimands. de Chaisemartin's `did_multiplegt_dyn` adds no new identification power here: both frameworks estimate group×time ATT cells and aggregate them, with the difference being weighting (uniform vs size-proportional).

The paper's authors independently ran a Bacon decomposition and used Gardner (did2s) as their primary estimator precisely because they were aware of TWFE's heterogeneity concerns. Running `did_multiplegt_dyn` would reproduce approximately what CS-DID already provides, without informational gain.

## Expected informational gain

None over CS-DID in this absorbing binary staggered design. The principal source of TWFE bias here is COVID-contamination of Cohort 2020, which is already fully diagnosed by the Bacon decomposition and CS-NT's cohort-uniform weighting. de Chaisemartin's estimator would weight cohorts similarly to CS-DID and would not resolve the COVID confound.

## Critical issues

None. Design is within CS-DID scope.

## Recommendations

NOT_NEEDED. Focus diagnostic effort on the COVID contamination mechanism (Cohort 2020, pslm_state_lag2 = 1 throughout all of 2020 for 2018 PSL-adopting states) and whether the paper's sample restriction (excluding March 18–May 9, 2020 diary days) fully resolves the confound.
