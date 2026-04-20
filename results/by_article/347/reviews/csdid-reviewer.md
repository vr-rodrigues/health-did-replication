# CS-DID Reviewer Report — Article 347

**Verdict:** PASS (implementation) / D-FRAGILE (design finding)
**Date:** 2026-04-19
**Reviewer:** csdid-reviewer

## Axis separation note
This report distinguishes Implementation concerns (failures in our pipeline) from Design findings (properties of the paper's design revealed by our reanalysis). Under the 3-axis skeptic rubric, only Implementation concerns affect the overall rating; Design findings go to Axis 3.

## Checklist

### 1. Group variable construction (Implementation)
- `gvar_cs = "gvar_yr"` — cohort year of first treatment. Values: 2008, 2009, 2010, 2011; 0/Inf for never-treated (63 counties).
- 4 cohorts correctly identified.
- **Implementation verdict: PASS.**

### 2. Panel construction — RCS → yearly county panel (Implementation)
- CS-DID requires panel structure; BRFSS is repeated cross-section.
- Implementation correctly collapses individual responses to county-year means (weighted by `swt`) for the 44 of 89 counties appearing in all survey years. This is the correct approach for RCS data with CS-DID.
- `cs_controls = []` (empty) because individual-level controls cannot be carried through the RCS-to-panel collapse — this is correct given the data structure.
- **Implementation verdict: PASS.** The RCS-to-panel approach is the only valid pathway and is executed correctly.

### 3. CS-NT and CS-NYT estimates (Implementation)
- CS-NT ATT = −0.448 (SE = 0.099). CS-NYT ATT = −0.439 (SE = 0.100).
- Both directionally consistent with TWFE (all negative).
- The `did` package runs with `panel = FALSE` (correct for RCS/collapsed panel) and `allow_unbalanced = FALSE`.
- **Implementation verdict: PASS.**

### 4. Estimand mismatch — TWFE vs CS-DID (Design finding — NOT an implementation failure)
- TWFE uses 89 counties with 12 individual-level controls + county-specific linear trends on monthly RCS data.
- CS-DID uses 44 counties balanced on yearly aggregates without individual controls or trend controls.
- **Design finding:** The 2.5× magnitude gap (TWFE −0.174 vs CS-NT −0.448) reflects this structural estimand difference — a property of the RCS data and the paper's specification choice, not a pipeline error.
- Our CS-DID is estimating the correct object: unconditional ATT on the balanced yearly county panel. TWFE is estimating a conditional ATT with trend absorption. These are genuinely different parameters.
- This paper is the 4th member of the Lesson 2 amplification quartet (Chapter 4 §Lesson 2): staggered cohorts 2008–2011 + trend controls attenuate TWFE toward zero while CS-DID recovers a larger (likely less attenuated) ATT.

### 5. Cohort 2009 near-singleton (Design finding)
- After panel balancing, cohort 2009 (Seattle+Westchester) has approximately 1 county with a full panel.
- The `did` package flags this; the TVU estimate for cohort 2009 is −0.692 (largest absolute value).
- **Design finding:** This is a data/structural feature — small cohort due to the paper's geographic sample construction. Not an implementation error. Noted as design fragility.

### 6. Custom 3-row schema
- results.csv stores 3 rows: TWFE, CS-NT, CS-NYT. No Spec A (TWFE-with-controls + CS-DID-with-controls) computed because individual controls cannot be passed through the RCS collapse.
- This is correctly documented in the metadata notes. The schema deviation is intentional and appropriate.
- **Implementation verdict: PASS** (correctly documented as `legacy_analysis = true`).

## Summary

**Implementation axis:** PASS. CS-DID estimation is correctly implemented for the RCS data structure. Group variable, panel construction, and estimand choices are all appropriate.

**Design findings (Axis 3 input):**
- 2.5× TWFE/CS-DID magnitude gap — Lesson 2 attenuation, structural to the paper's RCS + trend-control specification.
- Cohort 2009 near-singleton — small geographic sample; affects precision of cohort-specific estimate.
- All estimators agree on negative sign of calorie posting law effect on BMI.

**Verdict: PASS** (implementation clean; design findings documented as Axis 3 evidence)
