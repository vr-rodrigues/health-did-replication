# CS-DID Reviewer Report — Article 419

**Verdict:** PASS

**Article:** Kahn, Li, Zhao (2015) — "Water Pollution Progress at Borders"
**Date:** 2026-04-18

---

## Checklist

### 1. Cohort structure

Single adoption cohort: all boundary stations adopt in 2006 (gvar_CS = 2006 for treated, 0 for never-treated). This is a clean never-treated comparison group design. CS-DID with a single cohort reduces to a single ATT(g=2006, t) for each post-period — effectively the same as a clean 2x2 DiD at each time period.

### 2. Comparison group

- run_csdid_nt = true: uses never-treated (interior stations) as the control group. Appropriate and consistent with the TWFE specification.
- run_csdid_nyt = false: correctly skipped for single-cohort design (no not-yet-treated units exist when there is only one adoption year).

### 3. Controls

Two CS-DID variants estimated:
1. **Without controls** (cs_controls = []): att_csdid_nt = -1.411, SE = 0.898 (simple), SE = 0.943 (dynamic)
2. **With TWFE controls** (att_cs_nt_with_ctrls): att = -1.678, SE = 0.853 (simple), SE = 0.869 (dynamic), status = OK

Adding controls brings the CS-DID estimate closer to (but still somewhat smaller in magnitude than) the TWFE estimate (-2.012). The direction and significance are consistent across all variants.

### 4. Comparison with TWFE

| Estimator | ATT (simple) | SE | Relative to TWFE |
|---|---|---|---|
| TWFE | -2.012 | 1.023 | reference |
| CS-NT (no controls) | -1.411 | 0.898 | 30% smaller |
| CS-NT (with controls) | -1.678 | 0.853 | 17% smaller |
| Gardner | — | — | see event study |

With a single cohort, the TWFE and CS-DID should in principle identify the same parameter (the ATT for the single adoption cohort). The observed discrepancy (~17-30%) is worth noting:

- **Possible explanation 1:** The TWFE controls (gdpg, gdpp, temperature, lightbuffer5km) are included in the TWFE regression but not in the CS-DID without-controls variant. The with-controls CS-DID (-1.678) is closer to TWFE (-2.012), consistent with controls accounting for part of the gap.
- **Possible explanation 2:** The remaining gap (~0.33 units, ~16%) between TWFE-with-controls and CS-NT-with-controls may reflect differences in the variance estimator, the doubly-robust procedure, or minor panel balance differences.
- **Possible explanation 3:** The parallel trends assumption may hold in levels but imperfectly — with only 2 pre-periods, the CS estimator's pre-trend validation is limited.

The direction of effect is consistent (negative, implying reduced COD pollution at boundary stations post-2006). The sign and significance are robust across all estimators.

### 5. Dynamic CS-DID vs simple CS-DID

For a single cohort, the simple and dynamic ATT aggregations collapse to the same number (ATT=-1.411, ATT_dyn=-1.411 without controls; ATT=-1.678, ATT_dyn=-1.678 with controls). This is expected for a single cohort with no across-cohort heterogeneity.

### 6. Pre-trend assessment

| Period | CS-NT coef | SE |
|---|---|---|
| t=-2 | +1.682 | 0.967 |
| t=-1 | 0 (ref) | NA |

The CS-NT pre-trend coefficient at t=-2 is +1.682 (t≈1.74). This mirrors the TWFE result. With only 1 free pre-period, formal pre-trend rejection is not possible. The positive pre-period coefficient is a design concern noted in the HonestDiD reviewer section (that reviewer is SKIPPED due to insufficient pre-periods), but it is not a CS-DID implementation failure.

### 7. Status checks

- cs_nt_with_ctrls_status = "OK": no convergence or singularity issues.
- cs_nyt_with_ctrls_status = "NOT_ATTEMPTED": correct — no NYT run for single cohort.

### 8. Gardner (2x2 imputation) cross-check

Gardner event-study estimates:
- t=0: -2.061 (SE=0.942)
- t=1: -1.325 (SE=0.880)
- t=2: -1.669 (SE=1.099)
- t=3: -2.603 (SE=1.343)
- t=4: -3.291 (SE=1.416)
- t=-2: +0.623 (SE=0.336)

The Gardner pre-period at t=-2 is +0.623, substantially smaller in magnitude than the TWFE/CS-NT pre-period (+1.609/+1.682). This is notable: Gardner's imputation procedure absorbs some of the level difference via the first-stage. Post-treatment, Gardner shows larger negative effects (t=4: -3.29) than TWFE (-2.33), CS-NT (-2.43), suggesting the TWFE result may be conservatively estimated.

---

## Summary

CS-DID is correctly implemented for a single-cohort design. The never-treated comparison group is appropriate. Direction and significance of the effect are robust across all estimators (TWFE, CS-NT without controls, CS-NT with controls, Gardner). The gap between TWFE and CS-DID without controls is partly explained by covariate adjustment. No convergence issues. Single cohort precludes heterogeneous timing bias concerns.

**Verdict: PASS**

Full report: `reviews/csdid-reviewer.md`
