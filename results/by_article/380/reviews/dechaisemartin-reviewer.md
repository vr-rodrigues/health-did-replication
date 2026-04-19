# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 380
## Kuziemko, Meckel & Rossin-Slater (2018)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

---

## 1. Treatment Design Assessment

The paper studies the Texas Medicaid Managed Care (MMC) rollout. The treatment design is:

- **Treatment variable:** Binary indicator (`after`) for whether a county has been enrolled in MMC
- **Adoption pattern:** Staggered across counties (7 cohorts, 1993-2006)
- **Absorbing?** Yes — once a county is enrolled in MMC, it remains enrolled (irreversible policy adoption)
- **Continuous treatment?** No — binary enrollment
- **Heterogeneous dose at adoption?** No — all counties adopt under the same managed care mandate structure; there is no variation in intensity at adoption

---

## 2. Applicability of de Chaisemartin & D'Haultfoeuille (2020)

The `did_multiplegt` estimator (de Chaisemartin & D'Haultfoeuille 2020) is designed for settings where:
- Treatment can switch on AND off (non-absorbing), OR
- Treatment is continuous with changing levels over time, OR  
- There is meaningful variation in treatment dose across units or time periods

None of these conditions apply here. The Texas MMC rollout is a standard absorbing binary staggered DiD design. The Callaway-Sant'Anna and Sun-Abraham estimators (already reviewed) are the appropriate modern alternatives for this design.

---

## 3. Verdict Rationale

**NOT_NEEDED**: The de Chaisemartin & D'Haultfoeuille estimator is not required for this standard absorbing binary staggered design. CS-DID and SA adequately address the heterogeneous-effects concern for this treatment structure.

---

*No additional data files required for this assessment.*
