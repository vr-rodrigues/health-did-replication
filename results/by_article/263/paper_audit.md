# Paper fidelity audit: 263 — Axbard, Deng (2024)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 1a Col 1" — Table 1, Panel A, Column 1 (outcome: any air-pollution-related enforcement action). Equation (2): firm-level DiD comparing firms within 10 km of a monitor vs. farther away. FE: firm + industry×time + province×time. Cluster: city level. Sample: firms within 50 km of a monitor, started operating before 2010, non-missing revenue and key (N = 1,155,296 firm-quarters).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 1 Panel A Col 1) | 0.0033 | (0.00056) | 1,155,296 | city | *** |
| Our stored results.csv | 0.003328 | 0.000556 | — | city_id | *** |
| Relative Δ | +0.86% | −0.66% | | | |

## Notes
- Paper reports SE clustered at city level in parentheses; also reports Conley spatial HAC SE in brackets [0.00040]. Our stored SE (0.000556) matches the city-clustered SE, not the Conley SE.
- N is reported as 1,155,296 in the paper; our results.csv does not store N separately but the sample filter in metadata matches the paper's description (36,103 firms × 32 quarters ≈ 1.15M obs).
- The paper labels this table "Table 1" (not "Table 1a"); the metadata note's "1a" refers to Panel A of Table 1.
- Significance: paper states firms within 10 km are 0.33 pp higher, consistent with *** (the table uses a mean outcome of 0.0046, a 72% increase).

## Verdict rationale
Our stored beta_twfe (0.003328) reproduces the paper's Table 1 Panel A Col 1 value (0.0033) to within 0.86%, and the SE matches to within 0.66% — both well inside the 1% EXACT threshold.
