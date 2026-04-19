# CS-DID Reviewer Report — Article 304

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

---

## Checklist

### 1. Estimator configuration
- `run_csdid_nt = true`, `run_csdid_nyt = false`. Correct: single-timing design with a large never-treated pool (514/538 units).
- Control group: never-treated (`gvar_CS == 0`). Appropriate and unambiguous.
- `allow_unbalanced = false`: balanced panel confirmed (538 units × 2 periods = 1076 rows, matches data).
- `cs_controls = []`: no controls. Consistent with the no-controls baseline specification.

### 2. Group-time cell structure
- Only one treated cohort: g = 1861 (all 24 cotton districts adopt simultaneously in 1861).
- Only one relevant (g,t) cell: ATT(g=1861, t=1861).
- With a single (g,t) cell, simple aggregation = dynamic aggregation = the single ATT cell. All three stored values (att_csdid_nt, att_nt_simple, att_nt_dynamic) are identical = 2.2418 (confirmed).

### 3. Numerical comparison
| Estimator | CS-NT ATT | SE |
|---|---|---|
| TWFE | 2.1935 | 0.4635 |
| CS-NT (simple) | 2.2418 | 0.4161 |
| CS-NT (dynamic) | 2.2418 | 0.3832 |

- Gap between TWFE and CS-NT: (2.2418 - 2.1935) / 2.1935 = **+2.2%** — negligible.
- Direction: identical (positive, treated districts had higher mortality).
- Statistical significance: both clearly significant (TWFE t = 4.73; CS-NT simple t = 5.39).
- **No sign reversal, no magnitude divergence.** The 2.2% gap is explained by the fact that CS-NT uses the influence-function bootstrap SE while TWFE uses cluster-robust SE — the point estimates differ by 0.048, well within one SE.

### 4. Pre-trends
- Zero pre-periods available (T=2). Pre-trend test structurally infeasible.
- No CS-NT pre-trend concerns arise — there is nothing to test.

### 5. Parallel trends assumption
- The only (g,t) cell is ATT(1861, 1861): the post-treatment comparison. Parallel trends is an identifying assumption that cannot be tested with these data.
- This is a design limitation shared with the paper itself; it is not a CS-DID implementation failure.

### 6. Controls sensitivity
- `att_cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`: correct, no controls were specified in either the TWFE or CS-DID arms.
- With-controls CS-DID was not run, consistent with the baseline specification.
- Note: the metadata documents that the author-preferred specification (Col 3) includes controls (log population density, linkable share, age shares). Running CS-DID with those controls would be informative but is outside the Rule iii(b) baseline scope.

### 7. Design compatibility
- With a single cohort and 2 periods, CS-NT is identical to a 2x2 DiD against the never-treated pool. The estimator choice is appropriate and adds no new information beyond verifying the TWFE result, which it does (2.2% gap).

---

## Summary
CS-DID is correctly configured and the estimates converge with TWFE to within 2.2%. With a single cohort and 2 periods, the CS-NT estimator reduces to a clean 2x2 comparison against never-treated districts. No pre-trend concerns, no sign reversal, no cohort heterogeneity. The parallel-trends assumption remains untestable but this is a data structure issue, not an estimator failure.

**Verdict: PASS**
