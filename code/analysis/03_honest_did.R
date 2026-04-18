###############################################################################
# honest_did_v3_batch.R
# HonestDiD v3: Figure 5-style plots (first post + avg post), saves full
# sensitivity data and betahat/sigma for future re-plotting.
#
# Changes from v2:
#   - Adds tau_avg (average post-treatment) target with l_vec = rep(1/K, K)
#   - Saves full sensitivity data per article (not just breakdowns)
#   - Generates Figure 5-style plots matching Rambachan & Roth (2023, RES)
#   - Saves betahat/sigma to RDS for future re-plotting without re-estimation
#
# Usage: Rscript honest_did_v3_batch.R [start_id] [end_id]
###############################################################################
suppressPackageStartupMessages({
  library(haven); library(dplyr); library(did); library(fixest)
  library(jsonlite); library(ggplot2); library(HonestDiD)
})

# WARNING: Requires original data. Run from replication package root.
base_dir <- getwd()

args <- commandArgs(trailingOnly = TRUE)
start_id <- if (length(args) > 0) as.integer(args[1]) else 0L
end_id   <- if (length(args) > 1) as.integer(args[2]) else 99999L

meta_root <- file.path(base_dir, "results", "by_article")
out_root  <- file.path(base_dir, "results", "by_article")
result_dirs <- list.dirs(meta_root, recursive = FALSE, full.names = FALSE)
all_ids <- sort(as.integer(result_dirs[grepl("^[0-9]+$", result_dirs)]))
ids <- all_ids[all_ids >= start_id & all_ids <= end_id]

segfault_ids <- c(201, 267, 305, 333, 358, 359, 437)
# Articles with >15 total ES periods: HonestDiD RM optimization too slow
slow_ids <- c(9, 210, 357, 432)  # 17-38 total periods
# Standalone scripts: paper-specific ES that v3 batch can't replicate
# ID 44: quarterly ES (honest_did_v3_fig4D.R)
# ID 2303: yearly event time + id^month + prov^year^month FEs (honest_did_2303.R)
# ID 744: state_disease+year FEs, no controls (twfe_controls collinear) (honest_did_744.R)
standalone_ids <- c(44, 744, 2303)
ids <- ids[!ids %in% c(segfault_ids, slow_ids, standalone_ids)]

# Skip already-completed articles (have honest_did_v3.csv)
skip_existing <- TRUE
if (skip_existing) {
  done <- ids[sapply(ids, function(i) file.exists(file.path(out_root, i, "honest_did_v3.csv")))]
  if (length(done) > 0) {
    cat(sprintf("  Skipping %d already-done: %s\n", length(done), paste(done, collapse=", ")))
    ids <- ids[!ids %in% done]
  }
}

summary_file <- file.path(base_dir, "analysis", "honest_did_v3_summary.csv")
dir.create(dirname(summary_file), recursive = TRUE, showWarnings = FALSE)
Mbarvec <- seq(0, 2, by = 0.25)
# For Figure 5-style plot, show subset of Mbar values
Mbar_plot <- c(0.5, 1.0, 1.5, 2.0)

cat(sprintf("=== HonestDiD v3 --- %d articles (start_id=%d) ===\n\n", length(ids), start_id))

###############################################################################
# Helper: extract TWFE event study betahat + VCOV (same as v2)
###############################################################################
extract_twfe_honest <- function(fit, ev_pre = NULL) {
  if (is.null(fit)) return(NULL)
  cfs <- coef(fit); nms <- names(cfs)
  idx <- grepl("^rel_time_binned::", nms)
  if (sum(idx) < 3) return(NULL)

  times <- as.numeric(sub("rel_time_binned::", "", nms[idx]))
  betahat <- unname(cfs[idx])
  sigma <- as.matrix(vcov(fit)[idx, idx])

  ord <- order(times)
  times <- times[ord]; betahat <- betahat[ord]; sigma <- sigma[ord, ord]

  # Drop far-pre bin to equalize n_pre with CS-DID
  if (!is.null(ev_pre) && length(times) > 3) {
    far_pre_time <- -(as.integer(ev_pre) + 1L)
    drop <- which(times == far_pre_time)
    if (length(drop) == 1) {
      times <- times[-drop]; betahat <- betahat[-drop]
      sigma <- sigma[-drop, -drop]
    }
  }

  numPre  <- sum(times < 0)
  numPost <- sum(times >= 0)
  if (numPre < 2 || numPost < 1) return(NULL)
  if (any(!is.finite(betahat)) || any(!is.finite(sigma))) return(NULL)

  list(betahat = betahat, sigma = sigma, times = times,
       numPrePeriods = numPre, numPostPeriods = numPost, vcov_type = "full")
}

###############################################################################
# Helper: extract CS-DID event study betahat + VCOV (same as v2)
###############################################################################
extract_cs_honest <- function(agg, ev_pre = NULL, ev_post = NULL) {
  if (is.null(agg)) return(NULL)

  times <- agg$egt
  betahat <- agg$att.egt
  se_vec <- agg$se.egt
  n_orig <- length(times)
  if (n_orig < 3) return(NULL)

  inf_func <- NULL
  tryCatch({
    if (!is.null(agg$inf.function) && !is.null(agg$inf.function$dynamic.inf.func.e))
      inf_func <- agg$inf.function$dynamic.inf.func.e
  }, error = function(e) NULL)

  # Remove reference period (-1)
  ref_idx <- which(times == -1)
  if (length(ref_idx) == 1) {
    times <- times[-ref_idx]; betahat <- betahat[-ref_idx]; se_vec <- se_vec[-ref_idx]
    if (!is.null(inf_func) && ncol(inf_func) == n_orig) inf_func <- inf_func[, -ref_idx, drop = FALSE]
  }

  # Filter NaN/Inf/NA
  valid <- !is.na(betahat) & !is.na(se_vec) & is.finite(betahat) & is.finite(se_vec) & se_vec > 0
  if (!is.null(inf_func) && ncol(inf_func) == length(valid)) {
    inf_func <- inf_func[, valid, drop = FALSE]
  } else if (!is.null(inf_func) && ncol(inf_func) != length(valid)) {
    inf_func <- NULL
  }
  times <- times[valid]; betahat <- betahat[valid]; se_vec <- se_vec[valid]
  if (length(times) < 3) return(NULL)

  # Trim to event window
  if (!is.null(ev_pre) && !is.null(ev_post)) {
    keep <- times >= -ev_pre & times <= ev_post
    if (sum(keep) < 3) keep <- rep(TRUE, length(times))
    times <- times[keep]; betahat <- betahat[keep]; se_vec <- se_vec[keep]
    if (!is.null(inf_func)) inf_func <- inf_func[, keep, drop = FALSE]
  }

  sigma_diag <- diag(se_vec^2)

  # Full VCOV: RAW influence function (official HonestDiD approach)
  sigma_full <- NULL
  if (!is.null(inf_func) && ncol(inf_func) == length(times)) {
    n <- nrow(inf_func)
    sigma_full <- tryCatch({
      V <- t(inf_func) %*% inf_func / n / n
      if (any(!is.finite(V))) NULL else V
    }, error = function(e) NULL)
  }

  ord <- order(times)
  times <- times[ord]; betahat <- betahat[ord]
  sigma_diag <- sigma_diag[ord, ord]
  if (!is.null(sigma_full)) sigma_full <- sigma_full[ord, ord]

  numPre  <- sum(times < 0)
  numPost <- sum(times >= 0)
  if (numPre < 2 || numPost < 1) return(NULL)

  list(betahat = betahat, sigma_diag = sigma_diag, sigma_full = sigma_full,
       times = times, numPrePeriods = numPre, numPostPeriods = numPost,
       has_full_vcov = !is.null(sigma_full))
}

###############################################################################
# Helper: run HonestDiD v3 — adds tau_avg to v2 targets
###############################################################################
run_honest_v3 <- function(betahat, sigma, numPre, numPost, Mbarvec, alpha = 0.05) {
  results <- list()

  # --- Relative Magnitudes: first post-period ---
  tryCatch({
    l_first <- basisVector(1, numPost)
    sens_rm_first <- createSensitivityResults_relativeMagnitudes(
      betahat = betahat, sigma = sigma,
      numPrePeriods = numPre, numPostPeriods = numPost,
      Mbarvec = Mbarvec, l_vec = l_first, alpha = alpha)
    # Filter out Inf/-Inf (optimization failure) before checking exclusion
    finite <- is.finite(sens_rm_first$lb) & is.finite(sens_rm_first$ub)
    excl <- finite & ((sens_rm_first$lb > 0) | (sens_rm_first$ub < 0))
    results$rm_first_breakdown <- if (any(excl)) max(Mbarvec[excl]) else if (any(finite)) 0 else NA_real_
    results$rm_first_sens <- sens_rm_first
  }, error = function(e) {
    results$rm_first_breakdown <<- NA_real_
  })

  # --- Relative Magnitudes: average post-period (tau_bar_post) ---
  tryCatch({
    l_avg <- rep(1 / numPost, numPost)
    sens_rm_avg <- createSensitivityResults_relativeMagnitudes(
      betahat = betahat, sigma = sigma,
      numPrePeriods = numPre, numPostPeriods = numPost,
      Mbarvec = Mbarvec, l_vec = l_avg, alpha = alpha)
    finite <- is.finite(sens_rm_avg$lb) & is.finite(sens_rm_avg$ub)
    excl <- finite & ((sens_rm_avg$lb > 0) | (sens_rm_avg$ub < 0))
    results$rm_avg_breakdown <- if (any(excl)) max(Mbarvec[excl]) else if (any(finite)) 0 else NA_real_
    results$rm_avg_sens <- sens_rm_avg
  }, error = function(e) {
    results$rm_avg_breakdown <<- NA_real_
  })

  # --- Relative Magnitudes: peak post-period ---
  tryCatch({
    post_betas <- betahat[(numPre + 1):(numPre + numPost)]
    peak_idx <- which.max(abs(post_betas))
    l_peak <- basisVector(peak_idx, numPost)
    sens_rm_peak <- createSensitivityResults_relativeMagnitudes(
      betahat = betahat, sigma = sigma,
      numPrePeriods = numPre, numPostPeriods = numPost,
      Mbarvec = Mbarvec, l_vec = l_peak, alpha = alpha)
    finite <- is.finite(sens_rm_peak$lb) & is.finite(sens_rm_peak$ub)
    excl <- finite & ((sens_rm_peak$lb > 0) | (sens_rm_peak$ub < 0))
    results$rm_peak_breakdown <- if (any(excl)) max(Mbarvec[excl]) else if (any(finite)) 0 else NA_real_
    results$rm_peak_idx <- peak_idx
    results$rm_peak_sens <- sens_rm_peak
  }, error = function(e) {
    results$rm_peak_breakdown <<- NA_real_
  })

  results
}

###############################################################################
# Helper: generate Figure 5-style sensitivity plot (Rambachan & Roth 2023)
# - 2 panels: theta = tau_first (left), theta = tau_bar_post (right)
# - Only TWFE and CS-DID shown (our two estimators)
# - M̄=0 included as first x-axis point (= standard CI under exact PT)
# - No separate "OLS" — M̄=0 serves that role
###############################################################################
make_fig5_plot <- function(twfe_data, twfe_results, cs_data, cs_results,
                           cs_label, author_label, Mbar_plot, alpha = 0.05) {
  plot_df <- data.frame()

  # Include M̄=0 in the plot (serves as the "OLS" reference point)
  Mbar_show <- c(0, Mbar_plot)

  add_estimator <- function(es_data, honest_res, est_name) {
    if (is.null(es_data) || is.null(honest_res)) return()

    add_from_sens <- function(sens, tgt) {
      if (is.null(sens)) return()
      for (i in seq_along(sens$Mbar)) {
        if (sens$Mbar[i] %in% Mbar_show &&
            is.finite(sens$lb[i]) && is.finite(sens$ub[i])) {
          plot_df <<- rbind(plot_df, data.frame(
            estimator = est_name, target = tgt,
            Mbar = sens$Mbar[i], mid = (sens$lb[i] + sens$ub[i]) / 2,
            lb = sens$lb[i], ub = sens$ub[i], stringsAsFactors = FALSE))
        }
      }
    }
    add_from_sens(honest_res$rm_first_sens, "first")
    add_from_sens(honest_res$rm_avg_sens, "avg")
  }

  add_estimator(twfe_data, twfe_results, "TWFE")
  add_estimator(cs_data, cs_results, cs_label)

  if (nrow(plot_df) == 0) return(NULL)

  # X positions with jitter: TWFE left, CS right
  n_est <- length(unique(plot_df$estimator))
  jitter <- if (n_est > 1) 0.06 else 0

  plot_df$x_pos <- plot_df$Mbar
  est_levels <- unique(plot_df$estimator)
  for (i in seq_along(est_levels)) {
    mask <- plot_df$estimator == est_levels[i]
    offset <- (i - (length(est_levels) + 1) / 2) * jitter
    plot_df$x_pos[mask] <- plot_df$x_pos[mask] + offset
  }

  # Facet
  plot_df$target_f <- factor(
    ifelse(plot_df$target == "first", "first", "avg"),
    levels = c("first", "avg"))

  plot_df$estimator <- factor(plot_df$estimator, levels = est_levels)

  # Colors: TWFE = black, CS = firebrick
  color_vals <- c("TWFE" = "black")
  color_vals[cs_label] <- "firebrick"

  target_labeller <- as_labeller(c(
    "first" = "paste(theta,' = ',tau[first],', ',Delta,' = ',Delta^{RM},'(',bar(M),')')",
    "avg"   = "paste(theta,' = ',bar(tau)[post],', ',Delta,' = ',Delta^{RM},'(',bar(M),')')"
  ), label_parsed)

  p <- ggplot(plot_df, aes(x = x_pos, y = mid, ymin = lb, ymax = ub,
                            color = estimator)) +
    geom_hline(yintercept = 0, linetype = "solid", color = "black", linewidth = 0.4) +
    geom_pointrange(size = 0.3, linewidth = 0.55, fatten = 2.5) +
    facet_wrap(~target_f, labeller = target_labeller) +
    scale_color_manual(values = color_vals) +
    scale_x_continuous(breaks = Mbar_show) +
    labs(x = expression(bar(M)), y = "95% CI",
         title = author_label) +
    theme_classic(base_size = 11) +
    theme(
      legend.position = "bottom",
      legend.title = element_blank(),
      strip.background = element_rect(fill = "grey95", color = NA),
      strip.text = element_text(size = 10),
      panel.grid.major.y = element_line(color = "grey92", linewidth = 0.3)
    )

  p
}

###############################################################################
# Main loop
###############################################################################
for (id in ids) {
  meta_file <- file.path(meta_root, id, "metadata.json")
  out_dir   <- file.path(out_root, id)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  if (!file.exists(meta_file)) next
  meta <- tryCatch(fromJSON(meta_file), error = function(e) NULL)
  if (is.null(meta)) next

  has_es <- isTRUE(meta$analysis$has_event_study)
  ev_pre  <- as.integer(meta$analysis$event_pre %||% 0)
  ev_post <- as.integer(meta$analysis$event_post %||% 0)
  if (!has_es || ev_pre < 2 || ev_post < 1) {
    cat(sprintf("  ID %3d: skipped (no ES)\n", id)); next
  }

  run_nt  <- isTRUE(meta$analysis$run_csdid_nt)
  run_nyt <- isTRUE(meta$analysis$run_csdid_nyt)

  data_file <- meta$data$file
  if (!grepl("^[A-Z]:", data_file) && !startsWith(data_file, "/"))
    data_file <- file.path(base_dir, data_file)
  if (!file.exists(data_file)) {
    cat(sprintf("  ID %3d: DATA MISSING\n", id)); next
  }

  cat(sprintf("  ID %3d (%s): ", id, meta$author_label)); flush.console()

  df <- tryCatch({
    if (grepl("\\.dta$", data_file, ignore.case = TRUE)) read_dta(data_file)
    else read.csv(data_file, stringsAsFactors = FALSE)
  }, error = function(e) { cat("READ_ERR "); NULL })
  if (is.null(df)) { cat("\n"); next }

  # Preprocessing (same as v2)
  if (!is.null(meta$data$sample_filter) && nchar(meta$data$sample_filter) > 0)
    df <- tryCatch(df %>% filter(eval(parse(text = meta$data$sample_filter))), error = function(e) df)
  if (!is.null(meta$preprocessing$construct_vars))
    for (cv in meta$preprocessing$construct_vars) tryCatch(eval(parse(text = cv)), error = function(e) NULL)
  if (!is.null(meta$preprocessing$time_recode)) {
    recode_list <- meta$preprocessing$time_recode
    old_vals <- as.numeric(names(recode_list))
    new_vals <- as.numeric(unlist(recode_list))
    tvar <- meta$variables$time
    df[[tvar]] <- new_vals[match(df[[tvar]], old_vals)]
    df <- df[!is.na(df[[tvar]]), ]
  }

  yname <- meta$variables$outcome; tname <- meta$variables$time
  idname <- meta$variables$unit_id; gname <- meta$variables$gvar_cs
  # Defensive weight parsing: JSON {} parses to list(), not NULL; coerce to
  # NULL if it isn't a non-empty character string (Pattern 44 in
  # knowledge/failure_patterns.md).
  .w <- meta$variables$weight
  wname <- if (is.null(.w) || (is.list(.w) && length(.w) == 0) ||
               !is.character(.w) || length(.w) == 0 ||
               identical(as.character(.w), "null") ||
               identical(as.character(.w), ""))
            NULL else as.character(.w)[1]
  cname <- meta$variables$cluster
  add_fes <- meta$variables$additional_fes

  needed <- c(yname, tname, idname, gname)
  if (any(!needed %in% names(df))) { cat("MISSING_VARS\n"); next }
  df[[gname]] <- as.numeric(df[[gname]])

  is_panel <- !identical(meta$panel_setup$data_structure, "rcs") &&
              !identical(meta$panel_setup$data_structure, "repeated_cross_section")
  allow_unbal <- isTRUE(meta$panel_setup$allow_unbalanced)

  # ===== TWFE Event Study =====
  never_bin <- 9999L
  far_pre_bin <- -(ev_pre + 1L)
  df_es <- df %>% mutate(
    gvar_num = as.numeric(.data[[gname]]),
    raw_rel  = as.numeric(.data[[tname]]) - gvar_num,
    rel_time_binned = case_when(
      gvar_num == 0 | is.na(gvar_num) ~ as.integer(never_bin),
      raw_rel < -as.integer(ev_pre)   ~ as.integer(far_pre_bin),
      raw_rel >= as.integer(ev_post)  ~ as.integer(ev_post),
      TRUE                            ~ as.integer(raw_rel)
    )
  )
  fe_str <- paste(unique(c(idname, tname, if (length(add_fes) > 0 && add_fes[1] != "") add_fes else NULL)), collapse = " + ")
  ref_vals <- c(-1L, as.integer(never_bin))

  tw_es_ctrls <- meta$variables$twfe_es_controls
  if (is.null(tw_es_ctrls) || length(tw_es_ctrls) == 0) tw_es_ctrls <- meta$variables$twfe_controls
  if (is.null(tw_es_ctrls)) tw_es_ctrls <- character(0)
  tw_es_ctrls <- tw_es_ctrls[tw_es_ctrls != "" & tw_es_ctrls %in% names(df_es)]

  fml_rhs <- paste0("i(rel_time_binned, ref=c(", paste(ref_vals, collapse = ","), "))",
                     if (length(tw_es_ctrls) > 0) paste0(" + ", paste(tw_es_ctrls, collapse = " + ")) else "")
  fml_es <- as.formula(paste0(yname, " ~ ", fml_rhs, " | ", fe_str))
  fit_args <- list(fml = fml_es, data = df_es, cluster = as.formula(paste0("~", cname)))
  if (!is.null(wname) && wname %in% names(df_es)) fit_args$weights <- as.formula(paste0("~", wname))

  fit_twfe_es <- tryCatch(do.call(feols, fit_args), error = function(e) { cat("TWFE_ERR "); NULL })
  twfe_data <- extract_twfe_honest(fit_twfe_es, ev_pre = ev_pre)

  # ===== CS-DID Event Study =====
  cs_ctrl <- meta$variables$cs_controls
  xfml <- if (length(cs_ctrl) > 0 && cs_ctrl[1] != "") {
    as.formula(paste("~", paste(cs_ctrl, collapse = " + ")))
  } else ~1
  cs_clust <- if (!is.null(meta$variables$cs_cluster)) meta$variables$cs_cluster else cname
  if (identical(cs_clust, "none")) cs_clust <- NULL

  cs_data <- NULL; cs_label <- "CS-NT"

  do_cs <- function(cg, label) {
    if (is_panel) {
      df_cs <- df; the_id <- idname
      if (!allow_unbal) {
        n_per <- length(unique(df_cs[[tname]]))
        df_cs <- df_cs %>% group_by(across(all_of(idname))) %>%
          filter(n() == n_per, all(!is.na(.data[[yname]]))) %>% ungroup()
      }
    } else {
      df_cs <- df %>% mutate(row_id__ = row_number()); the_id <- "row_id__"
    }
    if (cg == "nevertreated") {
      max_t <- max(df_cs[[tname]], na.rm = TRUE)
      late <- df_cs[[gname]] > max_t & df_cs[[gname]] > 0
      if (any(late, na.rm = TRUE)) {
        df_cs <- df_cs[!late, ]
        if (!is_panel) df_cs$row_id__ <- seq_len(nrow(df_cs))
      }
    }
    cs_args <- list(yname = yname, tname = tname, idname = the_id, gname = gname,
                    xformla = xfml, control_group = cg,
                    panel = is_panel, allow_unbalanced_panel = allow_unbal,
                    base_period = "universal", data = as.data.frame(df_cs))
    if (!is.null(wname) && wname %in% names(df_cs)) cs_args$weightsname <- wname
    if (!is.null(cs_clust) && cs_clust %in% names(df_cs)) cs_args$clustervars <- cs_clust

    cs_obj <- tryCatch(do.call(att_gt, cs_args),
                       error = function(e) { cat(sprintf("%s_ERR ", label)); NULL })
    if (is.null(cs_obj)) return(NULL)

    agg <- tryCatch(aggte(cs_obj, type = "dynamic"),
                    error = function(e) { cat(sprintf("%s_AGG_ERR ", label)); NULL })
    if (is.null(agg)) return(NULL)

    extract_cs_honest(agg, ev_pre = ev_pre, ev_post = ev_post)
  }

  if (run_nt) {
    cs_data <- do_cs("nevertreated", "CS-NT"); cs_label <- "CS-NT"
  }
  if (is.null(cs_data) && run_nyt) {
    cs_data <- do_cs("notyettreated", "CS-NYT"); cs_label <- "CS-NYT"
  }

  # ===== Save betahat/sigma to RDS for future re-plotting =====
  rds_file <- file.path(out_dir, "honest_did_v3_data.rds")
  saveRDS(list(
    twfe_data = twfe_data, cs_data = cs_data, cs_label = cs_label,
    author_label = meta$author_label, id = id
  ), rds_file)

  # ===== Run HonestDiD v3 =====
  # TWFE (full VCOV)
  twfe_results <- NULL
  if (!is.null(twfe_data)) {
    cat(sprintf("twfe(%dp+%dq) ", twfe_data$numPrePeriods, twfe_data$numPostPeriods))
    twfe_results <- run_honest_v3(twfe_data$betahat, twfe_data$sigma,
                                  twfe_data$numPrePeriods, twfe_data$numPostPeriods, Mbarvec)
  } else {
    cat("twfe=NULL ")
  }

  # CS-DID: use full IF VCOV if available, else diagonal
  cs_results <- NULL
  cs_vcov_type <- "none"
  if (!is.null(cs_data)) {
    sigma_cs <- if (cs_data$has_full_vcov) { cs_vcov_type <- "full_IF"; cs_data$sigma_full
                } else { cs_vcov_type <- "diag"; cs_data$sigma_diag }
    cat(sprintf("cs(%dp+%dq,%s) ", cs_data$numPrePeriods, cs_data$numPostPeriods, cs_vcov_type))
    cs_results <- run_honest_v3(cs_data$betahat, sigma_cs,
                                cs_data$numPrePeriods, cs_data$numPostPeriods, Mbarvec)
  } else {
    cat("cs=NULL ")
  }

  # ===== Report breakdowns =====
  report_bd <- function(res, prefix) {
    if (is.null(res)) { cat(sprintf("%s:NA ", prefix)); return() }
    rm_f <- ifelse(is.na(res$rm_first_breakdown), "NA", sprintf("%.2f", res$rm_first_breakdown))
    rm_a <- ifelse(is.na(res$rm_avg_breakdown), "NA", sprintf("%.2f", res$rm_avg_breakdown))
    rm_p <- ifelse(is.na(res$rm_peak_breakdown), "NA", sprintf("%.2f", res$rm_peak_breakdown))
    cat(sprintf("%s[1st=%s,avg=%s,pk=%s] ", prefix, rm_f, rm_a, rm_p))
  }
  report_bd(twfe_results, "TWFE")
  report_bd(cs_results, cs_label)

  # ===== Save full sensitivity data per article =====
  sens_file <- file.path(out_dir, "honest_did_v3_sensitivity.csv")
  sens_rows <- list()

  save_sens <- function(sens, est_name, target_name) {
    if (is.null(sens)) return()
    for (i in seq_along(sens$Mbar)) {
      sens_rows[[length(sens_rows) + 1]] <<- data.frame(
        estimator = est_name, target = target_name,
        Mbar = sens$Mbar[i], lb = sens$lb[i], ub = sens$ub[i],
        stringsAsFactors = FALSE)
    }
  }

  if (!is.null(twfe_results)) {
    save_sens(twfe_results$rm_first_sens, "TWFE", "first")
    save_sens(twfe_results$rm_avg_sens, "TWFE", "avg")
    save_sens(twfe_results$rm_peak_sens, "TWFE", "peak")
  }
  if (!is.null(cs_results)) {
    save_sens(cs_results$rm_first_sens, cs_label, "first")
    save_sens(cs_results$rm_avg_sens, cs_label, "avg")
    save_sens(cs_results$rm_peak_sens, cs_label, "peak")
  }
  if (length(sens_rows) > 0) {
    write.csv(do.call(rbind, sens_rows), sens_file, row.names = FALSE)
  }

  # ===== Save per-article breakdown CSV =====
  csv_file <- file.path(out_dir, "honest_did_v3.csv")
  rows <- list()

  add_row <- function(estimator, vcov_type, res, es_data) {
    if (is.null(res) || is.null(es_data)) return()
    numPre <- es_data$numPrePeriods; numPost <- es_data$numPostPeriods
    post_betas <- es_data$betahat[(numPre + 1):(numPre + numPost)]
    peak_idx <- which.max(abs(post_betas))
    rows[[length(rows) + 1]] <<- data.frame(
      estimator = estimator, vcov_type = vcov_type,
      n_pre = numPre, n_post = numPost,
      rm_first_Mbar = res$rm_first_breakdown,
      rm_avg_Mbar = res$rm_avg_breakdown,
      rm_peak_Mbar = res$rm_peak_breakdown,
      rm_peak_idx = ifelse(is.null(res$rm_peak_idx), peak_idx, res$rm_peak_idx),
      att_first = post_betas[1],
      att_avg = mean(post_betas),
      att_peak = post_betas[peak_idx],
      stringsAsFactors = FALSE
    )
  }
  add_row("TWFE", "full", twfe_results, twfe_data)
  add_row(cs_label, cs_vcov_type, cs_results, cs_data)

  if (length(rows) > 0) write.csv(do.call(rbind, rows), csv_file, row.names = FALSE)

  # ===== Generate Figure 5-style plot =====
  pdf_file <- file.path(out_dir, "honest_did_v3.pdf")
  tryCatch({
    # For CS, use the sigma that was used for HonestDiD
    cs_plot_data <- cs_data
    if (!is.null(cs_plot_data)) {
      cs_plot_data$sigma <- if (cs_vcov_type == "full_IF") cs_data$sigma_full else cs_data$sigma_diag
    }
    twfe_plot_data <- twfe_data

    p <- make_fig5_plot(twfe_plot_data, twfe_results, cs_plot_data, cs_results,
                        cs_label, meta$author_label, Mbar_plot)
    if (!is.null(p)) ggsave(pdf_file, plot = p, width = 8, height = 4.5)
  }, error = function(e) cat(sprintf("PLOT_ERR(%s) ", conditionMessage(e))))

  # ===== Append to summary =====
  summary_rows <- list()
  add_summary <- function(estimator, vcov_type, res, es_data) {
    if (is.null(res) || is.null(es_data)) return()
    numPre <- es_data$numPrePeriods; numPost <- es_data$numPostPeriods
    post_betas <- es_data$betahat[(numPre + 1):(numPre + numPost)]
    peak_idx <- which.max(abs(post_betas))
    summary_rows[[length(summary_rows) + 1]] <<- data.frame(
      id = id, author_label = meta$author_label,
      estimator = estimator, vcov_type = vcov_type,
      n_pre = numPre, n_post = numPost,
      rm_first_Mbar = res$rm_first_breakdown,
      rm_avg_Mbar = res$rm_avg_breakdown,
      rm_peak_Mbar = res$rm_peak_breakdown,
      att_first = post_betas[1],
      att_avg = mean(post_betas),
      att_peak = post_betas[peak_idx],
      stringsAsFactors = FALSE
    )
  }
  add_summary("TWFE", "full", twfe_results, twfe_data)
  add_summary(cs_label, cs_vcov_type, cs_results, cs_data)

  if (length(summary_rows) > 0) {
    new_rows <- do.call(rbind, summary_rows)
    if (file.exists(summary_file)) {
      existing <- tryCatch(read.csv(summary_file, stringsAsFactors = FALSE), error = function(e) NULL)
      if (!is.null(existing)) {
        existing <- existing[existing$id != id, ]
        new_rows <- rbind(existing, new_rows)
      }
    }
    write.csv(new_rows[order(new_rows$id, new_rows$estimator), ],
              summary_file, row.names = FALSE)
  }

  cat("SAVED\n"); flush.console()
  rm(df, df_es); gc(verbose = FALSE)
}

cat("\n=== DONE ===\n")
