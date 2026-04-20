# Skeptic report: 311 -- Galasso and Schankerman (2024)

**Overall rating:** LOW  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=WARN: clustering mismatch only; pre-trends=Axis3), csdid (impl=PASS), bacon (impl=WARN: run_bacon=false on tractable 7-cohort design; TvT_share=Axis3_N/A), honestdid (impl=PASS; M_first=2.0 both, M_avg=0.75 TWFE/1.25 CS-NT, M_peak=0.50 TWFE/0.75 CS-NT), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT, 0.07%)

---

## Executive summary

Galasso and Schankerman (2024) estimate the effect of Medicines Patent Pool (MPP) membership on drug access using a staggered DiD design across 6,746 country-by-product units, 14 years (2005-2018), with 84.6% never-treated and 7 treatment cohorts (2011-2017). Our reanalysis achieves EXACT fidelity (beta gap = -0.07%) and CS-DID produces a valid ATT of 0.7135 after the 2026-04-19 allow_unbalanced fix. The stored estimate reliably captures the paper headline. The rating is LOW because two Axis-2 implementation concerns persist: (1) one-way clustering on product_code versus the paper two-way clustering (product x country), which understates SEs by approximately 6.6%; and (2) run_bacon=false in metadata despite a computationally tractable 7-cohort design. Pre-trends, HonestDiD M-bar values, and expected Bacon TvT shares are Axis-3 design findings, not Axis-2 implementation WARNs. The design-credibility finding (Axis 3) is D-MODERATE: first-post ATT is very robust (M_bar=2.0 both estimators), average ATT is moderately robust (M_bar=0.75 TWFE / 1.25 CS-NT), and significant pre-period coefficients at t=-3 and t=-4 are a substantive design concern for the paper parallel-trends assumption.

---

## Per-reviewer verdicts

### TWFE (WARN -- Axis 2: clustering mismatch only)
- **Axis-2 WARN:** Template uses one-way clustering on product_code; paper uses two-way (product_code x country_code). Stored SEs (0.0504) understate paper SEs (0.054) by 6.6%. Beta is unaffected; direction and significance preserved at both clustering levels.
- **Axis-3 design finding (not a demerit):** Pre-period coefficients at t=-4 (beta=+0.046, t-stat=2.8) and t=-3 (beta=+0.042, t-stat=3.8) are statistically significant across TWFE, CS-NT, and SA -- consistent signal of rising pre-treatment trajectory. This is a design-credibility concern for the paper, not a pipeline error.
- **Axis-3 design finding:** Staggered adoption risk (7 cohorts) motivates running CS-DID alongside TWFE; multi-estimator consistency (range 0.62-0.77 post-period) provides indirect reassurance.
- Full report: reviews/twfe-reviewer.md

### CS-DID (PASS)
- CS-NT ATT = 0.7135 (se = 0.0331), statistically significant, directionally unanimous with TWFE (0.6625). Gap = +7.7%, expected when 84.6% never-treated limits forbidden-comparison contamination.
- allow_unbalanced = true correctly set (2026-04-19 fix). Forced balancing of an 84.8%-fill-rate panel caused prior NA estimates; native unbalanced handling is methodologically appropriate.
- No controls (twfe_controls = [], cs_controls = []); unconditional parallel trends invoked consistently across both estimators.
- Full report: reviews/csdid-reviewer.md

### Bacon (WARN -- Axis 2: metadata flag)
- **Axis-2 WARN:** run_bacon=false in metadata on a design with 7 cohorts + 1 never-treated group requiring only 28 two-by-two comparisons. The stated justification (large dataset size) is incorrect -- O(G^2) computation is trivial; 94K observations is within bacondecomp capacity.
- **Axis-3 design finding (not a demerit):** Formal TvT share unavailable. Indirect evidence (84.6% never-treated, multi-estimator consistency across TWFE/CS-NT/SA/Gardner) strongly suggests TVU-dominant decomposition with low TvT contamination.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)
- M_bar_first = 2.0 for both TWFE and CS-NT: first-post ATT survives violations up to 2x pre-period variation. Very robust.
- M_bar_avg = 0.75 (TWFE) / 1.25 (CS-NT): average ATT survives violations in [0.75, 1.25]x pre-period variation. D-MODERATE per rubric.
- M_bar_peak = 0.50 (TWFE) / 0.75 (CS-NT): peak ATT moderately robust.
- These M-bar values are Axis-3 design findings. PASS verdict reflects correct HonestDiD implementation (n_pre=4, n_post=6).
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary staggered design; no dose heterogeneity or treatment reversals. CS-DID is the appropriate estimator; DIDmultiplegtDYN adds no information here.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper-Auditor (EXACT)
- Stored beta = 0.6625 vs paper beta = 0.663 (Table 2, Col 1); relative gap = -0.07% -- well within 1% EXACT threshold.
- SE divergence (0.0504 vs paper 0.054, -6.6%) fully explained by one-way vs. two-way clustering. Verdict unaffected.
- N discrepancy of 2 observations (80,103 vs 80,101) negligible.
- Full report: reviews/paper_audit.md

---

## Three-way controls decomposition

N/A -- paper has no original covariates (twfe_controls = [], cs_controls = []); unconditional comparison only. Specs A = B = C = headline. No decomposition applicable.

---

## Three-axis rating breakdown

**Axis 1 -- Fidelity:** F-HIGH (paper-auditor: EXACT, 0.07% gap)

**Axis 2 -- Implementation:** I-LOW (2 Axis-2 WARNs; 0 FAILs)
- WARN 1 (twfe-reviewer): one-way clustering vs. paper two-way clustering -- documented SE underestimation 6.6%; beta unaffected.
- WARN 2 (bacon-reviewer): run_bacon=false on a 7-cohort staggered design where Bacon is applicable and computationally trivial. Formal TvT verification absent.
- NOTE: TWFE pre-trend observations, CS-DID unbalanced-panel behavior, and HonestDiD M-bar values are Axis-3 design findings, NOT counted on Axis 2.

**Axis 3 -- Design credibility:** D-MODERATE *(finding about the paper; not a rating demerit)*
- M_bar_first = 2.0 (TWFE and CS-NT): D-ROBUST at first-post threshold.
- M_bar_avg = 0.75 TWFE / 1.25 CS-NT: falls in [0.5, 1] for TWFE -> D-MODERATE per rubric.
- Pre-period: t=-4 (beta=+0.046, t-stat=2.8) and t=-3 (beta=+0.042, t-stat=3.8) statistically significant across all estimators.
- Bacon TvT share: not computed; expected low given 84.6% never-treated.
- Overall: D-MODERATE (first-post very robust; average ATT moderately robust; pre-trends a substantive paper design concern).

**Final rating matrix:** F-HIGH x I-LOW = **LOW**

---

## Material findings (sorted by severity)

**WARN -- Axis 2 (Implementation):**
- Clustering mismatch: one-way product_code in results.csv vs. paper two-way product_code x country_code. SEs understated by ~6.6%. Effect remains significant at paper larger SEs; beta unaffected.
- Bacon disabled (run_bacon=false) on insufficient grounds for a 7-cohort staggered design. Formal TWFE weight verification unavailable.

**Design findings -- Axis 3 (informational; not demerits against our reanalysis):**
- Pre-period coefficients at t=-4 and t=-3 statistically significant across TWFE, CS-NT, and SA. Treated units on rising trajectory before MPP adoption. Consistent with anticipatory effects or genuine differential pre-trends.
- Average ATT HonestDiD: TWFE average loses significance at M_bar~0.75. Given pre-trend magnitudes (~0.04 at t=-3/-4 vs. post-period ATT ~0.64), M_bar bound is comfortable but warrants author explanation.
- CS-NT average ATT more robust (M_bar_avg=1.25): paper causal claim survives moderate parallel-trends violations under the modern estimator.

---

## Recommended actions

- **Repo-custodian:** Set run_bacon=true in data/metadata/311.json and re-run the Analyst stage. Pre-balance to units observed across all 14 years or use bacondecomp built-in balanced-subset approach. A 7-cohort design requires only 28 comparisons.
- **No action needed on allow_unbalanced:** 2026-04-19 fix is correct; allow_unbalanced=true should be retained.
- **No action needed on fidelity:** EXACT match at 0.07%; no metadata correction required.
- **User (methodological judgement):** Significant pre-period coefficients at t=-3 and t=-4 may reflect (a) anticipatory access effects prior to formal MPP adoption, (b) differential pre-trends between treated and never-treated country-product pairs, or (c) measurement noise. Authors should be asked whether they report formal pre-trend tests and whether an anticipation window is modelled.

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper_audit.md
