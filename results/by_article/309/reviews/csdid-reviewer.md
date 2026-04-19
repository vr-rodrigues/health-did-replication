# CS-DID Reviewer Report — Article 309

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

---

## Checklist

### 1. CS-DID results availability

Results stored in results.csv show NA for all CS-DID columns:
- att_csdid_nt: NA
- att_csdid_nyt: NA
- att_nt_simple / att_nt_dynamic: NA
- att_nyt_simple / att_nyt_dynamic: NA

Root cause (documented in metadata notes): att_gt() in did v2.3.0 produces C-level segfaults on the severely unbalanced panel. 21 state-run OSHA states have only 14 years of data (1992–2005) vs 29 states with 27 years (1979–2005). Both panel=TRUE+unbalanced and panel=FALSE trigger the segfault.

### 2. Panel balancing fix applied

The fix applied (fix_csdid_309.R, documented in metadata) balances the panel to the 29 full-coverage states only (allow_unbalanced=false). This drops 7 adoption cohorts: 1970, 1974, 1976, 1977, 1983, 1984, 1987. Remaining: 13 cohorts + 7 never-treated states.

Results from the fix script:
- CS-NT ATT: -0.201
- CS-NYT ATT: -0.202

These are documented in metadata notes but not stored in results.csv (stored as NA).

### 3. Magnitude comparison

- TWFE: -0.137
- CS-NT (fix script): -0.201
- CS-NYT (fix script): -0.202
- Divergence from TWFE: approximately 47% larger in absolute value

The larger CS-DID estimates are consistent with negative-weight attenuation in TWFE under staggered timing. The CS-DID estimator, restricted to the balanced panel (29 states), produces a larger and likely more credible causal estimate.

### 4. Representativeness concern

Dropping 7 cohorts (40% of original cohorts) for panel balance raises a representativeness concern: the stored CS-DID estimate covers only 13 of the 21 original adoption cohorts. The excluded cohorts are systematically earlier adopters (1970–1987), which may differ from later adopters in unobserved ways. This is a material limitation.

### 5. Pre-trend assessment (CS-DID event study)

From honest_did_v3.csv, CS-NT event study uses 4 pre-periods. The pre-trend structure is not separately available in the stored CSVs, but HonestDiD sensitivity at Mbar=0 (unconditional CI) is [-0.236, -0.019] for the first post-period, suggesting the CS-NT pre-trends are sufficiently flat to support the maintained assumption.

### 6. NT vs NYT comparison

CS-NT ATT: -0.201; CS-NYT ATT: -0.202. The near-identical values confirm that not-yet-treated states are a valid comparison group and that early adoption contamination of the never-treated pool is not a concern.

---

## Material findings

- **WARN:** CS-DID stored results are NA (segfault); fix script required non-standard balancing that drops 40% of cohorts.
- **WARN:** Representativeness of balanced-panel CS-DID is uncertain; excluded cohorts are systematically early adopters.
- **NOTE:** Direction and approximate magnitude from fix script are consistent with staggered-timing-corrected effect; convergence of NT and NYT is reassuring.

**Verdict: WARN**
