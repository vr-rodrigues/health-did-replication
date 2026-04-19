# TWFE Reviewer Report — Article 419

**Verdict:** PASS

**Article:** Kahn, Li, Zhao (2015) — "Water Pollution Progress at Borders"
**Date:** 2026-04-18

---

## Checklist

### 1. Specification fidelity

- Treatment variable: `bypost06 = boundary * post06` (interaction of boundary-station indicator with post-2005 dummy). Correctly constructed in preprocessing.
- Reference period: year 2005 (post06 = year > 2005), consistent with paper's 11th Five-Year Plan 2006 adoption.
- Controls: gdpg, gdpp, temperature, lightbuffer5km — matches Table 3 Col 2.
- Fixed effects: unit (station w) + time (year) — standard TWFE via `feols`.
- Clustering: station-level (w). Paper used 2-way clustering (station + riversystem); template uses station only. **This explains the SE discrepancy: paper SE=1.192, our SE=1.023.** SE is smaller with single-level clustering — not a bias, a variance estimation choice. WARN-level difference but expected and documented in metadata notes.

### 2. Coefficient reproduction

| Source | beta | SE |
|---|---|---|
| Paper (Table 3 Col 2) | -2.012 | 1.192 |
| Our TWFE | -2.012 | 1.023 |

Point estimate matches to 5 significant figures (-2.01218... vs -2.012). The SE difference (1.023 vs 1.192) is attributable to 1-way vs 2-way clustering. This is a known and documented variance estimation difference, not a specification error.

### 3. Pre-trend assessment (event study)

Event study pre-periods: t=-2 and t=-1 (reference).

| Period | TWFE coef | SE | t-stat |
|---|---|---|---|
| t=-2 | +1.609 | 0.899 | +1.79 |
| t=-1 | 0 (ref) | — | — |

**Finding:** The t=-2 coefficient is positive (+1.609) and marginally significant (t≈1.79). With only 2 pre-periods (one of which is the reference), formal pre-trend testing is severely limited. The positive pre-trend at t=-2 could indicate:
- Boundary stations had higher COD in 2004 relative to 2005 (pre-treatment level difference, not a trend violation per se)
- Or a genuine anticipatory upward trend that then reverses post-treatment

With only 1 free pre-period, no Granger-style test or event-study pre-trend test can be conducted. This is a **design limitation**, not an implementation failure.

### 4. Post-treatment dynamics

TWFE post-treatment coefficients (relative to t=-1 reference):

| Period | coef | SE | sig |
|---|---|---|---|
| t=0 (2006) | -1.127 | 0.673 | * |
| t=1 (2007) | -0.348 | 0.737 | n.s. |
| t=2 (2008) | -0.749 | 0.900 | n.s. |
| t=3 (2009) | -1.609 | 1.066 | n.s. |
| t=4 (2010) | -2.333 | 1.156 | * |

**Finding:** Pattern shows immediate negative effect at t=0, weakening at t=1-2, then strengthening through t=3-4. The growing effect at t=3-4 is consistent with escalating enforcement of the 11th Five-Year Plan targets. No anomalous reversal to positive territory post-treatment. Dynamic pattern is plausible.

### 5. TWFE estimand validity (single cohort)

With a single adoption cohort (boundary vs interior stations, all adopting in 2006), TWFE is equivalent to a single 2x2 DiD comparison with no heterogeneous treatment timing bias. The Bacon decomposition critique does not apply (no multiple cohorts). TWFE identifies the ATT for this single cohort cleanly.

### 6. Control variable concerns

TWFE includes gdpg (GDP growth), gdpp (GDP per capita), temperature, and lightbuffer5km (nighttime light). These are time-varying controls at the station or prefecture level. With unit and year fixed effects already included:
- No collinearity concerns with unit FE for time-invariant controls (none listed)
- Time-varying controls appropriately included to absorb confounders
- Potential concern: if controls are themselves affected by the policy (bad controls problem). GDP growth near boundary stations post-2006 could be affected by stricter environmental enforcement. However, this is a substantive design choice by the original authors, not an implementation error.

### 7. Sample

497 monitoring stations × 7 years = 3,477 potential observations. After `is.finite(cod)` filter, the template uses 3,377 observations (per notes). Minor attrition from missing COD values — no concerns about selective attrition.

---

## Summary

TWFE is correctly implemented. Point estimate exactly matches the paper (-2.012). SE difference (1.023 vs 1.192) is fully explained by 1-way vs 2-way clustering choice, documented in metadata. The design has only 1 free pre-period, which limits pre-trend assessment — but this is a design characteristic, not an implementation failure. Post-treatment dynamics are plausible and internally consistent.

**Verdict: PASS**

Full report: `reviews/twfe-reviewer.md`
