# Skeptic report: 133 — Hoynes et al. (2015)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Hoynes, Miller & Simon (2015) study the effect of the 1993 EITC expansion on low birthweight among low-income mothers, using a DiD design that compares high-parity mothers (who received a larger EITC credit, treated) to low-parity mothers (control) in 1991–1998. The headline TWFE estimate of approximately -0.35 to -0.39 percentage points on low birthweight rate is reproduced in sign and significance, but three distinct methodological concerns each earn a WARN: (1) the TWFE pre-trends are mild but positive, and the first-period effect is not robustly nonzero under HonestDiD even at Mbar=0; (2) our CS-DID estimate (-0.403) diverges substantially from the paper's reported CS-NT value (-0.180) despite the single-cohort structure, with significant pre-trends visible in the no-controls CS-NT specification; and (3) HonestDiD shows the TWFE average effect breaks down at Mbar=0.25 (modest pre-trend violation), with CS-NT confidence sets uninformative under any Mbar. The design is fundamentally sound — a single treatment cohort avoids staggered-adoption contamination — but the combination of imperfect pre-trends and limited HonestDiD robustness warrants caution. The fidelity axis cannot be evaluated (no PDF available). The stored consolidated result (beta_twfe ≈ -0.387) should be interpreted as broadly supportive of the paper's conclusion but with moderate uncertainty about the true causal magnitude.

## Per-reviewer verdicts

### TWFE (WARN)
- Our estimate (-0.387 pp) is ~9% larger in magnitude than the paper's reported -0.355 pp, same sign and significance. Divergence is plausibly due to weighting or sample margin differences.
- Pre-trends at t=-3 (+0.094) and t=-2 (+0.061) are positive but not individually significant at conventional levels.
- Post-period effects grow monotonically, consistent with a cumulating income effect.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- Our CS-NT ATT (-0.403) is more than double the paper's reported CS-NT (-0.180) — a large unexplained divergence despite correctly implementing the single-cohort design.
- CS-NT (no controls) shows statistically significant positive pre-trends at t=-3 (t≈2.49) and t=-2 (t≈2.14), undermining the parallel trends assumption for this specification.
- att_cs_nt_with_ctrls = 0 in results (anomalous; likely a computation failure) reduces confidence in the controls-based CS-NT.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single treatment timing (1994) and repeated cross-section structure; Bacon decomposition not applicable. Single bacon.csv row confirms weight = 1.0 (clean 2×2 DiD, no decomposition needed).
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE "avg" and "peak" effects are robustly negative at Mbar=0 (no pre-trend violation allowed) but break down at Mbar=0.25; first-period effect is fragile even at Mbar=0.
- CS-NT confidence sets include zero at Mbar=0 for all three targets (first, avg, peak) — HonestDiD is uninformative for CS-NT due to wide standard errors.
- Breakdown at Mbar=0.25 means only 25% of the observed pre-trend magnitude suffices to overturn the average TWFE result.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Binary, absorbing, single-timing treatment with no heterogeneous dose. The de Chaisemartin estimator is not needed for this design.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- PDF not available at `pdf/133.pdf`. Fidelity axis cannot be evaluated from published tables. Quantitative comparison relies solely on the `original_result` field in metadata.json.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

- **[WARN — CS-DID divergence]** Our CS-NT ATT (-0.403) diverges from the paper's CS-NT (-0.180) by 0.223 pp (>100%). The single-cohort structure means these should be close; the gap likely reflects a differences in controls implementation (Stata drops collinear racemiss silently; R behavior differs) and/or base_period specification.
- **[WARN — CS-NT pre-trends]** CS-NT (no controls) shows statistically significant positive pre-trends at t=-3 and t=-2 (t-stats ≈ 2.49 and 2.14). This is a direct threat to the parallel trends assumption for the no-controls CS-NT specification.
- **[WARN — HonestDiD fragility]** TWFE avg/peak effects are robust only up to Mbar=0.25. CS-NT is uninformative under HonestDiD at any Mbar. The first-period TWFE effect is not robust even at Mbar=0.
- **[WARN — TWFE magnitude divergence]** Our TWFE beta (-0.387) is 9% larger than the paper's (-0.355), though same sign and significance.
- **[WARN — att_cs_nt_with_ctrls anomaly]** att_cs_nt_with_ctrls = 0 in results.csv (status "OK") suggests a silent failure in the controls-based CS-NT specification.

## Recommended actions

- **For repo-custodian:** Investigate the att_cs_nt_with_ctrls = 0 anomaly — verify whether the controls-based CS-NT ran correctly or silently returned 0. Rerun with diagnostic logging enabled.
- **For repo-custodian:** Check whether `base_period = 'universal'` was correctly applied in R's did::att_gt() for CS-NT; this is documented in the metadata notes as required to match Stata. Confirm it was used in the stored run.
- **For repo-custodian:** The CS-NT divergence from the paper (-0.403 vs. -0.180) warrants a targeted diagnostic run — compare against Stata csdid2 output with i.stateres + xformla excluding racemiss, using method=dripw, to identify the source of divergence.
- **For user (methodological judgement):** The HonestDiD breakdown at Mbar=0.25 for the average effect means confidence in the average post-period impact is contingent on believing pre-trends are nearly zero. Given the observed positive pre-trends (especially in CS-NT), users should acknowledge moderate sensitivity. The peak (5-year) effect is somewhat more robust.
- **For user:** The large CS-NT divergence from the paper's reported value is unexplained and should be disclosed when reporting the consolidated reanalysis results for this article.
- **No new pattern needed:** The collinearity issue (racemiss = 0 for all controls) is already documented in the article notes. No new failure_patterns.md entry required.

## Methodology score derivation
| Reviewer | Verdict | Counted? |
|---|---|---|
| twfe | WARN | Yes |
| csdid | WARN | Yes |
| bacon | NOT_APPLICABLE | No |
| honestdid | WARN | Yes |
| dechaisemartin | NOT_NEEDED | No |

Applicable methodology reviewers: 3. WARNs: 3. FAILs: 0.
Rule applied: ≥2 WARN (no FAIL) → **M-LOW**
Fidelity score: F-NA (no PDF). Rating uses methodology alone.
**Final rating: LOW**

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
