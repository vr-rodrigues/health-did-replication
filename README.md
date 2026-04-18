# Replication Package
## Do Health Policy Conclusions Survive Modern DiD? Re-estimating TWFE Studies

**Author:** Victor Rangel
**Institution:** Insper (Master's dissertation, 2026)
**Advisors:** Cristine Pinto and Pedro H. C. Sant'Anna

---

## Overview

This package re-estimates 56 published studies that used TWFE difference-in-differences
with modern robust estimators (Callaway–Sant'Anna, Sun–Abraham, Borusyak–Jaravel–Spiess,
Bacon decomposition, HonestDiD sensitivity). It reproduces **every table and figure**
in Chapters 3 and 4 of the dissertation, as well as the appendix article cards and
per-article event-study / Bacon / HonestDiD plots.

The package follows the **AEA Data and Code Availability Policy (DCAS 1.0)**.

## Data availability

Please read [`data_availability_statement.md`](data_availability_statement.md).

Short version:

* **All aggregate and per-article derived data needed to reproduce the
  dissertation's tables and figures are bundled** inside `data/metadata/`,
  `results/by_article/`, and `analysis/`.
* **None of the 56 original papers' raw datasets are redistributed here.**
  Researchers who want to rerun the per-article re-estimation pipeline must
  download each paper's own replication package from the link listed in the
  data availability statement, and place the files under `data/raw/{id}/`.

## License

This package is distributed under the **Creative Commons Attribution 4.0
International License (CC-BY-4.0)** — see [`LICENSE.txt`](LICENSE.txt).
The license covers code and derived aggregate data produced by this project.
It does **not** extend to the 56 original datasets, which remain under the
licenses set by their original authors and publishers.

---

## Software requirements

| Software | Version |
|----------|---------|
| R        | 4.4.2 (tested; 4.3+ likely works) |
| Rscript  | bundled with R |

Required R packages (installed automatically by `00_setup.R`):

`jsonlite`, `haven`, `dplyr`, `tidyr`, `rlang`, `ggplot2`, `ggrepel`, `grid`,
`gridExtra`, `fixest`, `did`, `did2s`, `bacondecomp`, `HonestDiD`.

No compilation or proprietary software (Stata, MATLAB, etc.) is required.

LaTeX packages needed to recompile the bundled `.tex` tables:
`tcolorbox`, `booktabs`, `threeparttable`, `array`, `amsmath`, `amssymb`
(only relevant if you want to recompile `output/tables/*.tex` standalone;
they are used verbatim via `\input{}` in the dissertation source).

## Hardware / runtime

* Tier 1 (self-contained — regenerates all figures/tables from bundled
  aggregate data): under 5 minutes on a standard laptop.
* Tier 2 (per-article re-estimation using the 56 original datasets):
  several hours; memory depends on the largest paper's sample (expect up to
  16 GB of RAM for a full run; some articles are individually skipped in the
  scripts with explanatory comments).

## Operating system

Scripts were developed on Windows 11 with R 4.4.2 using forward-slash paths
throughout, and should run unchanged on macOS and Linux. Scripts assume that
the **working directory is the replication package root** (`Replication Package/`).

---

## Directory structure

Inputs, intermediate per-article results, cross-article aggregates, and final
outputs are kept in four separate top-level folders to make the package's
data flow explicit:

```
Replication Package/
├── README.md                            (this file)
├── LICENSE.txt                          (CC-BY-4.0)
├── data_availability_statement.md       (per-article source links)
├── 00_setup.R                           (install R packages)
│
├── code/                                (ALL executable code)
│   ├── 00_master.R                      (runs everything in order)
│   ├── analysis/
│   │   ├── did_analysis_template.R      (metadata-driven DiD engine)
│   │   ├── 01_run_all_did.R             (loops template over all 56 IDs)
│   │   ├── 02_event_study_weights.R     (Sun–Abraham ESW diagnostics)
│   │   ├── 03_honest_did.R              (Rambachan–Roth sensitivity)
│   │   └── 04_bacon_all.R               (Bacon decomposition)
│   ├── aggregation/
│   │   └── 01_consolidate_results.R     (builds consolidated_results.csv)
│   ├── figures/
│   │   ├── 01_aggregate_scatter.R       (Figures 4.1, 4.3)
│   │   ├── 02_density_z.R               (Figure 4.2)
│   │   ├── 03_panel_event_study.R       (Figure 4.4)
│   │   ├── 04_panel_binning_76.R        (Figure 4.5 — needs article 76 data)
│   │   ├── 05_panel_controls_133.R      (Figure 4.8 — needs article 133 data)
│   │   ├── 06_graduated_sensitivity.R   (Figure 4.9)
│   │   └── 07_density_covariates.R      (Figure 4.7)
│   ├── tables/
│   │   ├── 01_chapter_statistics.R      (numbers used in Tables 3.x / 4.x)
│   │   └── 02_article_cards.R           (appendix_article_cards.tex)
│   └── utils/
│       └── eventstudyweights.R          (Sun 2021 ESW implementation)
│
├── data/                                (INPUTS only — not outputs)
│   ├── metadata/                        (56 per-article metadata.json —
│   │                                     drives the analysis pipeline)
│   └── raw/                             (NOT included; populate yourself from
│                                         data_availability_statement.md)
│
├── results/                             (PER-ARTICLE derived outputs)
│   └── by_article/{id}/
│       ├── metadata.json                (copy of data/metadata/{id}.json for
│       │                                 traceability)
│       ├── results.csv                  (TWFE / CS-DID / SA / BJS estimates)
│       ├── event_study_data.csv         (event-study coefficients by estimator)
│       ├── bacon.csv                    (Bacon decomposition rows)
│       ├── honest_did_v3.csv            (HonestDiD breakdown values)
│       ├── honest_did_v3_sensitivity.csv (full HonestDiD sensitivity curves)
│       └── *.pdf                        (per-article figures, produced by
│                                         Tier 2 scripts)
│
├── analysis/                            (CROSS-ARTICLE aggregate datasets)
│   ├── consolidated_results.csv         (rebuilt by aggregation/01_consolidate_results.R)
│   ├── article_cards.csv
│   ├── honest_did_v3_summary.csv
│   ├── sensitivity_graduated.csv
│   ├── decision_log.csv
│   ├── progbin_summary.csv
│   ├── dcdh_weights_combined.csv
│   ├── outcome_labels.csv
│   └── relatorio_geral_v2.csv
│
└── output/                              (FINAL figures and tables for the paper)
    ├── figures/                         (main-text figures 4.1–4.10)
    │   ├── appendix_event_studies/      (per-article event study PDFs —
    │   │                                 pre-rendered dissertation versions)
    │   ├── appendix_honestdid/          (per-article HonestDiD PDFs — pre-rendered)
    │   └── appendix_bacon/              (per-article Bacon PDFs — pre-rendered)
    └── tables/
        ├── appendix_article_cards.tex
        └── honest_did_v3_table.tex
```

**Data flow.** `data/` holds only inputs (analysis metadata and raw article
data). Running Tier 2 turns raw data into per-article artifacts in
`results/by_article/{id}/`; running the aggregation script turns those into
cross-article CSVs in `analysis/`; Tier 1 figure/table scripts then read from
`analysis/` (and some from `results/by_article/`) to write the final
dissertation assets into `output/`. Tier 1 alone is enough to reproduce every
figure and table in the main text because `results/by_article/` and
`analysis/` are bundled pre-computed.

The `data/raw/` folder is **not** included; see
`data_availability_statement.md` for instructions on how to populate it.

---

## How to reproduce the dissertation's results

### Step 1 — Install R and unzip this package

Install R 4.4.2 (or newer in the 4.x line). Unzip this package into a folder
and open a terminal in that folder. All commands below assume the working
directory is the replication package root.

### Step 2 — Install R packages

```bash
Rscript 00_setup.R
```

### Step 3 — Run the master script

```bash
Rscript code/00_master.R
```

By default this reproduces, from the bundled aggregate data only (Tier 1):

* All numerical statistics reported in Tables 3.x and 4.x (printed to console
  by `code/tables/01_chapter_statistics.R`).
* `output/tables/appendix_article_cards.tex`.
* All main-text figures in Chapter 4 that do not require raw article-level
  data (see mapping below).

### Step 4 — (optional) Re-run the per-article pipeline (Tier 2)

To regenerate the per-article CSVs and PDFs from each paper's raw data:

1. Follow `data_availability_statement.md` to download each paper's
   replication package and place it under `data/raw/{id}/...`, matching the
   `data$file` path recorded in the corresponding
   `data/metadata/{id}.json`.
2. Open `code/00_master.R` and set:
   ```r
   RUN_TIER2 <- TRUE
   ```
3. Re-run:
   ```bash
   Rscript code/00_master.R
   ```

Tier 2 overwrites the bundled files under `results/by_article/{id}/` and the
aggregates under `analysis/` with freshly computed values.

---

## Program-to-output mapping

| Dissertation exhibit | Script | Output file |
|---|---|---|
| Figure 4.1 (aggregate scatter, dynamic) | `code/figures/01_aggregate_scatter.R` | `output/figures/figure_4_1_aggregate_scatter_dynamic.pdf` |
| Figure 4.2 (density of z-scores, dynamic) | `code/figures/02_density_z.R` | `output/figures/figure_4_2_density_z_dynamic.pdf` |
| Figure 4.3 (variation %) | `code/figures/01_aggregate_scatter.R` | `output/figures/figure_4_3_variation_pct_dynamic.pdf` |
| Figure 4.4 (6-panel event study) | `code/figures/03_panel_event_study.R` | `output/figures/figure_4_4_panel_event_study_6cases.pdf` |
| Figure 4.5 (ID 76 binning panel) | `code/figures/04_panel_binning_76.R` (Tier 2) | `output/figures/figure_4_5_panel_binning_76.pdf` |
| Figure 4.6a,b (NT vs NYT) | included pre-rendered in `output/figures/` | `figure_4_6a_nt_nyt_228.pdf`, `figure_4_6b_nt_nyt_79.pdf` |
| Figure 4.7 (density with covariates) | `code/figures/07_density_covariates.R` | `output/figures/figure_4_7_density_covariates.pdf` |
| Figure 4.8 (ID 133 conditional CS-DID) | `code/figures/05_panel_controls_133.R` (Tier 2) | `output/figures/figure_4_8_panel_controls_133.pdf` |
| Figure 4.9 (graduated sensitivity panel) | `code/figures/06_graduated_sensitivity.R` | `output/figures/figure_4_9_graduated_sensitivity.pdf` |
| Figure 4.10 (ID 210 sensitivity) | included pre-rendered in `output/figures/` | `figure_4_10_sensitivity_210.pdf` |
| Group / simple variants (aggregate and density) | `code/figures/01_aggregate_scatter.R` + `code/figures/02_density_z.R` | `agregado_group.pdf`, `agregado_simple.pdf`, `variacao_pct_*.pdf`, `density_z_*.pdf` |
| Appendix — 56 article cards (LaTeX) | `code/tables/02_article_cards.R` | `output/tables/appendix_article_cards.tex` |
| Appendix — per-article event studies | `code/analysis/01_run_all_did.R` (Tier 2) → `results/by_article/{id}/event_study.pdf`; dissertation versions pre-rendered in `output/figures/appendix_event_studies/` |
| Appendix — per-article HonestDiD | `code/analysis/03_honest_did.R` (Tier 2) → `results/by_article/{id}/honest_did_v3.pdf`; dissertation versions pre-rendered in `output/figures/appendix_honestdid/` |
| Appendix — per-article Bacon | `code/analysis/04_bacon_all.R` (Tier 2) → `results/by_article/{id}/bacon_decomposition.pdf`; dissertation versions pre-rendered in `output/figures/appendix_bacon/` |
| Table 3.1 (sample pipeline) | *static LaTeX (hand-curated selection steps)* | in the chapter source |
| Table 3.2 (sample composition) | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_2_sample_detailed.tex` |
| Table 3.3 (journal distribution) | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_3_journal_final.tex` |
| Table 3.4 (estimator coverage) | `code/tables/01_chapter_statistics.R` | `output/tables/table_3_4_estimator_coverage.tex` |
| Table 4.1 (aggregate concordance) | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_1_aggregate_concordance.tex` |
| Table 4.2 (divergence by timing) | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_2_timing_heterogeneity.tex` |
| Table 4.3 (Bacon + dCdH) | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_3_bacon_summary.tex` |
| Table 4.4 (progressive binning) | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_4_progbin_sensitivity.tex` |
| Table 4.5 (HonestDiD summary) | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_5_honestdid.tex` |
| Table 4.6 (aggregation comparison) | `code/tables/01_chapter_statistics.R` | `output/tables/table_4_6_aggte_comparison.tex` |
| HonestDiD breakdown table (detailed) | produced outside this pipeline | `output/tables/honest_did_v3_table.tex` |
| Consolidated results CSV | `code/aggregation/01_consolidate_results.R` | `analysis/consolidated_results.csv` |

Each `table_*.tex` is a self-contained LaTeX block (`\begin{table}…\end{table}`)
with `\caption{}` and `\label{}` set, so dissertation chapters simply
`\input{Tables/table_X.tex}` to embed them. The script also copies the 9 tables
into `overleaf/Tables/` and `health_did_replication/Tables/` if those LaTeX
project folders are present alongside the replication package.

## Data citations

Each of the 56 original replication packages cited in
`data_availability_statement.md` should be cited directly if any subset is
reused. The author of this package does **not** claim credit for any of those
datasets.

## Random seeds

`did_analysis_template.R` calls `set.seed(42)` immediately after loading
packages. This makes every bootstrap-dependent quantity (`did::aggte()`
simultaneous CIs, `did::att_gt()` multiplier bootstrap SEs) bit-identical
across successive runs on the same R version. Verified on 5 representative
articles (IDs 21, 25, 80, 97, 210): three consecutive invocations of the
template produce md5-identical `results.csv` files.

Minor numerical differences may still arise across R or package versions.

## Legacy-analysis articles

Two of the 56 articles require preprocessing that is too complex to express
as a JSON `construct_vars` array, so their `results.csv` is produced by a
standalone custom script rather than the main template:

- **ID 254** (Gandhi et al. 2024): weekly→quarterly aggregation + merge with
  `ccn_high_mcaid_il.csv` + bubble-period exclusion + multi-scenario
  high/low heterogeneity. Custom script at `results/254/id254_script.R`.
- **ID 347** (Courtemanche et al. 2025): requires the Stata file
  `brfss_clean_bmi.dta`, produced by `brfss_clean.do` which appends 19
  BRFSS annual `.dta` files (1994–2012) with per-year BMI variable
  renaming and merges `laws.dta`/`med_inc`/`unem_popdens`. Custom script.

Both articles are marked `"legacy_analysis": true` in their metadata. The
template recognizes this flag, prints `[LEGACY]` with the reason, and exits
cleanly without touching the bundled `results.csv`. All aggregation and
figure scripts consume these bundled values transparently.

## Contact

For questions about this replication package, please open an issue on the
dissertation's companion repository, or contact the author at the email listed
on the Insper Graduate Programs directory.
