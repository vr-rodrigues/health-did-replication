# Replication Package
## Do Health Policy Conclusions Survive Modern DiD? Re-estimating TWFE Studies

**Author:** Victor Rangel
**Institution:** Insper (Master's dissertation, 2026)
**Advisors:** Cristine Pinto and Pedro H. C. Sant'Anna

## Overview

This package re-estimates 56 published studies that used two-way fixed-effects
(TWFE) difference-in-differences with modern robust estimators: Callaway and
Sant'Anna, Sun and Abraham, Borusyak-Jaravel-Spiess, Goodman-Bacon
decompositions, de Chaisemartin-D'Haultfoeuille weights, and HonestDiD
sensitivity analysis.

The analysis starts from 56 candidate replication packages. The final comparable
sample used in the Chapter 4 aggregate results contains 53 articles after the
metadata exclusions documented in `analysis/excluded_papers.csv`.

The package follows the AEA Data and Code Availability Policy / DCAS 1.0 model:
it provides a master script, a data availability statement, bundled derived
analysis files, code for all computational exhibits, and a post-run
reproducibility audit.

## Data Availability Statement

The detailed statement is in `data_availability_statement.md`.

Short version:

- All aggregate and per-article derived data needed to reproduce the
  dissertation's tables and figures are bundled inside `data/metadata/`,
  `results/by_article/`, and `analysis/`.
- The 56 original papers' raw datasets are not redistributed here. Researchers
  who want to rerun the per-article re-estimation pipeline must download each
  paper's replication package from the source listed in
  `data_availability_statement.md` and place the files under `data/raw/{id}/`.
- Code and derived aggregate outputs produced by this project are released under
  CC-BY-4.0. The license does not extend to the original papers' data.

## Software Requirements

Tested environment:

| Software | Version |
|---|---|
| R | 4.4.2 |
| Rscript | bundled with R |
| OS | Windows 11; paths are written portably and should also run on macOS/Linux |

Required R packages are installed by `00_setup.R`:

`jsonlite`, `haven`, `dplyr`, `tidyr`, `rlang`, `ggplot2`, `ggrepel`, `grid`,
`gridExtra`, `patchwork`, `cowplot`, `scales`, `stringr`, `data.table`,
`fixest`, `did`, `did2s`, `bacondecomp`, `TwoWayFEWeights`, and `HonestDiD`.

No proprietary software is required for the bundled-data reproduction. Tier 2
uses the raw replication packages of the original papers, but the reanalysis
code itself is R-based.

## Hardware and Runtime

- Tier 1, bundled-data reproduction: expected to run in under 5 minutes on a
  standard laptop.
- Tier 2, per-article re-estimation from original raw data: several hours. The
  largest articles may require up to 16 GB of RAM.

## Single Reproduction Track

The package now has one intended final track:

- `overleaf/Chapters/` and `overleaf/Appendices/` are the manuscript text source.
- `output/tables/` and `output/figures/` are the computational artifact source.
- `code/audit/sync_final_outputs.R` copies generated artifacts into the LaTeX
  project folders and rebuilds `health_did_replication/main.tex` from the
  Overleaf chapter source.
- `code/audit/verify_reproducibility.R` checks that the generated artifacts,
  LaTeX copies, metadata, and documentation are internally consistent.

The generated audit file is `analysis/reproducibility_audit.csv`. A clean
bundled-data reproduction must have no rows with `status == "FAIL"`.

## Directory Structure

```text
Replication Package/
  README.md
  README.pdf
  LICENSE.txt
  data_availability_statement.md
  00_setup.R
  code/
    00_master.R
    analysis/
      did_analysis_template.R
      01_run_all_did.R
      02_event_study_weights.R
      03_honest_did.R
      04_bacon_all.R
      mvpf_pilots.R
    aggregation/
      01_consolidate_results.R
      02_rebuild_skeptic_ratings.R
      03_rebuild_paper_fidelity.R
      04_flag_excluded_in_cards.R
    figures/
      01_aggregate_scatter.R
      02_density_z.R
      03_panel_event_study.R
      04_panel_binning_76.R
      05_panel_controls_133.R
      06_graduated_sensitivity.R
      07_density_covariates.R
      08_headline_composite.R
      09_signif_matrix.R
      10_bacon_dcdh_maclean.R
      11_mvpf_stress_test.R
    tables/
      01_chapter_statistics.R
      02_article_cards.R
      03_margin_attribution.R
      04_selection_balance.R
      05_inject_skeptic_appendixB.R
    audit/
      sync_final_outputs.R
      verify_reproducibility.R
    utils/
      eventstudyweights.R
  data/
    metadata/
    raw/
  results/
    by_article/{id}/
  analysis/
  output/
    figures/
    tables/
  overleaf/
  health_did_replication/
```

## How to Reproduce the Bundled Results

1. Install R 4.4.2 or newer in the 4.x line.
2. Open a terminal in the replication package root.
3. Run:

```bash
Rscript code/00_master.R
```

By default, `code/00_master.R` runs Tier 1 only (`RUN_TIER2 <- FALSE`). It
installs/checks packages, rebuilds aggregate CSVs from bundled per-article
results, regenerates tables and figures, syncs final outputs into the LaTeX
projects, rebuilds the working-paper `main.tex`, and writes
`analysis/reproducibility_audit.csv`.

To check only the final artifact consistency after a run:

```bash
Rscript code/audit/verify_reproducibility.R
```

## Optional Tier 2 Re-estimation

To recompute per-article estimates from the original raw data:

1. Follow `data_availability_statement.md` to obtain each paper's raw
   replication package.
2. Place each package under `data/raw/{id}/`, preserving the internal path
   expected by `data/metadata/{id}.json` in the `data.file` field.
3. In `code/00_master.R`, set:

```r
RUN_TIER2 <- TRUE
```

4. Re-run:

```bash
Rscript code/00_master.R
```

Tier 2 overwrites the bundled files in `results/by_article/{id}/` and the
cross-article aggregates in `analysis/` with freshly computed values.

## Program-to-Output Mapping

| Exhibit / artifact | Script | Output |
|---|---|---|
| Consolidated results CSV | `code/aggregation/01_consolidate_results.R` | `analysis/consolidated_results.csv` |
| Paper-fidelity CSV | `code/aggregation/03_rebuild_paper_fidelity.R` | `analysis/paper_fidelity.csv` |
| Skeptic ratings CSV | `code/aggregation/02_rebuild_skeptic_ratings.R` | `analysis/skeptic_ratings.csv` |
| Table 3.2 | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_2_sample_detailed.tex` |
| Table 3.3 | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_3_journal_final.tex` |
| Table 3.4 | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_4_estimator_coverage.tex` |
| Table 3.5 | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_5_covariate_coverage.tex` |
| Table 3 selection balance | `code/tables/04_selection_balance.R` | `output/tables/table_3_selection_balance.tex` |
| Table 4.1 | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_1_aggregate_concordance.tex` |
| Table 4.2 | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_2_timing_heterogeneity.tex` |
| Table 4.3 | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_3_bacon_summary.tex` |
| Table 4.4 | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_4_progbin_sensitivity.tex` |
| Table 4.5 | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_5_honestdid.tex` |
| Table 4.6 | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_6_aggte_comparison.tex` |
| Table 4.7 | `code/tables/03_margin_attribution.R` | `output/tables/table_4_7_margin_attribution.tex` |
| Lesson 8 MVPF table | `code/analysis/mvpf_pilots.R` | `output/tables/table_4_8_mvpf_stress_test.tex` |
| Appendix article cards | `code/tables/02_article_cards.R` | `output/tables/appendix_article_cards.tex` |
| HonestDiD detailed table | bundled/generated support file | `output/tables/honest_did_v3_table.tex` |
| Figure 4.1 aggregate scatter | `code/figures/01_aggregate_scatter.R` | `output/figures/figure_4_1_aggregate_scatter_dynamic.pdf` |
| Figure 4.2 density | `code/figures/02_density_z.R` | `output/figures/figure_4_2_density_z_dynamic.pdf` |
| Figure 4.3 variation | `code/figures/01_aggregate_scatter.R` | `output/figures/figure_4_3_variation_pct_dynamic.pdf` |
| Figure 4.4 event-study panel | `code/figures/03_panel_event_study.R` | `output/figures/figure_4_4_panel_event_study_6cases.pdf` |
| Figure 4.5 binning panel | `code/figures/04_panel_binning_76.R` | `output/figures/figure_4_5_panel_binning_76.pdf` |
| NT vs NYT panels | bundled pre-rendered files | `output/figures/figure_4_6a_nt_nyt_228.pdf`, `output/figures/figure_4_6b_nt_nyt_79.pdf` |
| Covariate-alignment density | `code/figures/07_density_covariates.R` | `output/figures/figure_4_7_density_covariates.pdf` |
| Covariate-dynamics diagnostic | `code/figures/05_panel_controls_133.R` | `output/figures/figure_4_8_panel_controls_133.pdf` |
| Geographic support diagnostic | `code/figures/06_graduated_sensitivity.R` | `output/figures/figure_4_9_graduated_sensitivity.pdf` |
| ID 210 sensitivity | bundled pre-rendered file | `output/figures/figure_4_10_sensitivity_210.pdf` |
| Bacon/dCdH Maclean diagnostic | `code/figures/10_bacon_dcdh_maclean.R` | `output/figures/figure_4_X_bacon_dcdh_maclean.pdf` |
| Lesson 8 MVPF Panel A | `code/analysis/mvpf_pilots.R` + `code/figures/11_mvpf_stress_test.R` | `output/figures/figure_4_8_mvpf_stress_test_panelA.pdf` |
| Lesson 8 MVPF Panel B | `code/analysis/mvpf_pilots.R` + `code/figures/11_mvpf_stress_test.R` | `output/figures/figure_4_8_mvpf_stress_test_panelB.pdf` |
| Final sync | `code/audit/sync_final_outputs.R` | `overleaf/`, `health_did_replication/` |
| Final audit | `code/audit/verify_reproducibility.R` | `analysis/reproducibility_audit.csv` |

## Random Seeds

`did_analysis_template.R` calls `set.seed(42)` immediately after loading
packages. Bootstrap-dependent quantities should therefore be bit-identical
across repeated runs on the same R/package versions. Minor numerical
differences may arise across R or package versions.

## Legacy-Analysis Articles

Two of the 56 articles require preprocessing that is too complex to express as
a JSON `construct_vars` array, so their `results.csv` is produced by standalone
custom code rather than the main template:

- ID 254, Gandhi et al. (2024).
- ID 347, Courtemanche et al. (2025).

Both are marked `"legacy_analysis": true` in their metadata. The template
recognizes this flag and exits without overwriting the bundled `results.csv`.

## Data Citations

Each original replication package listed in `data_availability_statement.md`
should be cited directly if any subset is reused. The author of this package
does not claim credit for the original datasets.

## Known Deposit Checklist Items

- `data_availability_statement.md` must have all source links filled before an
  AEA/openICPSR deposit.
- A PDF copy of this README should be included as `README.pdf` in the top-level
  directory before deposit.

## Contact

For questions about this replication package, contact the author through the
Insper Graduate Programs directory or the companion repository issue tracker.
