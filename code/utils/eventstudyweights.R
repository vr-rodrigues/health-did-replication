# ===========================================================================
# eventstudyweights.R — R implementation of Sun (2021) diagnostic weights
# Decomposes TWFE event-study coefficients into weights on CATTs
# Based on: Sun & Abraham (2021, Proposition 3) and Stata's eventstudyweights
# ===========================================================================
#
# Algorithm (Frisch-Waugh-Lovell):
#   1. Residualize event-study bin indicators X against unit + time FEs
#   2. For each (cohort e, relative-time l) cell:
#      Compute w^g_{e,l} = [(X'X)^{-1} X' y]_g
#      where y = 1{cohort=e & reltime=l}
#   3. w^g_{e,l} = weight that CATT(e,l) receives in TWFE coefficient on bin g
#
# Properties (under correct spec):
#   - Own-bin weights sum to 1 for each bin g
#   - Cross-bin weights sum to 0 for each other bin g'
#   - Excluded/reference period weights sum to -1
#
# Usage:
#   source("templates/eventstudyweights.R")
#   w <- esw_compute(data, bin_vars, unit_fe, time_fe, cohort_var, reltime_var)
#   esw_plot(w, target_bin = "L_4", bin_mapping = list(L_4 = 4))
# ===========================================================================

suppressPackageStartupMessages(library(fixest))

#' Compute event study weights (Sun & Abraham 2021, Proposition 3)
#'
#' @param data       data.frame — full panel/RCS used in the TWFE event study
#' @param bin_vars   character vector — names of bin dummy columns (SAME ones in
#'                   the feols regression, EXCLUDING the omitted reference)
#' @param unit_fe    string — unit FE variable name
#' @param time_fe    string — time FE variable name
#' @param cohort_var string — cohort variable (first treatment period;
#'                   NA/0/Inf = never-treated)
#' @param reltime_var string — relative time variable (t - E_i; NA OK for NT)
#' @param covariates optional character vector — control variables (same as in
#'                   TWFE regression, excluding FEs)
#' @param extra_fes  optional character vector — additional FE variable names
#'                   beyond unit_fe and time_fe (e.g., c("mom_ed", "raceeth_cat"))
#' @param weights_var optional string — analytic/frequency weight variable
#'
#' @return data.frame with columns:
#'   cohort, rel_time, n_obs, and one column per bin_var (the weight)
esw_compute <- function(data, bin_vars, unit_fe, time_fe,
                        cohort_var, reltime_var,
                        covariates = NULL, extra_fes = NULL,
                        weights_var = NULL) {

  k <- length(bin_vars)

  # ── 0. Pre-filter: remove NAs in regression variables ONLY ──
  # CRITICAL: Do NOT filter on cohort_var/reltime_var — these are NA for
  # never-treated units, but never-treated obs are ESSENTIAL for identification.
  # Without them, bin dummies become collinear with time FEs (single cohort)
  # or lose cross-sectional variation (staggered).
  reg_vars <- as.character(c(bin_vars, unit_fe, time_fe,
                             covariates, extra_fes, weights_var))
  # Remove interaction terms (e.g., "industry^time") — they are FEs, not columns
  reg_vars <- reg_vars[!grepl("[\\^:]", reg_vars)]
  # Only filter vars that exist in data
  reg_vars <- intersect(reg_vars, colnames(data))
  keep <- complete.cases(data[, reg_vars, drop = FALSE])
  df <- data[keep, , drop = FALSE]
  n <- nrow(df)
  cat(sprintf("esw_compute: n=%d (dropped %d NAs), bins=%d\n",
              n, sum(!keep), k))

  # ── 1. Compute weights via feols (numerically robust) ──
  # For each (cohort, reltime) cell, regress cell indicator on bin_vars
  # with FEs. This mirrors Stata's areg approach and handles conditioning.

  # ── 5. Identify treated cohorts and relative times ──
  coh <- df[[cohort_var]]
  rt  <- df[[reltime_var]]

  is_treated   <- !is.na(coh) & is.finite(coh) & coh > 0
  cohort_vals  <- sort(unique(coh[is_treated]))
  reltime_vals <- sort(unique(rt[is_treated & !is.na(rt)]))

  n_cells <- length(cohort_vals) * length(reltime_vals)
  cat(sprintf("  Cohorts: %d | Rel times: %d | Max cells: %d\n",
              length(cohort_vals), length(reltime_vals), n_cells))

  # Build feols formula
  rhs <- paste(c(bin_vars, covariates), collapse = " + ")
  fe_parts <- c(unit_fe, time_fe, extra_fes)
  fe_str <- paste(fe_parts, collapse = " + ")
  fml <- as.formula(paste("y_cell__ ~", rhs, "|", fe_str))

  # ── 6. Compute weights: for each cell, regress indicator on bins ──
  out_coh     <- numeric(n_cells)
  out_rt      <- numeric(n_cells)
  out_nobs    <- integer(n_cells)
  out_w       <- matrix(NA_real_, nrow = n_cells, ncol = k)

  idx <- 0L
  for (e in cohort_vals) {
    for (l in reltime_vals) {
      idx <- idx + 1L
      out_coh[idx] <- e
      out_rt[idx]  <- l

      mask_logical <- !is.na(coh) & coh == e & !is.na(rt) & rt == l
      out_nobs[idx] <- sum(mask_logical)
      if (out_nobs[idx] == 0) next

      # Create cell indicator as outcome
      df$y_cell__ <- as.integer(mask_logical)

      # Run feols (suppress output)
      fit_cell <- tryCatch({
        if (!is.null(weights_var)) {
          fixest::feols(fml, data = df, weights = df[[weights_var]],
                        notes = FALSE, warn = FALSE)
        } else {
          fixest::feols(fml, data = df, notes = FALSE, warn = FALSE)
        }
      }, error = function(err) NULL)

      if (!is.null(fit_cell)) {
        cf <- coef(fit_cell)
        # Safely extract weights — handle dropped/renamed variables
        w_vals <- rep(NA_real_, k)
        for (j in seq_along(bin_vars)) {
          if (bin_vars[j] %in% names(cf)) w_vals[j] <- cf[bin_vars[j]]
        }
        out_w[idx, ] <- w_vals
      }
    }
  }
  df$y_cell__ <- NULL  # cleanup

  # ── 7. Assemble result ──
  result <- data.frame(cohort = out_coh, rel_time = out_rt, n_obs = out_nobs)
  w_cols <- as.data.frame(out_w)
  colnames(w_cols) <- bin_vars
  result <- cbind(result, w_cols)

  # Drop empty cells
  result <- result[result$n_obs > 0, ]

  cat(sprintf("  Non-empty cells: %d\n", nrow(result)))
  return(result)
}


#' Aggregate weights by relative time (sum across cohorts)
#'
#' @param w_df     output from esw_compute
#' @param target_bin string — which bin's weights to examine
#' @return data.frame with rel_time, weight, n_obs
esw_aggregate <- function(w_df, target_bin) {
  agg <- aggregate(
    cbind(weight = w_df[[target_bin]], n_obs = w_df$n_obs),
    by = list(rel_time = w_df$rel_time),
    FUN = function(x) sum(x, na.rm = TRUE)
  )
  agg <- agg[order(agg$rel_time), ]
  return(agg)
}


#' Verify weight properties (diagnostic print)
#'
#' @param w_df       output from esw_compute
#' @param bin_vars   character vector of bin variable names
#' @param bin_mapping named list: bin_name -> vector of relative times in that bin
#'                    e.g., list(F_5 = -5:-99, L_4 = 4:99, L_0 = 0)
esw_verify <- function(w_df, bin_vars, bin_mapping = NULL) {
  cat("\n=== Weight Verification ===\n")

  # Total weight across all cells for each bin
  for (b in bin_vars) {
    total <- sum(w_df[[b]], na.rm = TRUE)
    cat(sprintf("  Sum all weights for %-8s: %+.4f\n", b, total))
  }

  if (!is.null(bin_mapping)) {
    cat("\n  Own-bin vs cross-bin:\n")
    for (b in names(bin_mapping)) {
      if (!(b %in% bin_vars)) next
      own_rt   <- bin_mapping[[b]]
      own_w    <- sum(w_df[[b]][w_df$rel_time %in% own_rt], na.rm = TRUE)
      cross_w  <- sum(w_df[[b]][!w_df$rel_time %in% own_rt], na.rm = TRUE)
      cat(sprintf("    %-8s own=%+.4f  cross=%+.4f  (own should be ~1)\n",
                  b, own_w, cross_w))
    }
  }
}


#' Plot weight distribution for a target bin
#'
#' @param w_df       output from esw_compute
#' @param target_bin string — which bin coefficient to decompose
#' @param own_reltimes numeric vector — relative times that "belong" to this bin
#'                     (used to color own vs contamination)
#' @param title      optional plot title
#' @param xlim       optional x-axis range
#' @return ggplot object
esw_plot <- function(w_df, target_bin, own_reltimes = NULL,
                     title = NULL, xlim = NULL) {
  suppressPackageStartupMessages(library(ggplot2))

  agg <- esw_aggregate(w_df, target_bin)

  if (!is.null(own_reltimes)) {
    agg$type <- ifelse(agg$rel_time %in% own_reltimes, "Own bin", "Contamination")
  } else {
    agg$type <- "Weight"
  }

  p <- ggplot(agg, aes(x = rel_time, y = weight, fill = type)) +
    geom_col(alpha = 0.75, width = 0.7) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50",
               linewidth = 0.3) +
    scale_fill_manual(values = c("Own bin" = "steelblue",
                                  "Contamination" = "coral",
                                  "Weight" = "steelblue")) +
    labs(
      x = "Relative Time",
      y = paste("Weight on", target_bin, "coefficient"),
      title = if (is.null(title)) paste("Weight decomposition:", target_bin) else title
    ) +
    theme_classic(base_size = 11) +
    theme(legend.position = "bottom", legend.title = element_blank())

  if (!is.null(xlim)) p <- p + coord_cartesian(xlim = xlim)

  return(p)
}


#' Compare weight distributions between two specs (e.g., binned vs unbinned)
#'
#' @param w1, w2     outputs from esw_compute (two different specs)
#' @param target_bin1, target_bin2 string — bin to examine in each spec
#' @param label1, label2 string — labels for legend
#' @param title      optional plot title
#' @return ggplot object
esw_compare <- function(w1, target_bin1, w2, target_bin2,
                        label1 = "Spec 1", label2 = "Spec 2",
                        title = NULL) {
  suppressPackageStartupMessages(library(ggplot2))

  agg1 <- esw_aggregate(w1, target_bin1)
  agg1$spec <- label1

  agg2 <- esw_aggregate(w2, target_bin2)
  agg2$spec <- label2

  combined <- rbind(agg1, agg2)

  p <- ggplot(combined, aes(x = rel_time, y = weight, fill = spec)) +
    geom_col(position = "dodge", alpha = 0.75, width = 0.7) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50",
               linewidth = 0.3) +
    scale_fill_manual(values = c("steelblue", "coral")) +
    labs(
      x = "Relative Time",
      y = "Weight",
      title = if (is.null(title)) "Weight comparison" else title
    ) +
    theme_classic(base_size = 11) +
    theme(legend.position = "bottom", legend.title = element_blank())

  return(p)
}

cat("eventstudyweights.R loaded (esw_compute, esw_aggregate, esw_verify, esw_plot, esw_compare)\n")
