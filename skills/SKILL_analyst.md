# SKILL: ANALYST
## Goal
Run `templates/did_analysis_template.R` using `results/[id]/metadata.json`.
Produce `results/[id]/results.csv` and (if applicable) `results/[id]/event_study.pdf`.

---

## Prerequisites
- `results/[id]/metadata.json` must exist and be valid (output of PROFILER stage)
- Data file referenced in `metadata.json` must exist at the specified path
- R 4.4.2 at `/c/Program Files/R/R-4.5.2/bin/Rscript.exe`

---

## How to Run

```bash
"/c/Program Files/R/R-4.5.2/bin/Rscript.exe" templates/did_analysis_template.R [id]
```

Example for article ID 6:
```bash
"/c/Program Files/R/R-4.5.2/bin/Rscript.exe" templates/did_analysis_template.R 6
```

The script reads `results/6/metadata.json` and writes:
- `results/6/results.csv` — point estimates
- `results/6/event_study.pdf` — event study plot (if `has_event_study: true`)

---

## Estimator Selection Rules (NEVER VIOLATE)

| Estimator | Condition |
|-----------|-----------|
| **TWFE** | Always |
| **CSDID-NT** (never-treated) | Always |
| **CSDID-NYT** (not-yet-treated) | ONLY if `treatment_timing == "staggered"` |
| **Bacon decomposition** | ONLY if `treatment_timing == "staggered"` |
| **SA event study** | ONLY if `has_event_study == true` |
| **BJS event study** | ONLY if `has_event_study == true` AND `data_structure == "panel"` |

These rules are encoded in the template via metadata flags. The profiler must set them correctly.

---

## What the Template Does (Internal Logic)

### 1. TWFE
```r
feols(outcome ~ treatment + controls | unit_id + time + additional_fes,
      weights = ~weight_var, cluster = ~cluster_var, data = df)
```
- Extracts `coef[treatment]` and `se[treatment]`
- For composite TWFE (`preprocessing.composite_twfe == "additive_2"`):
  β = β₁ + 2×β₂ (see Bhalotra et al. 2021, Section 4.3.1 of dissertation)

### 2. CSDID-NT / CSDID-NYT
```r
att_gt(yname, tname, idname, gname, xformla, weightsname, clustervars,
       control_group = "nevertreated",   # or "notyettreated"
       panel = TRUE,                      # FALSE for repeated_cross_section
       allow_unbalanced_panel = TRUE,
       data = df)
aggte(cs_nt, type = "simple")$overall.att   # scalar ATT
```

### 3. Bacon Decomposition
```r
bacon(outcome ~ treatment, data = df, id_var = unit_id, time_var = time)
```

### 4. SA Event Study (Sun-Abraham)
```r
feols(outcome ~ sunab(cohort_sa, time_sa) + controls | FEs,
      cluster = ~c, data = df)
# cohort_sa: 0 = never-treated, year = treatment cohort
```
Extract results: `iplot(fit, only.params=TRUE)$prms` filtered by `!is_ref`.
**IMPORTANT**: `iplot` does NOT return `se`. Compute: `se = (ci_high - ci_low) / (2 * 1.96)`.

### 5. BJS Event Study (Borusyak-Jaravel-Spiess)
```r
did_imputation(df, yname, idname, tname, gname,
               wname = weight_var, cluster_var = cluster_var,
               horizon = 0:event_post)
```
**IMPORTANT**:
- The R package does NOT support negative horizons. BJS plot only shows t ≥ 0.
- Term names are plain numeric strings: `"0"`, `"1"`, `"2"` (NOT `"tau_0"`, `"pre_1"`).
- For individual-level data (repeated cross-section): aggregate to unit-time first.

---

## Handling Common Errors

### Error: Singular matrix / inversion failure (CSDID)
**Symptom**: `system is computationally singular` or `matrix is not positive definite`
**Fix**: The template automatically retries with `faster_mode = FALSE`.
If that also fails, CSDID result will be `NA` — acceptable if noted.

### Error: BJS "not a single explanatory variable different from 0"
**Cause**: Usually too few units per cohort, or individual-level data not aggregated.
**Fix for panel data**: The template handles this automatically.
**Fix for individual data**: If `data_structure == "repeated_cross_section"`, BJS is skipped. If you believe BJS is feasible, try aggregating to unit-time level first and check if ≥ 3 cohorts exist.

### Error: `iplot` fails for SA
**Symptom**: Various errors from `iplot()`
**Fix**: Check that `sunab()` call succeeded. If only 1 cohort exists, SA is not identifiable — set `has_event_study: false` for SA (BJS may still work).

### Error: Variable not found
**Cause**: Variable name in `metadata.json` does not match the `.dta` file.
**Fix**: Use `haven::read_dta()` + `names(df)` to inspect the actual variable names. Update `metadata.json` and rerun.

### Error: `sample_filter` evaluation fails
**Cause**: The R expression uses Stata syntax (e.g., `!missing(x)` instead of `!is.na(x)`)
**Fix**: Translate to valid R: `!is.na(x)`, `x %in% c(1,2)`, etc.

### Error: CSDID negative time values
**Cause**: Time variable encodes something unusual (e.g., halfyear integers from Stata)
**Fix**: Ensure the profiler correctly identifies the raw integer values. The template uses the raw numeric values — `att_gt` requires integer time.

### Error: TWFE event study CIs ±40,000 or completely degenerate
**Symptom**: Event study plot has enormous error bars (CI width ≥ 100×ATT) or the TWFE line is flat at 0.
**Cause**: The template's previous `filter(!is.na(rel_time))` removed all control units. Without the control group, the TWFE model is unidentified, producing explosive SEs.
**Fix**: The template now uses `rel_time_binned` on ALL data (never-treated assigned `never_bin = -(ev_pre+2)` as reference bin). This mirrors Stata's approach of pre-created dummies = 0 for controls. See failure_patterns.md Pattern 18. Do NOT add a filter on `rel_time` to the TWFE event study formula.

### Error: Post_avg inflated — LX or FX tail-bin renamed to L9/F9 in construct_vars
**Symptom**: TWFE β much larger in magnitude than expected; Post_avg sums over an extra tail-bin column beyond the event window.
**Cause**: `construct_vars` contains `df$L9 <- df$LX` or `df$F9 <- df$FX`.
**Fix**: Remove the rename. Use `intersect(paste0('L', 0:9), names(df))` to build Post_avg from only naturally existing event-window columns. See failure_patterns.md Pattern 13.

### Error: β diverges ~10% from original article in plain-OLS articles
**Symptom**: TWFE β differs from the paper by ~9–10%; same sign and significance, but systematically smaller/larger.
**Cause**: The article used plain OLS without FEs (treatment variable already encodes DiD structure), but the template always adds `| unit_id + time` to `feols()`.
**Fix**: No code fix — this is a known template limitation. Document in `notes` in metadata.json: `"Template adds unit+time FEs; original uses plain OLS with dd_treatment encoding DiD. ~9% beta difference expected — not a replication failure."` Report as a design difference. See failure_patterns.md Pattern 17.

### Error: TWFE event study controls cause collinearity with event dummies
**Symptom**: Event study TWFE line is flat at zero or has massive CIs; many controls dropped with "removed due to collinearity".
**Cause**: `twfe_controls` contains treatment-interaction variables (e.g., `treated_post_year`, `treated`, `post`) that are nearly collinear with `i(rel_time_binned)` dummies.
**Fix**: Add `"twfe_es_controls": []` (or a reduced control list) to `variables` in metadata.json. The template will use `twfe_es_controls` for the event study while keeping `twfe_controls` for the point estimate. See failure_patterns.md Pattern 20.

### Error: Event study includes units that should be excluded (es_sample_filter)
**Symptom**: Some articles exclude specific units only from the event study (e.g., outlier states) but include them in the point estimates.
**Fix**: Add `"es_sample_filter": "<R expression>"` to `data` in metadata.json. If the filter references a variable created in `construct_vars` (e.g., `state_label`), add `df$state_label <- state_ch` as the last `construct_vars` item. The template applies the filter to TWFE/SA/BJS event study; CS uses the full fitted `att_gt` object (minor deviation). See failure_patterns.md Pattern 21.

### Note: BJS skipped for repeated cross-section — use bjs_aggregate_to_panel
**Symptom**: `BJS skipped: repeated cross-section data (set bjs_aggregate_to_panel: true to enable)`
**Cause**: `data_structure: "repeated_cross_section"` and no `bjs_aggregate_to_panel` flag. Stata's `did_imputation` handles individual-level data via `fe(unit time ...)` internally; R requires unique (unit, time) pairs.
**Fix**: Add `"bjs_aggregate_to_panel": true` to `analysis` in metadata.json. Template aggregates to (idname × tname) level using explicit `sum(w*x)/sum(w)` after pre-filtering NA outcomes and NA weights. FEs beyond unit+time (e.g., age) are lost in aggregation — approximation of Stata. See failure_patterns.md Pattern 22.

### Note: CS-NT ≈ CS-NYT in RCS staggered adoption — dataset-specific cancellation
**Symptom**: `att_csdid_nt` ≈ `att_csdid_nyt` (same value ± 0.001) despite `run_csdid_nyt: true` and staggered adoption.
**Cause**: NOT a bug. R's `att_gt(panel=FALSE)` correctly implements NT vs NYT at the ATT(g,t) cell level (cell-level differences exist, max ≈ 0.09). The aggregate collapses because positive and negative cell-level differences cancel in the weighted average — this is dataset-specific, not structural. A separate issue: R NT may diverge substantially from Stata NT (e.g., 0.095 vs 0.164) due to different NT pool composition (early cohorts treated differently in Stata vs R). R NYT typically matches Stata NYT well (~5-10%).
**Fix**: No code fix needed. Post-treatment magnitudes differ by design (R marginal vs Stata cumulative). The template uses `base_period='universal'` (Pattern 26 REVISED: ALWAYS universal, no exceptions). Check if Stata NT has significant pre-trends (parallel trends failure); if so, NYT is the more credible estimator and R captures it well. Document in metadata `notes`. See failure_patterns.md Pattern 24.

### Error: BJS returns empty results — time-varying treatment within unit_id
**Symptom**: `Aggregating to (unit x time) panel level for BJS...` followed by silence (no "BJS ES: OK"). Result object exists but has no rows.
**Cause**: Same `unit_id` appears with different `gvar_CS` values across time (e.g., same municipality has gvar=NA in pre-period rows and gvar=1991 in post-period rows). `did_imputation` requires gvar to be constant within idname; time-varying treatment causes empty results silently.
**Fix**: Do NOT add `bjs_aggregate_to_panel: true` for these datasets — the aggregation doesn't help. Remove the flag and document in metadata `notes`: "BJS NOT AVAILABLE: same unit_id appears with varying gvar across years — time-varying treatment design incompatible with did_imputation." See failure_patterns.md Pattern 23.

### Note: BJS pre-treatment estimates not available in R
**Symptom**: BJS event study only shows post-treatment periods (0 to ev_post); Stata version shows pre-treatment periods via `pretrends(k)`.
**Cause**: The R `didimputation` package does not support individual pre-treatment coefficient estimates for plotting. `pretrends=k` produces a single degenerate term with NA values. Negative `horizon` values are silently ignored.
**Fix**: No fix available — this is a known package limitation. Pre-trends validation should rely on TWFE/CS/SA event study plots. Document in metadata `notes`. See failure_patterns.md Pattern 19.

### Error: CS-NT aggte(simple) much smaller than Stata (e.g., 0.096 vs 0.153)
**Symptom**: R CS-NT estimate is ~40% lower than Stata with `control_group="nevertreated"`. ATT(g,t) cells for the first post cohort are near zero despite Stata giving a large positive value.
**Cause**: States with `gvar_CS > max(year)` (late-treated, outside data window) are converted to `Inf` (never-treated) by `att_gt`'s internal preprocessing, inflating the NT control group and biasing the DiD toward zero.
**Fix**: For the NT call only, filter out late-treated units before calling `att_gt`:
```r
df_nt <- df %>% filter(gvar_CS == 0 | gvar_CS <= max(year_id, na.rm=TRUE))
df_nt$unit_id <- seq_len(nrow(df_nt))
cs_nt <- att_gt(..., data = as.data.frame(df_nt))
```
Do NOT apply this filter for the NYT call. See failure_patterns.md Pattern 25.

### Error: ATT (CS-NT) near zero on a perfectly balanced panel
**Symptom**: `aggte(simple)$overall.att` is near zero (e.g., -0.005) while TWFE is -0.162; `att_gt` printed "You have a balanced panel. Setting allow_unbalanced_panel = FALSE."
**Cause**: The `did` package auto-detects perfectly balanced panels and overrides `allow_unbalanced_panel=TRUE` to `FALSE`. This override combined with `base_period="universal"` triggers a different DRDID estimator path that produces near-zero ATT. Check: `nrow(df) == length(unique(df$unit_id)) * length(unique(df$time_var))`.
**Fix**: Pattern 26 REVISED — the template now ALWAYS uses `base_period = "universal"`. If you see near-zero ATT on a balanced panel, investigate other causes (e.g., covariate singularity, Pattern 27). Do NOT switch to "varying". See failure_patterns.md Pattern 26.

### Error: PDF file already open (Windows)
**Cause**: The event_study.pdf is open in a PDF viewer.
**Fix**: Close the PDF viewer and rerun, or the template will auto-save as `event_study_v2.pdf`.

---

## Validating Results

After the script completes:

1. Check `results/[id]/results.csv` exists and has non-NA values for TWFE and CSDID-NT.

2. **For F=1 articles (calibration set)**: Compare with dissertation results.
   - TWFE should match exactly (same specification).
   - CSDID may differ slightly due to Stata vs R differences (acceptable: ≤ 10% difference in coefficient).
   - If large discrepancy: re-read the Stata code to find differences.

3. **Sign check**: TWFE and CSDID-NT should generally point in the same direction unless the article shows sign reversal.

4. Check `event_study.pdf` (if applicable): should show pre-trends near zero, post-treatment effects in expected direction.

---

## Metadata Corrections During Analysis

If the R script fails due to incorrect metadata:
1. Fix the metadata.json
2. Rerun the script
3. Add to `knowledge/failure_patterns.md` if this is a new pattern

Do NOT modify `templates/did_analysis_template.R`.

---

## Output Format: results.csv

```
id_artigo,grupo,beta_twfe,se_twfe,att_csdid_nt,se_csdid_nt,att_csdid_nyt,se_csdid_nyt
"Author (year)","escalonada_controles",0.1234,0.0456,0.0987,0.0321,0.1102,0.0389
```

Missing values (`NA`) are acceptable for:
- `att_csdid_nyt` / `se_csdid_nyt`: when `treatment_timing == "single"`
- Any column: when estimation failed and was irrecoverable

---

## Communication Protocol

Success: `[Analyst][id] OK`
Failure: `[Analyst][id] FAIL: [brief reason]`

If a novel failure occurs: STOP, diagnose, add to `knowledge/failure_patterns.md`, then retry.
Do NOT proceed to REPORTER if ANALYST fails (results.csv invalid or missing).
