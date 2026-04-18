# Data Availability Statement

## Summary of availability

This replication package re-analyzes 56 previously published articles that used
Two-Way Fixed Effects (TWFE) difference-in-differences. The package does **not**
redistribute any of the 56 original datasets. All original data remain the
intellectual property of the respective authors and are available only from
their published replication packages, as listed in the table below.

This package bundles only the following derived, aggregated material, which is
sufficient to reproduce all tables and figures in the dissertation:

* Per-article analysis metadata (`data/metadata/*.json` and a copy in each
  `results/by_article/{id}/metadata.json` for traceability).
* Per-article numerical results produced by our reanalysis
  (`results/by_article/{id}/results.csv`, `event_study_data.csv`, `bacon.csv`,
  `honest_did_v3.csv`, `honest_did_v3_sensitivity.csv`).
* Aggregate cross-article datasets used to produce all figures and tables in
  Chapters 3 and 4 (`analysis/consolidated_results.csv`,
  `analysis/article_cards.csv`, `analysis/honest_did_v3_summary.csv`,
  `analysis/sensitivity_graduated.csv`, `analysis/decision_log.csv`,
  `analysis/progbin_summary.csv`, `analysis/dcdh_weights_combined.csv`,
  `analysis/outcome_labels.csv`, `analysis/relatorio_geral_v2.csv`).

None of the aggregated files above contain restricted-use or proprietary
microdata.

## What is reproducible from the bundled files alone (Tier 1)

Running `Rscript code/00_master.R` from the package root regenerates, using
only the bundled CSV/JSON files:

* `output/tables/appendix_article_cards.tex`
* Every main-text figure in `output/figures/` that can be derived from the
  bundled aggregates (Figures 4.1, 4.2, 4.3, 4.4, 4.7, 4.9 and the
  group/simple variants).
* Every chapter statistic printed in Tables 3.x and 4.x.

## What requires the original papers' data (Tier 2)

A full end-to-end rerun — i.e., recomputing TWFE, CS-DID, Sun–Abraham, BJS,
event-study weights, HonestDiD sensitivity, and Bacon decompositions for each
of the 56 articles — requires obtaining the raw data of each original paper.
These scripts are:

* `code/analysis/01_run_all_did.R` (orchestrates `did_analysis_template.R`)
* `code/analysis/02_event_study_weights.R`
* `code/analysis/03_honest_did.R`
* `code/analysis/04_bacon_all.R`
* `code/figures/04_panel_binning_76.R` (uses article 76's raw data)
* `code/figures/05_panel_controls_133.R` (uses article 133's raw data)

## How to populate `data/raw/`

Every metadata file uses **portable, relative** paths of the form
`data/raw/{id}/<internal/path/to/file>`. To reproduce Tier 2, download each
paper's replication package from the URL in the table below and unzip it under
`data/raw/{id}/`, preserving the archive's internal directory structure so that
the file expected by `data/metadata/{id}.json` (field `data.file`) exists at
that path relative to the package root.

**The dissertation author will fill the URLs in the `Source` column prior to
openICPSR deposit.**

| ID | Article | Source |
|-----|----------|--------|
| 9 | Dranove et al. (2021) | `<LINK>` |
| 21 | Buchmueller, Carey (2018) | `<LINK>` |
| 25 | Carrillo, Feres (2019) | `<LINK>` |
| 44 | Bosch, Campos-Vazquez (2014) | `<LINK>` |
| 47 | Clemens (2015) | `<LINK>` |
| 60 | Schmitt (2018) | `<LINK>` |
| 61 | Evans, Garthwaite (2014) | `<LINK>` |
| 65 | Monheit et al. (2011) | `<LINK>` |
| 68 | Tanaka (2014) | `<LINK>` |
| 76 | Lawler, Yewell (2023) | `<LINK>` |
| 79 | Carpenter, Lawler (2019) | `<LINK>` |
| 80 | Marcus et al. (2022) | `<LINK>` |
| 97 | Bhalotra et al. (2021) | `<LINK>` |
| 125 | Levine, McKnight, Heep (2011) | `<LINK>` |
| 133 | Hoynes et al. (2015) | `<LINK>` |
| 147 | Greenstone, Hanna (2014) | `<LINK>` |
| 201 | Maclean, Pabilonia (2025) | `<LINK>` |
| 210 | Li et al. (2026) | `<LINK>` |
| 213 | Estrada, Lombardi (2022) | `<LINK>` |
| 228 | Sarmiento, Wagner, Zaklan (2023) | `<LINK>` |
| 233 | Kresch (2020) | `<LINK>` |
| 234 | Myers (2017) | `<LINK>` |
| 241 | Soliman (2025) | `<LINK>` |
| 242 | Moorthy, Shaloka (2025) | `<LINK>` |
| 253 | Bancalari (2024) | `<LINK>` |
| 254 | Gandhi et al. (2024) | `<LINK>` |
| 262 | Anderson, Charles, Rees (2020) | `<LINK>` |
| 263 | Axbard, Deng (2024) | `<LINK>` |
| 267 | Bhalotra, Clarke, Gomes, Venkataramani (2022) | `<LINK>` |
| 271 | Sekhri, Shastry (2024) | `<LINK>` |
| 281 | Steffens, Pereda (2025) | `<LINK>` |
| 290 | Arbogast et al. (2022) | `<LINK>` |
| 304 | Arthi, Beach, Hanlon (2022) | `<LINK>` |
| 305 | Brodeur, Yousaf (2020) | `<LINK>` |
| 309 | Johnson, Schwab, Koval (2024) | `<LINK>` |
| 311 | Galasso, Schankerman (2024) | `<LINK>` |
| 321 | Xu (2023) | `<LINK>` |
| 323 | Prem, Vargas, Mejia (2023) | `<LINK>` |
| 333 | Clarke, Muhlrad (2021) | `<LINK>` |
| 335 | Le Moglie, Sorrenti (2022) | `<LINK>` |
| 337 | Cameron, Seager, Shah (2021) | `<LINK>` |
| 347 | Courtemanche et al. (2025) | `<LINK>` |
| 358 | Bargain, Boutin, Champeaux (2019) | `<LINK>` |
| 359 | Anderson, Charles, Olivares, Rees (2019) | `<LINK>` |
| 380 | Kuziemko, Meckel, Rossin-Slater (2018) | `<LINK>` |
| 395 | Malkova (2018) | `<LINK>` |
| 401 | Rossin-Slater (2017) | `<LINK>` |
| 419 | Kahn, Li, Zhao (2015) | `<LINK>` |
| 420 | Bailey, Goodman-Bacon (2015) | `<LINK>` |
| 432 | Gallagher (2014) | `<LINK>` |
| 433 | DeAngelo, Hansen (2014) | `<LINK>` |
| 437 | Hausman (2014) | `<LINK>` |
| 525 | Danzer, Zyska (2023) | `<LINK>` |
| 744 | Jayachandran et al. (2010) | `<LINK>` |
| 1094 | Fisman, Wang (2017) | `<LINK>` |
| 2303 | Cao, Ma (2023) | `<LINK>` |

The exact file each metadata script expects under `data/raw/{id}/` is recorded
in `data/metadata/{id}.json` (field `data.file`). To list all expected paths
after populating `data/raw/`, run:

```r
suppressPackageStartupMessages(library(jsonlite))
for (f in list.files("data/metadata", pattern="\\.json$", full.names=TRUE)) {
  m <- fromJSON(f)
  cat(sprintf("%s -> %s (exists: %s)\n",
              basename(f), m$data$file, file.exists(m$data$file)))
}
```

## Rights and permissions

All data listed above were obtained from publicly available replication
packages deposited by the original authors (openICPSR, Harvard Dataverse,
journal supplements, or authors' own websites). We hold no additional rights
over any of those datasets. Users who wish to rerun the full pipeline must
obtain the data directly from the sources above and comply with the original
terms of use set by each data provider.

## License

Code and aggregated results bundled in this package are released under
CC-BY-4.0 (see `LICENSE.txt`). The license does **not** extend to the original
papers' data, which remain under the terms specified by their original
authors and publishers.
