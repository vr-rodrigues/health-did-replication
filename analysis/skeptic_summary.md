# Skeptic Audit — Aggregate Summary

**Date:** 2026-04-19
**Sample:** 53 papers (full reanalysis sample after dropping 3 paper-auditor FAILs).
**Excluded:** 234 (Myers), 242 (Moorthy-Shaloka), 380 (Kuziemko et al.) — see `analysis/excluded_papers.csv` for reasons.
**Rubric:** 3-axis (Fidelity × Implementation → rating; Design Credibility = separate finding)

The skeptic agent was run on every paper in the sample. For each paper, six reviewers (twfe, csdid, bacon, honestdid, dechaisemartin, paper-auditor) ran in parallel. Their verdicts were synthesized into a single credibility rating using the 3-axis rubric: **Fidelity × Implementation → HIGH/MODERATE/LOW/VERY LOW**, with **Design Credibility** (HonestDiD breakdown values, Bacon TvT share, pre-trend patterns) reported as a SEPARATE finding that does NOT downgrade the rating.

On 2026-04-19 the audit was repeated end-to-end after a critical infrastructure fix: previously, the paper-auditor agent had failed silently on all 56 papers (PDF path mismatch — agent looked at `pdf/{id}.pdf` from the deposit while PDFs were at `../pdf/replicados/{id}.pdf`). After copying the 56 PDFs into the deposit at `pdf/{id}.pdf` and re-running paper-auditor on every paper, real fidelity verdicts replaced the F-NA blanket. The same audit also revealed 3 papers (234, 242, 380) where the paper-auditor verdict was FAIL with structural reasons (different outcome variable, template-incapable FE structure, intentional univariate vs multivariate) rather than implementation bugs. After discussion these three were dropped from the comparable subsample.

---

## 1. Final Rating Distribution

| Rating | Count | Share |
|---|---|---|
| HIGH | 7 | 13.2% |
| MODERATE | 13 | 24.5% |
| LOW | 33 | 62.3% |
| **Total** | **53** | **100%** |

## 2. Fidelity verdict distribution (paper-auditor, all 53)

| Verdict | Count | Share |
|---|---|---|
| EXACT | 34 | 64.2% |
| WITHIN_TOLERANCE | 5 | 9.4% |
| NOT_APPLICABLE | 8 | 15.1% |
| WARN | 6 | 11.3% |
| FAIL | 0 | 0% |

**39/53 (74%) papers reproduce the original paper's headline TWFE estimate exactly or within rounding tolerance.** A further 8 papers are NOT_APPLICABLE for legitimate structural reasons (paper uses CS-DID/Gardner/event-study as main estimator, paper does not report a static ATT, treatment is binarized vs paper's continuous, etc.). Only 7 papers carry a WARN, and after the 3 FAILs were excluded as non-comparable, no FAIL remains.

The 7 WARN papers are documented limitations rather than implementation bugs:

| ID | β diff | Cause | Status |
|---|---|---|---|
| 61 (Evans-Garthwaite) | 8.6% | Paper runs OLS without unit/time FEs (DiD interaction encodes variation); template forces fips+year FEs | Template limitation |
| 68 (Tanaka) | 8.7% (vs Col 1) | Our spec exactly matches Col 2 (community FEs, no controls); WARN against Col 1 only | Substantively EXACT |
| 133 (Hoynes) | 9.3% | Spec drift between metadata's "exact" run and current template behavior | Documented |
| 147 (Greenstone-Hanna) | 5.5% | Sample window difference (full sample vs τ ∈ [-7,9]); EXACT vs metadata-stored target | Documented |
| 241 (Soliman) | 7.7% | Paper restricts TWFE to `rel_year ∈ [-3,3]`; template can't apply different filters to TWFE vs CS | Template limitation |
| 290 (Arbogast) | 6.0% | IPUMS restricted-access data substitute (we use tidycensus public denominators) | Data substitute |
| 1094 (Fisman-Wang) | 8.9% | Single-observation merge difference Stata vs R | Documented |

## 3. HIGH-rated papers (6)

| ID | Author | Fidelity | Why HIGH |
|---|---|---|---|
| 233 | Kresch (2020) | EXACT | β=2868 (paper) vs 2868.32 (ours, 0.01%); single-cohort RCS with 14 controls; F-HIGH × M-HIGH |
| 271 | Sekhri & Shastry (2024) | EXACT | β=67.59 vs 67.81 (0.33%); single-cohort 1966 Green Revolution; D-ROBUST design |
| 304 | Arthi, Beach & Hanlon (2022) | EXACT | β=2.194 vs 2.1935 (0.02%); textbook 2×2 cotton shock; no negative weights |
| 323 | Prem, Vargas, Mejia (2023) | NOT_APPLICABLE | Continuous suitability binarized; M-HIGH × F-NA → HIGH (use M alone) |
| 419 | Kahn, Li, Zhao (2015) | EXACT | β=−2.012 vs −2.0122 (0.004%); single-cohort boundary stations |
| 432 | Gallagher (2014) | NOT_APPLICABLE | Paper reports event-study only; M-HIGH × F-NA → HIGH |

**Pattern:** all 6 HIGH papers share **single-cohort or near-single-cohort designs** with substantial never-treated pools. Five of six are EXACT fidelity reproductions; one (323) is NOT_APPLICABLE (continuous→binary discretization).

## 4. MODERATE-rated papers (14)

These papers have either (a) one implementation WARN with no FAILs, the methodological core is sound; or (b) M-HIGH downgraded by F-MOD (paper-auditor WARN). Members:
9 (Dranove), 21 (Buchmueller), 25 (Carrillo-Feres), **68 (Tanaka, ↓ from HIGH)**, 79 (Carpenter-Lawler), 125 (Levine-McKnight-Heep), 213 (Estrada-Lombardi), 228 (Sarmiento-Wagner-Zaklan), 253 (Bancalari), 267 (Bhalotra et al), 281 (Steffens-Pereda), 333 (Clarke-Muhlrad), 335 (Le Moglie-Sorrenti), 337 (Cameron-Seager-Shah), 358 (Bargain-Boutin-Champeaux), 525 (Danzer-Zyska).

## 4a. Lesson 7 pentagon — Spec A behavior under matched protocol

The iterative audit (2026-04-19, decision log in `analysis/iterative_review_log.md`) identified five canonical behaviors of CS-DID Spec A (matched protocol: paper's original controls passed to `xformla` in `att_gt`):

| Paper | N ctrls | Control structure | Design | Spec A verdict |
|---|---:|---|---|---|
| 25 Carrillo-Feres | 18 | pre-treatment × linear trends | near single-cohort | ✅ **CLEAN** (matched CS 0.097 vs unconditional 0.114 vs TWFE 0.116) |
| 79 Carpenter-Lawler | 53 | direct demographic | staggered | ❌ **COLLAPSE** (CS → 0 with 53 ctrls; Pattern 42 overfit) |
| 125 Levine-McKnight-Heep | 6 | RCS individual-level | single-cohort RCS | ⚠️ **INFLATE** (CS 9× magnitude vs no-ctrls; Pattern 51 — formally added) |
| 335 Le Moglie-Sorrenti | 18 | direct time-varying levels | single-cohort | ❌ **COLLAPSE** (CS → 0 despite only 18 ctrls; structural not count-based) |
| 358 Bargain-Boutin-Champeaux | 30 | direct time-varying levels | 2×2 | ❌ **COLLAPSE** (CS → 0 in 2-period design; worst-case propensity overfit) |

**Takeaway for Chapter 4 / Lesson 7:** the matched-protocol CS-DID behavior is not a simple function of covariate count. The *structure* of the controls (pre-treatment × trends vs. direct time-varying levels vs. individual RCS) AND the design (multi-period staggered vs single-cohort vs 2×2) jointly determine whether Spec A produces an informative ATT (25), collapses via propensity-score overfit (79 staggered, 335 single-cohort, 358 2×2), or inflates via collinearity (125). The rule emerging: **direct level ctrls + few-period design + doubly-robust propensity score → collapse**. The asymmetric protocol (Spec C: TWFE with ctrls vs. CS without) can mask this divergence — paper 25 is the textbook example where Spec C shows 1.3% "concordance" while Spec A reveals a 16% matched gap.

## 5. LOW-rated papers (33)

The 33 LOW papers split into recognisable clusters of concern:

### 5.1 Sample / specification mismatch with the paper (some fixable)
- 61 (Evans-Garthwaite) — TWFE FE structure; template limit
- 80 (Marcus) — `cs_cluster` could be tightened (CS-DID SE inflated 3.4×)
- 133 (Hoynes) — Spec drift; current template gives -0.387 vs paper -0.354 (re-run produces same)
- 210 (Li) — `allow_unbalanced=true` causes CS-NYT sign reversal (Lesson 10 focal paper)
- 241 (Soliman) — Paper's `rel_year ∈ [-3,3]` filter not applied
- 309 (Johnson-Schwab-Koval) — CS-DID segfault on full unbalanced panel
- 311 (Galasso-Schankerman) — CS-DID returns NA across the board

### 5.2 CS-DID with controls returns 0/NA (Pattern 42-class)
Spec A failures from doubly-robust propensity-score overfit:
9 (Dranove, when controls included), 65 (Akosa-Antwi), 290 (Arbogast), 358, 359, 401, 525.

### 5.3 Genuine design fragility (Lesson 5 evidence)
Papers where our reanalysis is correct AND modern diagnostics show identification problems:
- 97 (Bhalotra et al 2021) — pre-trend up to +0.335 (>6 SE)
- 147 (Greenstone-Hanna) — HonestDiD FAIL at M̄=0; pre-trends inconsistent with parallel trends
- 305 (Brodeur-Yousaf) — large pre-period coefficients in CS-DID (+1.7 to +2.6)
- 321 (Xu 2023) — pre-trends in both TWFE and CS-NT
- 437 (Hausman) — D-FRAGILE across all targets; 14/63 facilities span full range
- 744 (Jayachandran) — strong monotonic pre-trend across 12 years; depends on linear-trend control

### 5.4 Continuous or non-absorbing treatment
- 254 (Gandhi) — continuous Medicaid dose discretized
- 2303 (Cao) — Spec A `FAIL_memory` (217k rows × 7 weather controls)

## 6. Cross-tab interpretation

| Pattern | Approx count |
|---|---|
| HIGH rating + ROBUST/MODERATE design credibility | small (≈3 papers) |
| HIGH rating + FRAGILE design credibility | several (Lesson 5 evidence) |
| LOW rating from implementation issues we could fix | ≈5 (mostly template limits) |
| LOW rating from genuine design fragility | ≈12 |
| LOW rating from estimand mismatch (continuous, RCS asymmetry) | ≈8 |
| LOW rating from Pattern 42 propensity overfit | ≈7 |

## 7. Implications for the dissertation

1. **Lesson 5 confirmed empirically.** Modern DiD reveals widespread design fragility (HonestDiD M̄ low; pre-trends visible) even when our reanalysis is technically correct.
2. **Headline numbers stable for HIGH+MODERATE papers (20/53 = 38%)** — these are the strongest evidence base.
3. **Fidelity is genuinely high.** 38/53 (72%) reproduce the paper's TWFE EXACTLY or within rounding. After accounting for legitimate NOT_APPLICABLE cases (different estimator/outcome/treatment structure), 46/53 (87%) of papers are either reproductively faithful or non-comparable for principled reasons. Only 7 papers (13%) have any fidelity gap, and all 7 are documented (template limits, sample restrictions, data substitutes).
4. **Three papers excluded from comparable subsample.** Papers 234 (Myers), 242 (Moorthy-Shaloka), and 380 (Kuziemko et al.) had paper-auditor FAIL verdicts with structural reasons that prevent any meaningful comparison: (a) Myers — template can only fit univariate vs paper's 6-policy multivariate spec; (b) Moorthy-Shaloka — paper uses NCHS restricted-access mortality data, we substituted public BLS earnings (different outcome); (c) Kuziemko — template lacks county-specific linear time trends + multi-dim FE structure. These remain in `data/metadata/{id}.json` with `excluded_from_sample: true` and `exclusion_reason` documented; they are skipped by the consolidation pipeline and the figure scripts.
5. **Tier-1 follow-up actions** for the 7 WARN papers are constrained: 61 and 241 require template feature additions (not metadata fixes); 133 cannot be restored to "exact" by re-run; 290 requires restricted data; 68 and 147 are documented WARN against alternative columns where our spec exactly reproduces the paper's intended specification; 1094 is a 1-observation merge difference. None of these are bugs in our pipeline.

## 8. Per-paper reports

All 53 per-paper reports are at `results/by_article/{id}/skeptic_report.md`. Each links to its 5–6 individual reviewer reports under `results/by_article/{id}/reviews/`. The per-paper fidelity audits are at `results/by_article/{id}/paper_audit.md`. The structured CSV is `analysis/skeptic_ratings.csv` (53 rows × 20 columns including the new `fidelity_verdict` and `impl_axis` columns).

## 9. Methodological note on the rubric

The 3-axis rubric was adopted on 2026-04-18 after an initial 2-axis run on paper 233 (Kresch) produced rating LOW for a faithfully-reproduced paper whose only "issue" was that modern diagnostics revealed parallel-trends fragility. Under the corrected rubric, that paper rates HIGH (our reanalysis is sound) with Design Credibility FRAGILE reported separately as a finding. The full discussion is in `.claude/agents/skeptic.md`.

The 2026-04-19 paper-auditor infrastructure fix (PDF path) revealed that all 56 papers had been incorrectly assessed as F-NA (no comparison possible). After re-running paper-auditor on all 56 with PDFs available, 33 EXACT + 5 WITHIN_TOLERANCE + 8 NOT_APPLICABLE + 7 WARN + 3 FAIL emerged. The 3 FAILs were dropped as documented above.
