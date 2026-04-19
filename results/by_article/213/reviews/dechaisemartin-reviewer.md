# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 213
**Estrada & Lombardi (2022) — Dismissal Protection, Bureaucratic Turnover**
**Date:** 2026-04-18

**Verdict:** NOT_NEEDED

## Applicability check
The de Chaisemartin & D'Haultfoeuille (DcDH) estimator is relevant when:
1. Treatment is non-absorbing (can switch off), OR
2. Treatment is continuous or has heterogeneous dose at adoption, OR
3. Design involves staggered adoption creating forbidden comparisons that DcDH explicitly corrects.

For article 213:
- Treatment is **absorbing**: permanent contract is granted once and not revoked.
- Treatment is **binary**: treated (3yr seniority group) vs. never-treated (2yr seniority group). No heterogeneous dose.
- Treatment timing is **single**: all treated units adopt simultaneously in 2014. No staggered adoption; no forbidden comparisons possible.
- Data structure is **RCS**: DcDH requires a panel structure to compute switcher-based weights.

## Conclusion
All three conditions for DcDH relevance are absent. The design is a standard absorbing binary single-timing DiD. With a single cohort, TWFE and CS-NT already recover the correct ATT without DcDH correction. This verdict was anticipated in the applicability assessment and is consistent with the standard absorbing binary staggered design exception.

DcDH is correctly not run. NOT_NEEDED.
