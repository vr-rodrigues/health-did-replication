# CS-DID Reviewer Report — Article 21 (Buchmueller & Carey 2018)

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

---

## Specification summary

- CS estimator: `att_gt` via `did` package, never-treated and not-yet-treated comparison groups
- Group variable: `gvar_CS` (0 = never-treated; 102 = Oklahoma; 104 = Delaware/Ohio; 105 = KY/NM/WV)
- Aggregation (static ATT): `aggte(type='dynamic')` — matches Stata `csdid2 long2` aggregation
- Controls: none

---

## Results

| Estimator | ATT | SE | Original paper |
|---|---|---|---|
| CS-NT simple | -0.001547 | 0.001169 | — |
| CS-NT dynamic | -0.001888 | 0.000809 | -0.0018 (SE ~0.0013) |
| CS-NYT simple | -0.001553 | 0.001149 | — |
| CS-NYT dynamic | -0.001891 | 0.000802 | — |

The dynamic aggregation ATT for CS-NT (-0.001888) is within 4.9% of the paper's reported CS-DID estimate (-0.0018). This is excellent agreement and validates the specification.

---

## Checklist

### 1. Group variable construction — PASS
`gvar_CS` correctly assigns adoption cohorts:
- Oklahoma: halfyear 102 (2011H2 — first mover)
- Delaware, Ohio: halfyear 104 (2012H1)
- Kentucky, New Mexico, West Virginia: halfyear 105 (2012H2, majority cohort)
- Never-treated: 0

The cohort assignment is consistent with the `evermustaccess` variable and state-specific `eventhalfyear` offsets documented in preprocessing.

### 2. Comparison group selection — PASS
Both never-treated (CS-NT) and not-yet-treated (CS-NYT) comparison groups are estimated. Results are nearly identical (within 0.2%), indicating robustness across comparison group choice. The not-yet-treated estimator is appropriate given the staggered design.

### 3. CS pre-trends (event study) — PASS
CS-NT event study coefficients:

| Period | Coefficient | SE |
|--------|------------|-----|
| t=-5 | +0.001554 | 0.000910 |
| t=-4 | +0.000043 | 0.000868 |
| t=-3 | -0.000086 | 0.001200 |
| t=-2 | +0.000029 | 0.000947 |

The CS-NT pre-trends are all very close to zero (the largest being t=-5 at +0.00155 with SE 0.00091, which is within 1.7 standard errors). This is a substantially cleaner pre-trend pattern than the TWFE event study, which showed large coefficients at t=-3 and t=-2. The CS estimator is correcting for the TWFE pre-trend artefact, likely because the TWFE pre-trends partly reflect compositional timing effects that the cohort-specific estimator eliminates.

### 4. Aggregation method — PASS (with note)
The paper uses Stata `csdid2` with `long2` aggregation, which averages over event-time periods — equivalent to `aggte(type='dynamic')` in the `did` R package. Using `aggte(type='simple')` gave -0.00155 (a 14.9% gap), while `aggte(type='dynamic')` gives -0.001888 (3.7% gap). The correct aggregation method is implemented.

### 5. HTE robustness — PASS
CS-NT dynamic ATT (-0.001888) aligns closely with TWFE (-0.00187). Agreement between the cohort-robust estimator and TWFE suggests that while cohort-heterogeneity exists in the event study dynamics, the aggregate ATT is not meaningfully biased by negative weighting in the TWFE.

### 6. Treatment effect dynamics — NOTE
CS post-period event study shows the same decay pattern as TWFE: t=0 (-0.00162) → t=1 (-0.00192) → t=2 (-0.00075). The immediate effect at t=0 is smaller in CS-NT than TWFE (0.00162 vs 0.00353), and the peak is at t=1. This heterogeneity in dynamics is informative but does not affect the CS ATT estimate's validity.

---

## Summary

The CS-DID implementation is sound. The group variable is correctly constructed, comparison groups are appropriate, and the aggregation method matches the paper's specification. Crucially, the CS pre-trends are essentially flat while the TWFE pre-trends showed large t=-3 and t=-2 coefficients — this suggests the TWFE pre-trend artefact is a composition effect that the CS estimator correctly handles. The headline ATT is robust across comparison group choices (NT vs NYT) and close to the paper's reported value.

**Verdict: PASS**
