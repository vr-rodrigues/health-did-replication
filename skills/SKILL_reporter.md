# SKILL: REPORTER
## Goal
Generate `results/[id]/report.md` from:
- `results/[id]/results.csv` — point estimates
- `results/[id]/event_study.pdf` — event study plot (if applicable)
- `results/[id]/metadata.json` — article metadata

---

## How to Run

Read the two files above. Then write `results/[id]/report.md` following the template below.

---

## Report Template

```markdown
# Reanalysis Report: [author_label]

**Article**: [title]
**Mapping ID**: [id]
**Group**: [group_label]
**Date**: [YYYY-MM-DD]

---

## 1. Article Summary

[1-2 sentences describing the article: what health policy they study,
what the treatment is, what the main outcome is, and the original finding.]

**Data**: [brief description: unit of observation, time period, data source]
**Treatment**: [what Post_avg = 1 means]
**Outcome**: [what the outcome variable measures]

---

## 2. Specification Used

| Element | Value |
|---------|-------|
| Outcome | [outcome_var] |
| Treatment | [treatment_twfe] |
| Unit FE | [unit_id] |
| Time FE | [time] |
| Cluster | [cluster_var] |
| Weights | [weight or "None"] |
| Controls | [list or "None (FE only)"] |
| Sample filter | [filter expression or "Full sample"] |

---

## 3. Point Estimate Results

| Estimator | ATT | SE | t-stat |
|-----------|-----|----|--------|
| TWFE | [beta_twfe] | [se_twfe] | [beta/se] |
| CSDID-NT | [att_csdid_nt] | [se_csdid_nt] | [att/se_twfe] |
| CSDID-NYT | [att_csdid_nyt] | [se_csdid_nyt] | [att/se_twfe] |

*Note: t-stat for CSDID uses TWFE SE as denominator (standardized for comparability).*

[If CSDID-NYT is NA because treatment_timing == "single", note: "Not applicable — single adoption timing."]

---

## 4. Comparison with Original Finding

**Original TWFE**: [sign and statistical significance from the paper]
**Reestimated TWFE**: [sign and significance from results.csv]
**CSDID-NT**: [sign and significance]

**Direction change?** [Yes / No]
**Magnitude change?** [e.g., "CSDID-NT is 34% smaller than TWFE"]
**Statistical significance change?** [e.g., "Both significant at 5%"; "CSDID-NT not significant"]

---

## 5. Event Study Assessment

[Skip this section if has_event_study == false]

**Pre-trend test**: [Describe visually: "Pre-trends are flat / show gradual trend / one period significant"]
**Post-treatment pattern**: [Stable / Growing / Declining / Reversal]
**Estimator agreement**: [Do TWFE, CS-NT, SA, BJS tell the same story?]

If estimators disagree: describe which differ and the likely mechanism
(heterogeneous treatment effects, compositional change, binning issues, etc.).

---

## 6. Conclusion

[One of the following classifications:]

**REPLICATION: CONFIRMED** — CSDID-NT and TWFE agree in sign and statistical significance.
Magnitude difference < 20%.

**REPLICATION: PARTIAL** — Same sign and significance, but magnitude differs by ≥ 20%.
Or: significant in one but marginally insignificant in the other.

**REPLICATION: CHALLENGED** — Sign reversal, or TWFE significant but CSDID not (or vice versa).

[Followed by 2-3 sentences explaining the mechanism behind any divergence.]
```

---

## Filling In the Report

### Section 2 (Specification)
Pull directly from `metadata.json`. Translate `twfe_controls: []` as "None (FE only)".
Translate `weight: null` as "None".

### Section 3 (Point Estimates)
Pull from `results.csv`. Round to 4 decimal places.
Compute t-stat for TWFE as `beta_twfe / se_twfe`.
Compute standardized t-stat for CSDID as `att_csdid_nt / se_twfe` (using TWFE's SE for comparability).

### Section 4 (Comparison)
Do NOT fabricate the original finding — derive it from `results.csv` (the reestimated TWFE matches the original if the specification is correct). If `original_result` in `metadata.json` has non-null values, use those.
Compare signs and whether `|t-stat| > 1.96` (5% level, two-tailed).

Magnitude change formula:
```
pct_change = (att_csdid_nt - beta_twfe) / |beta_twfe| * 100
```

### Section 5 (Event Study)
Read the PDF visually. Describe what you see.
Pre-trends: look at t = -2, -3, -4 (should be near zero).
Post-treatment: describe the pattern.

### Section 6 (Conclusion)
Use the classification rule:
- **CONFIRMED**: |pct_change| < 20% AND same sign AND both significant (or both insignificant)
- **PARTIAL**: same sign AND significance, but |pct_change| ≥ 20%
- **CHALLENGED**: sign reversal OR significance change (one significant, other not)

---

## Communication Protocol

Success: `[Reporter][id] OK`
Failure: `[Reporter][id] FAIL: [reason]`
