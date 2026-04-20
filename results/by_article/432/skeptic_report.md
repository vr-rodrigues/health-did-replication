# Skeptic report: 432 — Gallagher (2014)

**Overall rating:** HIGH  *(built from Fidelity x Implementation: F-NA x I-HIGH — use implementation alone)*
**Design credibility:** D-ROBUST  *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=PASS, TvT share <30%), honestdid (impl=PASS, M_first=2.0, M_avg=1.5/1.0, M_peak=0.75/1.0), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF, no original_result)

## Executive summary

Gallagher (2014) studies the effect of flood events (PDD declarations) on flood insurance take-up across 10,841 U.S. NFIP communities in an 18-year staggered panel (1990–2007). The stored TWFE estimate (beta = 0.1095, SE = 0.0163, t = 6.72) is highly significant and directionally confirmed by every modern estimator: CS-NT = 0.1215, CS-NYT = 0.1155, SA and Gardner consistent. Pre-trends are flat across all 10 pre-periods for both TWFE and CS-DID (max |t| = 1.3). HonestDiD confirms that the contemporaneous (first-period) effect is D-ROBUST at Mbar = 2.0 across all three estimators; the average and peak effects are D-MODERATE, robust to Mbar = 1.0–1.5. Given that the observed pre-period fluctuation implies a realistic Mbar ≤ 0.50, even the average and peak effects are robustly positive under realistic sensitivity assumptions. A known idiosyncrasy — 55% of treated communities experience repeated floods — is fully documented, does not affect the static ATT interpretation, and produces expected late-horizon attenuation in CS-DID. The paper's fidelity axis is F-NA (no PDF, no stored original_result); under the 3-axis rubric (F-NA x I-HIGH), the rating is HIGH based on implementation alone. The stored consolidated_results value is a valid causal estimate of the flood-experience effect on insurance take-up and can be trusted.

## Per-reviewer verdicts

### TWFE (PASS)
- Zero significant pre-trends across 10 pre-periods (max |t| = 1.13 at t = -7); parallel trends assumption passes strongly.
- Post-treatment plateau is flat and stable (range 0.090–0.124 at t = 0 to t = 11); no systematic growth or decay.
- State x year FE (864 categories) + community FE + state-level clustering match paper equation (1) exactly; fixest multi-way FE absorption correct.
- [Full report: `reviews/twfe-reviewer.md`]

### CS-DID (PASS)
- CS-NT = 0.1215 (+10.9% above TWFE) and CS-NYT = 0.1155 (+5.4% above TWFE) — upward adjustment is theoretically expected under staggered adoption with forbidden comparisons attenuating TWFE.
- Zero significant CS-NT pre-trends across 10 periods (max |t| = 1.26); simple vs dynamic aggregation gap 2.4% (negligible).
- Late-period CS-NT decay (t = 11: 0.066) is the documented repeated-events artefact, not a parallel-trends failure; stored aggregated ATT = 0.1215 is valid.
- [Full report: `reviews/csdid-reviewer.md`]

### Bacon (PASS)
- Large never-treated pool (36%, N = 3,927 communities) means TVU comparisons dominate the decomposition — the cleanest weight class.
- SA (Sun-Abraham) and TWFE within 0.5–3% at all horizons, confirming modest cohort-specific ATT heterogeneity; TvT share well below the 30% concern threshold.
- Stable post-adoption ATTs (range 0.09–0.12) mean EvL forbidden comparisons introduce minimal negative weight; the 10.9% TWFE-to-CS gap is consistent with moderate EvL contamination from a small share of timing comparisons.
- [Full report: `reviews/bacon-reviewer.md`]

### HonestDiD (PASS)
- First-period (contemporaneous) effect D-ROBUST: positive CIs at Mbar = 2.0 for TWFE, CS-NT, and CS-NYT (Axis 3 finding: design is credible at the most policy-relevant target).
- Average effect D-MODERATE: robust to Mbar = 1.5 (TWFE) / 1.0 (CS-NT); realistic Mbar ≤ 0.50 (pre-trend magnitude / ATT ratio ≈ 0.36) means the average effect is robustly positive in practice.
- Peak effect D-MODERATE: robust to Mbar = 0.75 (TWFE) / 1.0 (CS-NT); sign does not break under realistic sensitivity assumptions.
- [Full report: `reviews/honestdid-reviewer.md`]

### de Chaisemartin (NOT_NEEDED)
- Treatment is absorbing binary (post_hit permanently 1 after first flood hit). No reversal, no continuous dose, no time-varying heterogeneous dose at adoption. DID_M estimator adds no information.
- [Full report: `reviews/dechaisemartin-reviewer.md`]

### Paper Auditor (NOT_APPLICABLE)
- PDF not found at `pdf/432.pdf`; `original_result` field is empty in metadata. Fidelity axis is F-NA and is not factored into the rating.
- [Full report: `reviews/paper-auditor.md`]

## Three-way controls decomposition

N/A — paper has no original covariates; unconditional comparison only. `twfe_controls = []`, `cs_controls = []`. All three specs (A/B/C) collapse to the same unconditional specification. Results.csv confirms `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`.

## Material findings (sorted by severity)

No FAIL items. No WARN items. All applicable methodology reviewers PASS.

Informational Axis-3 design findings (not affecting rating):

- **Contemporaneous effect D-ROBUST (Axis 3, positive):** First-period ATT is robust to Mbar = 2.0 across all three estimators — the strongest HonestDiD result in the audit sample for staggered designs with this many pre-periods.
- **Average/peak effects D-MODERATE (Axis 3):** Average effect robust to Mbar = 1.0–1.5; peak to Mbar = 0.75–1.0. Under realistic Mbar ≈ 0.35–0.50 (calibrated from pre-trend magnitudes), all targets are robustly positive.
- **Repeated-events idiosyncrasy (documented, Axis 3):** 55% of treated communities experience multiple PDD floods. Paper's Figure 2 uses repeated-event hityear_* dummies; our TWFE ES uses first-hit timing. This produces a 4x divergence at late horizons (t = 10: 0.094 vs 0.024) — fully documented in metadata and es432_script.R. Not a methodological failure; the static ATT using post_hit is correctly defined.
- **Fidelity not evaluable (F-NA):** PDF unavailable and original_result empty. If the paper's Table 1/equation (1) coefficient is recoverable, it would allow fidelity scoring.

## Recommended actions

- No methodological action needed. All 4 applicable methodology reviewers PASS. Rating is HIGH.
- For the repo custodian: if a copy of Gallagher (2014) AEJ:Applied Economics becomes available, add its static ATT from Table 1 to `original_result` in `data/metadata/432.json` and re-run paper-auditor to obtain a fidelity score (expected F-HIGH given TWFE pipeline is correctly specified).
- For the pattern curator: no new failure patterns identified.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
