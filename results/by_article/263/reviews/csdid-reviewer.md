# CS-DID Reviewer Report — Article 263

**Article:** Axbard, Deng (2024) — "Informed Enforcement: Lessons from Pollution Monitoring in China"
**Reviewer:** csdid-reviewer
**Date:** 2026-04-18

**Verdict:** WARN

---

## Checklist

### 1. Group-time variable (gvar_CS)
- `gvar_CS = ifelse(min_dist_10 == 1, 21, 0)` — treated firms assigned to group 21 (first treated period), never-treated assigned 0.
- Single treatment date (time=21, Q1 2015) means there is only one ATT(g,t) group.
- **Status: PASS** — correct Callaway-Sant'Anna encoding for a single-timing design.

### 2. Comparison group: never-treated
- `run_csdid_nt = true`, `run_csdid_nyt = false`.
- With a single treatment date, never-treated is the appropriate and only feasible comparison group.
- Not-yet-treated comparison is inapplicable (no staggered adoption).
- **Status: PASS**

### 3. ATT estimates
- `att_csdid_nt = 0.002596` (SE = 0.003758)
- TWFE reference: 0.003328 (SE = 0.000556)
- Point estimate ratio: CS/TWFE = 0.78 — directionally consistent, same sign.
- SE ratio: 0.003758 / 0.000556 ≈ 6.8x wider for CS-NT.
- **Status: WARN** — extreme SE inflation (nearly 7x) means the CS-DID estimate is not statistically significant at conventional levels (t ≈ 0.69), whereas TWFE is highly significant (t ≈ 5.99). The confidence intervals largely overlap zero for CS-NT.

### 4. Root cause of SE inflation
- The paper's specification includes `industry^time` (~531 dummies) and `prov_id^time` (~21 dummies) as high-dimensional interacted FEs.
- CS-DID (`did` package) cannot directly absorb interacted FEs in the same way TWFE can via the Frisch-Waugh-Lovell theorem.
- As documented in metadata notes and Pattern 50: attempting to include 531 industry dummies as `xformla` controls causes overfitting (ATT collapses to 0); including 21 province dummies worsens SE further.
- The SE widening is structural, not a misspecification of the CS-DID setup per se.
- **Status: WARN (structural)** — this is a known Pattern 50 limitation, not a coding error.

### 5. Dynamic ATT (event study)
- CS-NT event study coefficients:
  - Pre-period (t=-5 to t=-2): all near-zero and insignificant (largest = 0.00058)
  - Post-period (t=0 to t=4): range 0.00059 to 0.00280, all with SEs of 0.003-0.005
  - All post-period estimates statistically indistinguishable from zero individually
- The dynamic pattern is directionally consistent with TWFE (positive, growing), but precision is insufficient to detect the effect.
- **Status: WARN** — CS dynamic estimates are directionally plausible but individually insignificant due to SE inflation.

### 6. Controls in CS-DID
- `cs_controls = []` — no controls (correct, matches baseline specification).
- `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"` — correctly skipped since there are no TWFE controls to replicate.
- **Status: PASS**

### 7. Comparison to SA and Gardner estimators
- Sun-Abraham (SA) estimates are nearly identical to TWFE: same pre-period coefficients, very similar post-period trajectory, similar SEs. This is expected for a single-timing design (SA is equivalent to TWFE when there is a single treatment date).
- Gardner (2SLS imputation) estimates are also directionally consistent: post-period range 0.00076 to 0.00392, smaller SEs than CS-NT.
- The convergence of TWFE, SA, and Gardner (but not CS-NT) is diagnostic: the SE widening in CS-NT is attributable to the FE structure mismatch, not to heterogeneous treatment effects.
- **Status: PASS (contextual)**

### 8. Aggregation
- With a single treatment date and never-treated comparison, the simple ATT and dynamic ATT are identical (both 0.002596 for att_nt_simple and att_nt_dynamic respectively, up to rounding differences in SE).
- This is expected behavior.
- **Status: PASS**

---

## Summary

The CS-DID implementation is correctly specified for a single-timing binary treatment. The central finding is that the ATT point estimate (0.0026) is directionally consistent with TWFE (0.0033) — a 22% difference — but CS-NT SEs are 7x wider due to the inability to accommodate the paper's high-dimensional industry×time and province×time FEs. This is a structural limitation (Pattern 50) rather than a methodological error. The CS-DID result neither confirms nor contradicts the TWFE result at conventional significance levels, but does not suggest the TWFE finding is spurious. The SA and Gardner estimators, which can better handle the FE structure, confirm the TWFE direction and magnitude.

**Verdict: WARN** (SE inflation 7x due to Pattern 50 FE structure mismatch; point estimates directionally consistent but CS-NT individually insignificant)
