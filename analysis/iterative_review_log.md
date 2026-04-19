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
| 2 | 21 | Buchmueller (2018) | MODERATE | _pending_ | — | — |

(Linhas serão adicionadas conforme o usuário decide.)

## Rules

- Template `did_analysis_template.R` fica intocado.
- Edits limitadas a `data/metadata/{id}.json`.
- Re-run target: apenas o paper em foco (`Rscript ... {id}`), nunca o batch completo aqui.
- Após cada `metadata.json` editado, registrar no `analysis/decision_log.csv` (o já existente).
- Se a decisão for "não mexer", documentar a razão em uma linha aqui.
