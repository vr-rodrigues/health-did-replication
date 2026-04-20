# TWFE Reviewer Report — Article 347

**Verdict:** PASS (implementation) / D-FRAGILE (design finding)
**Date:** 2026-04-19
**Reviewer:** twfe-reviewer

## Axis separation note
This report distinguishes Implementation concerns (failures in our pipeline) from Design findings (properties of the paper's design revealed by our reanalysis). Under the 3-axis skeptic rubric, only Implementation concerns affect the overall rating; Design findings go to Axis 3.

## Checklist

### 1. Specification alignment (Implementation)
- Paper uses `areg` with county FE + monthly time FE (`tt = (year-2001)*12 + mo + 84`) + county-specific linear trends (`fips[tt]`).
- Replication uses `fixest::feols` with `additional_fes = ["fips[tt]"]` encoding county-specific linear trends exactly.
- Treatment variable: `law_enacted` (binary, absorbing).
- Controls: 12 individual-level covariates (female, age dummies, race/ethnicity, education, pd, unem, med_inc).
- Weighted by `swt`; clustered by `fips`.
- **Result:** TWFE ATT = −0.1744, paper Table 3 Col 1 = −0.174. Deviation = 0.23% (< 1%).
- **Implementation verdict: PASS.** Specification is correctly implemented.

### 2. TWFE vs CS-DID gap (Design finding — NOT an implementation failure)
- TWFE = −0.174 (SE = 0.081). CS-NT = −0.448; CS-NYT = −0.439.
- CS-DID estimates are ~2.5× larger in magnitude than TWFE.
- **Design finding:** The gap is directionally consistent (all negative) but the 2.5× magnitude difference is a finding about how county-specific linear trends (`fips[tt]`) interact with the staggered adoption design. Trend controls absorb genuine pre-treatment dynamics that CS-DID (estimated on collapsed yearly panel without trend controls) attributes to the treatment.
- This is a property of the paper's specification, not a failure in our pipeline. We reproduce TWFE exactly; we compute CS-DID on the appropriate collapsed panel.
- This is the same attenuation mechanism documented in the Lesson 2 quartet (253 Bancalari, 267 Bhalotra et al., 241 Soliman): forbidden LvE/EvL comparisons from staggered cohorts 2008–2011 combined with trend controls attenuate TWFE toward zero.

### 3. County-specific linear trends (Design finding)
- The inclusion of `fips[tt]` (county × time linear trend) is a strong parametric assumption in the paper's own specification.
- This is a design-level concern shared with the original paper, not introduced by our reanalysis.
- Our implementation faithfully replicates this specification; we do not introduce or remove it.

### 4. Treatment timing
- 4 cohorts: NYC 2008, Seattle+Westchester 2009, Philadelphia+Albany+Montgomery+Schenectady+Suffolk 2010, Vermont 14 counties 2011.
- TWFE pools all cohorts with heterogeneous timing — standard staggered-adoption design.
- Our pooling correctly mirrors the paper's approach.

## Summary

**Implementation axis:** PASS. TWFE matches paper to 0.23%. Specification, controls, clustering, and FE structure all correctly implemented.

**Design findings (Axis 3 input):**
- CS-DID 2.5× TWFE in magnitude — Lesson 2 attenuation quartet mechanism confirmed.
- County-specific linear trends create parametric sensitivity — design feature of the paper.
- Direction unanimous across all 3 estimators (TWFE, CS-NT, CS-NYT): negative calorie posting effect on BMI.

**Verdict: PASS** (implementation clean; design findings documented as Axis 3 evidence)
