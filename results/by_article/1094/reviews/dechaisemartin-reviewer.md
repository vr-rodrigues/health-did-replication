# de Chaisemartin Reviewer Report: Article 1094

**Verdict: NOT_NEEDED**
**Date:** 2026-04-18
**Paper:** Fisman & Wang (2017) — "The Distortionary Effects of Incentives in Government: Evidence from China's Death Ceiling Program"

---

## 1. Treatment Structure Assessment

- Treatment variable: `post = I(year > effective_year)` — binary (0/1) indicator
- Treatment timing: staggered across 19 provinces (adoption years 2005–2012)
- Absorption: ABSORBING — once a province adopts the NSNP law, it remains treated. No evidence of treatment reversal in the data.
- Dose: Binary (0/1). No heterogeneous dose at adoption.
- This is a standard absorbing binary staggered design.

## 2. Applicability Assessment

The de Chaisemartin & D'Haultfoeuille (2020) DID_M estimator is designed primarily for:
- Non-absorbing treatments (units that switch in and out of treatment)
- Continuous or heterogeneous-dose treatments
- Cases where CS-DiD's clean-comparison assumption is violated

For this paper's standard absorbing-binary-staggered design:
- CS-DiD (Callaway & Sant'Anna 2021) with never-treated controls is the appropriate heterogeneity-robust estimator
- DID_M identifies the same set of clean 2x2 comparisons as CS-NT when treatment is absorbing and binary
- No additional methodological insight is gained from DID_M given the CS-NT results already available

## 3. Bacon Decomposition Cross-Check

The Bacon decomposition results (bacon.csv) provide qualitative insight into 2x2 cell structure:

**Treated vs Untreated (dominant component, total weight ≈ 0.71):**

| Cohort | 2x2 estimate | Weight |
|--------|-------------|--------|
| 2012 | +0.022 | 0.197 |
| 2009 | -0.019 | 0.150 |
| 2010 | +0.045 | 0.127 |
| 2011 | -0.086 | 0.079 |
| 2008 | -0.151 | 0.070 |
| 2007 | -0.309 | 0.056 |
| 2006 | +0.113 | 0.026 |

Wide heterogeneity across cohorts (range: -0.309 to +0.113). This heterogeneity is exactly what CS-NT is designed to handle — by estimating cohort-specific ATTs and aggregating them cleanly. DID_M would produce similar cohort-specific estimates.

The "Earlier vs Later" and "Later vs Earlier" contamination components in Bacon are present but have relatively low individual weights (largest single cell ≈ 0.047). Their contaminating influence on TWFE is limited but non-negligible.

## 4. Conclusion

Standard absorbing binary staggered design. DID_M adds no material additional information beyond CS-NT.

**Verdict: NOT_NEEDED**

Reason: Standard absorbing binary staggered treatment (NSNP law adoption, no reversal, no dose heterogeneity). CS-NT with never-treated controls is the appropriate estimator and has been run. DID_M would recover the same clean 2x2 comparisons, and no additional insight is gained. The Bacon decomposition provides adequate qualitative information about within-TWFE contamination.
