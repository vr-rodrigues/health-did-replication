# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 432 (Gallagher 2014)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability Assessment
Run for completeness. Treatment is absorbing binary staggered: once a community is first hit by a PDD flood (treatment = post_hit = 1{year2 >= hit1year}), it remains treated permanently. Treatment never reverses. Dose is homogeneous (binary 0/1). No continuous or time-varying dose component.

## Checklist

### 1. Is treatment non-absorbing?
No. post_hit is absorbing (once 1, always 1). No treatment reversal documented.

### 2. Is treatment continuous or heterogeneous-dose at adoption?
No. Binary 0/1 indicator. All treated communities receive the same nominal "treatment" (first PDD flood hit). Dose heterogeneity (intensity of flood, economic damage) is not encoded in the treatment indicator used for the DiD.

### 3. Repeated-events consideration
55% of treated communities are hit >1 time. However, subsequent hits do not change the treatment indicator (post_hit is already 1 after the first hit). From the perspective of the DiD estimator, this is an absorbing treatment. The de Chaisemartin & D'Haultfoeuille (2020) estimator is designed for non-absorbing or time-varying treatments; it is not needed here.

### 4. Conclusion
Standard absorbing binary staggered design. CS-DID (Callaway-Sant'Anna) is the appropriate alternative estimator and has been applied. de Chaisemartin-D'Haultfoeuille (DID_M) is not required.

**Verdict: NOT_NEEDED**
