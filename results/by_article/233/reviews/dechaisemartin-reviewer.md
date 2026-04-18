# de Chaisemartin Review: 233 — Kresch (2020)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

## Applicability assessment

Treatment design: `muni_companyxlaw` = Local × (year > 2005). This is:
- Binary (0/1)
- Absorbing (once treated in 2006, always treated — law is permanent)
- Single cohort (all Local municipalities treated simultaneously in 2006)
- No dose heterogeneity at adoption
- No treatment reversal

de Chaisemartin-D'Haultfoeuille (DH) estimators are designed to handle:
1. Non-absorbing (switching on and off) treatment — NOT applicable here
2. Continuous or heterogeneous-dose treatment — NOT applicable here
3. Multi-period staggered designs with heterogeneous timing — NOT applicable here (single cohort)

## Conclusion

For a binary absorbing single-cohort treatment, the DH estimator collapses to the same two-group DiD as CS-DID and TWFE (under the respective assumptions). Running `did_multiplegt` or `did_multiplegt_dyn` on this design would return results equivalent to CS-NT by construction. No additional identification concerns that CS-DID does not already address.

**Verdict: NOT_NEEDED** — Design is absorbing binary single-cohort. CS-DID (already reviewed) is the appropriate robust estimator for this design.
