# Skeptic report: 263 — Axbard, Deng (2024)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (N/A — no PDF, no original_result)

---

## Executive summary

Axbard and Deng (2024) study the effect of air pollution monitoring on enforcement actions against firms in China, using a DiD design where treated firms are those located within 10 km of newly installed air monitors, with a single treatment date of Q1 2015. The TWFE estimate (β=0.00333, SE=0.000556, t≈5.99) is strongly significant and pre-trends are clean. However, three methodological concerns each rise to WARN level: (1) the demanding FE structure (firm + time + 531 industry×time + 21 province×time dummies) cannot be replicated in CS-DID, causing a 7x SE inflation (Pattern 50) that renders the CS-NT estimate individually insignificant, though directionally consistent; (2) HonestDiD shows the avg-ATT becomes statistically fragile at Mbar=0.25 — a modest parallel trends violation — reflecting the design's limited power given the small effect magnitude; and (3) the TWFE itself conditions on so many FEs that the identifying variation is narrow and the parallel trends assumption is effectively untestable at this granularity. The stored consolidated result (β=0.00333) is the correct TWFE replication of the paper's Table 1a Col 1. SA and Gardner estimators confirm the direction and approximate magnitude. Users should treat this result as credible but not confirmed by the semiparametric robustness checks.

---

## Per-reviewer verdicts

### TWFE (WARN)
- β=0.00333 (SE=0.000556, t≈5.99) faithfully replicates the paper's `reghdfe` specification including all four FE layers.
- Pre-period event-study coefficients (t=-5 to t=-2) are all small and insignificant — no evidence of pre-trends.
- WARN: The `industry^time` (~531 dummies) and `prov_id^time` (~21 dummies) FEs create a near-collinear conditioning environment where parallel trends is empirically untestable at the required granularity.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT=0.00260 (SE=0.00376, t≈0.69) — directionally consistent with TWFE but individually insignificant.
- SE inflation is 6.8x relative to TWFE, root cause is structural (Pattern 50): CS-DID cannot absorb the high-dimensional interacted FEs.
- SA and Gardner estimators confirm TWFE direction and magnitude, isolating the problem to CS-NT FE mismatch.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Not applicable: single treatment timing (no staggered adoption); no decomposition needed or meaningful.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- At Mbar=0 (exact parallel trends), avg and peak ATTs exclude zero for both TWFE and CS-NT.
- Result becomes statistically fragile at Mbar=0.25 — even a mild violation of parallel trends renders avg-ATT insignificant.
- Pre-trends are clean; fragility reflects small effect size relative to precision, not evidence of pre-trend contamination.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary single-timing design — no forbidden comparisons, no dose heterogeneity.
- de Chaisemartin estimator adds no incremental insight beyond CS-DID for this design.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper auditor (N/A)
- No PDF found at `pdf/263.pdf`; `original_result` is empty `{}`. Fidelity axis not evaluable.

---

## Material findings (sorted by severity)

**WARN (3 active):**

1. **[WARN — csdid] Pattern 50 FE mismatch causes 7x SE inflation in CS-NT.** The paper's identifying specification requires industry×time and province×time FEs that CS-DID cannot absorb. CS-NT point estimate is directionally consistent (0.0026 vs TWFE 0.0033) but statistically insignificant (t≈0.69). This is a structural limitation of semiparametric estimators versus high-dimensional FE TWFE, not a misspecification.

2. **[WARN — honestdid] HonestDiD breakdown at Mbar=0.25 for avg-ATT.** The avg treatment effect loses significance at a modest 25% pre-trend violation. Given very small absolute pre-trends, this reflects sensitivity inherent to a small-magnitude effect rather than evidence of contamination.

3. **[WARN — twfe] High-dimensional FEs make parallel trends empirically untestable.** The 550+ interacted FE dummies condition on so much variation that the parallel trends assumption — while visually supported by the event study — cannot be formally verified at the required industry×province×time granularity.

---

## Recommended actions

- **For repo-custodian:** Populate `original_result` in `data/metadata/263.json` with the paper's Table 1a Col 1 numeric estimate (β and SE from the Stata reghdfe output) to enable future paper-auditor fidelity checks.
- **For pattern-curator:** Pattern 50 (high-dimensional FE structure causing CS-NT SE inflation) is confirmed and active for article 263. Consider strengthening the pattern description with this case: single-timing design, 531 industry×time + 21 province×time dummies, SE ratio ≈ 7x.
- **For user (methodological judgement):** The TWFE result is internally credible and confirmed by SA and Gardner estimators. The 7x CS-NT SE inflation should be noted as a caveat in any meta-analysis that pools CS-NT SEs across articles — article 263 will be an outlier on that dimension. Consider whether the paper's Conley spatial HAC SEs (an alternative robustness check not replicated here) would alter the inference.
- **For user:** Treat the stored β=0.00333 as the correct replication of the paper's point estimate. Mark this article as LOW credibility in the meta-analysis primarily because of the structural FE mismatch that prevents semiparametric confirmation, not because the TWFE estimate is suspect.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
