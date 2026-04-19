# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability Assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator is most relevant when:
- Treatment is non-absorbing (units can switch on and off), OR
- Treatment is continuous or has heterogeneous dose at adoption, OR
- Design has staggered timing creating heterogeneous-timing contamination in TWFE.

Article 335 design:
- Treatment is absorbing binary: provinces are classified as "high-mafia" (top tertile) permanently. This is a time-invariant characteristic interacted with a post-crisis indicator — once classified, always classified.
- Treatment is binary (not continuous): mafia_n3 = {0,1}, top-tertile indicator.
- Treatment timing is single (not staggered): all treatment occurs in 2007.
- No switchers-back, no movers, no dose heterogeneity.

**Result: NOT_NEEDED**

## Rationale
The de Chaisemartin–D'Haultfoeuille decomposition is designed to diagnose heterogeneous treatment effect contamination in TWFE arising from staggered timing and treatment effect heterogeneity across cohorts and periods. In this single-cohort, absorbing-binary design, TWFE is not susceptible to these pathologies. The standard 2×2 DiD interpretation applies fully. Running the DH estimator would produce results numerically identical to the standard CS-NT ATT, adding no analytical value.

The key TWFE robustness concerns for this paper lie elsewhere: (1) parallel trends assumption (addressed by HonestDiD), and (2) sensitivity of results to the never-treated comparison group (addressed by CS-DID). The DH estimator does not add a distinct diagnostic in this setting.
