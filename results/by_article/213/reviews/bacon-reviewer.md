# Bacon Decomposition Reviewer Report — Article 213
**Estrada & Lombardi (2022) — Dismissal Protection, Bureaucratic Turnover**
**Date:** 2026-04-18

**Verdict:** NOT_APPLICABLE

## Reason for non-applicability
Bacon decomposition requires staggered treatment adoption across units with variation in timing. Article 213 has:
- `treatment_timing = "single"`: all treated units adopt in 2014 simultaneously.
- `run_bacon = false` in metadata.
- Data structure is RCS (repeated cross-section), which further precludes Bacon's panel-based decomposition.

With a single cohort, the Bacon decomposition reduces to a single term: Treated vs. Never-Treated (TVU = 100%), which equals the TWFE estimate by construction. No forbidden comparisons (TVT = 0%). No decomposition is informative.

## Conclusion
Bacon is correctly not run. No staggered-timing heterogeneity concerns apply to this paper.
