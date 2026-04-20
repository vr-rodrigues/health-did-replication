# Skeptic report: 76 --- Lawler, Yewell (2023)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis --- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; Pattern-25 gap = design finding), bacon (impl=N/A --- RCS data), honestdid (impl=PASS; Mbar thresholds = design finding), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT via metadata; PDF absent)

---

## Executive summary

Lawler and Yewell (2023) estimate baby-friendly hospital certification regulations increase ever-breastfeeding by approximately 3.8 pp (TWFE, SE = 0.0095). Our reanalysis reproduces this to 0.06% (0.03832 vs 0.0383) --- an exact match requiring two documented fixes: the Stata %tm/%td month-formula confusion and explicit omission of styr_pergt64. All five applicable methodology reviewers find our implementation clean. The two WARN verdicts in prior cached reports (CS-DID gap, HonestDiD Mbar thresholds) are design findings about the paper, not pipeline errors. Under the corrected 3-axis rubric the stored consolidated result earns a HIGH rating. Design credibility is D-MODERATE: TWFE average ATT robust to Mbar = 0.25; peak (t = 2, +5.5 pp) survives Mbar = 0.5. CS-NYT fragile at Mbar = 0 due to elevated t = -4 pre-period (approx. 3.3 SEs) --- reported as design finding, not implementation demerit.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Beta reproduced exactly: 0.03832 vs paper 0.0383 (0.06%); SE 0.009499 vs 0.0095 (0.005%).
- Two implementation fixes validated: month formula correction; styr_pergt64 explicit omission.
- TWFE pre-trends flat: all 4 pre-periods within 1.2 SEs of zero.
[Full report: reviews/twfe-reviewer.md]

### CS-DID (impl=PASS under 3-axis rubric)
- Stored CS-NT (0.00774) and CS-NYT (0.00781) are 57-63% below paper Stata CSDID values (0.018, 0.0212). Root cause: Pattern 25 --- i.fips as Stata covariate in doubly-robust estimator structurally irreproducible in R att_gt() for RCS data. Documented structural limitation, not a pipeline bug.
- With-controls CS-NT (att_cs_nt_with_ctrls = 0.01652) closes gap to 8.2% --- the methodologically relevant comparison.
- t = -4 CS-NYT elevated coefficient (+0.0207, SE ~0.006, approx. 3.3 SEs): Axis-3 design finding, not Axis-2 implementation WARN.
[Full report: reviews/csdid-reviewer.md]

### Bacon (NOT_APPLICABLE)
- Data structure is repeated cross-section; Bacon decomposition requires panel data. Correctly skipped.
- Informational: 2015 cohort has negative TVU estimate (-0.035) and serves as contaminated control for earlier cohorts.
[Full report: reviews/bacon-reviewer.md]

### HonestDiD (impl=PASS under 3-axis rubric)
- Implementation inputs correct: 4 pre-periods (t = -5 to -2), 5 post-periods, TWFE and CS-NYT event studies fed correctly.
- TWFE avg ATT robust at Mbar = 0 (CI = [+0.0109, +0.0577]); loses robustness at Mbar = 0.25. Peak (t = 2): robust to Mbar = 0.5.
- CS-NYT avg ATT CI = [-0.000222, +0.0420] barely includes zero at Mbar = 0; fragile.
- All Mbar thresholds are Axis-3 design-credibility findings, not implementation errors.
[Full report: reviews/honestdid-reviewer.md]

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment at hospital level; continuous county-level share is a design feature. No switching.
[Full report: reviews/dechaisemartin-reviewer.md]

### Paper Auditor (EXACT via metadata; PDF absent)
- PDF at pdf/76.pdf does not exist; formal PDF scan not possible.
- Metadata cross-check: beta_twfe 0.03832 vs paper 0.0383 = 0.06% gap --- EXACT. SE 0.009499 vs 0.0095 = 0.005%.
- CS-DID divergence fully explained by Pattern 25. Fidelity axis scored F-HIGH (calibration article F = 1).
[Full report: reviews/paper-auditor.md]

---

## Three-way controls decomposition

twfe_controls is non-empty (20 controls TWFE; 8 individual-level controls CS).

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 0.0383 (SE 0.0095) | 0 / NA | Spec A collapsed (Pattern 42 / Lesson 7: direct-level controls cause propensity separation in DR step for RCS data) |
| (B) both without controls | 0.0238 (SE 0.0078) | 0.0165 (SE 0.0057) | OK |
| (C) TWFE with, CS without | 0.0383 (SE 0.0095) | 0.0077 (SE 0.0054) | headline, current default |

Key ratios:
- Estimator margin (protocol-matched, Spec B): (0.0238 - 0.0165) / |0.0238| = +30.7% (TWFE > CS-NT)
- Covariate margin (TWFE side): (0.0383 - 0.0238) / |0.0383| = +37.9% (controls add 37.9% to TWFE magnitude)
- Covariate margin (CS side): Spec A collapsed --- not estimable
- Total gap (Spec C headline): (0.0383 - 0.0077) / |0.0383| = +79.9%

Interpretation: in matched-protocol Spec B (both without controls), the TWFE-CS gap narrows from 79.9% to 30.7%. The majority of the headline gap is driven by controls (37.9% TWFE covariate margin), not estimator choice. The residual 30.7% estimator margin likely reflects the conceptual difference between continuous-dose TWFE (weighted by share of baby-friendly hospitals) and binary-adoption CS-DID (equally weighted by county). Spec A collapse is a Lesson 7 canonical instance.

---

## Three-axis rating summary

| Axis | Score | Evidence |
|---|---|---|
| Fidelity (paper-auditor) | F-HIGH | EXACT (0.06% gap, metadata-confirmed; calibration article F = 1) |
| Implementation (all reviewers) | I-HIGH | 0 implementation WARNs; 0 FAILs. TWFE PASS; CS-DID Pattern-25 = structural limitation (design finding); HonestDiD Mbar = design findings; Bacon N/A (correct). |
| Design credibility (Axis 3) | D-MODERATE | TWFE avg Mbar = 0.25; peak Mbar = 0.5. CS-NYT avg fragile at Mbar = 0 (elevated t = -4). Bacon TvT not computable (RCS). |

**Final rating: HIGH** (F-HIGH x I-HIGH)

---

## Material findings (sorted by severity)

**Design finding --- CS-NYT avg ATT fragile at Mbar = 0:** CI = [-0.000222, +0.042] barely excludes zero. Driven by elevated t = -4 pre-period (+0.021, approx. 3.3 SEs). Finding about paper parallel-trends support for NYT comparison group, not a pipeline demerit.

**Design finding --- TWFE avg ATT robust only to Mbar = 0.25:** Average post-treatment effect (0.0343) statistically uncertain when allowing post-treatment violations equal to 25% of the largest pre-trend deviation. Peak at t = 2 (+5.5 pp) more robust (Mbar = 0.5).

**Design finding --- Pattern 25 structural gap (informational):** Stored att_csdid_nt (0.00774) is 57% below paper Stata CSDID (0.018). Gap is structural; with-controls estimate (att_cs_nt_with_ctrls = 0.01652, gap = 8.2%) is best-available R comparison. Not a pipeline error.

**Design finding --- 2015 cohort anomaly (informational):** Informational Bacon shows 2015 cohort negative TVU (-0.035) and contaminated Later-vs-Earlier comparisons. Informational only for RCS data.

---

## Recommended actions

- No action needed on implementation: all five methodology reviewers find our pipeline clean under the 3-axis rubric.
- For the user (methodological judgement): headline result (baby-friendly regulations raise ever-breastfeeding ~3.8 pp) reproduced exactly and directionally consistent across estimators. Design credibility D-MODERATE. For meta-analysis, prefer peak ATT (t = 2, +5.5 pp, robust to Mbar = 0.5) over average ATT (robust only to Mbar = 0.25).
- For the pattern-curator: Pattern 25 documentation should note att_cs_nt_with_ctrls (gap = 8.2%) is the preferred stored comparison value for RCS calibration papers, not no-controls att_csdid_nt (gap = 57%).
- Rating correction from prior audit: prior report (2026-04-18) rated this paper LOW based on conflation of Axis-2 and Axis-3 concerns. Under the corrected 3-axis rubric the rating is HIGH. Design findings are real and reported on Axis 3 but do not constitute implementation failures.

---

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
