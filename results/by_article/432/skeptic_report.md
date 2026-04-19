# Skeptic report: 432 — Gallagher (2014)

**Overall rating:** HIGH
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (PASS), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Gallagher (2014) studies the effect of flood events (PDD declarations) on flood insurance take-up in U.S. communities, using an 18-year staggered panel of 10,841 NFIP communities (1990–2007). The stored TWFE estimate (beta = 0.1095, SE = 0.0163, t = 6.72) is highly significant and directionally confirmed by every modern estimator: CS-NT = 0.1215, CS-NYT = 0.1155, SA ≈ 0.098–0.126, Gardner ≈ 0.079–0.146. Pre-trends are clean across 10 pre-periods for both TWFE and CS-DID (no period exceeds |t| = 1.3). HonestDiD finds the contemporaneous effect D-ROBUST (positive CI at Mbar = 2.0 across all estimators) and the average/peak effects D-MODERATE (robust to Mbar = 1.0–1.5). A known idiosyncrasy — repeated flood events for 55% of treated communities — is fully documented and does not invalidate the causal interpretation; it produces expected late-horizon attenuation in CS-DID. The paper's fidelity axis cannot be assessed (no PDF). Under the 3-axis rubric (M-HIGH × F-NA), the rating is HIGH. The stored consolidated_results value can be trusted as a valid causal estimate of the flood-experience effect on insurance take-up.

## Per-reviewer verdicts

### TWFE (PASS)
- Zero significant pre-trends across 10 pre-periods (max |t| = 1.13 at t = −7); parallel trends holds strongly.
- Post-treatment plateau is flat and stable (range 0.090–0.124 over t = 0 to t = 11), with no evidence of dynamic treatment effect contamination.
- State×year FE (864 categories) correctly absorbed by fixest; community FE + cluster at state level match paper's equation (1).
- [Full report: `reviews/twfe-reviewer.md`]

### CS-DID (PASS)
- CS-NT = 0.1215 (+10.9% above TWFE) and CS-NYT = 0.1155 (+5.4% above TWFE) — the upward adjustment is theoretically expected under staggered adoption with forbidden comparisons attenuating TWFE.
- Zero significant CS-NT pre-trends across 10 periods (max |t| = 1.26 at t = −9); simple vs dynamic aggregation gap negligible (2.4%).
- Late-period CS-NT decay (t = 9–11: 0.092→0.066) is the documented repeated-events artefact, not a parallel-trends failure.
- [Full report: `reviews/csdid-reviewer.md`]

### Bacon (PASS)
- Large never-treated pool (36%, N = 3,927) means TVU comparisons dominate the decomposition — the "cleanest" Bacon weight class.
- Stable post-adoption ATTs (range 0.09–0.12) mean EvL forbidden comparisons introduce minimal negative weight; 10.9% TWFE-to-CS gap is consistent with this.
- SA (Sun-Abraham) and TWFE are within 0.5–3% at all horizons, confirming that cohort-specific ATT heterogeneity is not materially distorting TWFE.
- [Full report: `reviews/bacon-reviewer.md`]

### HonestDiD (PASS)
- First-period (contemporaneous) effect D-ROBUST: positive CI at Mbar = 2.0 for TWFE, CS-NT, and CS-NYT.
- Average effect D-MODERATE: robust to Mbar = 1.0–1.5 across estimators; given clean pre-trends (realistic Mbar ≤ 0.5), the average ATT is robustly positive.
- Peak effect D-MODERATE: robust to Mbar = 0.75 (TWFE) / 1.0 (CS-NT); sign does not break under realistic sensitivity assumptions.
- [Full report: `reviews/honestdid-reviewer.md`]

### de Chaisemartin (NOT_NEEDED)
- Treatment is absorbing binary (post_hit permanently 1 after first flood hit). No reversal, no continuous dose, no time-varying heterogeneous dose at adoption. DID_M estimator not applicable.
- [Full report: `reviews/dechaisemartin-reviewer.md`]

### Paper Auditor (NOT_APPLICABLE)
- PDF not found at `pdf/432.pdf`; `original_result` field is empty in metadata. Fidelity axis is F-NA and not factored into rating.
- [Full report: `reviews/paper-auditor.md`]

## Material findings (sorted by severity)

No FAIL items.

No WARN items.

Informational notes (not affecting rating):
- **Repeated-events idiosyncrasy (documented):** 55% of treated communities experience multiple PDD floods. The paper's Figure 2 uses repeated-event hityear_* dummies; our TWFE ES uses first-hit timing. This produces a 4× divergence at late horizons (t=10: first-hit = 0.094 vs repeated-event = 0.024) — fully documented in metadata notes and es432_script.R. Not a methodological failure.
- **Late-period CS-NT attenuation (expected):** CS-NT decays from t=2 (0.170) to t=11 (0.066) due to repeated-events contamination. The stored ATT (0.1215, aggregated across all post-periods) is valid.
- **Fidelity not evaluable (F-NA):** PDF unavailable and original_result empty. If the paper's Table 1/equation (1) coefficient is recoverable, adding it to metadata.json would enable fidelity scoring.

## Recommended actions

- **No methodological action needed.** All 4 applicable methodology reviewers PASS. Rating is HIGH.
- For the repo custodian: if a copy of Gallagher (2014) AEJ:AE becomes available, add its Table 1 static ATT to `original_result` in metadata.json and re-run paper-auditor to obtain a fidelity score.
- For the pattern curator: no new failure patterns identified for this article.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
