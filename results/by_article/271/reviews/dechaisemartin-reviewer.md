# de Chaisemartin Reviewer Report — Article 271

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

---

## 1. Treatment characterisation

- Treatment variable `d_dmaq23`: binary indicator = 1 iff `year >= 1966` AND district is thick/very-thick aquifer.
- Treatment is **absorbing**: once a district is treated (1966), it remains treated for all subsequent periods. No switching off.
- Treatment is **binary**: either 0 or 1. No continuous dose, no heterogeneous dose at adoption.
- Single treatment cohort: all treated units adopt simultaneously in 1966.

## 2. Applicability assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator is most valuable when:
- Treatment is non-absorbing (switches on and off), OR
- Treatment is continuous or has a heterogeneous dose at adoption, OR
- There are concerns about negative weights in TWFE from the above patterns.

None of these conditions apply here:
- Treatment is absorbing binary.
- Single cohort eliminates staggered-timing negative weight concerns.
- No dose heterogeneity.

## 3. Verdict rationale

This is a textbook absorbing binary single-cohort DiD design. The de Chaisemartin estimator adds no diagnostic value beyond what CS-DID and TWFE already provide. **NOT_NEEDED.**
