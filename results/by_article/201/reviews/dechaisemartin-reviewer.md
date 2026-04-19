# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 201 (Maclean & Pabilonia 2025)

**Verdict:** NOT_NEEDED

**Date:** 2026-04-18

## Applicability check
The de Chaisemartin & D'Haultfoeuille (2020) estimator (DID_M) is most valuable when:
- Treatment is non-absorbing (units can move in and out of treatment)
- Treatment is continuous or has a heterogeneous dose at adoption
- The design departs from standard binary absorbing staggered rollout

For article 201:
- **Treatment:** pslm_state_lag2 — binary indicator for whether a state has an active paid sick leave mandate (lagged 2 years). Once a state adopts a PSL mandate, it does not repeal it (absorbing binary treatment, per standard PSL policy design).
- **Structure:** 10 treated states, 34 never-treated states, 6 cohorts (2014, 2017, 2018, 2019, 2020, 2022). Standard absorbing staggered rollout.
- **Dose heterogeneity:** PSL mandates vary in days offered (7 days is standard), but the paper treats all mandates as equivalent binary indicators (pslm_state_lag2). No dose heterogeneity is modeled.
- **No switchers-back:** States do not repeal PSL mandates in the study period.

## Assessment
This is a canonical absorbing binary staggered adoption design. The de Chaisemartin estimator adds no diagnostic value beyond what Callaway-Sant'Anna already provides. The relevant heterogeneous treatment effects bias is already addressed by CS-DID and Gardner (did2s).

**Note:** There is a subtlety — the 2-year lag means a state "switches on" in pslm_state_lag2 two years after actual mandate adoption. This creates the COVID-contamination concern for the 2018 cohort (activates 2020), but this is captured by the Bacon decomposition and CS-DID, not by de Chaisemartin.

## Conclusion
NOT_NEEDED: Standard binary absorbing staggered design. No dose heterogeneity, no switchers-back. Callaway-Sant'Anna (CS-NT) already provides the appropriate estimator for this design.
