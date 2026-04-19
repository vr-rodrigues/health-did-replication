# Skeptic report: 61 — Evans, Garthwaite (2014)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (N/A), dechaisemartin (NOT_NEEDED), paper-auditor (WARN)

## Executive summary

Evans & Garthwaite (2014) use a single-adoption DiD to estimate the effect of the 1995 EITC expansion on maternal self-reported health (excellent or very good), finding beta_twfe = 0.0095 (pp). The paper's identification strategy is conceptually sound for a single-timing design — no staggered heterogeneity bias, no forbidden comparisons, and the de Chaisemartin concerns are not triggered. However, two overlapping implementation problems reduce confidence in the stored estimate. First, the stored results.csv value (beta_twfe = 0.01032) reflects an incorrectly over-specified model that added fips + year two-way fixed effects that the Stata original does not include; the correct no-FE specification exactly reproduces the paper's 0.0095 but has not been written back to the CSV, producing an 8.8% fidelity divergence (F-MOD). Second, the CS-DID estimate (ATT = 0.0065) is 31–37% smaller than both the paper value and the stored TWFE, and the doubly-robust CS-DID with controls returned a degenerate zero — a numerical anomaly consistent with collinearity in the single-cohort RCS aggregation with symmetric controls. No event study is available (treatment is defined at the individual level, not the fips level), so HonestDiD sensitivity analysis is precluded. On balance: the paper's direction (positive EITC-health effect) is reproduced across TWFE and CS-DiD; the design is methodologically clean for a single-timing study; but the stored TWFE reflects a mis-specified model and the CS-DID control variant is degenerate. Users should not rely on the stored beta_twfe = 0.01032 — the correct figure is 0.00948, exactly matching the paper.

## Per-reviewer verdicts

### TWFE (WARN)
- Stored beta_twfe = 0.01032 reflects an over-specified model (template incorrectly added fips + year FEs that Stata does not use). Correct no-FE beta = 0.009483.
- The fix is documented in metadata notes (Round 3) but results.csv has not been updated.
- Treatment variable `dd_treatment` is an individual-level interaction (post x 2+kids), non-standard for TWFE — it pre-encodes all DiD variation, making unit/time FEs spurious.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- ATT_NT = 0.0065 (SE = 0.0138), 31–37% below TWFE; direction consistent, not statistically significant at conventional levels.
- Doubly-robust CS-DID with controls returned att_cs_nt_with_ctrls = 0 — a numerical anomaly (likely collinearity between RCS-aggregated controls and the single-cohort structure), not a genuine zero effect.
- Single-timing design means CS-DID offers no staggered-heterogeneity correction; its main value here is a parallel-trends robustness check, which cannot be fully assessed without pre-trend coefficients.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Single-timing, repeated cross-section. Bacon decomposition inapplicable.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (N/A)
- No event study available; treatment defined at individual level (kids > 1), not fips level. Pre-period coefficients cannot be estimated.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary single-timing design. No staggered cohorts, no dose heterogeneity, no treatment reversals. No concerns triggered.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (WARN)
- Stored beta = 0.01032 vs paper beta = 0.0095: divergence = 8.8%, above 5% tolerance threshold.
- Root cause: documented specification error (spurious FEs); correct spec yields exact match.
- No PDF at pdf/61.pdf; fidelity assessed from metadata original_result field.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Rating decomposition

| Axis | Score | Basis |
|---|---|---|
| Methodology | M-LOW | 2 WARNs (TWFE stored spec; CS-DID degenerate controls), 0 FAILs |
| Fidelity | F-MOD | paper-auditor WARN: 8.8% divergence, explainable |
| **Combined** | **LOW** | M-LOW x F-MOD |

## Material findings (sorted by severity)

- WARN — Stored results.csv contains beta_twfe = 0.01032 from a mis-specified model (spurious fips+year FEs). The correct no-FE spec reproduces 0.009483 exactly but has not been written to the CSV. All downstream analyses using this stored value are 8.8% overstated.
- WARN — att_cs_nt_with_ctrls = 0 is a degenerate numerical result (not a genuine zero effect). The doubly-robust CS-DID estimator collapsed under the RCS single-cohort context with control collinearity. This cell should be flagged as FAIL_NUMERICAL rather than "OK" in the status column.
- WARN — No event study is available, so parallel trends cannot be assessed post-hoc. This is a design-inherent limitation (individual-level treatment prevents fips-level pre-trends), not a remediable implementation error.
- NOTE — CS-DID ATT (0.0065) is 31% below TWFE correct value (0.0095): direction consistent but precision loss is substantial (SE 75% wider). The point estimate difference is not statistically distinguishable from the TWFE given large SEs.

## Recommended actions

- **Repo-custodian:** Re-run the TWFE specification without fips+year FEs (as documented in Round 3 notes) and overwrite results.csv with beta_twfe = 0.009483. The metadata notes contain the exact fix; the CSV simply needs to be regenerated.
- **Repo-custodian:** Flag att_cs_nt_with_ctrls = 0 as FAIL_NUMERICAL in the status column (change cs_nt_with_ctrls_status from "OK" to "FAIL_COLLINEAR"). The zero is a computational artefact, not an estimate.
- **User:** Note that no sensitivity analysis (HonestDiD) is possible for this paper because the treatment is individual-level; the parallel trends assumption for the 1995 EITC expansion must be defended on institutional grounds (the legislative change was federal and quasi-random with respect to maternal health trends).
- **Pattern-curator:** Consider adding a pattern for "RCS single-cohort doubly-robust CS-DID numerical collapse when TWFE controls are symmetric component terms of the treatment interaction" — this is a structurally distinct failure mode from generic control collinearity.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
