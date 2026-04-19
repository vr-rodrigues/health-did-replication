# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 242

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability assessment

Treatment variable: `ddtquartile1` — binary indicator for top-quartile Rock Productivity Index counties.

**Is treatment absorbing?** Per metadata notes: treatment can switch off (~e=6). This makes the treatment potentially non-absorbing, which would normally trigger de Chaisemartin review.

**Is treatment continuous or heterogeneous dose?** No — binary indicator (top vs bottom quartile).

**Assessment:** The non-absorbing nature of the treatment is technically relevant. However:
1. The switching-off occurs at e~6 horizons, which is at the boundary of/beyond the event window studied (max_e=5 in this analysis).
2. Within the studied window (e=0 to e=5), the treatment is effectively absorbing for the purposes of the analysis.
3. The de Chaisemartin & D'Haultfoeuille (2020) estimator (`did_multiplegt`) is most critical for continuous treatment or heterogeneous intensity designs. This is a standard binary staggered adoption with a bounded analysis window.
4. The CS-DID analysis already provides a heterogeneity-robust alternative that addresses the primary concern about staggered adoption.

**Conclusion:** NOT_NEEDED — the design is standard absorbing-binary-staggered within the studied event window, and the CS-DID estimates already provide the robust counterfactual. The switching-off concern at e~6 is handled by restricting the event study to max_e=5.

## Notes on non-absorbing concern

If a full de Chaisemartin analysis were warranted (e.g., if the paper studied the full lifecycle including de-adoption), the key question would be whether `did_multiplegt` with a "no-stayers-switchers" approach would change the sign of the estimate. Given that the CS-DID simple ATT (which uses cohort-time averages within the studied window) yields 0.017 consistent with TWFE 0.019, the non-absorbing concern is unlikely to materially affect conclusions for the reported specification window.

## Verdict justification

NOT_NEEDED: Standard absorbing-binary-staggered within the studied horizon (max_e=5). The treatment de-adoption at e~6 is beyond the analysis window. CS-DID already provides a robust alternative. No additional de Chaisemartin analysis needed.
