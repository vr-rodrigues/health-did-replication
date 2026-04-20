# Skeptic report: 44 -- Bosch, Campos-Vazquez (2014)

**Overall rating:** HIGH *(built from Fidelity x Implementation)*
**Design credibility:** FRAGILE *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=PASS, TvT share=0%), honestdid (impl=PASS, M_bar_first=0.25, M_bar_avg=0.25, M_bar_peak=0.25), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Bosch and Campos-Vazquez (2014) study the effect of Mexico Seguro Popular health insurance program on log employer size (6-50 workers) using a staggered rollout across 1,392 municipalities from 2002Q4-2010Q1. The paper reports only a distributed lag event study (Figure 4 Panel D); no static ATT is published, making fidelity comparison impossible (F-NA). Our implementation is technically correct on every applicable axis: specification matches the paper Stata xtreg exactly, clustering is at the municipality level, state cubic time trends are included, and CS-NYT is correctly chosen given the all-eventually-treated design. The stored TWFE estimate is -0.00665 (SE=0.00395, t approx -1.68, not significant at 5%), with CS-NYT uncontrolled at +0.00056 and CS-NYT with controls at -0.0118. Three design-credibility concerns emerge as findings about the paper, not demerits against our work: (1) Bacon decomposition shows 0% Treated-vs-Never-Treated weight -- identification rests entirely on Earlier-vs-Later timing comparisons, with substantial sign heterogeneity and a pathological singleton gvar=200 cohort; (2) 25 time-varying controls are plausibly endogenous to Seguro Popular rollout, with TWFE magnitude shifting 10-fold between controlled and uncontrolled specifications; (3) HonestDiD sensitivity reveals D-FRAGILE results across all three post-treatment targets (M_bar breakdowns at 0.25). The stored result is technically reliable as a reanalysis of the paper specification; users should interpret it with full awareness of the D-FRAGILE design credibility finding.

---

## Per-reviewer verdicts

### TWFE (impl=PASS)

- Specification matches paper Stata xtreg exactly: 25 time-varying controls, state cubic time trends, municipality clustering, population weights. Implementation PASS.
- Design finding: TWFE magnitude shifts 10-fold between controlled (-0.00665) and uncontrolled (-0.000642) specifications -- 25 time-varying labor market controls (industry shares, informality rates) may be post-treatment endogenous regressors.
- Design finding: All-eventually-treated means TWFE relies exclusively on Earlier-vs-Later timing comparisons; no clean never-treated control group.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=PASS)

- Correctly disabled CS-NT (no never-treated units) and enabled CS-NYT. Correct to exclude time-varying controls from CS estimator (methodologically required). Implementation PASS.
- Design finding: Uncontrolled CS-NYT gives +0.00056 (opposite sign to TWFE); resolves to -0.0118 with controls but SE triples, reflecting thin comparison groups in late cohorts.
- Design finding: Pre-trends flat across both TWFE and CS-NYT (all pre-periods individually insignificant).
- Full report: reviews/csdid-reviewer.md

### Bacon (impl=PASS, TvT share=0%)

- Bacon decomposition computed and Bacon-weighted sum consistent with TWFE aggregate. Implementation PASS.
- Design finding: 0% Treated-vs-Never-Treated weight. 100% of Bacon variance from timing comparisons among eventually-treated cohorts. Under heterogeneous treatment effects, negative Bacon weights are structurally possible.
- Design finding: gvar=200 singleton cohort (~1 municipality) produces extreme estimates of -0.8 log points (20+ SDs from main cluster); isolated by tiny weight but structurally pathological.
- Design finding: Substantial sign heterogeneity across main-weight pairings (range -0.15 to +0.19); TWFE aggregate of -0.007 is a tenuous weighted average over effects of both signs.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS, M_bar_first=0.25, M_bar_avg=0.25, M_bar_peak=0.25)

- n_pre=3 (meets the >=3 free pre-periods requirement). Implementation PASS.
- TWFE all three targets significant at M_bar=0: first CI=[-0.0121,-0.0010], avg CI=[-0.0174,-0.0029], peak CI=[-0.0219,-0.0040].
- Design finding: D-FRAGILE -- all TWFE targets lose significance at M_bar=0.5 (breakdowns at M_bar=0.25). CS-NYT first-period not identified even at M_bar=0. A pre-trend deviation of ~0.001-0.002 log points per quarter suffices to overturn significance.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Absorbing-binary-staggered design; CS-NYT subsumes this estimators purpose. NOT_NEEDED as expected.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)

- original_result is empty -- paper reports only distributed lag event study (Figure 4 Panel D), no static ATT. Fidelity axis not evaluable.
- Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

| Spec | TWFE | CS-NYT | Status |
|---|---|---|---|
| (A) both with controls | -0.00665 (SE=0.00395) | -0.0118 (SE=0.01274) | OK (cs_nyt_with_ctrls_status=OK) |
| (B) both without controls | -0.000642 (SE=0.00449) | +0.000558 (SE=0.00462) | OK |
| (C) TWFE with, CS without (headline) | -0.00665 (SE=0.00395) | +0.000558 (SE=0.00462) | -- current default |

Key ratios:
- Estimator margin (Spec A, protocol-matched): (-0.00665 - (-0.0118)) / |-0.00665| = +77% (CS-NYT-with-ctrls 77% more negative than TWFE)
- Covariate margin, TWFE side: (-0.00665 - (-0.000642)) / |-0.00665| = -90% (removing controls shrinks TWFE magnitude 90%)
- Covariate margin, CS side: (-0.0118 - (+0.000558)) / |-0.0118| = +105% (adding controls reverses CS-NYT sign and triples SE)
- Total gap, headline Spec C: (-0.00665 - (+0.000558)) / |-0.00665| = -108% (gap exceeds 100% of TWFE magnitude)

Verbal interpretation: Spec A closes the sign gap (both estimators yield negative estimates) but does not reduce the magnitude gap. This confirms the Spec C sign reversal is driven by control variable omission rather than staggered-timing estimator differences; the Spec A SE tripling reveals the doubly-robust estimator is struggling with thin late-cohort comparison groups, limiting Spec A inferential value.

---

## Rating derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity | F-NA | original_result empty; paper reports only distributed lag event study; no static ATT |
| Implementation | I-HIGH | All applicable reviewers PASS on implementation checks; every WARN is a design finding (Axis 3) |
| **Combined** | **HIGH** | F-NA x I-HIGH -- use implementation alone -- I-HIGH -- HIGH |
| Design credibility | **D-FRAGILE** | M_bar breakdowns at 0.25 (all three TWFE targets); 0% TvT weight (all-eventually-treated) |

Design credibility is a finding about the paper, reported separately. It does not downgrade the rating.

---

## Material findings (sorted by severity -- all are Axis 3 design findings)

**Design finding (Axis 3) -- All-eventually-treated, 0% TvT weight (TWFE + Bacon):** No clean never-treated comparison group. TWFE identified entirely from timing variation. 100% of Bacon weight is Later-vs-Earlier or Earlier-vs-Later pairs. Under heterogeneous treatment effects, the TWFE estimand may incorporate negative weights on some cohort-time ATTs. This is the most fundamental design constraint of this paper.

**Design finding (Axis 3) -- HonestDiD D-FRAGILE (M_bar=0.25 all targets):** TWFE effects lose significance at M_bar=0.5. The identification fails if actual pre-trends deviate by ~0.001-0.002 log points per quarter -- a small tolerance given the program scale. CS-NYT first-period not identified even at M_bar=0.

**Design finding (Axis 3) -- Potentially endogenous time-varying controls:** 25 controls include labor market composition variables (informality rate, industry shares) that may be directly affected by Seguro Popular. Controlled vs uncontrolled TWFE differ by 10x in magnitude (-0.00665 vs -0.000642).

**Design finding (Axis 3) -- Sign reversal in uncontrolled CS-NYT vs TWFE:** Without controls, CS-NYT gives +0.00056 (positive, opposite TWFE). Sign resolves to negative with controls at the cost of tripled standard errors.

**Design finding (Axis 3) -- gvar=200 singleton cohort (Bacon):** Last adoption cohort has ~1 municipality, producing Bacon estimates of -0.80 log points (20+ SDs from main cluster). SA estimator correctly disabled (Pattern 36).

---

## Recommended actions

- No action needed on the implementation pipeline -- all reviewers PASS on Axis 2.
- For repo-custodian: Update run_bacon to true in metadata (bacon.csv already exists from supplementary run) so future automated runs include Bacon decomposition.
- For repo-custodian: Consider adding a gvar_exclude: [200] flag or note in metadata to flag the singleton cohort for sensitivity checks.
- For pattern-curator: Add pattern for all-eventually-treated designs (0% TvT) where time-varying controls are TWFE-included but CS-excluded by design -- Spec C sign gap reflects control omission not staggered-timing bias; Spec A closes the sign but SE tripling from thin late-cohort comparison groups limits inferential value.
- For user (methodological judgement): Given D-FRAGILE HonestDiD (M_bar breakdowns at 0.25), narrative should focus on direction of effect (negative on small employers) rather than statistical significance. A robustness check using only pre-treatment-measured covariates would assess the bad-controls concern.
- For user (methodological judgement): SA disabled (Pattern 36: near-singular VCOV from singleton gvar=200). Excluding gvar=200 municipalities in a sensitivity run could permit SA estimation as cross-validation.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
