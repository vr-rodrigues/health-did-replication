# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 254

**Article:** Gandhi et al. (2024) — The Effect of Medicaid Reimbursement Rates on Nursing Home Staffing
**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

---

## Applicability check

de Chaisemartin & D'Haultfoeuille (DCD) diagnostics are primarily designed for:
1. Non-absorbing treatment (treatment can switch on and off)
2. Continuous or multi-valued treatment with heterogeneous dose at adoption
3. Staggered adoption with heterogeneous timing (to detect "contaminated" 2x2 comparisons)

For article 254:
- Treatment is **absorbing binary** in the discretized version: high-Medicaid IL facilities are treated from Q3 2022 onward and do not switch off. This is a standard absorbing binary treatment.
- Treatment timing is **single** (all adopt simultaneously), so there is no staggered adoption contamination in the DCD sense.
- The paper's actual specification uses **continuous treatment** (Medicaid share × Illinois × post), but our stored estimate uses the discretized binary version.

**Result:** NOT_NEEDED. The DCD test for "contaminated cells" or "heterogeneous switching" is not needed for a single-adoption, absorbing binary treatment design. The main TWFE concern (continuous vs. binary treatment) is already flagged by the TWFE and CS-DID reviewers.

Note: If the paper's continuous treatment specification were directly replicated, DCD's extension to continuous treatments (de Chaisemartin & D'Haultfoeuille 2020b) could in principle be applied, but this is beyond the scope of the current reanalysis framework.

---

**Verdict: NOT_NEEDED** — Standard absorbing binary single-adoption design; DCD diagnostic does not add diagnostic value beyond what TWFE and CS-NT already provide.
