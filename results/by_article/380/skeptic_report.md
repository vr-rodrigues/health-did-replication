# Skeptic report: 380 — Kuziemko, Meckel & Rossin-Slater (2018)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Kuziemko, Meckel & Rossin-Slater (2018) study whether Texas's staggered rollout of Medicaid Managed Care (MMC) affected Black infant mortality in a county-month panel (1990-2006). Our TWFE replication yields beta_twfe = +0.068 (SE = 0.073), which is statistically insignificant and marginally positive — consistent in sign with the paper's specification but likely reflecting a simplified time-FE structure (single integer-month FE rather than the paper's year + month + year×month FEs). All four applicable methodological reviewers return WARN: the TWFE pre-event study shows notable drift at t=-3 (-0.425, t≈-1.94); CS-DID estimates reverse sign (all insignificant but volatile) and are extremely sensitive to control inclusion; the Bacon decomposition reveals high heterogeneity across 2x2 DDs (range -1.31 to +0.28) with an anomalous cohort (23976) pulling estimates; and HonestDiD shows the only marginally significant event-study estimate (first post-period: -0.475) is fragile — it loses significance at Mbar≥0.25, and given observed pre-trends of 0.3-0.4, Mbar=0 is not credible. The stored TWFE result (+0.068) should be treated with caution: it is statistically null, rests on a simplified FE structure, and the event-study evidence for any treatment effect is not robust to realistic violations of parallel trends. The fidelity axis is not evaluable (no PDF available). Overall rating: **LOW**.

---

## Per-reviewer verdicts

### TWFE (WARN)

- TWFE estimate is statistically insignificant: +0.068 (SE=0.073, t=0.93); controls change estimate minimally (+0.068 vs +0.061)
- Pre-trend at t=-3 is -0.425 (SE=0.219, t≈-1.94) — economically large relative to the static ATT and borderline significant, raising parallel trends concerns
- Template uses a simplified single integer-month time FE while the paper uses multi-dimensional year + month + year×month FEs, potentially introducing residual confounding

[Full report: `reviews/twfe-reviewer.md`]

### CS-DID (WARN)

- Sign reversal between TWFE (+0.068) and CS-NT (-0.023) / CS-NYT (-0.118), though all estimates are statistically insignificant
- Extreme sensitivity to control inclusion: CS-NT swings from -0.023 (no controls) to +0.660 (with controls), SE quadruples — CS estimates with controls are unreliable
- CS event-study pre-periods are volatile (t=-6: +0.641±0.461; t=-2: +0.616±0.469), suggesting even the CS estimator may not satisfy parallel trends in this setting

[Full report: `reviews/csdid-reviewer.md`]

### Bacon (WARN)

- Clean (treated vs untreated) 2x2 DDs range from -1.306 to +0.278 — 1.58 pp spread — indicating high cohort-level heterogeneity
- The aggregate TWFE (+0.068) is positive despite most clean comparisons being negative; the positive aggregate is partly driven by "Earlier vs Later" contamination (extreme values: +2.200, +2.999) from treated-vs-treated comparisons
- Cohort 23976 is anomalous: -1.306 vs never-treated and extreme within-treated estimates (up to -2.644); likely an influential outlier

[Full report: `reviews/bacon-reviewer.md`]

### HonestDiD (WARN)

- TWFE first-period estimate (-0.475) is significant only at Mbar=0 (strict parallel trends); at Mbar=0.25 the CI already includes zero
- Given observed pre-trends of 0.3-0.4 in magnitude (t=-3: -0.425, t=-5: -0.292), a credible Mbar is at least 0.25, making the result fragile
- Average post-period TWFE effect (-0.168) is never significant at any Mbar; CS-NT is uninformative across all targets and Mbar values

[Full report: `reviews/honestdid-reviewer.md`]

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design; no non-absorbing, continuous, or dose-heterogeneous treatment
- de Chaisemartin & D'Haultfoeuille estimator is not required; CS-DID and SA are the appropriate modern alternatives

[Full report: `reviews/dechaisemartin-reviewer.md`]

### Paper Auditor (NOT_APPLICABLE)

- PDF file `pdf/380.pdf` does not exist; numerical fidelity to Table 3 cannot be assessed
- Fidelity axis not factored into rating

[Full report: `reviews/paper-auditor.md`]

---

## Material findings (sorted by severity)

**WARN — HonestDiD fragility:** The only statistically suggestive result (TWFE first-period: -0.475) breaks down at Mbar=0.25. Given visible pre-period drift, Mbar=0 is not credible. No estimate is robust to realistic parallel-trend violations.

**WARN — Pre-trend drift (TWFE):** Event study shows a large negative pre-trend at t=-3 (-0.425, t≈-1.94), inconsistent with parallel trends in the pre-period.

**WARN — CS-DID instability:** Sign reversal vs TWFE and extreme control-variable sensitivity (estimate swings from -0.023 to +0.660) undermine the reliability of CS estimates.

**WARN — Bacon heterogeneity:** Wide range of 2x2 DDs (-1.31 to +0.28), anomalous cohort 23976, and partial contamination from treated-vs-treated comparisons inflate the TWFE aggregate.

**INFO — Simplified FEs:** Template uses single time FE vs. paper's multi-dimensional year×month FE structure. Magnitude of bias from this simplification is unknown.

**INFO — Fidelity not evaluated:** No PDF available for Table 3 comparison.

---

## Recommended actions

- **For the repo-custodian agent:** Update `original_result` in `data/metadata/380.json` to include a numeric `beta_paper` field once the PDF or online table is located, to enable fidelity auditing.
- **For the repo-custodian agent:** Investigate whether the template can be extended to support multi-dimensional time FEs (year + month + year×month) for papers where this is the original specification; this would improve comparability for article 380.
- **For the repo-custodian agent:** Consider adding `cs_controls` in metadata to match TWFE controls (`ln_pop`, `ln_inc`, `ln_tran`, `unemp`), so the CS-DID estimates are conditionally comparable to TWFE — or document explicitly that CS estimates are unconditional.
- **For the user (methodological judgement call):** The null TWFE result should not be interpreted as evidence of no effect: pre-trend drift and HonestDiD fragility mean the event-study evidence is unreliable. The paper's own estimate likely rests on more saturated FEs not replicated here.
- **For the pattern-curator:** Consider adding a pattern for "anomalous late-adopting cohort inflating within-treated Bacon comparisons" — cohort 23976 shows extreme within-treated estimates that distort the aggregate; this may generalize to other staggered-adoption settings with outlier cohorts.

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
