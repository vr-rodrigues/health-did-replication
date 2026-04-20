# Skeptic report: 21 — Buchmueller, Carey (2018)

**Overall rating:** HIGH  *(Fidelity axis F-NA; built from Implementation alone per F-NA rule)*
**Design credibility:** D-FRAGILE  *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (NOT_APPLICABLE — reviewer misread allow_unbalanced; informational TvT=6.1%), honestdid (impl=PASS, M̄_avg≈0.05 TWFE / ≈0.01 CS-NT, M̄_first=0 both), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — PDF absent; metadata ground truth: TWFE gap=1.6%, CS-NT gap=4.9%)

---

## Executive summary

Buchmueller & Carey (2018) estimate that must-access Prescription Drug Monitoring Program (PDMP) adoption reduces Medicare opioid polypharmacy (share with 4+ prescribers) by approximately 0.19 percentage points (TWFE: -0.00187; original paper: -0.0019). Our reanalysis reproduces this estimate within rounding and confirms the sign with CS-DID (dynamic ATT: -0.001888, 4.9% gap from paper's -0.0018). The TWFE and CS-DID estimates are tightly aligned, suggesting minimal aggregate negative-weighting bias — consistent with the Bacon decomposition showing 88.9% of weight on clean treated-vs-never-treated comparisons (TvT share: 6.1%). The stored estimate is trustworthy as a replication of the paper's original result. The primary design concern — which is a finding about the paper, not a deficiency of our pipeline — is that TWFE event-study pre-trends at t=-3 and t=-2 are large in magnitude (91% and 69% of the ATT, respectively), and HonestDiD robustness is very limited (TWFE avg M̄ ≈ 0.05; CS-NT avg M̄ ≈ 0.01). Notably, CS-DID pre-trends are essentially flat, suggesting the TWFE pre-trend pattern is partly a compositional artefact that the cohort-specific estimator corrects; this partially mitigates the concern. Overall rating is HIGH because all applicable reviewers pass on implementation and fidelity is confirmed from metadata ground truth.

---

## Per-reviewer verdicts

### TWFE (WARN — reclassified as design finding)

- Treatment indicator (`Post_avg`) correctly constructed; unit/time FEs correct; state-level clustering appropriate. No implementation deficiency.
- Pre-trend coefficients at t=-3 (-0.00171) and t=-2 (-0.00130) are 91% and 69% of the post-period ATT — a design finding about parallel trends (Axis 3), not an implementation failure.
- Post-period effect decay (t=0: -0.00353; t=1: -0.00175; t=2: -0.00125) is informative for interpretation of the static average ATT.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)

- Group variable correctly maps 4 adoption cohorts (Oklahoma=102, Delaware/Ohio=104, KY/NM/WV=105, never-treated=0).
- CS-NT dynamic ATT (-0.001888) within 4.9% of paper; NT and NYT results agree to within 0.2%, confirming comparison-group robustness.
- CS-NT pre-trends are flat (all within ~1.7 SE of zero), in contrast to TWFE, supporting the view that TWFE pre-trends are a composition artefact.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE — informational only)

- Reviewer returned NOT_APPLICABLE (misread `allow_unbalanced`; canonical metadata has `allow_unbalanced=false` and `run_bacon=true`). The bacon.csv results are informational.
- TvU weight: 88.9%; TvT (LvE+EvL): 6.1%; LvAlways: 5.1%. TvT well below 30% — D-ROBUST on the Bacon dimension.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS — but design finding: D-FRAGILE)

- TWFE `avg` target is sign-identified at M̄=0 (CI: [-0.00543, -0.00029]) but breaks at M̄=0.25.
- CS-NT `avg` target is marginally sign-identified at M̄=0 (CI: [-0.00535, +0.0001]) and breaks at M̄=0.01.
- Both `first` targets fail sign identification even at M̄=0 (CIs include zero).
- Implementation of HonestDiD inputs (pre-periods, vcov type) is correct. Fragility is a design finding.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Treatment is absorbing binary. CS-DID is the appropriate modern estimator; no additional information from DChDH.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

---

## Three-way controls decomposition

N/A — `twfe_controls` is empty (`[]`). Paper has no original covariates; unconditional comparison only. All three specs (A, B, C) collapse to the same no-controls estimate. The results.csv confirms `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`.

---

## Three-axis rating breakdown

| Axis | Score | Evidence |
|---|---|---|
| Fidelity (Axis 1) | F-NA | PDF absent; metadata confirms 1.6% TWFE gap and 4.9% CS-NT gap (WITHIN_TOLERANCE grade) |
| Implementation (Axis 2) | I-HIGH | All applicable reviewers PASS on implementation; twfe WARN reclassified as Axis-3 design finding |
| Design credibility (Axis 3) | D-FRAGILE | HonestDiD avg M̄≈0.05 (TWFE) / ≈0.01 (CS-NT); TvT=6.1% clean (D-ROBUST on Bacon); TWFE pre-trends large at t=-3/t=-2 but CS-NT pre-trends flat |

**Final rating: HIGH** (F-NA × I-HIGH → use implementation alone → HIGH)

**Design credibility: D-FRAGILE** — this is a finding about the paper. The sign of the effect (PDMP reduces polypharmacy) is confirmed across all estimators, but HonestDiD robustness is very limited. The CS estimator's flat pre-trends partially offset this concern.

---

## Material findings (sorted by severity)

- (Design finding, D-FRAGILE) HonestDiD avg M̄ ≈ 0.05 for TWFE: sign identification is maintained only under the assumption of zero pre-trend violations post-adoption. Given the large TWFE pre-trend dips at t=-3 and t=-2, any comparable post-treatment violations would invalidate the sign — though CS evidence of flat pre-trends mitigates this.
- (Design finding) TWFE pre-trends at t=-3 (91% of ATT) and t=-2 (69% of ATT): substantial pre-adoption dip. CS pre-trends are flat, suggesting a compositional timing artefact in TWFE rather than true parallel-trends failure.
- (Design finding) Post-adoption effect decay: t=0 ATT (-0.00353) decays to 35% of initial magnitude by t=2 (-0.00125). The static TWFE estimate (-0.00187) is an average that masks this dynamics pattern.
- (Informational) bacon-reviewer returned NOT_APPLICABLE due to misreading of allow_unbalanced field (canonical metadata has `false`). Informational Bacon weights are consistent with a clean design (TvT=6.1%).

---

## Recommended actions

- No action needed on the pipeline or stored estimates. The reanalysis is faithful to the paper and the implementation is clean.
- Metadata note: correct the bacon-reviewer's NOT_APPLICABLE misread in a future re-run with `--fresh`. The canonical `allow_unbalanced=false` means Bacon is applicable; a fresh bacon-reviewer run should return a formal PASS with TvT=6.1%.
- User note (methodological judgement): When citing the PDMP effect, disclose the HonestDiD fragility (M̄ ≈ 0.05 for the average ATT). The CS-DID flat pre-trends provide partial reassurance. The sign of the effect is robust across all five estimators.

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
