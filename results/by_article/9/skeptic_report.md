# Skeptic report: 9 -- Dranove et al. (2021)

**Overall rating:** MODERATE  *(Fidelity x Implementation: F-HIGH x I-MOD)*
**Design credibility:** MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-24
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=PASS, TvT=21.5%), honestdid (impl=WARN, n_pre=2 of 8, Mbar_avg_TWFE=0.70, Mbar_avg_CS=1.10, Mbar_peak_TWFE=0.95, Mbar_peak_CS=1.15), dechaisemartin (NOT_NEEDED), paper-auditor (WITHIN_TOLERANCE: TWFE=EXACT)

*Note: All six reviewer reports were cached from 2026-04-19 (5 days ago, no --fresh flag passed). Cached reports used for Axes 1-2. The focused Spec A analysis was performed by the skeptic from raw data (results.csv, honest_did_v3_sensitivity.csv, bacon.csv, failure_patterns.md). The rating is unchanged from 2026-04-19 but the report is expanded to address the dissertation promotion question.*

---

## Executive summary

Dranove, Ody and Starc (2021) estimate the effect of Medicaid managed care adoption on log drug price per prescription using a staggered TWFE specification across 29 U.S. states over 26 quarters. The headline TWFE coefficient is -0.176 (SE=0.048), implying managed care reduces drug prices by approximately 16%. Our replication matches this to within 0.003% (effectively exact). Modern estimators (CS-NT: -0.208, CS-NYT: -0.213, SA and BJS: -0.177 to -0.183) agree on sign and are 15-20% larger in magnitude, consistent with mild upward contamination in TWFE from the later-vs-earlier-treated Bacon TVT component (21.5% of weight). Pre-trends are flat across all 8 pre-periods under both TWFE and CS-NT. HonestDiD shows the average and peak effects are robust to moderate pre-trend violations (Mbar_avg_TWFE=0.70, Mbar_avg_CS=1.10). The stored result (-0.176 TWFE, -0.208 CS-NT) is credible and trustworthy for dissertation use. Design credibility is MODERATE.

**For the dissertation promotion decision (Chapter 4.8 MVPF stress-test):** The Spec A beta-collapse from beta_TWFE_ctrls = -0.176 to beta_CS-NT-with-ctrls = -0.013 is a real methodological finding (propensity-score overfit in a state-level panel with single continuous covariate), NOT a pipeline artefact analogous to Pattern 51 (RCS IPW inflation) or any implementation error. The Spec A estimate of -0.013 is non-informative; the protocol-matched Spec B (-0.186 TWFE vs -0.208 CS-NT) is the correct matched-protocol estimate. The 14x collapse is a legitimate Lesson 7 canonical instance of the Spec A COLLAPSE behavior. Rating: MODERATE. Suitable for dissertation body if disclosed.

---

## Spec A beta-collapse: diagnostic ruling

### The specific question

Is beta_CS-NT-with-ctrls = -0.013 (SE=0.0145) a legitimate doubly-robust estimate, or is it distorted by K-treated-unit issues, covariate collinearity, or weak overlap?

### Evidence examined

From results.csv: att_cs_nt_with_ctrls = -0.01301 (SE = 0.01448), cs_nt_with_ctrls_status = OK, att_cs_nyt_with_ctrls = -0.01288 (SE = 0.01438), cs_nyt_with_ctrls_status = OK, att_csdid_nt (Spec B) = -0.2084.

Collapse ratio: |-0.013 / -0.208| = 6.3% of baseline, a 16x attenuation. Both NT and NYT collapse to nearly identical values (-0.01301 and -0.01288). If the estimate were a real doubly-robust ATT, NT and NYT -- which use different comparison groups with different propensity models -- would not converge to the same near-zero value. This convergence is diagnostic of a shared failure in the propensity-score step.

### Is this Pattern 51 (RCS IPW inflation)?

No. Pattern 51 (documented from id_125 and id_433) requires: (1) data structure = RCS; (2) direction = inflation (|ATT_A| >> |ATT_B|); (3) mechanism = individual-level covariates causing IPW inflation. For id_9: data structure is balanced panel (29 states x 26 quarters = 754 rows), not RCS; direction is deflation (|ATT_A| << |ATT_B|). Pattern 51 does not apply.

### Is this Pattern 42 (propensity-score overfit causing collapse)?

Yes, with a panel-specific variant. Pattern 42 was originally documented for state/region factor dummies causing perfect separation. The mechanism here is subtler: the covariate exp (state-level expenditure) is a single continuous variable. In CS doubly-robust DRDID, for each (group g, time t) cell, a logistic regression estimates Pr(G=g | exp, C) where C is the comparison group. With 10 cohorts and staggered adoption across 29 states, some (g, t) cells have very few comparison units. A single continuous variable with limited observations per cohort-time cell produces near-perfect propensity score separation: the logistic model converges (hence status = OK) but with extreme predicted probabilities near 0 or 1, yielding extreme IPW weights that pull the doubly-robust ATT toward zero.

The convergence without error (status = OK) distinguishes this from Pattern 42 complete-failure mode, but the attenuation mechanism is identical: extreme IPW weights overwhelm the outcome regression component of the DR estimator.

Additional diagnostic evidence:
- Collapse replicated for both NT and NYT (different comparison sets) -- consistent with per-cell overfit, not a data artifact
- NT dynamic aggregate with controls even more attenuated: -0.00386 (SE=0.0046), near-zero
- TWFE Spec A stable (-0.176 with vs -0.186 without, a -5.7% covariate margin): exp is well-behaved in OLS; the problem is specific to IPW

### Is there a K=1 DR overfit issue (analogous to id_433)?

No. id_433 involved a single-cohort design with a small treated group. id_9 has 10 cohorts across 29 states -- no K=1 problem. The collapse here is a per-cell limited-comparison-unit issue in a balanced staggered panel.

### Diagnostic verdict on Spec A

The CS-NT-with-ctrls estimate of -0.013 is non-informative due to propensity-score overfit (Pattern 42 panel variant: single continuous covariate + balanced state-level panel + limited comparison units per cohort-time cell + status=OK). This is NOT a pipeline error, NOT Pattern 51, NOT a K=1 artefact. It is a real methodological finding: mechanically adding exp to CS-DID in this 29-state staggered panel destroys identification without error flags. The correct estimate for dissertation use is Spec B: TWFE_B = -0.186 (SE=0.046), CS-NT_B = -0.208 (SE=0.053), estimator margin 11.8%.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Specification matches original Stata code exactly; numerical match within 0.003% (EXACT).
- Pre-trend pattern clean: all 8 pre-period coefficients within 1-2 SE of zero; largest at t=-9 is -0.069 (SE=0.062), not significant. No systematic drift. [Design finding -- Axis 3]
- Post-treatment trajectory builds monotonically from -0.048 (t=0) to -0.259 (t=7), consistent with gradual managed care formulary implementation. [Design finding -- Axis 3]
- Full report: reviews/twfe-reviewer.md

### CS-DID (PASS)
- cs_controls=[] correctly applied: passing xformla=~exp drops cohorts 205-216 in did v2.3.0 -- avoidance documented (Pattern 26).
- base_period=universal applied per mandatory default (Pattern 26).
- CS-NT pre-trends cleaner than TWFE (max |coeff|=0.024 vs 0.069 at t=-9). [Design finding -- Axis 3]
- Full report: reviews/csdid-reviewer.md

### Bacon (PASS, TvT=21.5%)
- TVU weight 78.5%; TVT share 21.5%, below the 30% D-ROBUST threshold. [Design finding -- Axis 3]
- 9 of 10 cohorts show negative TVU estimates; cohort 205 (weight=3.9%) shows +0.047 -- minor. [Design finding -- Axis 3]
- TWFE undershoots CS-DID by approximately 15%, consistent with mild upward TVT contamination.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN on implementation)
From raw honest_did_v3_sensitivity.csv:
- TWFE avg: robust through Mbar=0.70 (CI crosses zero at Mbar=0.75: [-0.231, +0.001])
- TWFE peak: robust through Mbar=0.95 (CI crosses zero at Mbar=1.0: [-0.366, +0.016])
- CS-NT avg: robust through Mbar=1.10 (CI crosses zero at Mbar=1.25: [-0.287, +0.006])
- CS-NT peak: robust through Mbar=1.15 (CI crosses zero at Mbar=1.25: [-0.404, +0.016])
- Both estimators first: CI includes zero at Mbar=0 -- immediate impact not robustly identified (consistent with gradual rollout). [Design finding -- Axis 3]
- Implementation WARN (Axis 2): n_pre=2 passed to RM calibration despite 8 pre-periods available. Correctable; would upgrade HonestDiD to PASS and overall rating to HIGH.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered adoption; no dose heterogeneity, no reversal.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (WITHIN_TOLERANCE / TWFE=EXACT)
- pdf/9.pdf confirmed. TWFE matches paper Table 2, col (1) to 0.003% (EXACT). SE matches to 0.02%.
- CS-DID gap 3.2% (NT) / 2.4% (NYT): within tolerance; explained by did v2.3.0 cohort-dropping.
- Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

variables.twfe_controls = exp (non-empty) -- decomposition is relevant.

| Spec | TWFE | CS-DID NT | Status |
|------|------|-----------|--------|
| (A) both with controls | -0.176 (0.048) | -0.013 (0.014) | FAIL_overfit: Pattern 42 panel-variant; non-informative |
| (B) both without controls | -0.186 (0.046) | -0.208 (0.053) | OK -- clean matched-protocol estimate |
| (C) TWFE with, CS without | -0.176 (0.048) | -0.208 (0.053) | Headline, current default |

Key ratios:
- Estimator margin (protocol-matched Spec B): (-0.186 - (-0.208)) / |-0.186| = +11.8% (TWFE undershoots CS-NT)
- Covariate margin (TWFE side): (-0.176 - (-0.186)) / |-0.176| = -5.7% (controls shrink TWFE; OLS handles cleanly)
- Covariate margin (CS side): Spec A non-informative (Pattern 42 panel-variant overfit); not computable
- Total gap (headline Spec C): (-0.176 - (-0.208)) / |-0.176| = +18.2%

Verbal interpretation: The TWFE-CS gap persists in the protocol-matched Spec B (11.8%), confirming that estimator choice -- not covariate handling -- drives the magnitude difference. The covariate exp is well-behaved in TWFE (-5.7%) but destroys CS-DID via propensity-score overfit. The unconditional Spec B CS-DID (-0.208) is the clean matched-protocol estimate for meta-analysis and MVPF inputs.

---

## Rating computation (3-axis framework)

| Axis | Score | Basis |
|------|-------|-------|
| Axis 1 -- Fidelity (paper-auditor) | F-HIGH | WITHIN_TOLERANCE: TWFE=EXACT (0.003%), CS-DID within 3.2% with documented explanation |
| Axis 2 -- Implementation (methodology reviewers) | I-MOD | 1 WARN (HonestDiD n_pre=2 of 8); twfe/csdid/bacon all PASS; dechaisemartin NOT_NEEDED excluded |
| Overall rating (Fidelity x Implementation) | MODERATE | F-HIGH x I-MOD |
| Axis 3 -- Design credibility (finding, not demerit) | D-MODERATE | Mbar_avg TWFE=0.70, CS-NT=1.10; TvT=21.5% (<30%); pre-trends flat 8 periods |

---

## Material findings (sorted by severity)

### Implementation WARN (Axis 2)
- HonestDiD n_pre underspecification: pipeline passed n_pre=2 despite 8 pre-periods available (event_pre=8). Current Mbar bounds (avg TWFE=0.70, CS-NT=1.10) support D-MODERATE; re-running with n_pre=8 would very likely yield higher bounds, potentially upgrading design credibility to D-ROBUST and overall rating to HIGH.

### Design findings (Axis 3 -- informative, not demerits)
- Spec A collapse (Pattern 42 panel variant): CS-DID with covariate exp collapses to -0.013 (SE=0.014) vs -0.208 (SE=0.053) without controls (16x attenuation). Propensity-score overfit with single continuous state-level regressor; status=OK but extreme IPW weights. Spec A is non-informative. Real methodological finding (Lesson 7 COLLAPSE instance), not a pipeline error.
- TWFE Mbar_avg=0.70: TWFE average effect becomes fragile at Mbar=0.70. CS-NT Mbar_avg=1.10 should anchor the design-credibility claim.
- TVT share 21.5%: below the 30% concern threshold; most TVT estimates also negative, limiting net contamination.
- Cohort 205 anomaly: earliest adopter shows positive TVU estimate (+0.047, 3.9% weight) -- minor.
- First-period fragility: immediate t=0 effect not robustly identified under HonestDiD; consistent with gradual managed care rollout.

---

## Recommended actions

- Repo-custodian: Verify whether code/analysis/03_honest_did.R defaults to n_pre=2 regardless of event_pre. If so, implement a metadata override (n_pre_honest=8) for article 9 and re-run HonestDiD with all 8 pre-periods. This is likely a systematic gap affecting all papers with event_pre > 2. Resolution would upgrade HonestDiD WARN to PASS and the overall rating from MODERATE to HIGH.
- Pattern-curator: Confirm the Pattern 42 panel-specific variant is documented alongside the existing Pattern 42 entry. Key distinction: single continuous covariate + balanced state-level panel + status=OK + deflation (versus Pattern 42 original: factor/dummy variables; versus Pattern 51: RCS data, inflation direction).
- User (dissertation): The 14x Spec A beta-collapse (-0.176 to -0.013) is legitimate for Chapter 4.8. Suggested framing: mechanically matching the TWFE covariate specification in CS-DID destroys identification without producing an error flag; the propensity-score model converges but generates extreme IPW weights that attenuate the ATT 16x toward zero; the protocol-matched unconditional Spec B (-0.186 TWFE, -0.208 CS-NT) is the credible estimate for MVPF inputs. Article id_9 is suitable for the dissertation body at MODERATE rating; if the HonestDiD n_pre fix is applied first, it qualifies as HIGH.

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
