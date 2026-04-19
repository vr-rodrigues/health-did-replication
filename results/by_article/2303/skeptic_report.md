# Skeptic report: 2303 -- Cao and Ma (2023)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Cao and Ma (2023) estimate the effect of biomass power plant (BPP) operation on nearby agricultural fire frequency (ft90: fires within 90 km), using a staggered binary treatment across 125 cohorts of 954 plants observed monthly from 2001 to 2019 (228 periods). The headline TWFE estimate is -4.836 fires/month (SE=1.495, clustered by plant), within 0.6% of the paper reported -4.863 (SE=1.780, Conley spatial). All estimators -- TWFE, CS-NT, and Gardner/did2s -- agree on a significant negative post-treatment effect, providing strong directional robustness. However, three methodological concerns lower the rating to LOW: (1) the preferred doubly-robust CS-DID specification with 7 weather controls failed due to memory constraints on the 217k-row panel (FAIL_memory, Pattern 42), leaving only no-controls CS-DID available, which has 4.3x larger SEs and two significant pre-period spikes (k=-6, k=-2); (2) the Bacon decomposition reveals 15,625 pairwise comparisons with extreme cohort-pair estimate heterogeneity (range approximately -88 to +45 fires/month), confirming forbidden comparisons exist; (3) HonestDiD finds TWFE event-study CIs straddle zero even at Mbar=0 (D-FRAGILE for TWFE), though CS-NT avg and peak effects survive Mbar=0 (D-MODERATE). The stored TWFE result (-4.836) is credible in direction but the preferred specification cannot be fully validated due to the memory constraint. Fidelity axis is not evaluable (no PDF).

## Per-reviewer verdicts

### TWFE (WARN)

- Estimate beta=-4.836 within 0.6% of paper -4.863 (Table 2, Col 3). Directionally confirmed.
- Stored SEs are cluster-by-plant (1.495) vs paper Conley spatial (1.780) -- 16% understatement of uncertainty; documented SE method deviation.
- TWFE event study pre-period noisy: k=-3 spike +18.55 (SE=13.46, t~1.38) large but insignificant; 125-cohort staggered design guarantees some negative TWFE weights.

Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- Spec A (doubly-robust, 7 weather controls): FAIL_memory on 217k rows x 125 cohorts x 7 controls -- documented computational constraint (Pattern 42).
- No-controls CS-NT: att_nt_simple=-5.441 (SE=6.431), directionally consistent with TWFE but 4.3x noisier.
- Two significant CS-NT pre-period coefficients: k=-6 (+36.32, t~2.30) and k=-2 (-13.78, t~2.10) -- parallel trends not cleanly satisfied under no-controls specification.

Full report: reviews/csdid-reviewer.md

### Bacon (WARN)

- 15,625 pairwise comparisons across 125 cohorts; both LvE and EvL types present -- forbidden comparisons confirmed.
- Extreme estimate heterogeneity across pairs (range approximately -88 to +45 fires/month).
- Large NT pool (487/954=51%) likely causes TvNT comparisons to dominate; TWFE vs CS-NT gap (12%) suggests practical negative-weight bias is modest.

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)

- CS-NT avg and peak effects robustly negative at Mbar=0: avg CI=[-14.0, -4.4]; peak CI=[-20.7, -6.4].
- CS-NT first (contemporaneous) robust to Mbar=0.25; breaks at Mbar=0.50. rm_first_Mbar=0.25.
- TWFE HonestDiD fragile (Mbar=0 breakdown) due to large event-study SEs from rich id^month + prov^year^month FE -- methodologically explainable, not pre-trend evidence.
- Design credibility: D-MODERATE (CS-NT avg/peak); D-FRAGILE (TWFE, FE-induced).

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Treatment is binary, absorbing, staggered with uniform dose at adoption -- DCDH not required.
- CS-DID with NT comparisons is the appropriate robust estimator and has been run.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)

- PDF pdf/2303.pdf not found -- fidelity axis cannot be formally evaluated.
- Metadata-documented coefficient gap (0.56%) consistent with WITHIN_TOLERANCE but unconfirmed without PDF.

Full report: reviews/paper-auditor.md

## Rating synthesis

| Axis | Verdict | Score |
|---|---|---|
| TWFE | WARN | -- |
| CS-DID | WARN | -- |
| Bacon | WARN | -- |
| HonestDiD | PASS | -- |
| de Chaisemartin | NOT_NEEDED (excluded) | -- |
| **Methodology score** | 3 WARN, 1 PASS, 0 FAIL | **M-LOW** |
| **Fidelity score** | NOT_APPLICABLE (no PDF) | **F-NA** |
| **Combined** | M-LOW x F-NA uses methodology alone | **LOW** |

## Material findings (sorted by severity)

**WARN -- CS-DID Spec A FAIL_memory (design limitation):** The preferred doubly-robust CS-DID with 7 weather controls failed on 217k obs x 228 periods x 125 cohort models. Only no-controls CS-DID available. Weather-controlled parallel trends cannot be validated. Stored CS-NT SE (~6.4) is 4.3x larger than TWFE SE (1.5).

**WARN -- CS-NT pre-trend violations:** Two significant pre-period coefficients in no-controls CS-NT event study: k=-6 (beta=+36.32, t~2.30) and k=-2 (beta=-13.78, t~2.10). Likely reflects omitted weather confounders rather than true parallel-trends failure, but cannot be ruled out without Spec A.

**WARN -- Bacon forbidden comparisons and estimate heterogeneity:** 15,625 pairwise DiD comparisons; EvL forbidden comparisons present; cohort-pair estimates range from approximately -88 to +45 fires/month. Extreme heterogeneity makes TWFE aggregate estimand difficult to interpret as a specific causal parameter.

**WARN -- TWFE SE understatement:** Stored cluster SEs (1.495) are 16% smaller than paper Conley spatial SEs (1.780). Inferential conclusions based on stored SEs are slightly over-confident relative to the paper standard.

**WARN -- TWFE HonestDiD D-FRAGILE:** TWFE event-study CIs straddle zero at Mbar=0 for all targets. Reflects FE-induced large SEs, not pre-trend evidence; TWFE robustness cannot be mechanically certified.

## Design credibility

**D-MODERATE** (driven by CS-NT HonestDiD). CS-NT average and peak post-treatment effects are robustly negative at Mbar=0; first-period effect survives Mbar=0.25. Direction of headline result -- BPPs reduce nearby agricultural fires -- is robust to plausible pre-trend violations up to 25% of the observed pre-trend magnitude. TWFE HonestDiD is D-FRAGILE due to FE-induced large event-study SEs, not pre-trend evidence.

## Known design constraint (Pattern 42)

**FAIL_memory -- doubly-robust CS-DID on large N with many controls:** Spec A (CS-DID with 7 weather controls on 217k obs x 125 cohorts) failed with out-of-memory. The did package must fit cohort-specific outcome and propensity-score models on the full dataset; at this scale the memory requirement exceeds available RAM. Resolution: use no-controls CS-DID as fallback. Status field cs_nt_with_ctrls_status=FAIL_memory_doubly_robust_on_large_N accurately reflects this constraint.

## Recommended actions

- **Repo-custodian:** Document that cs_controls=[] in metadata is a computational constraint (Pattern 42), not a methodological preference. Intended specification is Spec A (7 weather controls) -- cannot run without substantially more RAM (estimated >64 GB for doubly-robust on this panel size).
- **Pattern-curator:** Confirm Pattern 42 is in knowledge/failure_patterns.md with 2303 as a case example. Note: doubly-robust CS-DID fails on panels with N>~100k obs x K>5 time-varying controls x T>~100 cohorts -- use no-controls fallback and flag as FAIL_memory.
- **User (methodological judgement):** Stored CS-NT estimate (-5.44, SE=6.43) is imprecise due to missing weather controls. For robust modern DiD validation, Spec A needs a high-RAM machine. TWFE (-4.836) and Gardner estimates are the most precisely estimated results and agree in sign and magnitude. Direction is credible; FAIL_memory constraint should be disclosed in dissertation methods.
- **User (SE reporting):** Stored TWFE SE (1.495, cluster) should not be compared directly to paper SE (1.780, Conley spatial) without noting the methodological difference.

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
