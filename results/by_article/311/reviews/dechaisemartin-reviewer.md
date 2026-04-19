# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 311

**Verdict:** NOT_NEEDED

**Reviewer:** dechaisemartin-reviewer
**Date:** 2026-04-18
**Article:** Galasso & Schankerman (2024) — Licensing Life-Saving Drugs for Developing Countries

---

## Applicability check
- Treatment is absorbing binary staggered (MPP membership: once a country-product pair joins the Medicines Patent Pool, it does not exit).
- Treatment is binary, not continuous or dose-heterogeneous.
- No evidence of treatment reversals in the data description.
- Standard absorbing-binary-staggered design.

**Verdict: NOT_NEEDED** — The de Chaisemartin & D'Haultfoeuille (2020) `did_multiplegt` estimator is designed primarily for non-absorbing, multi-valued, or continuous treatments where units can switch treatment status multiple times or receive varying doses. For a clean absorbing binary staggered design, CS-DID (Callaway-Sant'Anna) already addresses the heterogeneous-treatment-effects concern with equal or superior efficiency.

---

## Notes
- If treatment were reversible (countries exiting MPP), `did_multiplegt` would be warranted. The paper's context (Medicines Patent Pool licensing is a persistent policy) makes reversal unlikely.
- This verdict is consistent with the expectation in the Skeptic protocol that standard absorbing-binary-staggered designs return NOT_NEEDED quickly.
