# Skeptic report: 253 — Bancalari (2024)

**Overall rating:** HIGH  *(built from Fidelity × Implementation: F-NA × I-HIGH → use implementation alone)*
**Design credibility:** D-FRAGILE  *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; CS-TWFE gap=Axis3), bacon (impl=N/A — design finding; TVU=24.5%, LvAT=19.5%, LvE+EvL=56.0%), honestdid (impl=PASS; M_avg=0 at Mbar=0, breaks above; M_peak=0), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE; metadata-level fidelity EXACT 0.41%)

## Executive summary

Bancalari (2024) (REStat) studies the unintended consequences of staggered sewerage infrastructure rollout across 1,467 Peruvian districts (2005-2015), with outcome = 1-year infant mortality rate (vs_imr1y). The paper's headline TWFE = +0.74 (SE=0.42) is reproduced to 0.41% (our beta=0.737, SE=0.416 — EXACT by the rounding threshold). Our implementation is clean on all applicable axes: correct FE structure, correct cluster level, correct dataset, no controls (matched to paper), and all five estimators (TWFE, CS-NT, CS-NYT, SA, Gardner) confirm a positive and monotonically growing direction. The CS-NT vs TWFE divergence (our CS-NT dynamic ATT = 2.97 vs paper CS-DID = 1.79) is a design-level finding — Axis 3 — not an implementation failure: the paper itself acknowledges TWFE attenuation, and Bacon decomposition confirms the mechanism (75.5% of weight in forbidden timing comparisons, all LvAT estimates negative). The 65% gap between our stored CS-NYT dynamic aggregation and the paper's Stata pair-balanced value is a documented software-aggregation artefact for late small cohorts; pair-balanced estimation recovers 1.78 (exact match). HonestDiD M_bar = 0 at all targets for both TWFE and CS-NT, reflecting the structural difficulty of distinguishing growing effects from accelerating pre-trends with a 6-period pre-window — a design property, not a pipeline error. The stored TWFE = 0.737 is trustworthy as a faithful replication of the paper's published number. The design credibility diagnosis (D-FRAGILE) is an informative finding about the paper that the reanalysis has surfaced correctly.

## Per-reviewer verdicts

### TWFE (PASS)
- Coefficient exact: beta=0.737 vs paper 0.74 (0.41% gap); SE=0.416 vs 0.42 (0.95% gap). Both within rounding.
- Pre-period coefficients all statistically insignificant (t=-6 to t=-2), oscillating around zero. No systematic drift.
- Post-treatment trajectory monotonically growing t=0 (+0.84) to t=7 (+4.45), consistent with accumulating infrastructure effect.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS on implementation; WARN is Axis 3 design finding)
- CS-NT dynamic ATT = 2.974, CS-NYT dynamic ATT = 2.949 — internally consistent (0.8% difference), expected given 78% of districts have some pre-treatment period.
- Gap from paper's CS-DID (1.79): 65% divergence is a software-aggregation artefact — R's `att_gt` with `allow_unbalanced_panel=TRUE` produces extreme values for late small cohorts (2014-2015: ATT = -8.6, -6.4); pair-balanced estimation recovers 1.78 (exact match). This is Axis 3 (software ecosystem difference), not Axis 2 (our pipeline error).
- t=-3 CS-NT pre-period borderline elevated (+1.661, SE=1.03, t=1.62) — noted as design signal.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (Axis 3 design finding — implementation N/A)
- Weight decomposition: TVU (clean) = 24.5%; LvAT (Later vs Always Treated) = 19.5%; LvE+EvL (forbidden timing) = 56.0%.
- Total contaminated weight = 75.5% — well above the 50% D-FRAGILE threshold.
- All 10 LvAT pairs (cohorts vs always-treated cohort 2005 as pseudo-control) show negative estimates, mechanically pulling TWFE down by ~1-2 IMR points. This is the Bacon-attenuation mechanism acknowledged by the paper itself.
- TVU estimates all positive (range: +0.84 to +5.12), confirming the direction is genuine.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS on implementation; M_bar=0 is Axis 3 design finding)
- TWFE: M_bar_first=0, M_bar_avg=0, M_bar_peak=0. Average and peak effects survive Mbar=0 (avg CI=[0.815,3.617]; peak CI=[1.929,6.970]) but break immediately above.
- CS-NT: M_bar_first=0, M_bar_avg=0 (barely, lb=0.028), M_bar_peak=0.
- Structural explanation (Axis 3): 6-period pre-window × growing post-treatment effect (5x from t=0 to t=7) means HonestDiD cannot distinguish accelerating treatment effect from accelerating pre-trend at any Mbar>0. Pre-trends are visually flat and all insignificant — this is a formal property of the test, not a substantive indication of pre-trend violation.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing-binary-staggered design. No dose variation, no switching. CS-DID covers this design.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Three-way controls decomposition

N/A — paper has no original covariates (`twfe_controls=[]`); unconditional comparison only. Specs A and B collapse to Spec C (no controls on either side). `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`.

## Material findings (sorted by severity)

- [Axis 3 / Design] Bacon forbidden-comparison weight = 75.5% (LvAT=19.5% + LvE/EvL=56.0%). All LvAT estimates negative. This is the mechanistic explanation for TWFE (+0.74) vs CS-DID (1.79-2.97) divergence — growing effects under staggered timing with an always-treated cohort as pseudo-control. The paper acknowledges this.
- [Axis 3 / Design] HonestDiD M_bar=0 at all targets (TWFE and CS-NT). Structural consequence of 6-period pre-window combined with monotonically growing post-treatment effect (+0.84 to +4.45 over 8 periods). Not a sign of actual pre-trend violation — pre-period coefficients all insignificant.
- [Axis 3 / Software] CS-NYT dynamic ATT in our pipeline (2.95) is 65% above the paper's Stata pair-balanced value (1.79). Pair-balanced estimation recovers 1.78 exactly. Root cause: R `allow_unbalanced_panel=TRUE` produces extreme ATT(g,t) for small late cohorts (2014: -8.6; 2015: -6.4) that inflate dynamic aggregation. Documented technical artefact; simple ATT is more stable (2.51).
- [Axis 3 / Design] Cohort 2005 (78 units, first available period) is treated as always-treated and dropped by CS-DID pre-treatment base computation. Accepted structural constraint; consistent across software.

## Recommended actions

- No implementation action needed. All methodology reviewers PASS on Axis 2. The rating is HIGH.
- For the dissertation / Lesson 2 amplification quartet discussion: record Bancalari (2024) as the canonical Lesson 8 case where Bacon-attenuation is acknowledged in the paper itself. The TWFE/CS-DID 2.4x gap is fully mechanistically explained and not a reanalysis ambiguity.
- For users comparing stored CS-NYT dynamic (2.95) to paper (1.79): note the R/Stata aggregation artefact and prefer pair-balanced ATT = 1.78 or simple ATT = 2.51 for paper-adjacent comparisons.
- No pattern-curator action needed (the R/Stata aggregation artefact for small late cohorts is already documented in the metadata notes).

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
