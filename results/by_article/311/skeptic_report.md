# Skeptic report: 311 -- Galasso & Schankerman (2024)

**Overall rating:** LOW  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=WARN: clustering mismatch), csdid (impl=PASS; updated 2026-04-19), bacon (impl=WARN: run_bacon=false insufficient grounds; TvT share unavailable), honestdid (impl=PASS; Mbar_first=2.0 both, Mbar_avg=0.75 TWFE/1.25 CS-NT, Mbar_peak=0.50 TWFE/0.75 CS-NT), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, 0.07%)

---

## Executive summary

Galasso & Schankerman (2024) estimate the effect of Medicines Patent Pool (MPP) membership on drug access using a staggered DiD design across 6,746 country-by-product units, 14 years (2005-2018), with 84.6% never-treated and 7 treatment cohorts. The 2026-04-19 update resolves the primary prior failure: toggling allow_unbalanced from false to true recovered CS-DID from complete NA to a valid CS-NT ATT of 0.7135 (se = 0.0331), directionally consistent with TWFE = 0.6625 at a modest +7.7% premium -- the expected direction when forbidden comparisons are a small share of TWFE weight. The paper-auditor records an EXACT fidelity verdict (0.07% gap). The stored TWFE estimate reliably captures the paper headline result and our modern CS-DID estimate corroborates it. The rating is LOW because two implementation concerns persist: (1) one-way clustering (product_code only) versus the paper two-way clustering (product x country), which underestimates standard errors; and (2) the Bacon decomposition remains disabled despite a 7-cohort staggered design that is computationally trivial for bacondecomp. The design-credibility finding (separate axis) is D-MODERATE: the first-post-period ATT survives violations up to Mbar = 2 (very robust), but the average ATT breaks down at Mbar ~0.75 (TWFE) / 1.25 (CS-NT), and significant pre-period coefficients at t = -3 and t = -4 are a substantive design concern. The user can trust the stored CS-NT ATT as the best available estimate of the paper treatment effect; the TWFE estimate is corroborated but should be interpreted with awareness of the pre-trend signals.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Pre-period coefficients at t = -4 (beta = +0.046, se = 0.016, t = 2.8) and t = -3 (beta = +0.042, se = 0.011, t = 3.8) are statistically significant -- a design finding (Axis 3), not an implementation failure.
- Clustering mismatch: template uses one-way clustering on product_code; paper uses two-way clustering (product_code x country_code). SE underestimation in results.csv is the implementation concern (Axis 2 WARN).
- Post-period TWFE coefficients (0.62-0.77) are large, consistent, and monotonically growing -- a positive signal for effect stability.
- Full report: reviews/twfe-reviewer.md

### CS-DID (PASS -- updated 2026-04-19)
- CS-NT ATT = 0.7135 (se = 0.0331), statistically significant, direction unanimous with TWFE.
- The +7.7% premium over TWFE (0.6625) is consistent with TWFE minor downward bias from forbidden comparisons in an 84.6%-never-treated sample.
- allow_unbalanced = true is the correct setting for an 84.8%-fill-rate panel; the prior false setting caused forced balancing to produce NA estimates.
- Full report: reviews/csdid-reviewer.md

### Bacon (WARN)
- run_bacon = false in metadata; no Bacon output available. Formal verification of TWFE weight signs is unavailable.
- Justification (large dataset size) is insufficient: a 7-cohort staggered design requires only 28 two-by-two comparisons, well within bacondecomp capacity.
- TvT share expected to be low given 84.6% never-treated; multi-estimator consistency (TWFE / CS-NT / SA / Gardner all in 0.62-0.74 range) provides strong indirect reassurance.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)
- Mbar_first = 2.0 for both TWFE and CS-NT -- the first-post-period ATT survives violations up to 2x pre-period variation, a very strong standard.
- Mbar_avg = 0.75 (TWFE) / 1.25 (CS-NT). CS-NT average ATT is more robust, consistent with CS-NT being the correct estimator for this design.
- Mbar_peak = 0.50 (TWFE) / 0.75 (CS-NT). Peak ATT is moderately robust.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary staggered design; no dose heterogeneity or treatment reversals. CS-DID is the appropriate estimator.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper-Auditor (EXACT)
- Stored beta = 0.6625 vs paper beta = 0.663 (Table 2, Col 1); relative gap = -0.07%, well within the 1% EXACT threshold.
- SE divergence (0.0504 vs paper 0.054, -6.6%) fully explained by documented one-way vs. two-way clustering difference.
- N discrepancy of 2 observations (80,103 vs 80,101) is negligible.
- Full report: reviews/paper_audit.md

---

## Three-way controls decomposition

N/A -- paper has no original covariates (twfe_controls = [], cs_controls = []); unconditional comparison only. Specs B = C = headline; Spec A not applicable.

---

## Three-axis rating breakdown

**Axis 1 -- Fidelity:** F-HIGH (paper-auditor: EXACT, 0.07% gap)

**Axis 2 -- Implementation:** I-LOW (2 implementation WARNs)
- WARN 1 (twfe-reviewer): one-way clustering vs. paper two-way clustering -- documented mismatch, SE underestimation.
- WARN 2 (bacon-reviewer): run_bacon = false on a computationally tractable 7-cohort design prevents formal TWFE weight verification.

**Axis 3 -- Design credibility:** D-MODERATE (finding about the paper, not a rating demerit)
- Mbar_first = 2.0 for both TWFE and CS-NT -- D-ROBUST at first-post threshold.
- Mbar_avg = 0.75 (TWFE) / 1.25 (CS-NT) -- D-MODERATE (Mbar in [0.5, 1] for TWFE).
- Pre-period coefficients at t = -3 (3.8 sigma) and t = -4 (2.8 sigma): treated units appear on a rising trajectory before MPP adoption, potentially reflecting anticipatory effects or genuine pre-trends.
- Bacon TvT share: not computed; expected low given 84.6% never-treated.
- Overall design verdict: D-MODERATE (first-post very robust; average ATT moderately robust; pre-trends a substantive concern requiring author-level explanation).

**Final rating matrix:** F-HIGH x I-LOW = **LOW**

---

## Material findings (sorted by severity)

**WARN (Implementation Axis 2):**
- Clustering mismatch: one-way product_code clustering in results.csv vs. paper two-way product_code x country_code. Standard errors are underestimated relative to the paper. Effect significance should be interpreted with the paper larger SEs (0.054 vs. our 0.0504). Beta is unaffected.
- Bacon decomposition disabled (run_bacon = false) on an insufficient justification. A 7-cohort staggered design is computationally trivial for bacondecomp. Re-enabling would formally verify TWFE weight signs and TvT share.

**Design findings (Axis 3 -- informational, not demerits):**
- Pre-period TWFE coefficients at t = -4 (beta = +0.046, se = 0.016) and t = -3 (beta = +0.042, se = 0.011) are statistically significant across TWFE, CS-NT, and SA. This is a design-credibility concern for the paper parallel trends assumption.
- Average ATT robustness (Mbar_avg = 0.75 TWFE) means pre-trend violations of ~75% of pre-period variation magnitude would cause sign loss. Given the observed pre-trend magnitudes, this is a non-trivial concern.
- The CS-NT average ATT is more robust (Mbar_avg = 1.25), providing a more credible HonestDiD bound on the paper causal claim.

---

## Recommended actions

- **Repo-custodian:** Set run_bacon = true in data/metadata/311.json and re-run the Analyst stage. The 7-cohort staggered design requires only 28 two-by-two comparisons. Pre-balance the panel to the observation years common across all cohorts, or use the balanced subset within each 2x2 pair as bacondecomp does by default.
- **No action needed on allow_unbalanced:** The 2026-04-19 fix is correct and the CS-DID NA failure is resolved. allow_unbalanced = true should be retained.
- **User (methodological judgement):** The significant pre-period coefficients at t = -3 and t = -4 may reflect: (a) anticipatory access effects, (b) differential pre-trends between treated and never-treated country-product pairs, or (c) measurement noise in the early years. The HonestDiD bound (Mbar_first = 2) suggests the first-year effect is very robust, but the authors should be asked whether they report formal pre-trend tests and whether any anticipation window is built into their specification.
- **No action needed on fidelity:** EXACT match at 0.07%; no metadata correction required.

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper_audit.md

