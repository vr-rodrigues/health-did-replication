# Estimator Standardization Protocol
## Decision Rules for DiD Event Study Estimation

**Last updated**: 2026-03-07
**Based on**: 10 calibration articles + 16 new articles empirical experience

---

## 1. Decision Matrix

| Estimator | Panel Data | Repeated Cross-Section | Single Cohort | Staggered | Requires NT | Notes |
|-----------|:----------:|:---------------------:|:-------------:|:---------:|:-----------:|-------|
| **TWFE**    | individual | individual | Yes | Yes | No  | Always available |
| **CS-NT**   | panel=TRUE | panel=FALSE | Yes | Yes | **Yes** | Time ≤60 periods |
| **CS-NYT**  | panel=TRUE | panel=FALSE | Yes* | Yes | No  | Late horizons unreliable |
| **SA**      | individual | individual | **No** | Yes | No** | ≥2 cohorts required |
| **Gardner** | individual | individual | Yes | Yes | No** | Works on ANY data (panel or RCS) |

Legend:
- **individual**: runs on individual-level data directly (no aggregation needed)
- **panel=TRUE/FALSE**: att_gt parameter for panel vs RCS mode
- **NT**: never-treated group
- \* CS-NYT with single cohort: pre-treatment obs serve as "not yet treated"
- \*\* Uses not-yet-treated + pre-treatment observations as controls
- **Gardner replaces BJS**: equivalent to BJS on panel without controls, but works on both panel and RCS without aggregation

---

## 2. Key Rules

### Rule 1: Data Priority
> **Always use original (individual-level) data first.** All estimators (TWFE, CS, SA, Gardner) work on individual-level data. No aggregation is needed for any estimator.

### Rule 2: Gardner Works on ANY Data
> **Gardner (did2s) works on ANY data structure** — panel or RCS, individual-level or aggregated. The first stage estimates group + time FEs on untreated observations. Each individual does NOT need to be observed multiple times. Use `first_stage = ~ controls | group + time`.

### Rule 3: CS-DID Supports RCS
> **CS-DID (att_gt) supports RCS directly** via `panel = FALSE`. Set `idname = "row_id"` (unique per observation). No aggregation needed. If computation fails due to many time periods, reduce time granularity (monthly → yearly) but keep individual observations.

### Rule 4: SA Requires Staggered Treatment
> **SA (sunab) requires ≥2 treatment cohorts.** Single-cohort designs have nothing to decompose. Disable SA when `treatment_timing: "single"`.

### Rule 5: All-Eventually-Treated
> When all units are eventually treated (no never-treated group):
> - Use **TWFE + CS-NYT + Gardner**
> - **Disable CS-NT** (no never-treated control group)
> - **Disable SA** if last cohort is very small (Pattern 36: variance explosion)

---

## 3. Implementation by Scenario

### 3A. Panel + Staggered + Never-Treated (best case: all 4 estimators)

```r
# TWFE
feols(y ~ i(rel_time, ref=c(-1, never_bin)) + controls | unit + time,
      weights=~wt, cluster=~group)

# CS-NT
att_gt(yname="y", tname="time", idname="unit", gname="gvar",
       panel=TRUE, control_group="nevertreated", base_period="universal",
       xformla=~1, clustervars="group", data=df)

# SA
feols(y ~ sunab(cohort, time) + controls | unit + time,
      weights=~wt, cluster=~group)

# Gardner
did2s(data=df, yname="y",
      first_stage = ~ controls | unit + time,
      second_stage = ~ i(rel_time, ref=c(-1, never_bin)),
      treatment="post_treat", cluster_var="group", weights="wt")
```

### 3B. RCS + Staggered + Never-Treated

```r
# TWFE — individual data, group FEs
feols(y ~ i(rel_time, ref=c(-1, never_bin)) + controls | group + time,
      weights=~wt, cluster=~group)

# CS-NT — individual data, panel=FALSE
df$row_id <- seq_len(nrow(df))
att_gt(yname="y", tname="time_year", idname="row_id", gname="gvar_year",
       panel=FALSE, control_group="nevertreated", base_period="universal",
       weightsname="wt", xformla=~1, clustervars="group", data=df)

# SA — individual data
feols(y ~ sunab(cohort_year, time_year) + controls | group + time,
      weights=~wt, cluster=~group)

# Gardner — individual data (works on RCS directly!)
did2s(data=df, yname="y",
      first_stage = ~ controls | group + time,
      second_stage = ~ i(rel_time, ref=c(-1, never_bin)),
      treatment="post_treat", cluster_var="group", weights="wt")
```

### 3C. RCS + Single Cohort + Never-Treated

```r
# TWFE, CS-NT, Gardner: same as 3B
# SA: NOT APPLICABLE (single cohort)
```

### 3D. Panel + Staggered + All Eventually Treated

```r
# TWFE: same as 3A
# CS-NYT: att_gt(..., control_group="notyettreated")
# Gardner: same as 3A
# SA: DISABLE (or use with caution if last cohort is large)
# CS-NT: NOT APPLICABLE (no never-treated)
```

---

## 4. CS-DID Time Period Limits

| Periods | Status | Action |
|---------|--------|--------|
| ≤ 30 | Safe | Use original data |
| 30-60 | Caution | Monitor memory; use original data first |
| 60-100 | Risky | May segfault; try original, fall back to coarser time |
| > 100 | Likely fails | Must reduce time granularity |

**Reducing time granularity for CS-DID** (if needed):
- Keep individual observations
- Recode `tname` to coarser unit (monthly → yearly: `actual_year = 2004 + floor((time-1)/12)`)
- Recode `gname` to match (`gvar_year = 2004 + floor((gvar_month-1)/12)`)
- This is NOT aggregation — all N individual obs remain

---

## 5. Estimator-Specific Notes

### TWFE
- Uses `feols()` with `i(rel_time_binned)` for event dummies
- Reference: `ref = c(-1, never_bin)` where `never_bin` = -(ev_pre + 2)
- Far pre-treatment bin: `far_pre_bin` = -(ev_pre + 1) captures all t < -ev_pre
- Tail post-treatment bin: `ev_post` captures all t ≥ ev_post
- Monthly FEs in `| fips + time` absorb time-specific shocks even when event dummies are yearly

### CS-NT / CS-NYT
- ALWAYS use `base_period = "universal"` (Pattern 26)
- For RCS: `panel = FALSE`, `idname = "row_id"` (unique per obs)
- Extract event study: `aggte(cs, type = "dynamic")`
- `clustervars` controls inference level (can differ from TWFE clustering: Pattern 30)
- Never use `factor()` in `xformla` — pre-create factor columns (Pattern 16)

### SA (Sun-Abraham)
- Requires ≥2 treatment cohorts (staggered)
- ALWAYS extract via `iplot(fit, only.params=TRUE)`, NOT `coef()/vcov()` (SEs inflated 5-18x)
- `cohort_year = Inf` for never-treated
- Unreliable when last-treated cohort is very small (Pattern 36)
- For all-eventually-treated: consider disabling

### Gardner (did2s)
- Two-stage: (1) estimate group+time FEs on untreated obs; (2) regress residuals on event dummies
- Works on ANY data structure (panel or RCS, individual or aggregated)
- **Equivalent to BJS on panel without controls**, but works universally
- `first_stage = ~ controls | group + time` (controls optional)
- `second_stage = ~ i(rel_time, ref = c(-1, never_bin))`
- `treatment`: binary column (1 = treated unit in post-period)
- `weights`: string column name (e.g., "wt06")
- Returns fixest object — use `coef()` and `se()` for extraction

---

## 6. Default Estimator Selection by Article

Given article metadata:

```
IF data_structure == "panel":
    IF treatment_timing == "staggered":
        IF has_never_treated:
            → TWFE, CS-NT, SA, Gardner (all 4)
        ELSE (all eventually treated):
            → TWFE, CS-NYT, Gardner (SA optional with caveats)
    ELSE (single cohort):
        IF has_never_treated:
            → TWFE, CS-NT, Gardner (no SA)
        ELSE:
            → TWFE, CS-NYT, Gardner

IF data_structure == "repeated_cross_section":
    IF treatment_timing == "staggered":
        IF has_never_treated:
            → TWFE, CS-NT(panel=F), SA, Gardner
        ELSE:
            → TWFE, CS-NYT(panel=F), Gardner
    ELSE (single cohort):
        IF has_never_treated:
            → TWFE, CS-NT(panel=F), Gardner (no SA)
        ELSE:
            → TWFE, Gardner
```

---

## 7. Validation Checklist

Before running any event study, verify:

- [ ] Data structure correctly identified (panel vs RCS)
- [ ] Treatment timing correctly identified (single vs staggered)
- [ ] Never-treated group existence confirmed
- [ ] gvar_CS constant within unit (Pattern 15)
- [ ] base_period = "universal" for CS-DID (Pattern 26)
- [ ] Time periods ≤ 60 for CS-DID (or reduce granularity)
- [ ] SA extracted via iplot(), not coef()
- [ ] Gardner using individual data (no unnecessary aggregation)
- [ ] Controls consistent across estimators where appropriate
