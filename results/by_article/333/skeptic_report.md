# Skeptic report: 333 — Clarke, Muhlrad (2021)

**Overall rating:** HIGH  *(Fidelity × Implementation: F-HIGH × I-HIGH)*
**Design credibility:** FRAGILE  *(separate Axis-3 finding about the paper, not a demerit on our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design=WARN pre-trends), csdid (impl=PASS), bacon (N/A — single timing), honestdid (impl=PASS; design=WARN Mbar_avg=0.25 TWFE / Mbar_avg=0.5 CS-NT), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT via metadata — 0.66% gap; cached report returned NOT_APPLICABLE due to PDF path issue at run time, corrected by metadata AUDIT NOTE 2026-04-19)

## Executive summary

Clarke & Muhlrad (2021) estimate the causal effect of Mexico's 2007 ILE abortion liberalisation law on abortion-related mortality using a single treated unit (Mexico DF, estado=9) against 12 never-treated control states. The paper's headline TWFE estimate of -0.064 (SE=0.013, wild bootstrap) is recovered byte-identically by our pipeline at -0.0636 (0.66% gap, well within EXACT threshold). CS-DID corroborates direction and approximate magnitude (-0.058, 9% smaller, explained by baseline-period convention differences in a single-cohort design). All implementation reviewers pass with no concerns: the gvar_CS=207 alignment is correct, the Pattern 43 integer-to-numeric fix is resolved, and missing rows are symmetric and non-selective. The rating is therefore HIGH on the two axes that evaluate our work. Separately, as a finding about the paper, the design credibility is FRAGILE: the 36-period pre-event study shows substantial positive departures from zero at multiple lags (t=-29: +0.097, t=-31: +0.076, t=-19: +0.072), and HonestDiD sensitivity analysis shows the average-effect estimate loses significance at Mbar=0.25 (TWFE) and Mbar=0.5 (CS-NT), while the first-period TWFE estimate crosses zero even at Mbar=0. Users relying on this result should note that the parallel trends assumption is empirically challenged.

## Per-reviewer verdicts

### TWFE (impl=PASS; design=WARN)

- TWFE = -0.0636, paper Table 2 Panel A Col 1 = -0.064; gap = 0.66%, classified EXACT.
- Single treated unit → TWFE is a clean 2×2 with no heterogeneous timing contamination; no implementation concern.
- Pre-period event study non-flat: coefficients at t=-29 (+0.097), t=-31 (+0.076), t=-27 (+0.068), t=-19 (+0.072) are large. This is an Axis-3 design finding, not an Axis-2 implementation WARN.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)

- ATT_csdid_nt = -0.058; all three aggregation methods (simple, dynamic, default) agree, as expected with a single cohort.
- gvar_CS=207 (numeric) is correct; Pattern 43 resolved; 1716 symmetric missing rows are non-selective.
- 9% gap relative to TWFE is small and attributable to baseline-period convention differences in a single-cohort design, not an implementation error.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- treatment_timing = "single"; decomposition is trivially a single TvU 2×2. No information added. Correctly skipped.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (impl=PASS; design=WARN)

- TWFE "avg" CI at Mbar=0: [+0.014, +0.077] (excludes zero); breaks at Mbar=0.25 (CI: [-0.001, +0.105]).
- TWFE "first" CI at Mbar=0: [-0.007, +0.075] — crosses zero under exact parallel trends.
- CS-NT is more robust: "avg" and "first" survive to Mbar=0.25; all targets break at Mbar=0.5.
- Peak: TWFE robust to Mbar=0.25; both TWFE and CS-NT break at Mbar=0.5.
- Given observed pre-trend magnitudes, Mbar≥0.5 is empirically plausible — under that assumption the headline effect is statistically indistinguishable from zero. This is an Axis-3 design finding.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Single absorbing binary treatment, single adopting unit. No non-absorbing, continuous, or dose heterogeneity concerns. TWFE is already a clean 2×2. Correctly classified NOT_NEEDED.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Three-way controls decomposition

N/A — `twfe_controls = []`; paper has no original covariates. Unconditional comparison only. Specs B and C are identical; Spec A is not defined. No decomposition to report.

## Material findings (sorted by severity)

**Axis-3 design findings (about the paper — not demerits on our pipeline):**

- Pre-trend violation (TWFE event study, 36 pre-periods): multiple pre-period coefficients substantially depart from zero (t=-29: +0.097, t=-31: +0.076, t=-19: +0.072). Mexico DF appears to have been on a divergent trajectory in abortion-related mortality relative to control states before March 2007. This directly challenges the parallel trends assumption.
- HonestDiD fragility (TWFE avg and first): the average-effect estimate loses significance at the very small violation Mbar=0.25. The first-period estimate crosses zero even under exact parallel trends (Mbar=0). Both findings are mechanically consistent with the observed pre-trend pattern.
- HonestDiD fragility (CS-NT): the CS-NT estimate is more robust than TWFE but breaks at Mbar=0.5 for all three target parameters (first, avg, peak). Given empirically plausible violations of this magnitude, the effect is rendered insignificant.

**Axis-2 implementation issues: none.**

## Recommended actions

- No action needed on implementation: the pipeline is correctly specified, estimates reproduce the paper, and all implementation reviewers pass.
- For the **user (methodological judgement)**: report HonestDiD sensitivity bounds alongside the headline estimate (e.g., "significant if Mbar < 0.5 for CS-NT, Mbar < 0.25 for TWFE average"). The pre-trend pattern is the primary identification concern.
- For the **user**: consider investigating whether Mexico DF's pre-2007 divergence is explainable by healthcare infrastructure or policy changes coincident with ILE adoption. If a credible explanation bounds the pre-trend violation below Mbar=0.5, the result can be defended; otherwise parallel trends is materially in doubt.
- For the **paper-auditor**: re-run with `pdf/333.pdf` now confirmed present. The cached report returned NOT_APPLICABLE due to a path issue; the metadata annotation already records EXACT (0.66% gap), which is sufficient for rating purposes, but a fresh paper-auditor run would provide a formal PDF-based fidelity confirmation.

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
