# de Chaisemartin Reviewer Report: Article 281 — Steffens, Pereda (2025)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is designed for:
1. Non-absorbing treatment (units can switch in/out of treatment).
2. Continuous treatment or heterogeneous dose at adoption.
3. Staggered adoption where the researcher wants an alternative to CS-DID.

**This paper's design:**
- Treatment is binary and absorbing: states adopted the smoking ban and did not reverse it within the study window.
- Treatment timing is effectively single (only 2009 cohort retained in the analytic sample; other timing cohorts excluded).
- Treatment intensity is uniform (all 2009-treated states receive the same policy).
- No evidence of non-absorption or dose heterogeneity in the metadata.

**Conclusion:** The de Chaisemartin estimator adds no diagnostic value here. The standard absorbing-binary-single-timing design is already handled correctly by TWFE + CS-DID (never-treated). This reviewer's verdict is NOT_NEEDED per the applicability rule.

## Additional note
If the full (non-filtered) dataset were analyzed — including the 2008, 2010, and 2011 treatment cohorts — then a staggered design would exist and de Chaisemartin would be more relevant. The current analytic choice to isolate the 2009 cohort against never-treated controls is methodologically defensible and sidesteps heterogeneous treatment timing issues.

Full metadata: `data/metadata/281.json`
