# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 253 (Bancalari 2024)

**Verdict:** NOT_NEEDED

**Date:** 2026-04-18

## Applicability Assessment

The de Chaisemartin & D'Haultfoeuille estimator is intended primarily for:
1. Non-absorbing (switching) treatments
2. Continuous treatments
3. Heterogeneous-dose designs at adoption

**Assessment for article 253:**
- Treatment `D` is binary and absorbing: a district is treated (sewerage project initiated) and remains treated permanently. There is no evidence of dose variation within treated districts or de-adoption.
- Treatment is staggered across 11 cohorts but each cohort's adoption is a one-time, binary event.
- `twfe_controls=[]`: no time-varying controls that could create effective non-absorbing variation.

This is a standard absorbing-binary-staggered design. The de Chaisemartin & D'Haultfoeuille estimator (`did_multiplegt` or `did_multiplegt_dyn`) adds no information beyond what CS-DID provides for this design structure.

**Verdict: NOT_NEEDED** — Standard absorbing-binary-staggered design; CS-DID (both NT and NYT) is the appropriate robust estimator for this setting.

_No data required for this verdict._
