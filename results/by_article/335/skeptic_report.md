# Skeptic report: 335 -- Le Moglie, Sorrenti (2022)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-FRAGILE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS, design-findings=2), bacon (N/A -- single cohort), honestdid (impl=PASS, Mbar_avg_TWFE=0 barely robust, Mbar_avg_CS=0 barely robust), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, delta=-1.14%)

## Executive summary

Le Moglie and Sorrenti (2022) estimate the effect of mafia presence on new enterprise formation in Italian provinces following the 2007 financial crisis, using a single-cohort DiD where 28 high-mafia provinces (top tertile of Transcrime Mafia Index) are treated from 2007 onward, compared to 56 never-treated provinces. The headline TWFE estimate is reproduced exactly (beta=0.04053 vs paper 0.041; gap=-1.14%; N=924 exact match). Our implementation is clean: correct single-cohort structure, correct fixed effects, correct sample, correct cluster level. The stored consolidated_results value reliably reflects the published number.

Two findings about the design, not our pipeline, warrant disclosure. First, HonestDiD shows the average ATT is robust only under strict parallel trends (Mbar=0: TWFE avg CI=[0.005, 0.053]); Mbar=0.25 causes all targets to include zero. Second, Spec A (doubly-robust CS-DID with the 18 time-varying level controls) collapses to ATT=0.000, SE=NA, status=OK -- an instance of Pattern 42 propensity-score separation induced by direct time-varying level variables (pop_urb, tourism, banking) in a single-cohort doubly-robust estimator. This distinguishes paper 335 from paper 25 (Carrillo-Feres, also 18 controls, Spec A clean), where controls enter as pre-treatment x linear-trend interactions rather than contemporaneous levels. Control structure matters more than count. These are findings, not demerits: our rating is HIGH.

## Per-reviewer verdicts

### TWFE (PASS)
- Single-cohort DiD eliminates heterogeneous timing concerns; TWFE is appropriate and unambiguous. Coefficient reproduced exactly (0.04053 vs paper 0.041, gap=-1.14%).
- Pre-period coefficients near zero (t=-4: -0.007, t=-3: -0.002, t=-2: +0.007); no pre-trend concern in TWFE event study.
- SE difference (clustered 0.01274 vs Conley 0.0107) is documented, expected, does not affect the coefficient match.

Full report: reviews/twfe-reviewer.md

### CS-DID (PASS -- design findings noted on Axis 3)
- ATT_CS-NT = 0.04636 is 14% above TWFE (0.04053). Gap attributable to absence of controls in CS specification (cs_controls=[]) -- a documented design choice, not a pipeline error.
- CS pre-event study shows mild upward drift at t=-3 (0.016, SE=0.019) and t=-2 (0.020, SE=0.017). Not individually significant; Axis 3 design finding.
- Spec A (doubly-robust CS-DID with 18 time-varying level controls): att_cs_nt_with_ctrls=0.000, SE=NA, status=OK. Pattern 42 propensity-score separation from contemporaneous level controls in single-cohort g=2007. Template ran correctly; collapse is structural. Axis 3 design finding. Contrast with paper 25 where same control count is fine because controls are baseline x time interactions.

Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- Skipped: treatment_timing = single. Single 2007 cohort produces trivial 100% TvU decomposition -- uninformative.

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS -- D-FRAGILE design finding)
- Average ATT robust at Mbar=0: TWFE avg CI [0.005, 0.053], CS-NT avg CI [0.010, 0.083] -- both exclude zero. Peak also robust at Mbar=0 (TWFE: [0.002, 0.074]).
- All targets include zero at Mbar=0.25. Any modest anticipation or differential provincial dynamics erases significance.
- First post-period (t=0) not individually robust even at Mbar=0 (CI=[-0.009, 0.038]) -- mechanically expected.
- Design credibility: D-FRAGILE (Mbar threshold for avg ATT = 0).

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment, single cohort, no switchers or dose heterogeneity. DH estimator replicates CS-NT exactly. No diagnostic value.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (EXACT)
- PDF confirmed present as of 2026-04-19 (pdf/335.pdf).
- Stored beta (0.04053) reproduces Table 2, Column 5 (complete model) with gap=-1.14%, N=924 exact, significance *** match.
- SE divergence (15.8%: clustered 0.01274 vs Conley spatial HAC 0.0107) is documented and expected. Does not affect verdict.
- Fidelity axis: F-HIGH (EXACT).

Full report: reviews/paper-auditor.md

## Three-way controls decomposition

Paper 335 has non-empty twfe_controls (18 time-varying variables). Three-way decomposition is relevant.

From results/by_article/335/results.csv:

| Spec | TWFE | CS-NT | Status |
|---|---|---|---|
| (A) both with controls | beta=0.04053 (SE=0.01274) | ATT=0.000 (SE=NA) | FAIL_Pattern42: propensity-score separation from 18 direct time-varying level controls in single-cohort DR estimator |
| (B) both without controls | beta=0.03809 (SE=0.02101) | ATT=0.04636 (SE=0.01824) | OK |
| (C) TWFE with, CS without | beta=0.04053 (SE=0.01274) | ATT=0.04636 (SE=0.01824) | -- (current headline, legacy default) |

Key ratios:
- Estimator margin (Spec A, protocol-matched): undefined -- Spec A CS collapses; ratio not computable.
- Covariate margin TWFE side (C vs B): (0.04053 - 0.03809) / 0.04053 = +6.0%.
- Covariate margin CS side: Spec A collapses; not computable.
- Total gap current headline (Spec C): (0.04053 - 0.04636) / 0.04053 = -14.4%.

Verbal interpretation: Spec A collapse means the matched-protocol estimator is unavailable. The Spec C gap (-14.4%) is controls-driven; Spec B (both without controls: TWFE=0.038, CS=0.046, gap=+21%) confirms a residual estimator-difference also contributes. This is the canonical COLLAPSE-single-cohort exemplar of Lesson 7 (Chapter 4 sec:spec_a_hexagon), contrasted with paper 25 (Carrillo-Feres, Spec A clean at gap=16.4% because controls are baseline x time interactions not levels). Control structure, not count, determines Spec A feasibility. Contributes to Deliverable D1 (QJE review, 2026-04-17).

## Axis rating derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity (Axis 1) | F-HIGH | Paper-auditor EXACT (-1.14%); N=924 exact; *** match; PDF confirmed |
| Implementation (Axis 2) | I-HIGH | All applicable reviewers PASS on implementation checks. TWFE PASS (8/8). CS-DID design findings on Axis 3; Spec A collapse (Pattern 42) structural, status=OK. HonestDiD PASS. Bacon N/A. DH NOT_NEEDED. 0 implementation WARNs, 0 FAILs. |
| Design credibility (Axis 3) | D-FRAGILE | Avg ATT robust only at Mbar=0; all targets include zero at Mbar=0.25. Spec A collapse Pattern 42. Mild CS pre-trend drift t=-3/t=-2. Mbar threshold=0 -> D-FRAGILE. |
| Overall rating | HIGH | F-HIGH x I-HIGH = HIGH. D-FRAGILE is a finding about the paper, not a demerit against our reanalysis. |

## Material findings (sorted by severity)

Design findings (Axis 3 -- findings about the paper, not implementation demerits):

- [D-FRAGILE -- HonestDiD] Average ATT survives only at Mbar=0. Mbar=0.25 causes all targets to include zero for TWFE and CS-NT. Any modest anticipation or differential provincial dynamics erases statistical significance.
- [Pattern 42 -- Spec A collapse] Doubly-robust CS-DID with 18 time-varying level controls produces ATT=0.000, SE=NA, status=OK. Propensity-score separation: single treated cohort (g=2007) with 18 contemporaneous-level controls provides insufficient within-group propensity variation. Contrast with paper 25 (18 controls as baseline x time interactions, Spec A clean). Control structure, not count, determines Spec A feasibility.
- [Mild CS pre-trend] CS-NT event study: upward drift at t=-3 (0.016, SE=0.019) and t=-2 (0.020, SE=0.017). Not individually significant. TWFE pre-trends flat (all within +/-0.007).

No implementation WARNs or FAILs.

## Recommended actions

- No action needed on TWFE, Bacon, or de Chaisemartin axes.
- No action needed on fidelity: EXACT match confirmed, PDF present and audited.
- For the dissertation (Chapter 4 sec:spec_a_hexagon): paper 335 is the canonical COLLAPSE-single-cohort cell in the Lesson 7 quadrangulum. Report Spec A collapse (Pattern 42) as a design-structure finding, explicitly contrasted with paper 25 (CLEAN cell, pre-treatment x trend controls). Quadrangulum: (a) 25 Carrillo 18 pre-treat x trends CLEAN; (b) 79 Carpenter 53 demographic staggered COLLAPSE; (c) 125 Levine 6 RCS individual INFLATE; (d) 335 Le Moglie 18 direct-level single-cohort COLLAPSE.
- For the user (methodological judgement call): D-FRAGILE is a disclosable limitation. Report that average effect survives under maintained parallel trends but is sensitive to Mbar=0.25. Flat TWFE pre-trends make Mbar=0 the most credible maintained assumption; mildly rising CS pre-trends at t=-3/t=-2 introduce residual uncertainty.
- For the pattern-curator: consider adding a Pattern 42 sub-entry distinguishing single-cohort direct-level variant (335) from staggered-design variant (79, 201) to refine guidance for future papers.

## Lesson 7 context (quadrangulum)

This paper is the canonical COLLAPSE-single-cohort cell. The Lesson 7 quadrangulum (Chapter 4 sec:spec_a_hexagon):

| Cell | Paper | Controls | Design | Spec A outcome |
|---|---|---|---|---|
| CLEAN (pre-treat x trends) | 25 Carrillo-Feres | 18 baseline x time interactions | Staggered | ATT=0.097, matched gap=16.4% vs TWFE |
| COLLAPSE (staggered) | 79 Carpenter | 53 demographic levels | Staggered RCS | ATT collapses, Pattern 42 |
| INFLATE (RCS individual) | 125 Levine | 6 individual-level RCS | RCS panel | ATT inflated, control-collinearity |
| COLLAPSE (single-cohort levels) | 335 Le Moglie | 18 direct time-varying levels | Single-cohort panel | ATT=0.000, SE=NA, Pattern 42 |

Distinguishing mechanism for 335 vs 79: in 335 separation occurs from contemporaneous level controls in a single-cohort DR estimator with only treated vs never-treated propensity variation in g=2007. In 79, collapse occurs from demographic controls under staggered timing. Both are Pattern 42 with distinct structural causes.

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
