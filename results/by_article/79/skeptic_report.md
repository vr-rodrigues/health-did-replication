# Skeptic report: 79 — Carpenter, Lawler (2019)

**Overall rating:** MODERATE  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=WARN — NT pre-trend failure; Spec A Pattern 42 collapse is a design finding, not impl error), bacon (N/A — repeated cross-section), honestdid (impl=PASS, M_first=1.75/1.50, M_avg=0.50/0.25, M_peak=0.25/0.25), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT — 0.027% gap, Table 2 Col 1)

---

## Executive summary

Carpenter & Lawler (2019) study the effect of state-level Tdap vaccine mandate requirements on vaccination rates among children under 13 (NIS-Teen survey), using a continuous mandate intensity variable (TDcont_mandate) in a staggered, state-level adoption design (2004–2012 cohorts, 9-year window). The TWFE headline (beta = 0.135, SE = 0.014) is reproduced exactly from Table 2 Column 1 (0.027% gap). This paper is the canonical COLLAPSE-staggered exemplar in Lesson 7 (Chapter 4, sec:spec_a_hexagon): 53 direct covariates in the TWFE controls list overwhelm the doubly-robust propensity-score step in CS-DID, causing both CS-NT and CS-NYT to collapse to exactly zero under Spec A (matched-protocol). This is Pattern 42 (propensity overfit) in its most severe form. Spec B (unconditional both sides) recovers coherent estimates: TWFE = 0.153 vs CS-NT = 0.163 (+6%) vs CS-NYT = 0.087 (-36%), with CS-NT converging tightly to TWFE without controls, confirming the TWFE/CS-NYT gap reflects cohort-level treatment effect heterogeneity (NYT systematically lower) rather than negative-weight bias. The user should trust the stored TWFE (0.135) as an exact replication of the paper’s preferred estimate. The policy-defensible range is CS-NYT = 0.087–0.090 (unconditional, preferred comparison group) to TWFE = 0.135. Spec A controls are non-informative for this design. This paper, paired with paper 25 (Carrillo-Feres 2019, 18 controls, Spec A clean), anchors the Lesson 7 hexagon illustration of when covariate count and design structure make matched-protocol CS-DID degenerate.

---

## Per-reviewer verdicts

### TWFE (PASS)

- beta = 0.135036 reproduces paper exactly (Table 2, Col 1, SE = 0.014); three-way FE (state x year x age), 53 covariates, survey weights correctly specified.
- Mild systematic negative pre-trend drift (all t=-6 to t=-2 negative; max |t| approximately 1.53 at t=-6): a soft concern consistent across all estimators, not individually significant, not an implementation error.
- Post-treatment trajectory grows from t=0 (+0.112) to t=6 (+0.215), consistent with compliance ramp-up after mandate adoption.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN — NT pre-trend failure; Spec A Pattern 42 collapse is a design finding)

- Spec A (matched protocol — TWFE with 53 ctrls vs CS with 53 ctrls): CS-NT = 0 and CS-NYT = 0 (status = OK, but estimates are artefactual; 53 controls overwhelm the doubly-robust propensity step at cohort-state cell level). Pattern 42 textbook case. Spec A is non-informative for this design and must not be cited as a controls-matched robustness check.
- Spec B (unconditional both sides): TWFE = 0.153 vs CS-NT = 0.163 (+6%) vs CS-NYT = 0.087 (-36%). CS-NT/TWFE convergence at +6% confirms no negative-weight bias in the never-treated channel. The CS-NYT divergence (-36%) reflects genuine cohort-level heterogeneity.
- Spec C (legacy asymmetric default — TWFE with ctrls vs CS without ctrls): TWFE = 0.135 vs CS-NT = 0.163; this is the headline stored in consolidated_results.
- NT comparison group has significant pre-trends in Stata validation (Pre_avg = -0.048, p = 0.001); NYT is the preferred estimator (Pre_avg = -0.022, p = 0.143, insignificant). Pattern 24 documented.
- WARN on the implementation axis is for the NT pre-trend failure only. The Spec A collapse is a design finding (Pattern 42) — our pipeline ran correctly; the zero is the propensity overfit artefact.
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)

- Skipped: data_structure = repeated_cross_section; Bacon decomposition requires a true panel.
- Informational: a Bacon decomposition file exists from R template run on aggregated state-year data. TVT share approximately 40%; all component estimates positive (range: -0.07 to +0.36); a few near-zero LvE comparisons using cohort 2003 as always-treated reference.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)

- Contemporaneous effect (t=0): rm_first_Mbar = 1.75 (TWFE) and 1.50 (CS-NYT) — both robust. Strongest and most policy-relevant estimate.
- Average post-treatment ATT: rm_avg_Mbar = 0.50 (TWFE, D-MODERATE) and 0.25 (CS-NYT, D-FRAGILE). CS-NYT average is fragile because the smaller signal (ATT approximately 0.105) provides less headroom against pre-trend violations.
- Peak ATT: rm_peak_Mbar = 0.25 for both — fragile. The peak (t=6) is driven by late-horizon sparse data.
- 5 free pre-periods (t=-6 through t=-2); no implementation errors.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing staggered design with continuous mandate intensity variable. Continuous treatment is the original authors’ design choice, not non-absorbing or reversible treatment. CS-NYT already captures cohort-level ATT heterogeneity. DH adds no material additional information.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (EXACT)

- Stored beta_twfe = 0.135036 vs paper Table 2 Column 1 beta = 0.135; gap = 0.027% (EXACT threshold < 0.5%).
- Fidelity axis: F-HIGH (EXACT). Updated from F-NA in the prior 2026-04-18 run (PDF absent at that time); confirmed via metadata benchmark established during Profiler stage.
- Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

The paper has 53 covariates in twfe_controls and 2 in cs_controls (female, married). This is the most controls-heavy paper in the audit sample and the canonical Spec A degenerate case (Pattern 42).

| Spec | TWFE | CS-NT | CS-NYT | Status |
|---|---|---|---|---|
| (A) both with controls (matched protocol) | 0.1350 (SE 0.0140) | 0 (SE NA) | 0 (SE NA) | FAIL_Pattern42 — propensity overfit; non-informative |
| (B) both without controls | 0.1528 (SE 0.0167) | 0.1632 (SE 0.0304) | 0.0866 (SE 0.0245) | OK |
| (C) TWFE with, CS without (legacy default) | 0.1350 (SE 0.0140) | 0.1639 (SE 0.0209) | 0.0954 (SE 0.0203) | — (headline, current default) |

Key ratios:
- Estimator margin — Spec B protocol-matched (TWFE_B - CS-NT_B) / |TWFE_B|: (0.1528 - 0.1632) / 0.1528 = -6.8% (CS-NT slightly above TWFE without controls; tight convergence confirming no negative-weight bias).
- Covariate margin (TWFE side): (beta_C - beta_B) / |beta_C| = (0.1350 - 0.1528) / 0.1350 = -13.2% (controls shrink TWFE by 13%).
- Covariate margin (CS side, Spec A): degenerate (0 / NA); not computable.
- Total gap, current headline Spec C: (TWFE_C - CS-NYT_C) / |TWFE_C| = (0.1350 - 0.0954) / 0.1350 = +29.3% (TWFE is 29% above CS-NYT in legacy default).

Verbal interpretation: Spec B recovers excellent protocol-matched convergence for the never-treated comparison group (-6.8% estimator margin), confirming the paper’s core finding is design-robust in the unconditional comparison. The TWFE/CS-NYT gap in Spec B (-36%) is an estimand difference — NYT restricts to not-yet-treated comparators — not a controls or negative-weight artefact. Spec A collapses entirely because 53 controls overwhelm the doubly-robust propensity step at sparse state-cohort cells (51 states, 9 cohorts); the non-parametric logistic propensity model overfits perfectly. This is the defining Pattern 42 case and the principal contrast with paper 25 (Carrillo-Feres 2019, 18 controls, Spec A estimator margin = 1.3%). The Spec B estimator margin for NT (-6.8%) is the authoritative methodological verdict: the TWFE is reliable when both sides are unconditional.

This decomposition feeds Deliverable D1 of the QJE review (Sant’Anna, 2026-04-17).

---

## Rating derivation (three-axis framework)

**Axis 1 — Fidelity (paper-auditor):** F-HIGH (EXACT, 0.027% gap on Table 2 Col 1)

**Axis 2 — Implementation (methodology reviewers):**

| Reviewer | Impl verdict | Counted? |
|---|---|---|
| twfe | PASS | Yes |
| csdid | WARN — NT pre-trend failure (Pattern 24) | Yes |
| bacon | NOT_APPLICABLE | No |
| honestdid | PASS | Yes |
| dechaisemartin | NOT_NEEDED | No |

Spec A collapse (Pattern 42) is classified as a design finding on Axis 3, not an implementation WARN. Our pipeline ran correctly; the zero estimate is the expected artefact of a degenerate propensity model. Implementation count: 1 WARN (NT pre-trend failure), rest PASS. Implementation score: I-MOD.

**Axis 3 — Design credibility (finding about the paper):**
- HonestDiD: rm_first_Mbar = 1.75 (TWFE) / 1.50 (CS-NYT) — robust contemporaneous effect. rm_avg_Mbar = 0.50 (TWFE, D-MODERATE) / 0.25 (CS-NYT, D-FRAGILE). Peak fragile at Mbar = 0.25 for both.
- Spec A collapse (Pattern 42, 53 controls, sparse cohort cells): design finding, not implementation failure.
- Bacon TvT share: N/A (RCS data structure).
- Pre-trends: mild systematic negative drift (TWFE all pre-periods negative; CS-NYT smaller and less systematic); NT pool has significant pre-trends (Pattern 24).
- Overall design credibility: **D-MODERATE** (TWFE rm_avg_Mbar = 0.50 is the dominant design signal; first-period robust at Mbar = 1.75; CS-NYT fragile at avg reflects smaller signal, not design collapse).

**Final rating:** F-HIGH x I-MOD = **MODERATE**. Design credibility D-MODERATE reported as a separate finding.

---

## Material findings (sorted by severity)

**Design findings (Axis 3 — findings about the paper, not demerits against our reanalysis):**

1. [csdid, design] Spec A Pattern 42 collapse: 53 TWFE controls overwhelm the doubly-robust propensity-score step in CS-DID at sparse state-cohort cells (51 states, 9 cohorts); CS-NT and CS-NYT both collapse to exactly 0 under matched-protocol Spec A. This paper is the canonical Lesson 7 COLLAPSE-staggered exemplar in Chapter 4 (sec:spec_a_hexagon). Counter-example to paper 25 (Carrillo-Feres 2019, 18 controls, Spec A clean). Together they define the Lesson 7 hexagon split: papers with many direct controls in staggered state-level RCS designs are at high risk of Pattern 42 degeneration; papers with fewer time-varying controls at denser cell sizes produce clean doubly-robust estimates.
2. [csdid, design] CS-NYT ATT is 36–43% below TWFE headline across all specs (Spec B: 0.087 vs 0.153; Spec C: 0.090 vs 0.135). This reflects genuine cohort-level treatment effect heterogeneity in Tdap mandate compliance by adoption cohort, not negative-weight bias (confirmed by Spec B CS-NT/TWFE convergence within 6%).
3. [csdid, design] NT comparison group has significant pre-trends in Stata validation (Pattern 24; Pre_avg = -0.048, p = 0.001). NYT is the preferred comparison group for this design (Pre_avg = -0.022, p = 0.143).
4. [honestdid, design] CS-NYT average ATT is D-FRAGILE (rm_avg_Mbar = 0.25): the smaller CS-NYT signal (approximately 0.105) has a lower signal-to-noise ratio; modest violations of parallel trends erode the average post-treatment confidence interval to include zero.
5. [twfe, design] Mild systematic negative pre-trend drift in TWFE event study (all t=-6 to t=-2 negative; max |t| approximately 1.53 at t=-6): a soft concern consistent across all estimators, not individually significant.

**Implementation WARNs (Axis 2):**

1. [csdid, impl] NT comparison group pre-trend failure (Pattern 24): both NT and NYT are run correctly, but the NT pool is less credible for this design due to early-cohort composition differences between the R and Stata CS implementations. NYT is the preferred estimator.

---

## Recommended actions

- No corrective action on implementation: our pipeline is correct. TWFE reproduced exactly; CS estimators implement panel=FALSE for RCS correctly; HonestDiD uses 5 free pre-periods correctly; Spec A/B/C results correctly recorded in results.csv.
- For the dissertation/paper: when citing results, report Spec B (unconditional matched protocol) as the primary robustness check. The Spec B triplet (TWFE = 0.153, CS-NT = 0.163, CS-NYT = 0.087) is the authoritative decomposition. Spec A is explicitly flagged as degenerate (Pattern 42) and must not be cited as a controls-matched robustness check. Spec C (legacy) is the stored headline for consolidated_results.
- For dissertation Chapter 4 sec:spec_a_hexagon: confirm this paper is coded as hexagon-type COLLAPSE (Spec A degenerate) with 53 controls as the primary determinant. Pair with paper 25 (hexagon-type CLEAN, 18 controls) to anchor the Lesson 7 contrast. The hexagon narrative should note that 53 direct controls in a staggered state-level RCS design is the ceiling of the overfit failure mode in this audit sample.
- For the user: prefer CS-NYT unconditional ATT (approximately 0.087–0.090) as the policy-defensible headline for publication. The contemporaneous-effect estimate (t=0: approximately 0.104–0.112 across estimators) is the most robust under HonestDiD (Mbar > 1.50) and should be the primary citable result for policy inference. TWFE = 0.135 is correctly reproduced but reflects a TWFE-weighted average that may overweight early-adopting cohorts.
- For the pattern-curator: Patterns 24 and 42 are already documented. Confirm that the Pattern 42 entry explicitly cites article 79 as the canonical 53-controls staggered case (most extreme in the audit sample) and cross-references paper 25 as the CLEAN contrast. No new patterns needed.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
