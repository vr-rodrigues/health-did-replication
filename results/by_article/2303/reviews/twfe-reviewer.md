# TWFE Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer axis:** Methodology

---

## Checklist

### 1. Fixed-effects specification

- TWFE FE override: `id^month + prov^year^month` (plant×calendar-month absorbs plant-level seasonal trends; province×year×month absorbs common provincial shocks).
- This is a high-dimensional, non-standard FE structure. It is appropriate for the agricultural fire context (fires are highly seasonal; provincial shocks are common confounders).
- The FE structure is richer than a simple unit+time specification, which reduces but does not eliminate negative-weighting concerns when treatment timing is staggered.

### 2. Staggered timing and negative weights

- Treatment is staggered across 125 cohorts (monthly entry of biomass power plants, 2001–2019).
- With 125 cohorts and a rich FE structure (`id^month + prov^year^month`), the TWFE estimand is a weighted average of 2x2 DiD comparisons. **With staggered adoption, negative weights on some 2x2 pairs are mathematically guaranteed.**
- Bacon decomposition ran successfully (15,625 pairwise comparisons). The decomposition contains both "Later vs Earlier Treated" and "Earlier vs Later Treated" entries, confirming forbidden comparisons exist. The sheer number of pairs (15,625 rows) with highly heterogeneous point estimates (ranging from approximately −88 to +45) signals substantial treatment effect heterogeneity across cohort×comparison pairs.
- TWFE estimate: β = −4.836 (SE = 1.495, clustered by plant). This is negative and large relative to mean fire frequency.

### 3. Standard errors

- Paper uses Conley spatial SEs (600 km bandwidth): SE = 1.780.
- Replication uses cluster-by-plant: SE = 1.495.
- The cluster SE is **smaller** than Conley SE (by ~16%). Conley spatial SE is more conservative and appropriate given spatial correlation in fire data. The replication's cluster SE understates uncertainty relative to the paper's specification.
- WARN: the stored SE cannot be directly compared to the paper's inferential standard without adjustment.

### 4. Controls

- 7 weather controls in TWFE: temperature, precipitation, windspeed, humidity, winddirection1/2/3.
- These are time-varying controls interacted implicitly with treatment timing, which is appropriate for weather-driven confounders of fire activity.
- Controls are NOT passed to CS-DID (Pattern 42 in failure_patterns.md). This creates a known methodological asymmetry between TWFE and CS-DID estimates.

### 5. Fidelity to paper

- Paper reports β = −4.863 (Table 2, Col 3). Replication β = −4.836. Gap = 0.6%. This is within tolerance.
- SE discrepancy (Conley vs cluster) is a known deviation, documented in metadata.

### 6. Pre-trends (event study)

- TWFE event study: coefficients at k=−5 to k=−2 range from −10.95 to +18.55, with large SEs (6.2–13.5). Pre-period estimates are noisy but mostly insignificant given the SEs.
- k=−3 coefficient is large (+18.55, SE=13.46), t-ratio ≈ 1.38 — marginal but not significant at 5%.
- TWFE k=−6 coefficient: +4.98 (SE=5.23, t≈0.95) — not significant.
- Pre-trends are noisy but not cleanly flat. The large k=−3 spike is a yellow flag.

---

## Summary

**WARN.** The TWFE estimate (−4.836) is within 0.6% of the paper's reported −4.863 and is directionally robust across all estimators. However, three issues merit caution: (1) staggered adoption with 125 cohorts creates unavoidable negative TWFE weights; (2) stored SEs use cluster-by-plant rather than the paper's Conley spatial SEs, understating uncertainty; (3) the TWFE event study pre-period is noisy (large k=−3 spike), though not formally significant. The TWFE specification with its rich FE structure is appropriate, but the negative-weighting concern is real in a 125-cohort staggered design.

**Flags:**
- Negative weighting confirmed via Bacon (125 cohorts, LvE and EvL pairs both present).
- SE mismatch: cluster (1.495) vs Conley (1.780) — 16% understatement.
- k=−3 pre-period coefficient large but insignificant.
