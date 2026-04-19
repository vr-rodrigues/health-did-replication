# de Chaisemartin Reviewer Report: Article 9 — Dranove et al. (2021)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

---

## Applicability assessment

De Chaisemartin & D'Haultfoeuille (2020) estimators (DCDH, FEct, etc.) are specifically designed for:
1. Non-absorbing treatment (units that switch in and out of treatment).
2. Continuous treatment or heterogeneous dose at adoption.
3. Cases where the "stayers" vs "switchers" decomposition reveals sign changes not visible in TWFE.

### Assessment for article 9:
- **Treatment type**: Binary absorbing treatment (state adopts Medicaid managed care and does not reverse).
- **Dose heterogeneity at adoption**: None — all treated states receive the same binary treatment indicator (`Post_avg`). The `gvar_CS` coding confirms a single adoption date per state with no dose variation.
- **Non-absorbing**: No reversal observed in the data (all L0:L9 indicators are monotonically consistent with a single adoption event).
- **Continuous treatment**: Not applicable — `lnpriceperpresc` is the outcome, not the treatment.

### Conclusion:
This is a standard absorbing binary staggered adoption design. The Callaway-Sant'Anna and Borusyak-Jaravel-Spiess estimators already handle heterogeneous timing in this setting correctly. De Chaisemartin estimators add no additional information beyond what CS-DID already provides for this design.

---

## Summary
This paper presents a canonical absorbing binary staggered DiD design with no dose heterogeneity, no treatment reversal, and no continuous intensity variation. The de Chaisemartin & D'Haultfoeuille family of estimators is not required and adds no diagnostic value beyond the CS-DID analysis already conducted.

**Verdict: NOT_NEEDED**
