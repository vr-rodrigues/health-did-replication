# Paper fidelity audit: 68 — Tanaka (2014)

**Verdict:** WARN
**Date:** 2026-04-19

## Selected specification

Table 3, Column 1 — "Effects of Free Health Care on Newborns"; baseline (benchmark) equation (1) specification. Selected per paper's own language (p. 291): "Column 1 presents the benchmark result based on equation (1)." Equation (1) is a simple 2×2 DiD with no community/cohort FEs and no controls, regressing WAZ on (High × Post), Post, High, plus household controls in later columns. Column 1 is the most parsimonious baseline.

Sample: children aged 0–3 from both KIDS93 (pre-reform) and KIDS98 (post-reform); restricted to black Africans with non-missing WAZ in biologically plausible range (WAZ > −6 and WAZ < 5) and non-missing clinic93. N = 1,071 individual observations; SE clustered at the community level (62 communities).

Our metadata filter (`ageyr < 4 & waz > -6 & waz < 5 & !is.na(clinic93)`) and treatment variable (`postXhigh = post × high`) exactly match this specification. No controls are listed in metadata (`twfe_controls: []`), consistent with Column 1 being the target.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 1) | 0.522 | (0.235) | 1,071 | community (62) | ** |
| Our stored results.csv | 0.5672 | 0.2412 | — | clustnum | — |
| Relative Δ | +8.7% | +2.6% | | | |

Calculations:
- rel_diff_beta = (0.5672 − 0.522) / 0.522 = +8.66%
- rel_diff_se   = (0.2412 − 0.235) / 0.235  = +2.64%

## Notes

- The paper has two main analyses: (1) effect on newborns (Table 3, N=1,071) and (2) effect on already-born children (Table 5, N=1,195). The metadata filter `ageyr < 4` selects the newborns sample, unambiguously matching Table 3.
- Table 5 Panel A Col 1 reports β = 0.521 (SE = 0.253, N = 1,195) for already-born children — our beta is slightly closer to this value (8.7% vs. essentially 8.8% gap), but the sample is structurally different (KIDS93 children aged 0–3 only vs. combined 0–3 and 5–8 age groups). The metadata target is unambiguously Table 3.
- The 8.7% gap in β is above the WITHIN_TOLERANCE threshold (5%) but well below FAIL (20%). The gap could stem from how the two-period repeat cross-section is handled (panel vs. pooled OLS), minor differences in community FE structure (the paper uses `clustnum` FEs in columns 2+, but Col 1 only has the High dummy, Post dummy, and High×Post), or rounding in the paper's reported value.
- Column 1 of Table 3 is a simple pooled OLS with three regressors (High, Post, High×Post) plus SEs clustered at community level. Our pipeline adds clustnum fixed effects (`twfe_fe_override: "clustnum"`), which absorbs the High dummy — this is structurally different from Column 1 (which includes High as a regressor) and closer to Column 2 (which replaces High with community FEs). Column 2 reports β = 0.571 (SE = 0.256). Our stored estimate of 0.567 is within 0.7% of Column 2, suggesting our specification actually matches Column 2, not Column 1.
- In summary: the 8.7% gap from Column 1 is explained by a specification shift — our `twfe_fe_override: "clustnum"` absorbs the community (High) dummy, making our implementation equivalent to Column 2 (community FEs, no other controls). The paper's Column 2 value is 0.571, and our stored 0.567 matches that at 0.7% (EXACT).

## Verdict rationale

Relative to Table 3 Col 1 (the stated benchmark): β diverges by 8.7%, triggering WARN. However, the gap is fully explained by a specification shift: our `twfe_fe_override: "clustnum"` implements community FEs (matching Column 2, β = 0.571) rather than the raw 2×2 Col 1 specification. Against Column 2, our estimate is EXACT (0.7% gap). The WARN verdict is recorded against the strict Col 1 headline target per protocol; the implementation-vs-paper alignment note is provided for the twfe-reviewer.
