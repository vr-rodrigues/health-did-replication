# de Chaisemartin-D'Haultfoeuille Reviewer Report: Article 262

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Article:** Anderson, Charles, Rees (2020) — Hospital Desegregation & Black Postneonatal Mortality

---

## Applicability Assessment

The de Chaisemartin-D'Haultfoeuille (CDH) estimator is most valuable when:
1. Treatment is non-absorbing (units can enter and exit treatment), OR
2. Treatment is continuous/has heterogeneous dose, OR
3. Treatment has heterogeneous dose at adoption

**Assessment for Article 262:**
- Treatment variable: `medicare` — binary indicator of Medicare certification
- Treatment mechanism: Hospital desegregation via Medicare certification. Once a county's hospitals are certified, they remain certified. Treatment is **absorbing** (counties do not lose certification).
- Treatment is binary, not continuous.
- There is no heterogeneous dose — certification is an all-or-nothing county-level event.

This is a **standard absorbing binary staggered adoption design**. The CDH estimator's additional diagnostics do not add value beyond CS-DID for this design type.

The Callaway-Sant'Anna estimator (already run) is the appropriate robust alternative for this design, and it directly addresses the same heterogeneous treatment effects concern that CDH addresses.

---

## Conclusion

No negative weight diagnostics are needed beyond the Bacon decomposition (already reviewed). The CDH `de_chaisemartin` estimator would return results numerically equivalent to or noisier than CS-DID for this absorbing binary design.

**Verdict: NOT_NEEDED** — Standard absorbing binary staggered design. CS-DID fully addresses heterogeneous treatment effects concern. CDH diagnostic not required.
