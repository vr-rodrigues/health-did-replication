# CS-DID Reviewer Report — Article 311

**Verdict:** FAIL

**Reviewer:** csdid-reviewer
**Date:** 2026-04-18
**Article:** Galasso & Schankerman (2024) — Licensing Life-Saving Drugs for Developing Countries

---

## Checklist

### 1. CS-DID execution
- `run_csdid_nt = true` in metadata.
- Results from results.csv: `att_csdid_nt = NA`, `se_csdid_nt = NA`, `att_nt_simple = NA`, `att_nt_dynamic = NA`.
- **FAIL:** CS-DID (never-treated) did not produce a valid ATT estimate. All CS-DID output fields are NA.

### 2. Likely cause
- The notes field identifies: "Unbalanced panel (84.8% fill rate)." Despite `allow_unbalanced = false`, the panel has structural gaps — not every country×product pair is observed in every year. When the template attempts to balance the panel, the resulting balanced subset may be too sparse to estimate ATTs for all cohorts, or the `did` package may have encountered a numerical issue.
- With 6746 units, 14 years, 7 cohorts, and 84.8% fill, the balanced subset retains only those units observed in all 14 years — potentially a very small fraction of the original data.

### 3. CS-NT availability for HonestDiD
- The `honest_did_v3.csv` file contains a CS-NT row with non-NA values (att_avg = 0.644, se source = "diag_clustered"), suggesting CS-NT estimates *were* produced in the HonestDiD analysis (run separately), but the main results.csv records NA. This discrepancy suggests the CS estimation ran in one context but not another — possibly a different panel-balancing or subsetting step.

### 4. gvar_CS construction
- gvar_CS is constructed via preprocessing: units with MPP=1 get the minimum year of treatment; others get 0. This is correct Callaway-Sant'Anna convention.
- No controls (`cs_controls = []`), so the "unconditional parallel trends" assumption is invoked.

### 5. Impact
- Without a valid CS-DID ATT in results.csv, we cannot assess whether the TWFE estimate is contaminated by heterogeneous treatment effects. The primary robustness check is unavailable.

---

## Summary

CS-DID failed to produce valid ATT estimates in the main results pipeline (all NA in results.csv). This is a hard failure — it means the primary modern estimator meant to correct TWFE's staggered-adoption bias is not available for comparison. The likely cause is panel unbalancedness conflicting with the `allow_unbalanced = false` instruction. A CS-NT estimate does appear in the HonestDiD auxiliary analysis (~0.644), which is close to the TWFE estimate (0.663), but this is not formally recorded as a robust check.

**Verdict: FAIL** (CS-DID ATT is NA in results.csv; primary robustness estimator unavailable)
