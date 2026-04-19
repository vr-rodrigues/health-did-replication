# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 61 (Evans & Garthwaite 2014)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check
- Treatment: absorbing binary treatment. Once the EITC expansion occurred in 1995, affected units (2+-child households in states that adopted) remain treated. Treatment does not reverse.
- Timing: single cohort (1995). No staggered adoption.
- Dose: binary (treated = 2+ kids × post-1995). No heterogeneous continuous dose.

The de Chaisemartin & D'Haultfoeuille (2020) estimator (Chaisemartin-DiD) addresses two specific concerns: (1) heterogeneous treatment effects across staggered cohorts in TWFE and (2) non-absorbing or fuzzy treatments. Neither concern applies here.

- Single timing: no forbidden comparisons (treated vs. treated-earlier) possible.
- Absorbing binary treatment: no "switching off" contamination.
- Homogeneous cohort structure: all treated units share a single adoption date.

## Verdict rationale
NOT_NEEDED — standard absorbing binary single-timing design. TWFE negative-weighting due to staggered heterogeneity is not a concern. No action required.
