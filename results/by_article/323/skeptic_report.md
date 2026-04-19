# Skeptic report: 323 --- Prem, Vargas, Mejia (2023)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (N/A), honestdid (PASS informational), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Prem, Vargas, Mejia (2023) study the effect of a 2014 Colombian peace-process policy announcement on coca cultivation area, exploiting cross-municipal variation in coca suitability. The paper uses a continuous treatment (suitability index x announcement). For replication, treatment is binarized at median suitability. Replication finds TWFE = 0.643 and CS-NT = 0.599 -- positive effects growing monotonically over five post-announcement years. All three applicable methodology reviewers PASS. The design is a clean single-cohort setup: no staggered-timing bias, no forbidden comparisons, no negative weights. Pre-trends are flat (|coef| < 0.08; |t| < 1.8). HonestDiD shows average and peak ATTs robust to pre-trend violations at Mbar = 1.25-1.50; the first-period effect is fragile (Mbar = 0-0.25). Fidelity axis is NOT_APPLICABLE (no PDF; stored coefficient not comparable to paper due to continuous-to-binary estimand transformation). Rating: M-HIGH x F-NA = conservative MODERATE due to estimand mismatch.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Single treatment cohort (2014) with never-treated controls: no negative weights or forbidden comparisons.
- Pre-trends at t=-2 and t=-3 are small and insignificant (|t| < 1.8).
- Post-treatment effects grow monotonically from 0.129 (t=0) to 0.960 (t=4).
- Full report: reviews/twfe-reviewer.md

### CS-DID (PASS)
- CS-NT / TWFE gap = 6.9%, within normal bounds for single-cohort aggregation weighting differences.
- Pre-period CS-NT coefficients replicate TWFE pre-periods identically; no CS-specific pre-trend concerns.
- Three-way convergence (TWFE, CS-NT, Gardner) supports causal direction; Gardner 5-10% larger at post-periods (imputation artefact).
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- Single treatment date: 100% Treated-vs-Untreated weight by construction. No decomposition needed.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS -- informational; only 2 pre-periods)
- Avg ATT robustness: TWFE rm_Mbar=1.25, CS-NT rm_Mbar=1.50 (D-MODERATE to D-ROBUST).
- Peak ATT (t=4) robustness: TWFE Mbar=1.25, CS-NT Mbar=1.00.
- First-period ATT is D-FRAGILE (Mbar=0 CS-NT; Mbar=0.25 TWFE).
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary single-cohort design; no treatment switching or continuous dose heterogeneity in binarized spec.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)
- pdf/323.pdf not available; stored TWFE (0.643) not comparable to paper coefficient (0.300 in continuous units).
- Full report: reviews/paper-auditor.md

---

## Material findings (sorted by severity)

**WARN items:**

1. Estimand mismatch (binary vs. continuous treatment): Stored TWFE=0.643 and CS-NT=0.599 are for the binarized specification; not a replication of the paper coefficient (0.300, continuous units). Documented in metadata but must be flagged for downstream users.

2. First-period ATT is D-FRAGILE: The contemporaneous announcement effect (0.129) does not survive HonestDiD sensitivity at Mbar > 0.25 (TWFE) or Mbar > 0 (CS-NT).

3. Only 2 pre-periods: HonestDiD sensitivity analysis has limited power; Mbar robustness margins should be interpreted conservatively.

No FAIL items.

---

## Recommended actions

- No methodological action needed: implementation is sound and all applicable reviewers PASS.
- For downstream users: clarify in consolidated results that stored beta_twfe (0.643) is the binarized-specification ATT, not a replication of Table 1 Col 1 (continuous treatment). Consider adding an estimand_modified flag in consolidated_results.csv.
- For pattern-curator: the continuous-to-binary median-split approach (median split to enable CS-DID on a continuous-treatment paper) may be worth codifying as a named replication pattern (cf. Article 234).
- No repo-custodian action needed: metadata is correctly specified and binarization is documented.

---

## Methodology and fidelity scores

| Axis | Score | Basis |
|------|-------|-------|
| Methodology | M-HIGH | All 3 applicable reviewers PASS; bacon N/A; dechaisemartin NOT_NEEDED |
| Fidelity | F-NA | No PDF; estimand mismatch makes direct comparison ill-defined |
| Combined | MODERATE | M-HIGH x F-NA: use methodology alone; conservative MODERATE due to estimand mismatch |

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
