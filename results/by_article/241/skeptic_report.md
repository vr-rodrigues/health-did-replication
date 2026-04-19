# Skeptic report: 241 — Soliman (2025)

**Overall rating:** LOW
**Methodology score:** M-LOW (2 WARN, 0 FAIL among applicable methodology reviewers)
**Fidelity score:** F-NA (no PDF; fidelity axis not evaluable from PDF; metadata confirms -6.76% gap explained by sample filter)
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (PASS), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Soliman (2025) studies the effect of DEA enforcement crackdowns on opioid pill mills using a staggered county-year panel (95 treated counties, 8 cohorts 2007–2014, 2,911 never-treated). The paper's headline TWFE estimate is -31.52 MME per capita (Table 1, Col 1), obtained on a sample restricted to rel_year ∈ [-3, 3]. Our stored result (-33.65) uses the unfiltered sample due to template limitations, a 6.76% discrepancy that is documented and explainable. The core finding — that DEA crackdowns substantially reduce opioid prescribing — is robust to modern DiD methods: CS-DiD (never-treated) yields ATT = -50.3 (simple) to -70.0 (dynamic), consistently larger in magnitude than TWFE, as expected when treatment effects grow over time. Two methodological concerns temper confidence: (1) the stored TWFE does not correspond to the paper's headline due to the sample filter mismatch; (2) HonestDiD sensitivity analysis is limited by only 2 pre-periods, and the first-period effect loses significance at Mbar ≈ 0.75. The direction and policy conclusion (crackdowns reduce MME per capita) are credible, but users should rely on the CS-DiD estimates rather than the stored TWFE as the primary reproducibility anchor.

**Design credibility:** MODERATE-HIGH. The design is a well-identified staggered adoption with a deep never-treated control group (2,911 counties), no contamination from forbidden Bacon comparisons (98.7% weight on treated-vs-never-treated), flat pre-trends, and consistent estimates across all modern estimators. The main design limitation is the restricted pre-period window (2 pre-periods) which constrains HonestDiD robustness checks.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Stored beta_twfe = -33.65 (unfiltered); paper reports -31.52 (filtered to rel_year ∈ [-3,3]). The 6.76% gap is explained by the sample restriction used in the original code but not replicable via the standard template.
- Pre-trends are flat (t=-3: +2.23 SE=6.03; t=-2: +0.64 SE=3.95). No pre-trend concern.
- TWFE event-study path diverges from CS/SA/Gardner post-treatment (by period +3: TWFE=-48.7 vs CS-NT=-60.9), consistent with downward attenuation under growing treatment effects.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DiD (PASS)
- CS-NT and CS-NYT estimates track closely (simple ATT: -50.34 vs -50.42), confirming robustness to control group choice.
- Pre-trends flat for both CS variants; no significant pre-trend violations.
- Dynamic ATT (-70.0) substantially larger than simple ATT (-50.3), consistent with escalating treatment effects over time (pill mill crackdown intensification).
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (PASS)
- 98.7% of TWFE weight comes from clean treated-vs-never-treated comparisons; forbidden later-vs-earlier treated comparisons weight ~1.3% — negligible contamination.
- Cohort heterogeneity is present: 2012 cohort shows +3.19 (weight 16.4%), directionally opposite to other cohorts. CS-DiD is the right tool to unpack this.
- Aggregate TWFE is not distorted by forbidden comparisons; its attenuation relative to CS reflects growing within-cohort effects, not Bacon weighting artifacts.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- Only 2 pre-periods available (t=-3, t=-2 with t=-1 normalised); robustness analysis has reduced power.
- First-period TWFE effect (-13.5) loses significance at Mbar ≈ 0.75; average TWFE effect (-34.1) loses significance at Mbar ≈ 1.0.
- CS-NT average ATT (-41.0) is robust to Mbar ≈ 1.0, providing stronger robustness than TWFE.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered treatment. DID_M estimator is not applicable to this design. CS-DiD covers this axis.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF available for formal numerical fidelity audit.
- Metadata explicitly documents the gap: paper = -31.52 (filtered), stored = -33.65 (unfiltered), source = sample filter not applied in template run.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

**WARN — TWFE sample filter mismatch (twfe-reviewer):** The stored beta_twfe (-33.65) does not reproduce the paper's Table 1 headline (-31.52) because the paper applies a rel_year ∈ [-3,3] filter that the standard template cannot implement. Any downstream analysis using the stored TWFE as a calibration anchor is comparing against the wrong number.

**WARN — HonestDiD limited by 2 pre-periods (honestdid-reviewer):** Only 2 pre-periods are available, reducing the power of parallel trends sensitivity analysis. The first-period effect is not robust beyond Mbar ≈ 0.75. This is a design limitation of the original study (9-year panel with treatment starting 2007), not an implementation error.

**FINDING — Cohort heterogeneity (bacon-reviewer):** The 2012 cohort shows a positive estimate (+3.19 MME/capita, weight 16.4%), contrary to the overall direction. TWFE masks this heterogeneity. CS-DiD cohort-specific ATTs are recommended for substantive interpretation.

---

## Recommended actions

- **Repo-custodian:** Update `results/by_article/241/results.csv` to store the filtered TWFE estimate (-31.52, SE=5.767) as the primary `beta_twfe`, or add a separate column `beta_twfe_filtered` to reflect the paper's actual headline. The current stored value creates a misleading 6.76% gap in any fidelity analysis.

- **Repo-custodian:** Consider running the standalone `investigate_241.R` script and storing its output alongside the main results.csv, so downstream consumers can access both the filtered TWFE and the CS/SA/Gardner estimates computed on the full panel.

- **Pattern-curator:** Consider adding a pattern note: "TWFE with event-window restriction: papers that restrict the TWFE estimation sample to a symmetric window around treatment (e.g., rel_year ∈ [-k,k]) cannot be replicated via the standard template. A standalone script is required. Stored TWFE will systematically differ from the paper's headline."

- **User (methodological):** Rely on CS-DiD ATTs (simple: -50.3, dynamic: -70.0) as the primary reproducibility anchor. These are computed on the full sample with the appropriate comparison group. The HonestDiD analysis using CS-NT average ATT provides the most robust sensitivity result (robust to Mbar ≈ 1.0).

- **User (substantive):** Investigate the 2012 cohort anomaly (positive treatment effect +3.19 MME/capita). A cohort-specific ATT table from CS-DiD would clarify whether this cohort's positive estimate is statistically meaningful or a small-sample artifact.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
