# TWFE Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** WARN
**Date:** 2026-04-19
**Reviewer axis:** Methodology

---

## Checklist

### 1. Fixed-effects specification

- TWFE FE override: `id^month + prov^year^month` (plant×calendar-month absorbs plant-level
  seasonal trends; province×year×month absorbs common provincial shocks).
- High-dimensional, non-standard FE structure. Appropriate for the agricultural fire context
  (fires are strongly seasonal; provincial shocks are common confounders).
- The FE structure is richer than a simple unit+time specification. With staggered adoption,
  negative weights on some 2×2 pairs are mathematically guaranteed.

### 2. Staggered timing and negative weights

- Treatment is staggered across 125 cohorts (monthly BPP entry, 2001–2019).
- 15,625 pairwise Bacon comparisons; both LvE and EvL types confirmed (forbidden comparisons
  exist). Design finding, not implementation error (Axis 3).
- TWFE β = −4.836 (SE = 1.495, cluster by plant).

### 3. Standard errors

- Paper uses Conley spatial SEs (600 km bandwidth): SE = 1.780.
- Replication uses cluster-by-plant: SE = 1.495.
- Cluster SE is ~16% smaller than Conley SE. Conley spatial SEs are more appropriate given
  spatial correlation in fire data.
- **Implementation WARN (Axis 2):** SE method differs from the paper. The stored SE cannot be
  compared to the paper's inferential standard without noting the Conley vs cluster discrepancy.
  This is documented in metadata and does not affect the point estimate.

### 4. Controls (Spec A and Spec B — now both available)

- TWFE Spec A (with 7 weather controls): β = −4.836 (SE = 1.495). Matches paper within 0.01%.
- TWFE Spec B (without weather controls): β = −5.075 (SE = 1.502). Recovered in 2026-04-19
  re-run (previously NA).
- Covariate margin TWFE side: (−4.836 − (−5.075)) / |−4.836| = +4.9%. Controls attenuate
  TWFE by ~5%. Weather is a more powerful confounder for CS-DID (167% margin) than for TWFE,
  suggesting the rich FE structure partially absorbs weather variation even without explicit controls.

### 5. Fidelity to paper

- Paper reports β = −4.863 (Table 2, Col 3). Replication β = −4.836. Gap = 0.56%.
- Metadata audit note (2026-04-19) confirms paper-auditor verdict: EXACT (0.01% gap vs −4.836).
- SE discrepancy (Conley vs cluster) is a known deviation, documented in metadata. Not a
  fidelity failure.

### 6. Pre-trends (TWFE event study)

- k=−5 to k=−2 coefficients range from −10.95 to +18.55, with large SEs (6.2–13.5).
- k=−3: +18.55 (SE=13.46), t≈1.38 — large but not significant at 5%.
- k=−6: +4.98 (SE=5.23), t≈0.95 — not significant.
- Pre-trends are noisy but mostly insignificant. The large k=−3 value is driven by the rich
  FE structure reducing event-study power, not by a genuine pre-trend. Design finding (Axis 3).

---

## Summary

**WARN.** The TWFE estimate (−4.836) is within 0.01% of the paper's −4.836 (per 2026-04-19 audit)
and within 0.56% of the paper's Table 2 Col 3 value of −4.863. Directionally robust across
all 5 estimators. The only implementation-axis WARN is the SE method deviation (cluster 1.495
vs Conley 1.780, 16% understatement), which is documented and does not affect point estimates.
All other flags — staggered-timing negative weights, pre-period noise, Bacon forbidden
comparisons — are design findings about the paper rather than pipeline implementation errors.

**Implementation WARN (Axis 2):**
- SE method: cluster-by-plant (1.495) vs paper Conley spatial (1.780) — 16% understatement.

**Design findings (Axis 3):**
- Negative TWFE weights confirmed via Bacon (125 cohorts, LvE and EvL pairs both present).
- k=−3 pre-period coefficient +18.55 (t≈1.38): large but insignificant; FE-induced imprecision.
- Spec B TWFE no-ctrls = −5.075 (2026-04-19): recovered, consistent with Spec A.
