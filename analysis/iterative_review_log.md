# Iterative Review Pipeline — MODERATE → LOW

**Started:** 2026-04-19
**Goal:** revisar paper por paper, decidir caso a caso o que (se algo) mexer, re-rodar análise quando aplicável, atualizar rating skeptic.

## Pipeline (per paper)

1. **Audit report** — Claude lê `results/by_article/{id}/skeptic_report.md` + reviewers + `metadata.json` + `results.csv`. Retorna:
   - Rating atual + design credibility
   - Principais achados dos 5 reviewers (PASS/WARN/FAIL com 1 linha cada)
   - O QUE reviewers sugerem mexer (lista numerada de candidatos)
   - Custo/risco de cada mudança
2. **User decides** — escolhe entre: (a) aplicar mudança X, (b) NA — está certo, deixa LOW/MOD com nota, (c) outra ação.
3. **Apply** — Claude edita `data/metadata/{id}.json` (única edição permitida sem aprovação extra; código template é fixo).
4. **Re-run** — `Rscript code/analysis/01_run_all_did.R {id}` + atualiza `consolidated_results.csv` + (se mudou material) re-roda skeptic.
5. **Report new result** — diff antes/depois + nova rating skeptic.
6. **User decides** — outra mudança ou próximo.

## Order

MODERATE first (16 papers, ordem por ID): 9, 21, 25, 79, 125, 213, 228, 253, 267, 281, 323, 333, 335, 337, 358, 525.
LOW after (34 papers).

## Decision log

| # | id | author | original rating | decision | new rating | notes |
|---|---|---|---|---|---|---|
| 1 | 9 | Dranove (2021) | MODERATE | B — add Pattern 42 note to Spec A in metadata; no re-run | MODERATE (unchanged) | 1-line metadata.notes edit; estimates stable |
| 2 | 21 | Buchmueller (2018) | MODERATE | D — set allow_unbalanced=false (within 22-paper global sweep, 2026-04-19) | MODERATE (unchanged) | β_TWFE byte-identical; ATT_NT −4.7% shift |
| 3 | 25 | Carrillo-Feres (2019) | MODERATE | C — investigated Spec A, documented Lesson 7 case study in metadata.notes | MODERATE (unchanged) | Spec A: 0.116 vs 0.097 (16% matched gap); Spec B: 0.128 vs 0.114 (11%); Spec C (legacy): 0.116 vs 0.114 — asymmetric C hid real gap |
| 4 | 79 | Carpenter-Lawler (2019) | MODERATE | 2 — documented Pattern 42 degenerate case in notes; counter-example to paper 25 | MODERATE (unchanged) | Spec A (53 ctrls) collapses CS-DID to 0 (overfit); Spec B: TWFE=0.153 vs CS-NT=0.163 vs CS-NYT=0.087; Lesson 7 "degenerate" case |
| 5 | 125 | Levine-McKnight-Heep (2011) | MODERATE | 2 — documented Pattern 25b/Lesson7 inflate case + formalized as Pattern 51 in knowledge base | MODERATE (unchanged) | RCS+6 ctrls inflates CS-NT 9× to false-positive; TWFE robust null; completes Lesson 7 triptych clean/collapse/inflate |
| 6 | 213 | Estrada-Lombardi (2022) | MODERATE | 2 — documented HonestDiD D-FRAGILE as structural (n_post=1); no Spec A (0 ctrls) | MODERATE (unchanged) | TWFE=-0.037 EXACT paper; CS-NT=-0.030 (Pattern 25 RCS gap); single-cohort clean |
| 7 | 228 | Sarmiento-Wagner-Zaklan (2023) | MODERATE | 1 — documented data-granularity WARN + Lesson 6 positive (NT≈NYT 0.3%) | MODERATE (unchanged) | Paper uses CS-DD+daily+weather; we use yearly+no-ctrls. 0 ctrls → no Spec A |
| 8 | 253 | Bancalari (2024) | MODERATE | 1 — documented Lesson 8 Bacon-attenuation case study (paper acknowledges gap) | MODERATE (unchanged) | TWFE 0.74 (EXACT) vs CS-DID 1.79 (paper) = 2.4x Bacon-attenuation; 0 ctrls |
| 9 | 267 | Bhalotra et al (2022) | MODERATE | 1 — Lesson 8 case (negative direction); allow_unbalanced=true retained (false breaks CS) | MODERATE (unchanged) | TWFE -0.082 (EXACT) vs CS -0.127 (+55%); pair with 253 forms negative/positive Lesson 8 symmetry |
| 10 | 281 | Steffens-Pereda (2025) | MODERATE | 1 — documented synthetic-panel serial dependence + null-robust across estimators | MODERATE (unchanged) | TWFE=0.0024 CS-NT=0.0003 both ns; single-cohort; 0 ctrls; paper-auditor N/A (paper uses event-study only) |
| 11 | 333 | Clarke-Muhlrad (2021) | MODERATE | 2 — documented WARNs as design (not implementation); kept MODERATE | MODERATE (unchanged) | TWFE -0.064 EXACT (0.66%); CS-NT -0.058 (9% gap); pre-trend in Mexico DF pre-2007 → D-FRAGILE paper design; 0 ctrls |
| 12 | 335 | Le Moglie-Sorrenti (2022) | MODERATE | 1 — Lesson 7 refinement to quadrangulum; direct-level ctrls → 2nd collapse variant | MODERATE (unchanged) | TWFE 0.041 EXACT; Spec A collapses to 0 despite 18 ctrls (vs paper 25 with 18 pre-treat×trends = clean); structure matters not count |
| 13 | 337 | Cameron-Seager-Shah (2021) | MODERATE | 1 — documented CS-NT WARN as few-cluster structural (K=6), not implementation | MODERATE (unchanged) | TWFE 0.273 EXACT; CS-NT SE 13.7× due to 6 treated clusters; paper uses wild cluster bootstrap; 0 ctrls |
| 14 | 358 | Bargain-Boutin-Champeaux (2019) | MODERATE | 1 — added to Lesson 7 pentagon (3rd direct-level collapse); skeptic_summary updated | MODERATE (unchanged) | TWFE 4.18 EXACT; Spec A collapses (30 ctrls × 2×2); consolidates rule direct-level-ctrls → collapse |
| 15 | 525 | Danzer-Zyska (2023) | MODERATE | 1 — documented TREAT-as-load-bearing-dummy; no-ctrls TWFE is different estimand not robustness | MODERATE (unchanged) | TWFE=-0.008 WITHIN_TOLERANCE; Spec B sign-reversal due to TREAT role; Spec A collinearity collapse |
| 16 | 68 | Tanaka (2014) | MODERATE | 1 — updated metadata target from Col 1 to Col 2 (matches our community-FE spec); re-ran paper-auditor → EXACT; rating back to HIGH | **HIGH** (↑ from MOD) | β=0.567 vs Col 2 0.571 = 0.66% EXACT; WARN was column-targeting error |

**16 MODERATE papers audited. Final rating distribution after iterative review: HIGH 7 / MOD 13 / LOW 33 = 53.**

## LOW papers decision log

Note: papers 125, 253, 525 appear in both MOD and LOW lists (skeptic-elevated-to-MOD rows that the strict 3-axis rubric classifies as LOW). Already audited in MOD phase, not re-audited here.

| # | id | author | decision | new rating | notes |
|---|---|---|---|---|---|
| 17 | 44 | Bosch-Campos-Vazquez (2014) | 1 — documented all-eventually-treated + endogenous ctrls + D-FRAGILE | LOW (unchanged) | paper reports only event-study; 4 WARNs all design/data; sign reversal TWFE vs CS-NYT |
| 18 | 47 | Clemens (2015) | 1 — 4th direct-level collapse (Pattern 42 variant) + pre-trend t=-5 as design | LOW (unchanged) | Paper-auditor EXACT 0.03%; TWFE robust OLS vs CS-DID fragile DR; HonestDiD robust Mbar=1 |
| 19 | 60 | Schmitt (2018) | 1 — 6th Lesson 7 case: AMPLIFY variant (6 direct-level ctrls, staggered); hexagon updated | LOW (unchanged) | Paper-auditor EXACT 0.25%; Spec A OK, CS +57% mag; direction preserved; Bacon clean 93.8% TVU |
| 20 | 61 | Evans-Garthwaite (2014) | 1 — WARN is template-limit (can't opt out of FE); 5th Lesson 7 direct-level collapse | LOW (unchanged) | Paper uses plain OLS; template forces fips+year FEs → 8.59% gap; fix=template change; Spec A collapses with 2 ctrls |
| 21 | 65 | Akosa Antwi-Moriya-Simon (2013) | 1 — collapse #6 documented briefly | LOW | EXACT (0.18%); 12 RCS ctrls → Spec A 0/NA |
| 22 | 76 | Lawler-Yewell (2023) | 1 — collapse #7 documented briefly | LOW | EXACT 0.06%; 21 ctrls → Spec A 0/NA; ctrls double TWFE |
| 23 | 80 | Marcus et al (2022) | 1 — null robust, 0 ctrls, Pattern 25 CS gap | LOW | EXACT 0.83%; all estimators ns |
| 24 | 97 | Bhalotra et al (2021) | 1 — documented special case: "twfe_controls" are composite-DiD components not substantive covariates; TWFE no_ctrls=−0.303 = with_ctrls; Spec A/B N/A | LOW (unchanged) | EXACT 0.09%; design D-FRAGILE (pre-trend +0.335 t=-4); 8th collapse is composite-artefact |
| 25 | 133 | Hoynes et al (2015) | 1 — WARN 9.3% is template drift (not metadata); 9th collapse | LOW | -0.387 vs -0.354; re-run produces same; requires template investigation out of scope |
| 26 | 147 | Greenstone-Hanna (2014) | 1 — HonestDiD FAIL is design (pre-trends huge); collapse #10; allow_unbalanced=true retained | LOW | EXACT vs metadata target; 9 RCS ctrls + staggered → Spec A 0/NA |
| 27 | 201 | Maclean-Pabilonia (2025) | **REMOVED state×year collapse** from metadata; CS-DID now runs on monthly indiv-level directly; re-run + consolidation | LOW | TWFE 4.609 EXACT; CS-NT simple -22.81 (was -3.04 with collapse); sign reversal amplified; Spec A still collapses (Pattern 42 unavoidable with 19 ctrls × 239 periods DR) |
| 28 | 210 | Li et al (2026) | 1 — Lesson 10 sweep resolved sign reversal; 11 pre-trend coefs = design fragility; 11th collapse | LOW | CS-NYT -0.0065 → +0.034 post-sweep; TWFE WITHIN_TOLERANCE 2.44% |
| 29 | 241 | Soliman (2025) | **sample_filter rel_year[-3,3] applied; cs_sample_filter='' + cs_min_e/max_e clip** | LOW | TWFE WARN→EXACT (-31.52 matches paper byte-identical); CS-NT dyn=-40.96 clipped; Lesson 8 attenuation |
| 30 | 254 | Gandhi et al (2024) | 1 — documented design mismatch (paper IL-vs-non-IL, ours within-IL high-vs-low); N/A legitimate | LOW | TWFE 5.49, CS-NT 5.69; heterogeneity high=8.84/low=1.72; no Spec A |
| 31 | 262 | Anderson-Charles-Rees (2020) | 1 — collapse #12 + cohort imbalance documented | LOW | EXACT 0.08%; 1967 cohort 85% weight; CS-NYT underpowered |
| 32 | 263 | Axbard-Deng (2024) | 1 — Pattern 50 SE inflation is FE-structure limit, design D-FRAGILE | LOW | EXACT 0.86%; CS SE 7× (can't absorb industry×time FEs) |
| 33 | 290 | Arbogast et al (2022) | **FIX allow_unbalanced false→true**: CS-DID recovered from FAIL | LOW | TWFE WARN 6% (IPUMS→tidycensus substitute); CS-NT -0.0298 matches paper target -0.031 (3.7%) |
| 34 | 305 | Brodeur-Yousaf (2020) | 1 — EXACT 0.006%; D-FRAGILE is paper design (aroundms imbalance, +1.7/+2.6 pre-trends); 0 ctrls | LOW | TWFE -1.348 matches paper byte-identical; 5 estimators concordant |
| 35 | 309 | Johnson-Schwab-Koval (2024) | **FIX allow_unbalanced false→true**: CS-DID recovered from NA | LOW | TWFE -0.137 EXACT; CS-NT -0.033 (same sign, 4× smaller mag); documentation vs historical number stale |
| 36 | 311 | Galasso-Schankerman (2024) | **FIX allow_unbalanced false→true**: CS-DID recovered from NA | LOW | TWFE 0.6625 EXACT; CS-NT 0.7135 (matches TWFE direction, +7.7% mag) |
| 37 | 321 | Xu (2023) | 1 — EXACT 0.25%; pre-trends are design fragility (1918 pandemic cohort) | LOW | TWFE -0.142; CS-NT -0.110; 0 ctrls |
| 38 | 347 | Courtemanche et al (2025) | 1 — Lesson 8 attenuation case (TWFE 2.5× smaller); documented | LOW | TWFE EXACT; CS -0.448/-0.439 both 2.5× TWFE; custom schema |
| 39 | 359 | Anderson-Charles-Olivares-Rees (2019) | 1 — sign reversal (extreme cohort heterogeneity 1900-1917); collapse #13 | LOW | TWFE -0.036 EXACT; CS +0.012-0.020; 16 cohorts Bacon TVT dominant |
| 40 | 395 | Malkova (2018) | 1 — all-eventually-treated; Lesson 8 attenuation; N/A paper-auditor legit | LOW | TWFE 1.091 vs CS-NYT 1.968 (+80%); 100% timing Bacon |
| 41 | 401 | Rossin-Slater (2017) | 1 — WT 1.56% (state trends); collapse #14; all-eventually-treated | LOW | TWFE -0.0285 matches between Col 4/5 paper; CS noise near zero |
| 42 | 420 | Bailey-Goodman-Bacon (2015) | 1 — Spec C (Durb_f) as headline; Spec A collapses (15th instance); N/A paper-auditor legit | LOW | TWFE -53 / CS-NT -59 (Spec C matched direction); FE structure urban×year unabsorbable by CS |
| 43 | 433 | DeAngelo-Hansen (2014) | 1 — Pattern 51-style inflation (K=1 treated unit + DR overfit); Spec B 0.70 = TWFE byte-identical | LOW | WT 1.45%; single-treated Oregon; Spec A ATT 1.73 artefactual |
| 44 | 437 | Hausman (2014) | 1 — all ns; design/data noisy (14/63 facilities; 3 singleton cohorts); paper's Poisson main estimand not OLS | LOW | EXACT 0.58% TWFE; CS near-zero ns; no Spec A (0 ctrls) |
| 45 | 744 | Jayachandran et al (2010) | 1 — parametric trend dependence; EXACT with trends; collapse #16 | LOW | TWFE no_ctrls +13.62 vs with 3 trend ctrls -0.281; CS-NT -0.333 matches direction |
| 46 | 1094 | Fisman-Wang (2017) | 1 — 9% gap investigated: FE structure matches; gap is Stata data-prep pipeline micro-diffs; null robust | LOW | TWFE -0.047 vs paper -0.051 (ns both); WARN persists, not metadata-fixable |
| 47 | 2303 | Cao-Ma (2023) | **Full re-run completed after 2.5h**: Spec B -5.075 (was NA), Spec A -1.71/-2.04 (was FAIL_memory) | LOW | EXACT 0.01%; all specs recovered; controls attenuate CS ~65% |

**All 30 LOW papers (+ 3 carry-over from MOD) audited. Iterative review phase complete.**
Fidelity: 36 EXACT + 5 WT + 8 N/A + 4 WARN + 0 FAIL  (paper 241 was EXACT now; paper 2303 remaining WARN=0 after all audits).

(Linhas serão adicionadas conforme o usuário decide.)

## Rules

- Template `did_analysis_template.R` fica intocado.
- Edits limitadas a `data/metadata/{id}.json`.
- Re-run target: apenas o paper em foco (`Rscript ... {id}`), nunca o batch completo aqui.
- Após cada `metadata.json` editado, registrar no `analysis/decision_log.csv` (o já existente).
- Se a decisão for "não mexer", documentar a razão em uma linha aqui.
