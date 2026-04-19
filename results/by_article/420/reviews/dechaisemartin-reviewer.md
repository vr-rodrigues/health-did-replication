# de Chaisemartin-D'Haultfoeuille Reviewer Report — Article 420

**Verdict: NOT_NEEDED**
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

---

## 1. Applicability Assessment

This reviewer is designed for designs where treatment is:
- Non-absorbing (units can switch in and out of treatment)
- Continuous treatment (dose-varying)
- Heterogeneous dose at adoption

### Assessment for Article 420

Bailey & Goodman-Bacon (2015) uses a standard **absorbing binary staggered treatment** design:
- Treatment = county receives Community Health Center (CHC) for the first time.
- Once a county receives a CHC (gvar_CS > 0), it remains treated. Absorption holds.
- Binary: treated or not (0/1 at county-year level).
- Dose heterogeneity: The paper does not model CHC dose intensity at the county level as the primary treatment. The treatment is binary (received CHC or not), with staggered timing.

There is no evidence of:
- Treatment reversal (deactivation of CHCs after opening).
- Continuous dose variation used as the primary estimand.
- Heterogeneous intensity of CHC adoption used as the main specification.

### Conclusion

The de Chaisemartin-D'Haultfoeuille (2020) estimator (DID_M, DID_l) is designed specifically for switching treatments or intensity variation. For the standard absorbing-binary-staggered design in this paper, the Callaway-Sant'Anna and Sun-Abraham approaches are the appropriate modern estimators. The de Chaisemartin framework does not add analytical value here beyond what CS and SA already provide.

**Verdict: NOT_NEEDED**

The design is a standard absorbing binary staggered rollout. DID_M/DID_l are not required. The relevant modern robustness checks (CS-NT, SA, Gardner, HonestDiD, Bacon) have been applied.
