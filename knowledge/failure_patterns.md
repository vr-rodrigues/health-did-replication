# Failure Patterns Knowledge Base
## Version-controlled between runs. Add new patterns as encountered.

---

## Pattern 1: SA extraction — `se` column does not exist in `iplot` output

**Context**: Extracting Sun-Abraham event study coefficients from `fixest::feols` with `sunab()`.

**Root Cause**: `iplot(fit, only.params=TRUE)` returns a list with element `prms` (a data.frame). This data.frame has columns `x`, `y`, `ci_low`, `ci_high`, `is_ref` — but NO `se` column.

**Resolution Rule**: Always compute SE as:
```r
se = (prms$ci_high - prms$ci_low) / (2 * 1.96)
```
Filter out the reference period with `prms[!prms$is_ref, ]` before extracting.

---

## Pattern 2: BJS term names — wrong format

**Context**: Extracting BJS event study estimates from `didimputation::did_imputation()`.

**Root Cause**: In the Stata `did_imputation` command, terms are named `tau_0`, `tau_1`, `pre_1`, etc. In the R package, terms are plain numeric strings: `"0"`, `"1"`, `"2"`, `"-1"`, etc.

**Resolution Rule**: Filter rows where `grepl("^-?[0-9]+$", trimws(term))` is TRUE, then convert with `as.numeric(term)`. Do NOT use `gsub("(tau|pre)_?", "", term)` — it will not match.

---

## Pattern 3: BJS negative horizons silently dropped

**Context**: Calling `did_imputation(..., horizon = -4:6)` to include pre-treatment periods.

**Root Cause**: The R package silently ignores negative values in `horizon` without error. The `pretrends` argument runs a joint smoothness test (not individual estimates). No pre-treatment BJS estimates are available.

**Resolution Rule**: Use `horizon = 0:event_post` only. BJS event study plots show post-treatment only (t ≥ 0). This is expected and correct — note it in the report.

---

## Pattern 4: BJS fails with individual-level repeated cross-section data

**Context**: Running `did_imputation()` on individual-level survey data (multiple obs per unit-year, e.g., NIS or NLSY data).

**Root Cause**: `did_imputation` requires a proper balanced/unbalanced panel at the unit-time level. Multiple rows per unit-year cause "not a single explanatory variable different from 0" or rank deficiency errors.

**Resolution Rule**:
- If `data_structure == "repeated_cross_section"`: skip BJS in the template (show only TWFE + CS-NT + SA).
- If BJS is desired: pre-aggregate to unit-time level using weighted mean before calling `did_imputation`. Store aggregated dataset separately. This requires custom preprocessing outside the standard template — flag in `notes` of `metadata.json`.

---

## Pattern 5: CSDID singular matrix

**Context**: `att_gt(..., panel=TRUE)` fails with "system is computationally singular" or similar.

**Root Cause**: Too few units per cohort (sometimes only 1-2 states), causing near-singular covariance matrix in the doubly-robust estimator.

**Resolution Rule**: Retry with `faster_mode = FALSE`. This uses a different (slower) variance estimation method that handles small cohorts better. The template does this automatically. If it still fails, CSDID-NT result will be NA — document in report.

---

## Pattern 6: PDF file lock on Windows

**Context**: `ggsave()` fails with permission error when trying to write event_study.pdf.

**Root Cause**: The PDF is already open in a PDF viewer (Acrobat, Edge, etc.) which locks the file on Windows.

**Resolution Rule**: The template uses a tryCatch fallback to save as `event_study_v2.pdf`. Tell user to close PDF viewer and rerun if they want the canonical `event_study.pdf`.

---

## Pattern 7: Stata halfyear format → R integer

**Context**: Article uses Stata half-year time format (e.g., `th(2012h2)` stored as integer 107).

**Root Cause**: Stata encodes half-years as integers: `th(year, h)` = `(year - 1960) * 2 + (h - 1)`. So `th(2007h1)` = 94, `th(2012h2)` = 107, etc.

**Resolution Rule**: Treat as raw integer in R. The value 94 means "2007H1", 107 means "2012H2". `att_gt` and `feols` work with raw integers. Do NOT try to convert to fractional years (e.g., 2007.5) — keep as integers for consistency.

---

## Pattern 8: CSDID with repeated cross-section (panel=FALSE)

**Context**: Data has multiple individuals per unit-year (e.g., state-year combinations with many people). Need CS-DID but not a true panel.

**Root Cause**: `att_gt(panel=TRUE)` requires unique unit-time combinations. Individual-level data violates this.

**Resolution Rule**: Use `panel=FALSE` and create a row-number ID:
```r
df$row_id__ <- seq_len(nrow(df))
att_gt(..., idname="row_id__", panel=FALSE, ...)
```
This treats each observation as a unique "unit" and uses the repeated cross-section estimator.

---

## Pattern 9: Non-contiguous time periods break CS cohort structure

**Context**: Surveys conducted in non-sequential years (e.g., 1988, 1989, 1990, 1991, 1992, 1997) but the CSDID package assumes time periods are sequential integers.

**Root Cause**: `att_gt` internally computes cohort × relative-time cells. If time jumps (1992 → 1997), it misidentifies pre/post periods.

**Resolution Rule**: Recode time to sequential integers before running CS:
- 1988→1, 1989→2, 1990→3, 1991→4, 1992→5, 1997→6
- Set `preprocessing.time_recode` in `metadata.json`
- Also recode `gvar_CS` to the recoded time value of the treatment year

---

## Pattern 10: `sample_filter` in R vs Stata syntax

**Context**: Stata sample restrictions written as `if parentsmallfirm == 1 & state_fips != 25` fail in R.

**Root Cause**: Stata uses `&` and `!= ` the same as R, but some patterns differ:
- Stata: `!missing(x)` → R: `!is.na(x)`
- Stata: `inlist(x, 1, 2, 3)` → R: `x %in% c(1, 2, 3)`
- Stata: `inrange(x, a, b)` → R: `x >= a & x <= b`
- Stata: `x == .` → R: `is.na(x)`

**Resolution Rule**: Always translate to valid R syntax. Test the filter expression in isolation before saving to metadata.json.

---

## Pattern 11: `treatment_twfe` variable not in data — needs construction

**Context**: The TWFE treatment indicator `Post_avg` is constructed in Stata as `(time >= adopt_year) * treated_unit` but doesn't exist in the raw `.dta` file.

**Root Cause**: Stata constructs variables interactively in `.do` scripts. The raw data only contains the components (`treated_unit`, `adopt_year`), not the interaction.

**Resolution Rule**: Add the construction to `data.sample_filter` as additional R code, OR note in `notes` that the analyst needs to construct `Post_avg` before running the template. Example:
```json
"notes": "Post_avg must be constructed: df$Post_avg = (df$year >= df$adopt_year) * df$treated"
```
In future template versions, consider adding a `preprocessing.construct_vars` field.

---

## Pattern 12: Stata monthly date → wrong month extraction with `as.Date()`

**Context**: `construct_vars` extracts month from a Stata monthly date variable (e.g., `start_ym` in Lawler & Yewell 2023).

**Root Cause**: Stata stores monthly dates as integers (e.g., Jan 2012 = 624). Formula: `month = (integer %% 12) + 1`, `year = (integer %/% 12) + 1960`. Using `as.Date()` or `format()` on these integers produces wrong results (interprets integer as days since 1970-01-01).

**Resolution Rule**: Extract month with `(as.integer(x) %% 12L) + 1L`. Extract year with `(as.integer(x) %/% 12L) + 1960L`. **Never** use `as.Date()`, `format()`, or `lubridate` functions on raw Stata monthly date integers.
```r
df$start_month <- (as.integer(df$start_ym) %% 12L) + 1L
df$start_year  <- (as.integer(df$start_ym) %/% 12L) + 1960L
```

---

## Pattern 13: LX/FX tail-bin columns renamed to L9/F9 — inflates Post_avg

**Context**: Event study datasets (e.g., Dranove et al. 2021) have columns L0–L9 (10-period post-treatment window) plus a column `LX` that bins all periods beyond L9 ("10+"). Similarly `FX` bins all pre-treatment periods beyond the window.

**Root Cause**: Renaming `df$L9 <- df$LX` overwrites L9 with the tail bin, causing `Post_avg = rowSums(L0:L9)` to include events far beyond the original study's post-treatment window. The resulting β is inflated/deflated.

**Resolution Rule**: **Never** rename LX→L9 or FX→F9. Use `intersect()` to find only naturally existing event-window columns:
```r
l_cols <- intersect(paste0('L', 0:9), names(df))
df$Post_avg <- as.integer(rowSums(df[, l_cols, drop=FALSE], na.rm=TRUE) > 0)
```

---

## Pattern 14: gvar_CS built via F1==1 instead of L0==1

**Context**: Constructing `gvar_CS` from event study dummies (F1, L0) to identify the first treatment period (Dranove et al. 2021 style datasets with pre-created F/L dummies).

**Root Cause**: `F1 == 1` means "one period BEFORE treatment" — using it as reference yields a cohort year one period too early. `L0 == 1` means "first period OF treatment" — the correct reference.

**Resolution Rule**: Use `L0 == 1` (not `F1 == 1`) to identify the first treated period. Aggregate to `unit_id` level via group mean:
```r
df$gvar_aux <- ifelse(!is.na(df$L0) & df$L0 == 1, as.numeric(df$time), NA_real_)
df <- df %>% group_by(unit_id) %>%
  mutate(gvar_CS_raw = mean(gvar_aux, na.rm = TRUE)) %>% ungroup()
df$gvar_CS <- ifelse(is.nan(df$gvar_CS_raw) | is.na(df$gvar_CS_raw), 0, df$gvar_CS_raw)
```

---

## Pattern 15: gvar_CS varies within unit_id → create composite cell_id

**Context**: Data has multiple observations per natural unit (e.g., parvar × state in Hoynes et al. 2015) where subgroups within the same unit have different treatment timing.

**Root Cause**: `att_gt()` requires `gvar_CS` to be constant within each `unit_id`. If the same `unit_id` value has multiple `gvar_CS` values, CSDID fails with "treatment must be irreversible" or "treatment can't vary within unit".

**Resolution Rule**: Create a composite `cell_id` that uniquely identifies each unit × subgroup combination:
```r
df$cell_id <- df$parvar * 100L + as.integer(df$stateres)
```
Update `unit_id` in `metadata.json` to `"cell_id"` and add the construct expression to `preprocessing.construct_vars`. If singularity persists, remove `cs_controls`.

---

## Pattern 16: Stata xi-expanded variable names vs. actual R names

**Context**: `metadata.json` specifies variables like `educ_category2`, `_Iownersh_2`, `id_worker2` copied from Stata regression output that used `xi:`.

**Root Cause**: Stata's `xi:` command creates indicator variables internally (e.g., `xi: reg y x i.educ_category` creates `_Ieduc_cat_2`, `_Ieduc_cat_3`), but these don't exist in the raw `.dta`. The file stores the original categorical variable (e.g., `educ_category` as numeric with value labels).

**Resolution Rule**: Always check actual variable names with `names(haven::read_dta(file))`. Use the base categorical variable (e.g., `educ_category`) in `additional_fes`. `feols()` handles factor FEs natively. **Never** use xi-expanded names in metadata.

---

## Pattern 17: Template always adds unit+time FEs — plain-OLS articles diverge ~10%

**Context**: Articles that use a treatment variable already encoding the DiD structure (e.g., `dd_treatment = treated_unit × post_period`) and run plain OLS without unit or time FEs.

**Root Cause**: The template always includes `| unit_id + time` in the `feols()` formula. This double-controls by absorbing variation already captured by the treatment indicator, yielding a β that differs from the paper's plain OLS (~9% difference observed in Evans & Garthwaite 2014).

**Resolution Rule**: This is a **known template limitation**. The β will diverge ~10% from the article's OLS. Document in `notes`: `"Template adds unit+time FEs; original uses plain OLS with dd_treatment encoding DiD. ~9% beta difference expected — not a replication failure."` Do **not** remove `unit_id` from metadata (would break CSDID).

---

---

### Padrão 18: TWFE event study com CIs de ±40.000 — controles removidos por `filter(!is.na(rel_time))`

**Context**: Template TWFE event study gerava CIs absurdos (±40.000) porque filtrava todas as unidades nunca-tratadas.

**Root Cause**: A linha `data = df_es %>% filter(!is.na(rel_time))` removia todas as observações com `gvar=0` (nunca-tratadas), pois `rel_time = NA` para elas. Sem o grupo de controle, o modelo de FEs é mal identificado e os erros-padrão explodem.

**Resolution Rule**: A abordagem correta (implementada no template) é criar `rel_time_binned` com um valor de referência para nunca-tratadas (`never_bin = -(ev_pre+2)`), que fica excluído dos coeficientes via `ref=c(-1, never_bin)` no `i()` do fixest. Usar **todos** os dados (incluindo controles) na estimação:
```r
never_bin   <- -(as.integer(ev_pre) + 2L)
far_pre_bin <- -(as.integer(ev_pre) + 1L)
df_es <- df %>% mutate(
  gvar_num = as.numeric(.data[[gcsname]]),
  raw_rel  = as.numeric(.data[[tname]]) - gvar_num,
  rel_time_binned = case_when(
    gvar_num == 0 | is.na(gvar_num)  ~ as.integer(never_bin),
    raw_rel < -as.integer(ev_pre)    ~ as.integer(far_pre_bin),
    raw_rel >= as.integer(ev_post)   ~ as.integer(ev_post),
    TRUE                             ~ as.integer(raw_rel)
  )
)
# Run on ALL data — controls contribute via FEs, not interaction coefs:
feols(y ~ i(rel_time_binned, ref=c(-1, never_bin)) | unit + time, data=df_es)
```
Isso espelha a abordagem do Stata que cria dummies pré-criadas iguais a 0 para os controles.

---

### Padrão 19: BJS pre-treatment estimates indisponíveis no R — usar `pretrends=k` retorna NA

**Context**: Template BJS usa `did_imputation(..., horizon=0:ev_post)`. No Stata, `pretrends(k)` produz k estimativas pré-tratamento visíveis. No R, tentou-se reproduzir isso.

**Root Cause**: O pacote R `didimputation` não suporta horizontes negativos (silenciosamente ignorados em `horizon=`) e `pretrends=k` retorna apenas UM termo com nome opaco (`i(factor_var = zz000event_time, keep = c(k))1`) e estimativa NA. Não é uma série de k coeficientes pré-tratamento individuais — é possivelmente o resultado de um teste de Wald conjunto.

**Resolution Rule**: **Limitação conhecida**: o BJS event study no R mostra apenas períodos pós-tratamento (0 a ev_post). Para verificação de pré-tendências, usar TWFE, CS-NT/NYT ou SA (todos mostram períodos pré). Documentar em notes: "BJS event study: R package não produz estimativas pré-tratamento individuais (limitação do didimputation R vs Stata)."

---

### Padrão 20: `twfe_es_controls` — controles de ponto não adequados para event study

**Context**: Artigos com controles TWFE que incluem interações de tratamento (e.g., Bhalotra 2021: `treated_post_year`, `treated_year`, `treated`, `post`, `y`) para estimar β composto (`β₁ + 2β₂`).

**Root Cause**: Esses controles são quase perfeitamente colineares com as dummies de event-time `i(rel_time_binned)` quando incluídos no event study, causando dropout e padrões absurdos.

**Resolution Rule**: Adicionar campo `twfe_es_controls` em `variables` do metadata.json quando os controles TWFE do ponto devem ser substituídos para o event study. O template prioriza `twfe_es_controls` sobre `twfe_controls` no event study. Para artigos com controles compostos, usar `"twfe_es_controls": []`.

---

### Padrão 21: `es_sample_filter` — exclusão de unidades apenas no event study

**Context**: Artigos que excluem certas unidades do event study mas não do ponto estimado (e.g., Buchmueller 2018: exclui NV/LA/NY/TN do event study mas não do β TWFE principal).

**Root Cause**: O sample_filter principal se aplica a todas as estimativas. Um filtro adicional no event study requer tratamento especial.

**Resolution Rule**: Adicionar `"es_sample_filter"` em `data` do metadata.json. O template aplica esse filtro ao `df_es_base` (base para TWFE, SA, BJS event study). CS usa o objeto `att_gt` já computado — ligeira divergência aceitável. Para `es_sample_filter` referenciar variáveis de `construct_vars`, adicionar a variável ao `df` no último item de `construct_vars` (e.g., `df$state_label <- state_ch`).

---

---

### Padrão 22: BJS em dados de repeated cross-section — agregar para painel (unit×time) primeiro

**Context**: Artigos com dados individuais (repeated cross-section) onde o BJS deve ser estimado ao nível da unidade natural (e.g., fips), não ao nível da linha. Stata's `did_imputation` usa `fe(fips year age)` para absorver FEs; R não suporta isso diretamente.

**Root Cause**: `didimputation::did_imputation()` exige combinações únicas de (idname, tname). Dados individuais têm múltiplas linhas por (fips, year), causando falha. Além disso, `weighted.mean(x, w, na.rm=TRUE)` remove NA de `x` mas NÃO de `w` — se w tiver NA, o resultado da agregação é NA, não o valor correto.

**Resolution Rule**: Definir `"bjs_aggregate_to_panel": true` na seção `analysis` do metadata.json. O template agrega (unit_id × time) usando `sum(w*x)/sum(w)` após filtrar `!is.na(outcome) & !is.na(weight)`. Os FEs de age/outros grupos são perdidos na agregação — é uma aproximação do Stata.

```r
# CORRETO — filtrar NAs de x E w antes de somar:
pre <- df %>% filter(!is.na(outcome), !is.na(weight))
pre %>% group_by(unit, time) %>%
  summarise(outcome = sum(weight*outcome)/sum(weight), ...)
# ERRADO — weighted.mean retorna NA quando weight tem NA:
df %>% group_by(unit, time) %>%
  summarise(outcome = weighted.mean(outcome, weight, na.rm=TRUE), ...)
```

---

### Padrão 23: Tratamento tempo-variante (observation-level) — incompatível com BJS

**Context**: Datasets onde o mesmo `unit_id` (e.g., município) aparece com status de tratamento diferente em diferentes períodos de tempo — i.e., o mesmo município tem linhas com `gvar=0` (pré-tratamento) e `gvar=1991` (pós-tratamento) por ano (Bhalotra et al. 2021, ID 97).

**Root Cause**: `did_imputation` (BJS) exige que `gvar` seja constante dentro de cada `idname`. Um design onde `treated2=1` (controle) e `treated2=2` (tratado) codificam os mesmos municípios em diferentes períodos de tempo resulta no mesmo `mun_reg` tendo `gvar=NA` em alguns anos e `gvar=1991` em outros. Após agregação, cada `mun_reg` terá gvar variando por ano → `did_imputation` retorna resultados vazios silenciosamente.

**Resolution Rule**: BJS **não é aplicável** para designs de tratamento time-varying ao nível de observação. Verificar se o mesmo `unit_id` aparece com diferentes valores de `gvar_CS` em anos diferentes. Se sim, documentar em `notes`: "BJS NOT AVAILABLE: same unit_id appears with varying gvar across years — time-varying treatment design incompatible with did_imputation." **Não** adicionar `bjs_aggregate_to_panel: true` nesses casos — o resultado seria sempre vazio.

---

### Padrão 24: R vs Stata no event study CS com RCS — base_period e efeitos cumulativos vs marginais

**Context**: Dados de repeated cross-section (ID 79, Carpenter & Lawler 2019) onde `att_gt(panel=FALSE)` produz resultados que diferem do Stata `csdid2 ... long2` em duas dimensões: (1) o agregado NT ≈ NYT em R, e (2) os efeitos pós-tratamento no event study diferem entre R e Stata.

**Root Cause — diagnóstico completo após testes extensivos**:

**A) Agregado NT ≈ NYT (aggte simple):**
- R distingue corretamente NT de NYT ao nível celular: 62/72 células ATT(g,t) diferem (max diff=0.094)
- O agregado colapsa porque diferenças positivas e negativas entre células se cancelam no produto com pesos de cohort — coincidência dataset-específica, não bug estrutural
- `faster_mode=FALSE` produz resultado idêntico ao default → não é bug no caminho rápido

**B) Event study NT — pré-período: sinal oposto entre R e Stata**
- Stata NT Pre_avg = -0.048 (negativo, significativo)
- R NT Pre_avg (default `base_period='universal'`) = -0.038 (sinal correto, próximo de -0.048)
- CAUSA: o default de R usa período **variável** como referência (t-1 para cada t), enquanto o Stata `long2` usa o período g-1 como referência **universal** para todos os t
- SOLUÇÃO: usar `base_period='universal'` em `att_gt` → R NT Pre_avg = -0.038 (sinal correto, próximo de -0.048)

**C) Event study NT — pós-tratamento: magnitude diferente**
- Stata NT Post_avg(0:5) = 0.164; R NT (ambos base_period) = 0.101
- CAUSA: Stata `csdid2 ... long2` usa g-1 como referência para TODOS os t (pré E pós) → **efeitos cumulativos** (crescentes). R `aggte(type="dynamic")` usa t-1 como referência para os pós → **efeitos marginais** (menores por período)
- VERIFICAÇÃO: DiD manual com base fixa em g-1 para cohort 2005: k=3 cumulativo = 0.158 ≈ Stata tp3 = 0.164; k=5 = 0.286 vs Stata tp5 = 0.163 (Stata agrega múltiplos cohorts, R só cohort 2005)
- O parâmetro `base_period='universal'` em R NÃO resolve isso — afeta apenas os placebos pré-tratamento, não a estimação pós-tratamento

**D) Event study NYT — boa concordância**
- R NYT Post_avg(0:5) = 0.093 ≈ Stata NYT 0.099 (~6% diferença) — aceitável
- R NYT Pre_avg (universal) = -0.023 ≈ Stata NYT -0.022 — excelente concordância

**E) Ponto estimado (aggte simple) — NÃO afetado por base_period, mas SIM pela contaminação do grupo NT**
- `base_period` só afeta os placebos pré; o agregado `aggte(simple)` é o mesmo
- **ATENÇÃO**: R NT simple = 0.096 (original, com late-treated contaminando o grupo NT) → 0.159 (após fix, removendo late-treated). Stata NT simple ≈ 0.153. Ver Pattern 25.
- A discrepância observada anteriormente (R NT simple ~0.096 vs Stata 0.153) NÃO era diferença metodológica — era bug na construção do grupo controle.

**Implicações práticas**:
- **UPDATE (Pattern 26 REVISED)**: O template agora usa `base_period='universal'` SEMPRE. Isto é o padrão obrigatório — sem exceções.
- **FIX NECESSÁRIO para NT**: verificar se `gvar_CS > max(year)` existe no dataset; se sim, filtrar antes do att_gt NT (ver Pattern 25)
- O ponto estimado (aggte simple) é comparável entre R e Stata APÓS o fix de contaminação NT
- R NYT replica bem Stata NYT (0.096 vs 0.096, match quase exato)

**Resolution Rule**:
1. O template usa `base_period='universal'` SEMPRE (Pattern 26 revisado). Sem exceções.
2. Para CS-NT com `gvar_CS > max(year)` no dataset, aplicar filtro antes do att_gt NT: `df_nt <- df %>% filter(gvar_CS == 0 | gvar_CS <= max(year))`. Ver Pattern 25.
3. Documentar em `notes` do metadata: "Event study: Stata long2 computes cumulative effects (g-1 reference for all t); R aggte(dynamic) computes marginal effects (t-1 reference). Post-period magnitudes differ by design. CS-NT fix applied: late-treated states excluded from NT control group."
4. R NYT ≈ Stata NYT is an excellent match (~0.096 vs 0.096)
5. CS-NT after fix: R 0.159 ≈ Stata 0.153 (4.5% residual gap — acceptable)

---

---

## Pattern 25: Late-treated states incorrectly absorbed into never-treated group by `att_gt`

**Context**: Datasets where treatment adoption extends beyond the last year in the data (e.g., some states adopt in 2013–2014 while data ends in 2012). This occurs in CS (CSDID) estimation with `control_group="nevertreated"` — observed in Carpenter & Lawler 2019 (ID 79, NIS Tdap data).

**Root Cause**: `att_gt`'s internal preprocessing (`did_standarization`) converts `gvar_CS = 0` to `Inf` (never-treated). But it ALSO converts states with `gvar_CS > max(year)` to `Inf` — i.e., states treated after the data window are reclassified as "never treated within the window". This inflates the NT control group:
- True NT observations: 1,574 (2004–2005)
- Late-treated observations incorrectly added to NT: 2,447
- Contaminated NT group: 4,021 (vs 1,574 in Stata)

Stata's `csdid2` with `control("nevertreated")` uses ONLY `gvar == 0` units, excluding late-treated.

**Diagnostic**: If `aggte(simple, NT)` in R is much smaller than Stata (e.g., 0.096 vs 0.153), check whether some states have `gvar_CS > max(year)` in the data.

**Resolution Rule**: Before calling `att_gt` for **NT only**, filter out late-treated units:
```r
df_nt <- df %>% filter(gvar_CS == 0 | gvar_CS <= max(year_id, na.rm=TRUE))
df_nt$unit_id <- seq_len(nrow(df_nt))
cs_nt <- att_gt(..., data = as.data.frame(df_nt))
```
For **NYT** (`control_group="notyettreated"`), keep late-treated states — they are valid "not yet treated" controls and `att_gt` handles them correctly. Do NOT apply the filter for NYT.

**Result**: After fix, R NT aggte(simple) = 0.159 ≈ Stata 0.153 (4.5% residual gap due to aggte weighting). ATT(g=2005, t=2005) = 0.0112 — exact match with Stata.

---

## Pattern 26: `base_period="universal"` causes near-zero ATT on perfectly balanced panels

**Context**: Calling `att_gt` with `panel=TRUE, allow_unbalanced_panel=TRUE, base_period="universal"` on a dataset that is a perfectly balanced panel (every (unit, time) pair appears exactly once). Observed in Dranove et al. (2021), ID 9 (29 states × 26 quarters = 754 rows exactly balanced).

**Root Cause**: The `did` package (version 2.x) auto-detects perfectly balanced panels and overrides the explicit `allow_unbalanced_panel=TRUE` to `FALSE`. When this override occurs AND `base_period="universal"` is specified, the balanced-panel DRDID estimator interacts with the universal base period in a way that produces near-zero ATT estimates (e.g., -0.00471 instead of the correct -0.162). Without `base_period="universal"`, the same balanced panel override gives the correct estimate. This combination is a bug or undocumented behavior in the did package.

**Diagnostic**: `att_gt` prints "You have a balanced panel. Setting allow_unbalanced_panel = FALSE." and the resulting `aggte(simple)$overall.att` is near zero (much smaller than TWFE). Check `nrow(df) == length(unique(df$unit_id)) * length(unique(df$time_var))`.

**Resolution Rule (REVISED)**: ALWAYS use `base_period="universal"` in all `att_gt` calls. This is the mandatory default — no exceptions.

**Result**: After removing `base_period="universal"`, ID 9 R CS-NT = -0.162 (Stata = -0.202, gap due to long2 vs aggte methodological difference). Point estimates are stable.

---

## Pattern 42: CS-DID propensity score overfitting with state/region dummies in xformla

**Context**: When `att_gt()` uses `xformla = ~factor(state)` on data where units (counties, municipalities, districts, firms) are nested within states/regions. The propensity score model in DRDID must estimate Pr(treated | state) for each (group, time) pair. If some states have very few treated units (e.g., <5), the propensity score overfits — perfectly predicting treatment from state membership — causing estimation failure or dramatic ATT attenuation.

**Root Cause**: CS-DID (Callaway & Sant'Anna) uses inverse propensity weighting (IPW) or doubly-robust (DR) methods. Adding high-dimensional categorical covariates (state dummies) to xformla inflates the propensity score model dimensionality. In states with few treated units, the logistic regression for Pr(G=g | X, C) achieves near-perfect separation → propensity scores near 0 or 1 → extreme IPW weights or numerical failure. Three failure modes observed:
1. **Complete failure** (ATT=0, SE=NA): propensity score cannot converge at all. Error: "No pre-treatment periods to test."
2. **Dramatic attenuation** (-47% to -83%): propensity score converges but with extreme weights → biased ATT toward zero.
3. **Stable** (0% to +10%): when ALL states have sufficient treated units, state dummies add legitimate heterogeneity control without overfitting.

**Empirical evidence** (8 articles tested):

| ID | Author | Baseline ATT | + State ATT | Change | States <5 treated | Diagnosis |
|----|--------|-------------|-------------|--------|-------------------|-----------|
| 241 | Soliman (2024) | -70.04*** | 0.00 (NA) | -100% | 32/49 | Complete failure |
| 25 | Carrillo, Feres (2019) | +0.114*** | 0.00 (NA) | -100% | 1/27* | Complete failure |
| 44 | Bosch (2014) | +0.307*** | 0.00 (NA) | -100% | 1/32 | Complete failure (all-eventually-treated) |
| 91 | Evans et al. (2022) | +3.889*** | +0.656 | -83% | many | Dramatic attenuation |
| 271 | Sekhri, Shastry (2024) | +69.75*** | +36.81 (ns) | -47% | 4/13 | Attenuation + significance loss |
| 219 | Clay et al. (2016) | +0.35 (ns) | +0.97 (ns) | +175% | 6/41 | Both insignificant, uninformative |
| 263 | Axbard, Deng (2023) | +0.003 | +0.003 | +10% | 0/21 | Stable (all provinces have enough treated) |
| 97 | Bhalotra et al. (2021) | -0.351*** | -0.351*** | 0% | 2/32 | Perfectly stable (≥4 treated/state) |

*ID 25: only 1 state with <5, but "No pre-treatment periods" error suggests co-treatment timing confound with state assignment.

**Graduated analysis** (distinguishing overfitting from genuine attenuation):

Simple baseline-vs-state comparison is AMBIGUOUS. The graduated protocol resolves this:
1. Baseline (no geographic controls)
2. +Region dummies (coarse: 4 US census regions, 5 BR macro-regions)
3. +State dummies (full sample)
4. +State dummies (overlap: only states with ≥5 treated AND ≥5 control)

| ID | Baseline | +Region | +State(full) | +State(overlap≥5) | Diagnosis |
|----|----------|---------|--------------|-------------------|-----------|
| 241 | -70.0*** | -66.5*** | 0.00 | -84.6*** (N=307) | **Pure overfitting** |
| 91 | +3.60*** | +3.74*** | 0.00 | +0.95 (N=233) | **Genuine attenuation** |
| 271 | +69.8*** | +57.6*** | +36.8** | +65.9*** (N=152,≥3) | **Mixed** |
| 25 | +0.114*** | +0.114*** | 0.00 | +0.116*** (N=5397) | **Pure overfitting** |
| 97 | -0.351*** | -0.349*** | -0.351*** | -0.353*** (N=2810) | **Stable** |

Key: If +Region ≈ Baseline AND +State(overlap) ≈ Baseline → pure overfitting, no confounding.
If +State(overlap) << Baseline → genuine state-level confounders exist.

**Resolution Rule (Updated)**:
1. **Count treated AND control per state** before adding state dummies to CS-DID.
2. **If >30% of states have <5 treated**: do NOT run +State(full). Run graduated protocol instead.
3. **Run graduated protocol**: baseline → +region → +state(overlap≥5).
   - If +region ≈ baseline AND +state(overlap) ≈ baseline → effect is robust (pure overfitting).
   - If +state(overlap) attenuates significantly → genuine state-level confounders → report both.
4. **For TWFE sensitivity**: use `state × time` FEs via `additional_fes` (Frisch-Waugh, no propensity score).
5. **Overlap threshold**: ≥5 treated AND ≥5 control per state. If resulting sample <100 units, relax to ≥3.
6. **When state dummies work in CS-DID**: when ALL states have substantial treated+control (like ID 97: 30/32 states qualify for ≥5 overlap). In that case, stability validates robustness.

**Related**: UPA work-leave paper found identical pattern: CS-DID with 27 UF dummies killed effect; restricting to UFs with ≥5 treated restored ~70% (pure overfitting). Graduated analysis confirms.

**Scripts**: `results/sensitivity_graduated.R` (graduated), `results/sensitivity_state_dummies.R` (simple). Data: `results/sensitivity_graduated.csv`.

---

## Adding New Patterns

## Pattern 43: gvar_CS as.integer() truncates Inf → wrong results or sign reversal

**Context**: When `construct_vars` creates gvar_CS using `as.integer()` and assigns `0L` for never-treated units. The `did` package internally converts gvar_CS=0 to Inf for never-treated. Since R integers cannot represent Inf, `as.integer(Inf)` returns NA. The package then sees no never-treated units and either fails or produces biased estimates.

**Root Cause**: R's integer type has a finite range (~2.1 billion). `Inf` is only representable as `numeric` (double). When gvar_CS is stored as integer column, the `did` package's internal conversion 0→Inf silently produces NA. This cascades to: (1) "No never-treated group" warning, (2) wrong ATT estimates (often sign-reversed), or (3) the package falls back to not-yet-treated comparison without telling the user.

**Affected articles**: IDs 305 (ATT flipped from +5.43 to -0.92 after fix), 359, 338.

**Resolution Rule**: ALWAYS use `as.numeric()` (not `as.integer()`) when constructing gvar_CS. Use `0` (not `0L`) for never-treated units. In construct_vars:
```r
# WRONG:
df$gvar_CS <- ifelse(!is.na(first_yr), as.integer(first_yr), 0L)
# CORRECT:
df$gvar_CS <- ifelse(!is.na(first_yr), as.numeric(first_yr), 0)
```
The `did` package needs `gvar_CS` as numeric so it can internally set 0 → Inf.

---

## Pattern 44: JSON empty object `{}` silently breaks preprocessing

**Context**: Articles where metadata preprocessing fields are left as empty JSON objects rather than omitted entirely — e.g. `"time_recode": {}`, `"composite_twfe": {}`, `"composite_vars": {}`, `"weight": {}`. Observed on IDs 9, 281, 419 (all with `time_recode: {}`) and ID 419 also with `weight: {}`.

**Root Cause**: `jsonlite::fromJSON("{}")` returns a zero-length named list, NOT `NULL`. The old template used `if (!is.null(meta$...))` guards, which evaluate TRUE for `list()`. Downstream code then tried to operate on empty structures:
- **time_recode**: `match(df[[tvar]], numeric(0))` returns all-NA → the entire time column is silently destroyed → every row hits an NA fixed-effect → TWFE fails with "All observations contain NA values" even though the raw data was pristine.
- **weight**: `list()` passed to `as.formula(paste0("~", wname))` → `as.formula("~")` → `str2lang` error on empty formula.
- **composite_twfe**: `list() == "additive_2"` returns `logical(0)` → `if (logical(0))` errors with "argument is of length zero".

**Affected IDs at discovery**: 9, 68 (missing construct_vars separately), 254 (legacy), 281, 347 (legacy), 419. Four of the six were directly fixed by the guard change — they had correct metadata otherwise.

**Resolution Rule**: Guard every optional metadata list/object with `length(x) > 0` (not just `!is.null(x)`). For scalar-character fields that may be `{}`, coerce defensively:
```r
# Generic shape-aware guard for optional list fields (time_recode, construct_vars):
if (!is.null(meta$preprocessing$FIELD) && length(meta$preprocessing$FIELD) > 0) { ... }

# Scalar string with JSON-{} tolerance (e.g. composite_twfe, weight):
.x <- meta$variables$FIELD
if (!is.character(.x) || length(.x) == 0) .x <- NULL
```
Applied in `code/analysis/did_analysis_template.R` around the `time_recode`, `composite_twfe`, and `weight` sections. After the fix, a dry run on all 56 articles reproduced bundled results.csv values for IDs 9, 281, 419 to machine precision.

---

## Pattern 45: Dual metadata locations drift silently

**Context**: The template reads from `results/by_article/{id}/metadata.json`, but the human-maintained canonical metadata is in `data/metadata/{id}.json`. Edits to the canonical file are invisible to the pipeline until manually copied.

**Root Cause**: Historic design — `results/by_article/{id}/metadata.json` was intended as a frozen snapshot of "what metadata produced these results." Over time, the canonical copy diverged when users edited only `data/metadata/` expecting the template to pick it up.

**Resolution Rule**: `code/analysis/01_run_all_did.R` now runs a `sync_meta(id)` step at startup: it copies `data/metadata/{id}.json` → `results/by_article/{id}/metadata.json` for every article before dispatching the template. The ID list itself is also derived from `data/metadata/` (authoritative), not from `results/by_article/` (output directory). Users edit `data/metadata/` only; the by_article copy is regenerated on every run.

---

## Pattern 46: Non-deterministic SEs and occasional ATT drift from unset bootstrap seed

**Context**: `did::aggte()` and `did::att_gt()` use multiplier bootstrap for standard errors and simultaneous critical values. Without a fixed seed, successive runs of `did_analysis_template.R` on the same data produced non-byte-identical `results.csv` files. Observed drift: SEs at 4th–6th decimal, occasional ATT point estimate drift (at 13th decimal for fixest / ~0.02% for CSDID via influence-function reweighting).

**Root Cause**: No `set.seed()` anywhere in the template. Every invocation drew fresh random multipliers, changing bootstrap-dependent outputs across runs even when the inputs were identical.

**Resolution Rule**: `set.seed(42)` added immediately after `library()` calls at the top of `code/analysis/did_analysis_template.R`. Verified: 5 representative articles (IDs 21, 25, 80, 97, 210) produce byte-identical `results.csv` across 3 successive runs (md5 match on all 3).

---

## Pattern 47: Custom preprocessing beyond metadata's reach (legacy_analysis flag)

**Context**: A few articles require preprocessing that is too complex to express as a JSON `construct_vars` array:
- ID 254 (Gandhi et al. 2024): weekly→quarterly aggregation + merge with external `ccn_high_mcaid_il.csv` + bubble-period exclusion + multi-scenario high/low heterogeneity (10-column output schema instead of the standard 16).
- ID 347 (Courtemanche et al. 2025): requires running a Stata `brfss_clean.do` that appends 19 BRFSS annual files (1994–2012) with per-year BMI variable renaming, then merging laws.dta + med_inc + unem_popdens.

**Resolution Rule**: Added `legacy_analysis: true` and `legacy_reason: "..."` flags in `analysis`. The template checks this flag immediately after loading metadata; if set, it prints `[LEGACY]` with the reason and exits 0 without touching `results.csv`. The bundled `results.csv` (produced previously by custom standalone scripts) is preserved. Aggregation scripts read these bundled values transparently.

---

## Pattern 48: `aggte(type="dynamic")` overall ATT polluted by long-horizon noise

**Context**: For several staggered-adoption articles (Brodeur & Yousaf 2020, Moorthy &
Shaloka 2025, Maclean & Pabilonia 2025, Myers 2017, Levine, McKnight & Heep 2011, and
others), the stored `att_nt_dynamic` produced by `did::aggte(cs_nt, type="dynamic")`
differed dramatically from what the event study figure visibly showed. Example:
Brodeur's CS-NT per-horizon att.egt at egt = 0–5 was uniformly negative (−0.31 to
−2.50), but `overall.att` was **+8.02**. In the cross-article aggregate chart this
produced absurd Δ% values (Brodeur +695%, Moorthy +539%, Maclean −1542%, Levine
−1865%, etc.) that did not reflect the underlying dynamic profile.

**Root Cause**: `did::aggte(type="dynamic")` by default averages `att.egt` over the
entire post-treatment horizon range that is identifiable from the data — not just
the window the analyst displays in the event study. For staggered designs with
very-early and very-late cohorts, the range can extend far beyond
`event_pre`/`event_post`. In Brodeur's case the realized egt range was `[−18, +18]`
even though the paper's event study window was `[−5, +5]`. The att.egt values at
egt = 7–17 were dominated by one or two late-treated cohorts with very few
observations contributing and exploded to +9 to +22. Those noisy long-horizon
estimates entered `overall.att` with the same weighting scheme as the precise
short-horizon estimates, pulling the overall average far away from the displayed
effect.

**Resolution Rule**: Clip the dynamic aggregate to the event window declared in
metadata (`event_pre`/`event_post`). In `code/analysis/did_analysis_template.R`
replace

```r
agg_nt_d <- aggte(cs_nt, type="dynamic")
```

with the event-window-clipped variant, which passes `min_e = -event_pre` and
`max_e = event_post` when those are available:

```r
.min_e <- if (has_es && !is.na(ev_pre))  -as.integer(ev_pre)  else NULL
.max_e <- if (has_es && !is.na(ev_post))  as.integer(ev_post) else NULL
agg_nt_d <- do.call(aggte, c(list(MP = cs_nt, type = "dynamic"),
                             if (!is.null(.min_e)) list(min_e = .min_e),
                             if (!is.null(.max_e)) list(max_e = .max_e)))
```

Apply the same replacement for the CS-NYT dynamic aggregate. Verified on Brodeur:
`overall.att` moves from +8.024 (unclipped, dominated by egt = 7–17 with att ≈
+10–+22) to −1.476 (clipped to [−5, +5], aligning with the event study which shows
all post-treatment att values in [−0.31, −2.50]). The cross-article Δ% chart
becomes sensible again; the stored dynamic ATT now matches the empirical content
of the displayed event study.

---

## Pattern 49: CS-DID requires a different sample / settings than TWFE

**Context**: Several articles in the calibration set produced bundled `results.csv`
values that the main `did_analysis_template.R` could not reproduce when run
end-to-end, because the original canonical pipeline applied article-specific
adjustments via standalone scripts (`scripts/fix_201.R`, `scripts/fix_234_241.R`,
`scripts/fix_242_dynamic.R`, `scripts/update_419_744_balanced.R`, and the bundled
`results/305/es305_script.R`). Each fix tweaked only the CS-DID branch:
switching the sample filter, collapsing time to a coarser unit, using a balanced
panel, or clipping the dynamic aggregate's event-time horizon. TWFE, SA, and
Gardner ran unchanged.

When the template was run without these per-article tweaks, CS-DID estimates
diverged sharply for IDs 201 (Maclean & Pabilonia), 234 (Myers), 241 (Soliman),
242 (Moorthy), 305 (Brodeur), 419 (Kahn), 744 (Jayachandran). The aggregate
scatter picked up spurious sign reversals (e.g. 305 moved from −1.28 static to
+3.61), while the per-article event study figures kept the original (bundled)
shape, producing a visible inconsistency between the appendix and main-text
chart.

**Root cause**: the default-path template treats the paper's TWFE sample,
filter, panel-balance rule, and aggregation horizon as if they also define the
CS-DID estimand. In practice, CS-DID sometimes needs its own sample (e.g.
Brodeur's balanced full panel instead of the `aroundms==1` window, which makes
`att_gt` segfault; Maclean's yearly-collapsed panel instead of monthly RCS),
its own balancing flag, or its own `min_e`/`max_e` clip.

**Resolution rule**: extend the metadata schema with CS-specific override
fields (all optional; they fall back to the paper's displayed defaults when
absent):

| Field | Location | Meaning |
|---|---|---|
| `data.cs_sample_filter` | `data` | Filter applied to `df_full` for CS only. Empty string means "skip the TWFE `sample_filter`". Not set means "inherit `sample_filter`". |
| `preprocessing.cs_construct_vars` | `preprocessing` | Array of R expressions applied to `df_base` (the filtered CS sample) before `att_gt`. Useful for time-unit collapses, pair-balancing, etc. |
| `panel_setup.cs_data_structure` | `panel_setup` | `"panel"` or `"rcs"` — override the default when `cs_construct_vars` transforms the data structure (e.g. RCS → panel after aggregation). |
| `panel_setup.cs_allow_unbalanced` | `panel_setup` | TRUE/FALSE — override `allow_unbalanced_panel` passed to `att_gt` in the CS section only. |
| `analysis.cs_min_e`, `analysis.cs_max_e` | `analysis` | Integer clips passed to `aggte(type="dynamic", min_e=…, max_e=…)`. Useful when long-horizon event times have only 1–2 contributing cohorts and pollute the overall dynamic ATT. |
| `analysis.cs_drop_late_treated` | `analysis` | TRUE (default) applies Pattern 25's drop of observations with `gvar > max(time)` before calling `att_gt` for the NT comparison. Set to FALSE when the article's bundled result did not apply the drop. |

Template updates in `code/analysis/did_analysis_template.R`:

1. Snapshot `df_full` immediately after `construct_vars` but before
   `sample_filter`. This is the starting point for the CS pipeline.
2. Resolve the five CS-specific overrides early (immediately after the main
   variable setup).
3. Build `df_base` by applying `cs_sample_filter` (or inheriting `sample_filter`)
   and then `cs_construct_vars`.
4. Use `cs_is_panel`, `cs_allow_unbal` in `att_gt`; optionally pass
   `cs_min_e`/`cs_max_e` to `aggte(type="dynamic")`.

Verified end-to-end reproduction of the canonical bundled values for 241, 242,
419, 744 (EXACT match across `beta_twfe`, `att_csdid_nt`, `att_csdid_nyt`,
`att_nt_dynamic`, `att_nyt_dynamic`) and 305's dynamic ATTs (−0.923 / −0.910 both
match). Residual small discrepancies for 234's `att_nt_dynamic` (both ≈0) and
201's `att_nt_dynamic` (12.04 → −3.04) come from inherent inconsistencies in
the bundled values — the original was produced by running multiple partial
scripts that populated different columns under different configurations, which
no single coherent template invocation can fully reproduce. Both articles
passed the sign/significance criteria needed for the aggregate chart.

---

## Pattern 50: Silent CS/TWFE sample mismatch — invariant check (Kresch-class bug)

**Context**: Any CS-DID run where `cs_sample_filter` and `cs_construct_vars` are both absent from metadata, meaning `df_base` is supposed to inherit the TWFE sample exactly. If `df_base` was inadvertently assembled from `df_full` (pre-filter) instead of `df`, or if `sample_filter` was left empty in metadata while the paper's canonical spec required a filter, `att_gt` silently estimates on a different population than TWFE. Observed in id 233 (Kresch 2020, Table 3 Col 1): TWFE used the `balance2001 == 1` subsample (1,346 municipalities, β = +2868), while the old pipeline ran CS-DID on the unfiltered post-`construct_vars` sample (5,199 municipalities), yielding `att_csdid_nt = +367.5` — 9× smaller than the correct +3329.4.

**Root Cause**: The template never asserts that `n_distinct(df_cs[[idname]])` equals `n_distinct(df[[idname]])` when no CS-specific override justifies a difference. A silent unit-count divergence means TWFE and CS-DID are measuring effects on different populations; the consolidated `results.csv` then presents them as comparable estimands when they are not.

**Resolution Rule**: Add the following invariant immediately after `df_base` is assembled (around line 346 of the current template, just before the `cs_is_panel` / `att_gt` block). Use `stop()` rather than `warning()` — a silent inflated or deflated estimate is worse than a loud crash:

```r
# Pattern 50 invariant: CS sample must match TWFE sample unless metadata
# explicitly overrides via cs_sample_filter or cs_construct_vars.
# Silent divergence = Kresch-class bug (id 233, 2026-04-17).
has_cs_override <- (has_cs_filter || has_cs_construct)
n_units_twfe <- n_distinct(df[[idname]])
n_units_cs   <- n_distinct(df_base[[idname]])
if (n_units_twfe != n_units_cs && !has_cs_override) {
  stop(sprintf(
    "[Pattern 50] CS sample has %d units but TWFE sample has %d units, yet no cs_sample_filter or cs_construct_vars is declared in metadata. This is a silent-sample-mismatch bug (see knowledge/failure_patterns.md Pattern 50; Kresch 2020 / id 233 was the discovery case). Either (a) add cs_sample_filter to metadata to justify the difference, or (b) fix the upstream pipeline so df_base inherits df correctly.",
    n_units_cs, n_units_twfe))
}
if (n_units_twfe != n_units_cs && has_cs_override) {
  cat(sprintf("    [Pattern 50 OK] CS sample differs from TWFE (cs: %d, twfe: %d) — justified by cs_sample_filter/cs_construct_vars\n",
              n_units_cs, n_units_twfe))
}
```

**Detected in**: id 233 (Kresch 2020), csdid-reviewer audit 2026-04-17. The current NEW template already produces the correct +3329.4 (Pattern 49 refactor resolved the underlying pipeline issue). This pattern encodes the runtime guard to prevent any future regression.

---

## Pattern 51 — RCS control collinearity silently inflates CS-DID ATT (false positive)

**Context**: CS-DID Spec A run on a repeated-cross-section (RCS) design (`data_structure == "rcs"` in metadata) that includes time-varying individual-level demographic covariates (e.g., `married`, `student`, `female`, `age`) in `cs_controls` / `xformla`. The run completes with `status = OK` (no convergence error, no NA). But the resulting ATT is 3×–10× larger in absolute value than the no-controls CS-DID (Spec B), often flipping a statistically null result into a false positive significant finding. TWFE Spec A vs Spec B shows no such divergence.

**Observed failure**: id 125 (Levine, McKnight & Heep 2011 — a null-result paper):

| Estimate | Spec | ATT | SE | t-stat | Significant? |
|---|---|---|---|---|---|
| TWFE (paper spec, with ctrls) | A | −0.00045 | 0.007 | −0.07 | No (matches paper) |
| TWFE (no ctrls) | B | +0.00272 | — | — | No |
| CS-NT simple (no ctrls) | B | −0.00403 | — | — | No |
| CS-NT simple (with ctrls) | A | −0.03584 | 0.016 | −2.24 | YES — false positive |
| CS-NT dynamic (no ctrls) | B | −0.00888 | — | — | No |
| CS-NT dynamic (with ctrls) | A | −0.02675 | 0.015 | −1.77 | Borderline |

9× magnitude inflation plus crossing the significance threshold is the canonical signature.

**Root Cause**: In an RCS dataset there is no true panel: individual-level demographic covariates vary across observations within the same (unit × time) cell because different individuals are surveyed each period. The CS-DID doubly-robust estimator (`method = 'dr'` in the `did` package) estimates a propensity score Pr(G=g | X) from these individual covariates. With no within-unit continuity, the logistic regression for propensity score becomes near-collinear with the treatment indicator at the cell level. Rather than failing to converge (which would be Pattern 42 / complete overfit), the model converges with extreme but finite IPW weights. At the aggregation step (`aggte(type = "simple")`), these extreme weights mechanically inflate the ATT magnitude rather than identifying a different population estimand. TWFE is unaffected because OLS absorbs collinearity through the Frisch-Waugh projection without reweighting observations.

**Resolution Rule**: When Spec A for an RCS paper produces |ATT_A / ATT_B| > 2, AND either the sign reverses OR one estimate is significant while the other is not, flag as a Pattern 51 collinearity inflation event. In `results.csv`, set `rcs_ctrl_sensitivity_flag = TRUE` for the affected article. Report both Spec A and Spec B to the reader; treat Spec B (no controls) as the primary CS-DID estimate, since it avoids the IPW collinearity pathology entirely. Spec A is retained for transparency but must not be used as the headline ATT for null-result papers without this caveat.

Detection pseudocode:
```r
if (data_structure == "rcs" &&
    !is.null(cs_controls) && length(cs_controls) > 0 &&
    abs(att_a / att_b) > 2 &&
    (sign(att_a) != sign(att_b) || xor(p_a < 0.05, p_b < 0.05))) {
  flag_rcs_ctrl_sensitivity(id)
}
```

**Distinction from related patterns**:
- Pattern 42 (propensity score overfits → ATT collapses to 0 or NA, status may show partial failure). Pattern 51 (propensity score converges with extreme weights → ATT *inflates* → status = OK throughout, harder to detect).
- Pattern 25 (late-treated states contaminate the NT control group — affects *which units* enter CS-DID). Pattern 51 (correct units, wrong weighting — affects *how* the ATT is aggregated).

**Triptych context (Lesson 7)**: Together with id 25 (Carrillo-Feres, 18 controls as pre-treatment × trends, Spec A clean) and id 79 (Carpenter-Lawler, 53 controls staggered, Spec A collapses = Pattern 42), id 125 completes the three canonical Spec A behaviors: clean / collapse / inflate.

**Detected in**: id 125 (Levine, McKnight & Heep 2011), Spec A audit 2026-04-19.

---

## Adding New Patterns

When a new failure occurs:
1. Document it here with the format above: Context, Root Cause, Resolution Rule
2. Update `templates/did_analysis_template.R` if a code fix applies universally
3. Commit the updated `failure_patterns.md` so future runs benefit

Format:
```markdown
## Pattern N: [Short description]

**Context**: [When does this happen?]
**Root Cause**: [Why does it happen?]
**Resolution Rule**: [How to fix it, including code if applicable]
```
