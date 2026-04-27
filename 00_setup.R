# ===========================================================================
# 00_setup.R — Install all required R packages
# Rangel (2026): "Do Health Policy Conclusions Survive Modern DiD?"
# ===========================================================================
# Run this script once before running any analysis.
# Requires R >= 4.4.0 and an internet connection.
# ===========================================================================

cat("=== Installing required R packages ===\n\n")

# CRAN packages
pkgs <- c(
  "jsonlite",      # JSON parsing for metadata
  "haven",         # Read Stata .dta files
  "dplyr",         # Data manipulation
  "tidyr",         # Data reshaping
  "rlang",         # Tidy evaluation
  "ggplot2",       # Plotting
  "ggrepel",       # Non-overlapping labels
  "grid",          # Low-level graphics
  "gridExtra",     # Arrange multiple plots
  "patchwork",     # Assemble multi-panel figures
  "cowplot",       # Figure extraction/assembly helpers
  "scales",        # Axis and label helpers
  "stringr",       # String parsing for article cards
  "data.table",    # Fast input for selected diagnostic panels
  "fixest",        # TWFE and Sun-Abraham estimation
  "did",           # Callaway-Sant'Anna estimator
  "did2s",         # Gardner (2022) imputation estimator
  "bacondecomp",   # Goodman-Bacon decomposition
  "TwoWayFEWeights", # de Chaisemartin-D'Haultfoeuille weights
  "HonestDiD"      # Rambachan-Roth sensitivity analysis
)

installed <- rownames(installed.packages())
to_install <- pkgs[!pkgs %in% installed]

if (length(to_install) > 0) {
  cat("Installing:", paste(to_install, collapse = ", "), "\n")
  install.packages(to_install, repos = "https://cloud.r-project.org")
} else {
  cat("All packages already installed.\n")
}

# Verify all loaded
cat("\n=== Verifying package loading ===\n")
ok <- TRUE
for (p in pkgs) {
  loaded <- suppressPackageStartupMessages(
    require(p, character.only = TRUE, quietly = TRUE)
  )
  if (loaded) {
    cat(sprintf("  [OK] %-15s %s\n", p, packageVersion(p)))
  } else {
    cat(sprintf("  [FAIL] %s\n", p))
    ok <- FALSE
  }
}

if (ok) {
  cat("\n=== All packages ready. ===\n")
} else {
  stop("\nSome packages failed to load. Please install them manually before reproducing the package.",
       call. = FALSE)
}
