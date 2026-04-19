# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 525
# Danzer & Zyska (2023) — Pensions and Fertility: Microeconomic Evidence

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

---

## Applicability assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is most relevant when:
- Treatment is non-absorbing (units can switch in and out)
- Treatment is continuous or has heterogeneous dose at adoption
- The design involves staggered adoption with potential treatment effect heterogeneity that contaminates TWFE

For article 525:
- **Treatment timing**: single (all treated units adopt treatment in 1992)
- **Treatment type**: absorbing binary (rural workers become eligible for pension benefit permanently)
- **Staggered adoption**: none — all treated units receive treatment simultaneously
- **Dose heterogeneity**: none — the pension reform applies uniformly to all eligible rural workers

The design is a clean 2×2 DiD: one treatment group (rural workers), one control group (urban workers), one treatment date (1992). The de Chaisemartin & D'Haultfoeuille estimator was designed to address TWFE heterogeneity bias arising from staggered adoption or treatment switching. With a single cohort and absorbing binary treatment, these concerns do not arise.

Specifically:
1. **No contamination from "forbidden comparisons"**: With one cohort, there are no already-treated vs. newly-treated comparisons that would bias TWFE.
2. **No non-absorbing treatment concern**: Rural workers' eligibility is permanent after 1992.
3. **No continuous treatment concern**: The reform is a binary eligibility change.

The FWL theorem guarantees that TWFE in this 2×2 case recovers the population-weighted average treatment effect, which is identical to the CS-DID ATT in the limiting case of a single cohort.

**Verdict: NOT_NEEDED** — Standard absorbing-binary single-cohort design. The TWFE estimand is well-defined and uncontaminated. The de Chaisemartin estimator provides no additional diagnostic value over CS-DID NT in this setting.
