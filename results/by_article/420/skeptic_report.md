# Skeptic report: 420 -- Bailey, Goodman-Bacon (2015)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (PASS), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF)

---

## Executive summary

Bailey & Goodman-Bacon (2015, AER) estimate that the staggered rollout of Community Health Centers (CHCs) reduced age-adjusted elderly mortality (50+) by approximately 53 units per 100,000, using TWFE with county, year, urban-category x year, and state x year fixed effects plus baseline x trend controls. Our reestimation with SA (-70 to -86 across post-periods) and Gardner (-62 to -82) confirms the direction and broad magnitude of the effect. HonestDiD analysis shows the first-period ATT is robust to pre-trend violations up to M-bar=0.50 (TWFE) and M-bar=0 (CS-NT). However, two methodological concerns emerge: (1) the CS-DID estimate collapses from -61.4 (no controls) to -6.78 (Durb_f controls, SE=27.7), indicating the paper's identification depends on high-dimensional parametric FEs that CS-NT cannot replicate; (2) the Bacon decomposition reveals an anomalous positive estimate for the 1974 cohort (+40.5, weight=11.5%). SA, Gardner, and HonestDiD corroborate the direction and magnitude of the mortality reduction. The stored TWFE result (-53.21, SE=14.84) is a credible estimate. Fidelity axis not evaluable (no PDF).

---

## Per-reviewer verdicts

### TWFE (WARN)

- Pre-period TWFE coefficients (t=-7 to t=-2) all within 1 SE of zero; no systematic pre-trend.
- Specification faithful to Table 2 Panel B Col 2: D_ baseline x trend controls, R_/H_ time-varying, Durb x year and state x year FEs, popwt_eld weighting. NYC/LA/Chicago exclusions correct.
- SA and Gardner consistent with TWFE (peak: SA=-86, Gardner=-82, TWFE=-78). CS-NT with controls (-6.78) dramatically diverges -- Pattern 51. Metadata run_bacon=false inconsistent with existing bacon.csv.

[Full report: reviews/twfe-reviewer.md]

### CS-DID (WARN)

- CS-NT ATT without controls: -61.4 (SE=19.1); with Durb_f controls: -6.78 (SE=27.7) -- not distinguishable from zero.
- CS-NT (no controls) pre-period drift at t=-4 (+28.9, ~2.2 SEs): unconditional parallel trends fails without parametric controls for urban composition and state trends.
- Range -6.78 to -61.43 is too wide for CS-NT to serve as a clean robustness check.

[Full report: reviews/csdid-reviewer.md]

### Bacon (PASS)

- ~84% of TWFE weight from treated vs never-treated comparisons. Inter-cohort comparisons <1% -- no material negative-weighting contamination.
- 1974 cohort anomalous: TvU estimate +40.5 (weight=11.5%). All other 8 cohorts show large negative effects.
- Metadata inconsistency: run_bacon=false but bacon.csv exists.

[Full report: reviews/bacon-reviewer.md]

### HonestDiD (PASS)

- TWFE first-period ATT robust to M-bar=0.50 (CI: [-52.26, -0.61]); average ATT robust to M-bar=0.25.
- CS-NT avg and peak ATTs robust at M-bar=0 (no pre-trend assumption needed).
- CHC mortality reduction is not a pre-trend artifact under plausible smoothness assumptions.

[Full report: reviews/honestdid-reviewer.md]

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered treatment. DID_M/DID_l not applicable.

[Full report: reviews/dechaisemartin-reviewer.md]

### Paper-Auditor (NOT_APPLICABLE)

- PDF not found at pdf/420.pdf. Fidelity axis is F-NA, not factored into the rating.

---

## Material findings (sorted by severity)

**WARN -- CS-DID estimate collapses under control specification (Pattern 51):** ATT swings from -61.4 (no controls) to -6.78 (Durb_f, SE=27.7). Paper identification relies on Durb x year and state x year FEs that CS-NT cannot absorb. CS-NT is not a valid standalone robustness check for this design.

**WARN -- CS-NT pre-trend at t=-4 (+28.9, ~2.2 SEs):** Unconditional parallel trends fails for this design without parametric controls.

**WARN -- 1974 cohort positive Bacon TvU estimate (+40.5, weight=11.5%):** Anomalous positive effect for the latest cohort. Does not overturn aggregate finding.

**WARN -- Metadata run_bacon=false inconsistent with existing bacon.csv:** Flag should be updated to true.

**NOTE -- HonestDiD TWFE first-period borderline at M-bar=0.50:** Effect loses significance at M-bar=0.75. Robustness is moderate.

---

## Recommended actions

- Repo-custodian: Update run_bacon to true in data/metadata/420.json.
- Repo-custodian: Obtain pdf/420.pdf to enable paper-auditor fidelity check on Table 2 Panel B Col 2.
- Pattern-curator: Confirm Pattern 51 in knowledge/failure_patterns.md with Article 420 as a confirmed case; note cs_controls=[Durb_f] reduces but does not eliminate the gap vs TWFE.
- User: LOW rating reflects two WARN flags, not fundamental failures. SA, Gardner, and HonestDiD corroborate the direction and magnitude. TWFE stored result (-53.21) is credible. CS-NT cannot serve as an independent robustness check for this identification strategy.
- User: Investigate 1974 cohort anomaly in bacon.csv; consider cohort-specific diagnostics or exclusion of the 1974 cohort from CS analysis.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
