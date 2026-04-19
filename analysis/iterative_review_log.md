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

(Linhas serão adicionadas conforme o usuário decide.)

## Rules

- Template `did_analysis_template.R` fica intocado.
- Edits limitadas a `data/metadata/{id}.json`.
- Re-run target: apenas o paper em foco (`Rscript ... {id}`), nunca o batch completo aqui.
- Após cada `metadata.json` editado, registrar no `analysis/decision_log.csv` (o já existente).
- Se a decisão for "não mexer", documentar a razão em uma linha aqui.
