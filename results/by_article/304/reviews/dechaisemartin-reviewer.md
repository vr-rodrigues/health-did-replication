# de Chaisemartin & d'Haultfoeuille Reviewer Report — Article 304

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

---

## Applicability assessment

The de Chaisemartin & d'Haultfoeuille (2020) reviewer is relevant for:
- Non-absorbing treatment (treatment can be reversed or varied over time)
- Continuous or graded treatment (heterogeneous dose at adoption)
- Heterogeneous dose designs (some treated units get higher dose than others)

For article 304:
- Treatment (`cotton_dist`): binary, time-invariant covariate — a district either is or is not a cotton-producing district. **Absorbing by construction.**
- Treatment timing: **single** (all cotton districts become "treated" in 1861 simultaneously).
- Dose heterogeneity: none specified. The treatment is a binary indicator for being in the cotton-producing region affected by the 1861 Lancashire Cotton Famine.
- Periods: only 2 (1851, 1861). No within-treatment-period variation in treatment status is possible.

**Conclusion:** This is a textbook absorbing binary single-cohort DiD. The DChDH estimator is designed to decompose TWFE in the presence of heterogeneous treatment switching or continuous treatment. With a single absorbing binary treatment and a single post period, there is no decomposition to perform beyond the standard 2x2. The reviewer returns NOT_NEEDED.

**Verdict: NOT_NEEDED**
