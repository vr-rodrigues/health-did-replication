# Bacon Reviewer Report — Article 79 (Carpenter & Lawler 2019)

**Verdict:** NOT_APPLICABLE

**Date:** 2026-04-18

---

## Applicability check

Bacon decomposition requires:
- `treatment_timing == "staggered"`: YES
- `data_structure == "panel"`: NO — article 79 has `data_structure == "repeated_cross_section"`
- `allow_unbalanced == false` (or pre-balanced): MOOT (failed prior condition)

**Formal rule:** `data_structure == "repeated_cross_section"` means the Bacon decomposition is **NOT APPLICABLE**.

Bacon decomposition assumes a balanced (or at minimum unbalanced) panel of the same units observed repeatedly over time. NIS-Teen survey data (the underlying microdata) is a repeated cross-section of adolescents — different individuals are surveyed each year. While the analysis unit is at the state-year level (aggregated), the underlying sampling structure violates the panel requirement.

---

Note: A Bacon decomposition file (`bacon.csv`) was found in the results directory, likely produced as a by-product of the R template run on aggregated state-year data. For reference, the TVT (treated vs. untreated) weights sum to approximately 0.60 and the between-treated-group weights sum to approximately 0.40. All component estimates are positive (range: -0.07 to +0.36), with a few "Later vs. Always Treated" comparisons using cohort 2003 that show near-zero or slightly negative estimates. This suggests cohort 2003 (earliest adopters) may be atypical — they serve as the "always treated" control for later cohorts, and the estimates near zero or negative indicate the later cohorts' pre-treatment trends differ from cohort 2003. However, since the formal applicability condition is not met, this decomposition is informational only.

**Verdict: NOT_APPLICABLE** — data structure is repeated cross-section, not a true panel.
