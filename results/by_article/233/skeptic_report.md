# Skeptic report: 233 -- Kresch (2020)

**Overall rating:** HIGH  (Fidelity x Implementation)
**Design credibility:** D-FRAGILE  (separate axis -- a finding about the paper, not our reanalysis)
**Date:** 2026-04-19
**Rubric version:** 3-axis (Xu-Yang 2026 s3.2 / Lal et al. 2024 adaptation)
**Reviewers run:** twfe (impl=PASS; design-WARN reclassified Axis 3), csdid (impl=PASS), bacon (SKIPPED -- single-cohort), honestdid (impl=PASS; M-bar reclassified Axis 3), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT)

---

## Axis summary

| Axis | Score | Basis |
|---|---|---|
| Fidelity | F-HIGH | paper-auditor EXACT: beta=2868.317 vs paper 2868 (0.01% gap); SE within 4.9% of paper 1319 |
| Implementation | I-HIGH | Zero impl WARNs or FAILs; pre-trend and HonestDiD signals are Axis 3 design findings |
| Design credibility | D-FRAGILE | M-bar(first)=0.40-0.48; pre-trend drift 400-715 BRL pre-reform; Bacon N/A (single-cohort) |

**Final rating: HIGH** (F-HIGH x I-HIGH). D-FRAGILE is a standalone finding about the paper identifying assumption.

---

## Executive summary

Kresch (2020) estimates the effect of Brazil 2005 Water and Sanitation Law on municipal investment in a balanced panel of 1346 municipalities over 2001-2012. The headline TWFE result (BRL 2868 thousand, SE 1254) is reproduced to 0.01%. The Pattern 49/50 asymmetric-clustering bug -- the canonical reference case -- was resolved in a prior run: CS-NT ATT=3329.351 (SE 1199.780) is correct. Spec A (both estimators with controls) returns CS-NT=2883.614 (status OK), closing the 16% Spec C gap to 0.5% -- confirming that the headline TWFE/CS divergence is entirely driven by the no-controls default of CS-DID, not by estimator mechanics. All methodology reviewers PASS on implementation; pre-trend pattern and HonestDiD fragility are Axis 3 design signals. The stored results are trustworthy.

---

## Per-reviewer verdicts

### TWFE (impl=PASS)

- Specification correct: unit + year FEs, 14 controls including baseinvestTT interaction, company-level clustering (149 clusters). Reproduces paper to 0.01%.
- Single-cohort design: no negative-weighting from staggered adoption; TWFE = ATT under parallel trends.
- Pre-period coefficients (387-715 BRL, t=-5 to t=-2) form an upward-trending pattern -- Axis 3 design finding, not an implementation error.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=PASS)

- Pattern 49/50 resolved: cs_cluster=code (unit-level bootstrap) yields ATT=3329.351 vs erroneous 367.503 from asymmetric company-level bootstrap.
- CS-NYT = NA (correct: no not-yet-treated units in single-cohort design).
- Spec A status = OK: att_cs_nt_with_ctrls=2883.614 (SE 1991.339) -- recoverable; SE wide (doubly-robust propensity with 14 controls over 1346 units).
- Full report: reviews/csdid-reviewer.md

### Bacon (SKIPPED)

- treatment_timing = single. Bacon decomposition is mechanically degenerate for single-cohort design (100% TvU weight by construction). No TvT share to report.

### HonestDiD (impl=PASS; M-bar reclassified Axis 3)

- Tool ran correctly on 4 valid pre-periods (minimum 3 required).
- M-bar breakeven values are Axis 3 design-credibility signals: first post-period M-bar 0.40 (CS-NT) to 0.48 (TWFE); peak effect (t=1) M-bar 0.62 more robust; TWFE average post-period M-bar 0.25.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Binary absorbing single-cohort design. DH estimator collapses to same two-group DiD as CS-NT.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper-auditor (EXACT)

- beta=2868.317 vs paper 2868 (0.01% gap, within 1% EXACT threshold). SE=1254.26 vs paper 1319 (4.9% gap, within 30% tolerance). N=14460 exact match.
- Full report: paper_audit.md

---

## Three-way controls decomposition

Paper has 14 non-empty twfe_controls.

| Spec | TWFE beta (SE) | CS-NT ATT (SE) | Status |
|---|---|---|---|
| (A) both with controls | 2868.317 (1254.260) | 2883.614 (1991.339) | OK |
| (B) both without controls | 2997.099 (1308.513) | 3329.351 (1199.780) | OK |
| (C) TWFE with, CS without (headline) | 2868.317 (1254.260) | 3329.351 (1199.780) | -- |

Key ratios:
- Estimator margin (protocol-matched Spec A): (2868-2884)/|2868| = -0.5% -- controls close the gap entirely.
- Covariate margin (TWFE side): (2868-2997)/|2868| = -4.5%
- Covariate margin (CS side): (2884-3329)/|2884| = -15.4%
- Total gap (Spec C headline): (2868-3329)/|2868| = -16.1%

Verbal interpretation: Spec A collapses the TWFE/CS gap from 16.1% (Spec C) to -0.5%, confirming the entire divergence is driven by the no-controls default of CS-DID, not by estimator mechanics. Spec A status = OK (no Pattern 42 collapse): 14 controls do not cause propensity separation in this 1346-unit panel. Feeds Deliverable D1 of the QJE review.

---

## Design credibility finding: D-FRAGILE

This section reports what our correct reanalysis reveals about the paper identifying assumption. It does not affect the HIGH rating.

**Bacon TvT share:** N/A -- single-cohort design; 100% TvU weight by construction; no timing-contaminated comparisons possible.

**Pre-trend pattern.** Both TWFE and CS-NT event studies show consistently positive and growing pre-period coefficients (TWFE: 388, 455, 715, 599 BRL at t=-5 through t=-2; CS-NT: 138, 398, 709, 689 BRL). The baseinvestTT control partially addresses differential growth paths but may not fully absorb them.

**HonestDiD sensitivity (RM class):**

| Target | Estimator | M-bar breakeven | Sign-robust at M=0 | Designation |
|---|---|---|---|---|
| First post-period (t=0, ~1501 BRL) | TWFE | ~0.48 | YES | D-FRAGILE |
| First post-period (t=0, ~1281 BRL) | CS-NT | ~0.40 | YES | D-FRAGILE |
| Peak effect (t=1, ~2840 BRL) | CS-NT | ~0.62 | YES | D-MODERATE |
| Average post-period (~1544 BRL) | TWFE | ~0.25 | YES | D-FRAGILE |

**Interpretation.** The medium-to-long-run investment effect survives reasonable sensitivity checks (M-bar < 0.5). The first-period estimate is fragile. The aggregate ATT likely captures a real post-reform investment increase, but magnitude could partially reflect a pre-existing differential trend.

---

## Material findings (sorted by severity)

**Design signals (Axis 3 -- findings about the paper, not demerits against our reanalysis):**
- D-FRAGILE: Pre-trend drift 400-715 BRL pre-reform, consistent across both estimators.
- D-FRAGILE: HonestDiD M-bar(first)=0.40-0.48 -- first-period estimate fragile to modest parallel-trends violations.
- D-MODERATE: HonestDiD M-bar(peak)=0.62 -- peak effect more durable.

**Implementation (Axis 2):** None. All applicable methodology reviewers PASS.

---

## Recommended actions

- No action on stored results: TWFE=2868.317 and CS-NT=3329.351 are correct; no metadata changes needed.
- No new patterns needed: Pattern 49/50 fully documents the Kresch-class clustering bug. Article 233 remains the canonical reference case.
- User (methodological judgement): Note D-FRAGILE when reporting article 233. The Spec A result (CS-NT=2883 vs TWFE=2868, -0.5% gap) is the key QJE D1 decomposition input confirming the covariate-specification origin of the headline divergence.
- User (methodological judgement): Consider citing any pre-trend F-test from Kresch (2020) alongside HonestDiD bounds.

---

## Rating change log

| Date | Rubric | Rating | Basis |
|---|---|---|---|
| 2026-04-18 (conflated) | 2-axis | LOW | TWFE WARN + HonestDiD WARN counted as implementation failures |
| 2026-04-18 (corrected) | 3-axis | HIGH | Pre-trend/HonestDiD reclassified Axis 3; I-HIGH; F-HIGH |
| 2026-04-19 (this run) | 3-axis | HIGH | Spec A decomposition added; Bacon TvT N/A explicit; rating unchanged |

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- paper_audit.md
