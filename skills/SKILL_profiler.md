# SKILL: PROFILER
## Goal
Extract a complete `results/[id]/metadata.json` from:
1. The article PDF (`pdf/[id].pdf`)
2. The replication code (`data/[id]/`)

---

## Output: metadata.json Schema

```json
{
  "id": "[mapping ID, e.g. '6']",
  "title": "Full article title",
  "author_label": "Author1, Author2 (year)",
  "group_label": "escalonada_controles",

  "data": {
    "file": "data/[id]/[filename].dta",
    "format": "dta",
    "sample_filter": ""
  },

  "variables": {
    "outcome": "y_varname",
    "unit_id": "unit_varname",
    "time": "time_varname",
    "cluster": "cluster_varname",
    "weight": null,
    "treatment_twfe": "Post_avg",
    "gvar_cs": "gvar_CS",
    "twfe_controls": [],
    "cs_controls": [],
    "additional_fes": []
  },

  "panel_setup": {
    "data_structure": "panel",
    "treatment_timing": "staggered",
    "allow_unbalanced": true
  },

  "analysis": {
    "run_csdid_nyt": true,
    "run_bacon": true,
    "has_event_study": true,
    "event_pre": 4,
    "event_post": 6,
    "bjs_gvar": "gvar_BJS"
  },

  "preprocessing": {
    "time_recode": null,
    "composite_twfe": null,
    "composite_vars": null
  },

  "original_result": {
    "beta_twfe": null,
    "se_twfe": null
  },

  "notes": ""
}
```

---

## Field Definitions

### `group_label` — choose exactly one:
| Code | Meaning |
|------|---------|
| `escalonada_controles` | Staggered adoption + has time-varying controls in TWFE |
| `escalonada_sem_controles` | Staggered adoption + TWFE has only FEs (no controls) |
| `unica_controles` | Single treatment date + has time-varying controls |
| `unica_sem_controles` | Single treatment date + TWFE has only FEs |

**Staggered** = different units adopt treatment in different periods.
**Controls** = TWFE regression includes covariates beyond FEs.

### `data.sample_filter`
R expression (as string) applied with `filter()`. Example:
- `"parentsmallfirm == 1 & state_fips != 25"`
- Leave `""` if no filter needed.

### `variables.treatment_twfe`
The treatment indicator variable in the TWFE regression. This is the binary 0/1 post-treatment indicator (labeled `Post_avg` in the dissertation code). Must already exist in the data or be constructible from existing variables.

If it doesn't exist in the data, note in `preprocessing.notes` what construction is needed, and ask the ANALYST to add a preprocessing step. Example: `"Post_avg = (year >= treat_year) * treated_unit"`

### `variables.gvar_cs`
Cohort variable for Callaway-Sant'Anna:
- 0 = never-treated
- year = first year of treatment for treated units

If this variable doesn't exist in the data, describe how to create it in `notes`.

### `variables.twfe_controls`
List of time-varying control variable names included in the TWFE regression. Do NOT include:
- Unit FEs (captured by `unit_id`)
- Time FEs (captured by `time`)
- Year or unit dummies (these are FEs)
- The treatment variable itself

Example: `["unemp_rate", "poverty_rate", "pct_black"]`

### `variables.cs_controls`
Controls to pass to `att_gt(xformla=)`. Usually a subset of `twfe_controls` (individual-level or unit-level covariates, NOT time dummies). Factor variables need to be listed by name; the template handles conversion.

### `variables.additional_fes`
Extra fixed effects beyond unit + time. Example: `["age_group"]` for individual-level data with age FEs.

### `panel_setup.data_structure`
- `"panel"`: One observation per unit-period (e.g., state-year data)
- `"repeated_cross_section"`: Multiple observations per unit-period (e.g., individual survey data)

For repeated cross-section: template uses `panel=FALSE` for CS and skips BJS (or pre-aggregates if possible).

### `panel_setup.treatment_timing`
- `"staggered"`: Multiple cohorts (units adopt treatment at different times)
- `"single"`: Binary DiD (all treated units adopt at the same time)

### `analysis.run_csdid_nyt`
Set `true` only if `treatment_timing == "staggered"`. Otherwise `false`.

### `analysis.run_bacon`
Set `true` only if `treatment_timing == "staggered"`. Otherwise `false`.

### `analysis.has_event_study`
Set `true` only if the original paper contains an event study plot. If paper only reports ATT levels, set `false`.

### `analysis.bjs_gvar`
The BJS cohort variable. Typically the same as `gvar_cs`, but sometimes a separate variable (e.g., `gvar_BJS`) where never-treated units have `NA` (not 0). Check the original code. If same as `gvar_cs`, set to `""` or null.

### `preprocessing.time_recode`
For non-contiguous time periods (e.g., survey years 1988,1989,1990,1991,1992,1997):
```json
"time_recode": {"1988": 1, "1989": 2, "1990": 3, "1991": 4, "1992": 5, "1997": 6}
```
If time is already sequential integers, leave `null`.

### `preprocessing.composite_twfe`
For articles where the main TWFE coefficient is a linear combination of multiple terms:
- `"additive_2"`: β = β₁ + 2×β₂ (like Bhalotra et al. 2021, treated_post + 2×treated_post_year)
- Otherwise: `null`

### `preprocessing.composite_vars`
Required if `composite_twfe` is set. Array of variable names:
`["treated_post", "treated_post_year"]`

---

## Specification Selection Protocol

When the original paper reports multiple specifications:
1. Use the **main/preferred** specification explicitly labeled by the authors
2. If unclear: use the specification with the **most observations**
3. If still tied: use the specification with the **fewest time-varying controls**
4. If still tied: use the **first** specification presented

Prefer the specification closest to the original TWFE design (not robustness checks, not placebo tests, not subgroup analyses).

---

## Step-by-Step Procedure

1. **Read the article PDF** (methodology section, Table 1 or main results table)
   - Identify: outcome variable(s), treatment variable, level of variation (unit), time period
   - Note: are there event study plots? Single or staggered adoption?

2. **Read the replication code** in `data/[id]/`
   - Find: the main .do or .R file running the DiD regression
   - Identify: exact variable names, data file path, sample restrictions, controls

3. **Check the data file(s)** in `data/[id]/`
   - Confirm variable names exist (use `haven::read_dta()` or similar if needed)
   - Confirm `gvar_cs` exists or can be constructed

4. **Fill in metadata.json** field by field

5. **Validate**:
   - `group_label` is consistent with `treatment_timing` and `twfe_controls`
   - `run_csdid_nyt` and `run_bacon` are `true` iff `treatment_timing == "staggered"`
   - `has_event_study` reflects what the paper actually contains
   - `data.file` path is correct relative to project root

6. **Save** to `results/[id]/metadata.json`

7. **Report**: `[Profiler][id] OK` or `[Profiler][id] FAIL: reason`

---

## Common Pitfalls

- Stata `.dta` files often contain Stata-labeled formats. The `haven` package reads these with attributes but the values are numeric — check that variable names match the `.dta` file exactly (case-sensitive in R).
- Stata `halfyear` format (e.g., `th(2012h2)`) is stored as an integer. Decode as: `year + 0.5 * half`. In R, treat as numeric.
- `Post_avg` may not exist in the data — it might need to be created as `(time >= adopt_time) * treated_unit`. Note this in `notes`.
- `gvar_CS` with value `0` = never-treated. If original code uses a different sentinel (e.g., `.` or `9999`), recode to 0 in `notes`.
- Factor variables in controls: list the base variable name; the template handles `as.factor()` conversion when needed.
- **Stata monthly dates** (`start_ym`, etc.): stored as integers — extract month with `(as.integer(x) %% 12L) + 1L`, year with `(as.integer(x) %/% 12L) + 1960L`. Never use `as.Date()` or `format()` on these integers. See failure_patterns.md Pattern 12.
- **gvar_CS: use L0==1, not F1==1** to identify the first treated period in datasets with pre-created event study dummies (F1, L0, L1...). F1==1 is the period prior to treatment and would shift the cohort year back by one period. See failure_patterns.md Pattern 14.
- **gvar_CS must be constant within unit_id**: if data has subgroups with different timing (e.g., parvar × state), create `cell_id = var1 * 100L + as.integer(var2)` and use as `unit_id` instead of the natural unit. See failure_patterns.md Pattern 15.
- **Variable names in metadata.json**: use actual names from the `.dta` file (verify with `names(haven::read_dta(file))`), **not** Stata xi-expanded names (e.g., `_Ieduc_2`). Categorical variables go in `additional_fes` by their base name (e.g., `educ_category`). See failure_patterns.md Pattern 16.
- **Late-treated states absorbed as never-treated (NT) by `att_gt`**: when some states have `gvar_CS > max(year)`, `att_gt` converts them to `Inf` (never-treated), inflating the NT control group and severely biasing estimates. Check: `any(df$gvar_CS > max(df$year))`. Fix for **NT only**: `df_nt <- df %>% filter(gvar_CS == 0 | gvar_CS <= max(year))` before calling `att_gt`. Do NOT apply this filter for NYT — late-treated states are valid NYT controls. See failure_patterns.md Pattern 25.
- **Pattern 26 (REVISED)**: ALWAYS use `base_period="universal"` in all `att_gt` calls. This is the mandatory default — no exceptions.
