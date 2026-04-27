# Replication Audit

Date: 2026-04-27

## Scope

This audit reorganized the project around one final reproduction track:

- Manuscript text source: `overleaf/Chapters/` and `overleaf/Appendices/`.
- Computational artifact source: `output/tables/` and `output/figures/`.
- Working-paper copy: rebuilt from the Overleaf text source.
- Final consistency check: `analysis/reproducibility_audit.csv`.

## Changes Made

- `code/00_master.R` now defaults to bundled-data reproduction with
  `RUN_TIER2 <- FALSE`, runs scripts fail-fast, generates Lesson 8 MVPF inputs
  before plotting them, syncs final outputs, renders `README.pdf`, and runs the
  reproducibility audit at the end.
- `00_setup.R` now includes all packages used by the Tier 1 scripts and stops if
  any required package fails to load.
- `code/audit/sync_final_outputs.R` was added to copy generated tables/figures
  into `overleaf/` and `health_did_replication/`, map appendix figure folders
  consistently, and rebuild `health_did_replication/main.tex`.
- `code/audit/verify_reproducibility.R` was added to check metadata/results
  consistency, output-to-LaTeX synchronization, referenced LaTeX assets, README
  requirements, Lesson 8 files, and stale Figure 4.8 mappings.
- `code/audit/render_readme_pdf.R` was added to create the top-level
  `README.pdf` required by DCAS without requiring pandoc, quarto, or LaTeX.
- `README.md` was rewritten to document the single final track, the 56-to-53
  sample distinction, software requirements, run instructions, and the current
  program-to-output mapping.
- Lesson 8 text, table generation, and LaTeX copies were aligned with the
  audited MVPF interpretation.
- The empty orphan directory `results/by_article/91` was removed.

## Verification

Command run:

```bash
Rscript code/00_master.R
```

Result:

- Exit status: 0.
- Runtime in this environment: 44.2 seconds.
- Tier 1 regenerated aggregate outputs from bundled files.
- `health_did_replication/main.tex` was rebuilt from Overleaf chapter sources.
- `README.pdf` was generated.
- `analysis/reproducibility_audit.csv` was generated.

Audit summary:

```text
PASS: 312
WARN:   1
FAIL:   0
```

## Remaining DCAS Blocker

`data_availability_statement.md` still contains 56 `<LINK>` placeholders in the
per-article source table. This is the only remaining warning in the automated
audit. It is a documentation/deposit blocker under the AEA/DCAS policy because
independent replicators need source locations for the original papers' raw
replication packages when those raw data are not redistributed.

The local `data/raw/` directory is ignored by git and is not part of the public
deposit. Filling the source table therefore requires real public repository or
publisher links for each original paper, not the local raw-data paths.
