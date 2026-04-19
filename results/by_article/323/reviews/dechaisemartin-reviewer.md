# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 323

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Article:** Prem, Vargas, Mejia (2023) — "The Rise and Persistence of Illegal Crops"

---

## Applicability assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator is primarily designed for:
1. Non-absorbing treatment (treatment can switch on and off)
2. Continuous or multi-valued treatment with heterogeneous dose at adoption
3. Complex staggered designs where the treatment path varies non-monotonically

Article 323 characteristics:
- **Treatment:** Binary indicator `treated = I(suitability > median)` — absorbing (municipalities do not change suitability category over time).
- **Timing:** Single treatment cohort (2014). Treatment is absorbed at adoption.
- **Structure:** Standard absorbing binary staggered (in fact, simpler: single cohort).

This is the canonical case where the de Chaisemartin estimator returns `NOT_NEEDED`: the standard CS-DID and TWFE estimands are well-defined, and the treatment path complications that motivate DCH do not apply.

---

## Design check

- No evidence of treatment switching (suitability is time-invariant in this dataset; municipalities cannot change from high to low suitability).
- No continuous dose heterogeneity in the binarized replication specification (though the original paper uses a continuous treatment, the replication uses binary high/low).
- The binarization actually moves the design further from DCH's focus (which is heterogeneous continuous dose) — the replication simplifies to a clean binary absorbing treatment.

**Verdict: NOT_NEEDED** — Standard absorbing binary single-cohort design. DCH estimator provides no additional information beyond CS-DID/TWFE in this case.
