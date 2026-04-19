# de Chaisemartin & d'Haultfoeuille Reviewer Report — Article 21 (Buchmueller & Carey 2018)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

---

## Applicability assessment

The de Chaisemartin & d'Haultfoeuille (DChDH) estimator is primarily needed for:
- Non-absorbing (switching on/off) treatment
- Continuous or dose-varying treatment
- Heterogeneous dose at adoption

For article 21:
- Treatment (`mustaccess`) is **absorbing binary** — once a state adopts must-access PDMP, it does not repeal it within the study period.
- Treatment is not continuous or dose-varying; it is a clean 0/1 mandate indicator.
- No heterogeneous dose at adoption is documented.

This is a standard absorbing binary staggered adoption design. The DChDH estimator provides no additional methodological value beyond what CS-DID already provides for this design.

**Verdict: NOT_NEEDED** — standard absorbing binary staggered adoption; CS-DID is the appropriate modern estimator.

---

## Confirmation

The `gvar_CS` structure (0 for never-treated, specific halfyear for each adopting cohort) and the `evermustaccess` variable confirm that treatment is purely absorbing binary. No variation in treatment intensity within adopting states is present in the metadata specification.
