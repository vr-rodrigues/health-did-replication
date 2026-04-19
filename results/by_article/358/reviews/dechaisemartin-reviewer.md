# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 358
## Bargain, Boutin, Champeaux (2019)

**Verdict:** NOT_NEEDED

**Date:** 2026-04-18

---

## Applicability assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`DID_M`) and its associated negative-weight diagnostics are designed to address:
1. Treatment effect heterogeneity across time and groups in staggered adoption designs.
2. Non-absorbing or continuously-varying treatment intensity.
3. Designs where TWFE weights can be negative, making the TWFE estimate a weighted average with negative weights on some group-period ATTs.

**This paper has none of those features:**
- Treatment timing: single event (2011 Arab Spring shock). All treated units adopt treatment at the same time.
- Treatment nature: binary, absorbing. Once a governorate is classified as "treated" (above-median protest intensity), it remains treated.
- Data structure: two periods only (2008 pre, 2014 post). With two periods and a single cohort, TWFE cannot produce negative weights — the Bacon decomposition would show 100% of weight on the single clean 2x2 comparison.
- No dose heterogeneity at adoption: treatment is classified as a binary above/below-median split, not a continuous intensity measure that varies post-adoption.

The `DID_M` estimator is not needed to validate or supplement the TWFE estimate in this setting. The canonical 2x2 DiD structure is immune to the negative-weight critique.

---

## Verdict

**NOT_NEEDED** — The design is a clean 2x2 DiD with a single treatment event. de Chaisemartin & D'Haultfoeuille concerns do not apply.
