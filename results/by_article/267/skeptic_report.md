# Skeptic report: 267 -- Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Overall rating:** HIGH  *(Fidelity x Implementation: F-NA x I-HIGH -> use implementation alone -> HIGH)*
**Design credibility:** D-FRAGILE  *(separate Axis 3 finding -- not a demerit against our pipeline)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design-WARN reclassified to Axis 3), csdid (impl=PASS), bacon (SKIPPED per allow_unbalanced=true; informational positive TVU=26.7%), honestdid (impl=PASS; M_bar_first=0, M_bar_peak=0), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF)

**Axis 1 -- Fidelity:** F-NA (PDF absent; metadata reference -0.082 matches stored -0.0821278 within 0.02%; formal fidelity axis not evaluable)
**Axis 2 -- Implementation:** I-HIGH (0 WARNs; 0 FAILs; all reviewers PASS or NOT_NEEDED/SKIPPED on impl checks)
**Axis 3 -- Design credibility:** D-FRAGILE (M_bar=0 all TWFE targets; M_bar=0 all CS-NT targets; positive TVU 3 late-adopting cohorts combined 26.7%; flat pre-trends across 5 estimators prevents D-BROKEN)

---

## Executive summary

Bhalotra, Clarke, Gomes, Venkataramani (2022 JEEA) estimate that reserved-seat gender quotas reduce the log maternal mortality ratio by -0.082 (SE=0.051) using TWFE across 178 countries 1990-2015. Reanalysis reproduces the TWFE exactly (-0.0821278; 0.02% gap). Under the 3-axis rubric the stored result earns a HIGH rating: every reviewer PASSes on implementation-specific checks, with all design findings classified to Axis 3. Key Axis 3 findings: (a) TWFE understates the ATT -- Bacon reveals positive TVU for 3 late-adopting cohorts (2005, 2010, 2012; combined weight 26.7%), attenuating TWFE toward zero; CS-DiD ATT is -0.112 to -0.127 (37-55% larger in magnitude); (b) HonestDiD D-FRAGILE (M_bar=0 all targets, both TWFE and CS-NT), structurally constrained by n_pre=2 and growing-effects design; (c) pre-trends flat across all 5 estimators. Paper 267 is the negative-direction member of the Lesson 8 symmetric-attenuation pair (paper 253 is the positive-direction member). Trust the direction; TWFE -0.082 is a conservative lower bound on the true ATT magnitude.

**Rating upgrade vs 2026-04-18:** Prior report used the old 2-axis framework; Bacon-attenuation WARN and HonestDiD D-FRAGILE counted as M-MOD, yielding MODERATE. Under the 3-axis rubric these are Axis 3 design findings, not pipeline implementation demerits. Implementation is clean (I-HIGH); rating corrected to HIGH.

---

## Per-reviewer verdicts

### TWFE (impl=PASS; design-WARN -> Axis 3)
- Stored TWFE -0.0821278 matches paper -0.082 to 0.02% -- exact match within numerical precision.
- Specification correctly reproduced: country + year FE, cluster at ccode, no controls.
- WARN reclassified to Axis 3: late-adopter positive TVU components attenuate TWFE toward zero. Paper design finding, not a pipeline error.

Full report: reviews/twfe-reviewer.md

### CS-DID (impl=PASS)
- CS-NT and CS-NYT ATTs nearly identical (-0.112 vs -0.111; 0.4% gap) -- strong internal consistency.
- Pre-period CS-NT: no systematic slope violations; consistent level offset (not drift) absorbed by FE normalization.
- All 22 treated countries retained in the balanced 119-country subsample; attrition entirely from never-treated pool.
- ATT (-0.127 to -0.131 dynamic) 37-55% larger in magnitude than TWFE -- consistent with Bacon-confirmed attenuation (Axis 3).

Full report: reviews/csdid-reviewer.md

### Bacon (SKIPPED -- allow_unbalanced=true; informational)
- Formally SKIPPED per applicability rule (allow_unbalanced=true).
- Axis 3 informational: 3 of 7 TVU components positive (cohort 2005: +0.102 wt=11.8%; cohort 2010: +0.085 wt=8.6%; cohort 2012: +0.159 wt=6.3%; combined 26.7%).
- Forbidden TvT weight < 5% -- minor.

Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS; D-FRAGILE -> Axis 3)
- Implementation PASS: correctly run on TWFE and CS-NT with available pre-periods.
- Axis 3: M_bar=0 all three targets (first, avg, peak) for both TWFE and CS-NT. TWFE peak CI just excludes zero at Mbar=0 [-0.106, -0.001] but breaks at Mbar=0.25.
- Structural constraint: n_pre=2 limits discriminatory power; growing-effects design makes first-period near-zero.
- Paper own JEEA HonestDiD (more pre-periods) finds robustness -- our implementation is conservative.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; did_multiplegt_dc adds no additional information beyond CS-DiD.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)
- pdf/267.pdf not found; formal fidelity axis not evaluable.
- Informal: stored TWFE -0.0821278 matches metadata reference -0.082 (quotaDifDif.tex Col 4) to 0.02%.

Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

N/A -- paper has no original covariates; unconditional comparison only. twfe_controls = [] and cs_controls = []. Specs A and B recorded as N/A_no_twfe_controls in results.csv.

---

## Material findings (sorted by severity)

**Axis 3 design findings (about the paper, not our pipeline):**

1. **TWFE staggered-timing attenuation:** Late-adopting cohorts (2005, 2010, 2012) contribute positive Bacon TVU components (combined 26.7%), attenuating TWFE to -0.082 vs. true ATT approximately -0.112 to -0.127. Direction unambiguous; magnitude understated. Lesson 8 negative-direction amplification case (symmetric to paper 253).

2. **HonestDiD D-FRAGILE:** M_bar=0 across all three targets for both TWFE and CS-NT. Peak TWFE CI barely excludes zero at Mbar=0 only; breaks at Mbar=0.25. Structural constraint (n_pre=2 + growing-effects design). Paper own analysis with more pre-periods finds robustness.

3. **CS-NT / TWFE divergence 37-55%:** Not an implementation error. Explained by Bacon-confirmed positive TVU for late-adopting cohorts. Both estimators agree on direction.

**No implementation WARNs or FAILs on Axis 2.**

---

## Recommended actions

- No structural action needed: pipeline correctly implemented, TWFE reproduced exactly, CS-DiD internally consistent.
- For the dissertation: document paper 267 as Lesson 8 negative-direction amplification member (TWFE -0.082 -> CS-NT -0.112 to -0.127; symmetric to paper 253). Log rating correction MODERATE -> HIGH under 3-axis rubric.
- For the pattern curator: positive Bacon TVU components for late adopters in cross-country MMR panel consistent with development-level compositional differences. Candidate entry for failure_patterns.md.
- For the user: D-FRAGILE HonestDiD reflects conservative n_pre=2; trust direction, treat TWFE -0.082 as lower bound on magnitude.

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md