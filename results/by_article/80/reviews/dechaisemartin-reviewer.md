# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 80

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

---

## Applicability assessment

The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt` / `DIDmultiplegt`) targets designs where treatment is:
- Non-absorbing (units can enter and exit treatment), OR
- Continuous or heterogeneous dose, OR
- Staggered with heterogeneous adoption.

### Design characteristics of Article 80
- Treatment: absorbing binary (cities receive the voucher program in 2008 and remain treated).
- Treatment timing: single cohort (all treated cities adopt in 2008 simultaneously).
- Heterogeneous dose: None documented. Treatment is binary (received voucher program or not).
- Non-absorbing: No evidence of treatment reversal.

### Verdict
This is a standard absorbing-binary single-cohort design. The de Chaisemartin estimator addresses negative weights arising from heterogeneous treatment effects in **staggered** timing designs, or from treatment switching. Neither concern applies here because:
1. Single timing removes the "forbidden comparison" problem that motivates the DCM estimator in staggered designs.
2. Binary absorbing treatment removes the continuous/non-absorbing motivation.

**NOT_NEEDED.** The TWFE estimator in a single-cohort binary design is equivalent to a simple DiD and does not suffer from the heterogeneous-timing negative-weight problem that DCM addresses.

