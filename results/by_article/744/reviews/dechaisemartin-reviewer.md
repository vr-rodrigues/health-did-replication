# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 744

**Article:** Jayachandran, Lleras-Muney & Smith (2010) — "Modern Medicine and the 20th Century Decline in Mortality"
**Reviewer:** dechaisemartin-reviewer
**Date:** 2026-04-18
**Verdict:** NOT_NEEDED

---

## Applicability check

The de Chaisemartin & D'Haultfoeuille (DChDH) estimator is designed to handle:
1. Non-absorbing treatment (units can switch in and out of treatment)
2. Continuous or multi-valued treatment
3. Heterogeneous treatment doses at adoption

For article 744:
- `treatment_timing = "single"` — single adoption cohort, 1937
- Treatment variable `treatedXpost37` is binary (0/1) and absorbing — MMR disease is either treated (post-1937) or not; TB is never treated
- No dose heterogeneity: all MMR states receive the same treatment (availability of sulfa drugs nationally in 1937)
- No switching: once sulfa drugs became available, treatment status does not revert

This is a standard absorbing binary single-timing DiD design. The DChDH estimator's heterogeneity correction is not needed — there is only one group-time ATT to estimate (ATT(g=1937, t) for t≥1937), which CS-DID already recovers correctly.

**Verdict: NOT_NEEDED** — Standard absorbing binary single-cohort design. CS-DID with never-treated control is the appropriate estimator and has already been applied. No additional DChDH analysis required.
