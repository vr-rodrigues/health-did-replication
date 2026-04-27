###############################################################################
# 03_panel_event_study.R — 6-panel event study figure (Figure 4.4)
#
# Cases: Dranove (9), Carpenter-Lawler (79), Lawler-Yewell (76),
#        Cao & Ma (2303), Bosch-Campos-Vazquez (44), Brodeur-Yousaf (305).
#
# This script preserves verbatim the plotting logic from the author's
# original scripts/panel_es_5cases.R. Only the input/output paths are
# adapted to the current replication-package layout:
#   results/{id}/                -> results/by_article/{id}/
#   data/{id}/analysis_data.csv  -> data/raw/{id}/analysis_data.csv
#
# Output: output/figures/figure_4_4_panel_event_study_6cases.pdf
###############################################################################
suppressPackageStartupMessages({
  library(ggplot2); library(patchwork); library(grid); library(jsonlite)
  library(fixest); library(did); library(dplyr)
})

base_dir     <- getwd()
results_root <- file.path(base_dir, "results", "by_article")
out_dir      <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

cases <- list(
  list(id = 9,    label = "Dranove et al. (2021)"),
  list(id = 79,   label = "Carpenter, Lawler (2019)"),
  list(id = 76,   label = "Lawler, Yewell (2023)"),
  list(id = 2303, label = "Cao & Ma (2023)"),
  list(id = 44,   label = "Bosch, Campos-Vazquez (2014)"),
  list(id = 305,  label = "Brodeur, Yousaf (2020)")
)

est_colors <- c("TWFE" = "black", "CS-NT" = "forestgreen", "CS-NYT" = "darkorange")
est_shapes <- c("TWFE" = 3,       "CS-NT" = 4,             "CS-NYT" = 5)

# ── Load pre-computed event-study data ─────────────────────────────────
load_es_data <- function(id) {
  es_csv <- file.path(results_root, id, "event_study_data.csv")
  es <- read.csv(es_csv, stringsAsFactors = FALSE)
  if ("rel_year" %in% names(es)) names(es)[names(es) == "rel_year"] <- "time"
  if ("att"      %in% names(es)) names(es)[names(es) == "att"]      <- "coef"
  es$time <- as.numeric(es$time)
  es$coef <- as.numeric(es$coef)
  es$se   <- as.numeric(es$se)
  es <- es[, c("estimator", "time", "coef", "se")]

  # Optional supplement from honest_did_v3_data.rds when an estimator the
  # metadata expects is missing in the CSV (mirrors the original script).
  rds_file  <- file.path(results_root, id, "honest_did_v3_data.rds")
  meta_file <- file.path(results_root, id, "metadata.json")
  if (!file.exists(meta_file)) return(es)
  meta  <- fromJSON(meta_file)
  avail <- unique(es$estimator)

  if (!"CS-NYT" %in% avail && isTRUE(meta$analysis$run_csdid_nyt) && file.exists(rds_file)) {
    rds <- readRDS(rds_file)
    if ("cs_nyt_es" %in% names(rds)) {
      nyt <- rds$cs_nyt_es
      if (!is.null(nyt) && nrow(nyt) > 0) {
        if ("rel_year" %in% names(nyt)) names(nyt)[names(nyt) == "rel_year"] <- "time"
        if ("att"      %in% names(nyt)) names(nyt)[names(nyt) == "att"]      <- "coef"
        nyt$estimator <- "CS-NYT"
        nyt <- nyt[, c("estimator", "time", "coef", "se")]
        es <- rbind(es, nyt)
      }
    }
  }
  if (!"CS-NT" %in% avail && file.exists(rds_file)) {
    rds <- if (exists("rds")) rds else readRDS(rds_file)
    if ("cs_nt_es" %in% names(rds)) {
      nt <- rds$cs_nt_es
      if (!is.null(nt) && nrow(nt) > 0) {
        if ("rel_year" %in% names(nt)) names(nt)[names(nt) == "rel_year"] <- "time"
        if ("att"      %in% names(nt)) names(nt)[names(nt) == "att"]      <- "coef"
        nt$estimator <- "CS-NT"
        nt <- nt[, c("estimator", "time", "coef", "se")]
        es <- rbind(es, nt)
      }
    }
  }
  es
}

# ── Compute ID 44 from scratch (preserved verbatim from original script) ──
compute_id44 <- function() {
  cat("Computing ID 44 (Bosch & Campos-Vazquez)...\n")
  df <- read.csv(file.path(base_dir, "data", "raw", "44", "analysis_data.csv"))
  df$p3      <- log(df$pat_size_6_50)
  df         <- df %>% filter(is.finite(p3))
  df$mydate2 <- df$mydate^2
  df$mydate3 <- df$mydate^3
  x_t_vars   <- grep("^x_t_", names(df), value = TRUE)
  ctrl_str   <- paste(c("log_pop", x_t_vars), collapse = " + ")
  ev_pre     <- 12L; ev_post <- 16L
  df$rel_time   <- df$mydate - df$gvar_CS
  df$rel_time_b <- pmax(pmin(df$rel_time, ev_post), -ev_pre)

  # TWFE
  fml <- as.formula(paste0("p3 ~ i(rel_time_b, ref = -1) + ", ctrl_str,
    " | cvemun + mydate + ent[mydate] + ent[mydate2] + ent[mydate3]"))
  fit <- feols(fml, data = df, weights = ~pob2000, cluster = ~cvemun)
  cf  <- coef(fit); se_tw <- se(fit)
  idx <- grep("^rel_time_b::", names(cf))
  t_vals <- as.integer(sub("rel_time_b::", "", names(cf)[idx]))
  twfe <- rbind(
    data.frame(estimator = "TWFE", time = t_vals,
               coef = unname(cf[idx]), se = unname(se_tw[idx])),
    data.frame(estimator = "TWFE", time = -1L, coef = 0, se = 0)
  )
  cat("  TWFE OK\n")

  # CS-NYT
  cs <- tryCatch({
    att_gt(yname = "p3", tname = "mydate", idname = "cvemun", gname = "gvar_CS",
           weightsname = "pob2000", xformla = ~1, control_group = "notyettreated",
           panel = TRUE, allow_unbalanced_panel = FALSE, base_period = "universal",
           data = as.data.frame(df))
  }, error = function(e) { cat("  CS-NYT error:", e$message, "\n"); NULL })

  nyt <- if (!is.null(cs)) {
    agg <- aggte(cs, type = "dynamic")
    d   <- data.frame(estimator = "CS-NYT", time = agg$egt,
                      coef = agg$att.egt, se = agg$se.egt)
    d   <- d %>% filter(is.finite(se), se > 0,
                         time >= -ev_pre, time <= ev_post)
    if (!any(d$time == -1))
      d <- rbind(d, data.frame(estimator = "CS-NYT", time = -1L, coef = 0, se = 0))
    d
  } else NULL
  cat("  CS-NYT OK\n")

  rbind(twfe, nyt)
}

# ── Compute ID 2303 (Cao & Ma) — yearly event time ─────────────────────
# Replicates the logic of the canonical es_2303.R script that produced the
# appendix event study PDF (rel_year = year - year_month with year_month
# defined as the first treated year per (id, month) pair; FE structure
# id^month + prov^year^month; 7 weather controls). Gardner and SA are
# omitted for the in-text panel per the panel's estimator whitelist.
compute_id2303 <- function(ev_pre = 10L, ev_post = 11L) {
  cat("Computing ID 2303 (Cao & Ma, yearly)...\n")
  suppressPackageStartupMessages({
    library(haven); library(data.table)
  })

  data_dir <- file.path(base_dir, "data", "raw", "2303")
  dt <- as.data.table(read_dta(file.path(data_dir,
                     "biomass_plant_year_month_MCD12Q1.dta")))

  # Treatment indicator (Stata: gen tbp = ...)
  dt[, tyear := as.integer(substr(edate, 1, 4))]
  dt[, tmonth := as.integer(substr(edate, 6, 7))]
  dt[, tbp := as.integer((year > tyear & !is.na(tyear)) |
                          (year == tyear & month >= tmonth & !is.na(tmonth)))]
  dt[is.na(tbp), tbp := 0L]
  dt[, prov := as.integer(adcode %/% 10000)]

  # Merge weather controls
  weather <- as.data.table(read_dta(file.path(data_dir, "plant_weather.dta")))
  dt <- merge(dt, weather, by = c("id", "year", "month"), all.x = TRUE)

  # year_month = first treated year per (id, month) pair
  # (Stata: bys id month: egen year_month = min(s1))
  dt[, s1 := ifelse(tbp == 1L, year, NA_integer_)]
  dt[, year_month := as.integer(min(s1, na.rm = TRUE)), by = .(id, month)]
  dt[is.infinite(year_month) | is.nan(year_month), year_month := NA_integer_]

  # Yearly event time
  dt[, rel_year := year - year_month]
  dt[, rel_year_b := pmax(as.integer(-ev_pre), pmin(as.integer(ev_post), rel_year))]
  dt[, id_month := paste0(id, "_", month)]

  # ─── TWFE (paper's FE structure + 7 weather controls) ───────────────
  twfe_es <- tryCatch(
    feols(ft90 ~ i(rel_year_b, ref = -1) +
                 temperature + precipitation + windspeed + humidity +
                 winddirection1 + winddirection2 + winddirection3 |
                 id^month + prov^year^month,
          data = dt, cluster = ~id),
    error = function(e) { cat("  TWFE error:", conditionMessage(e), "\n"); NULL })

  twfe <- if (!is.null(twfe_es)) {
    cfs <- coef(twfe_es); ses <- se(twfe_es)
    idx <- grepl("^rel_year_b::", names(cfs))
    t_vals <- as.integer(sub("rel_year_b::", "", names(cfs)[idx]))
    d <- data.frame(estimator = "TWFE", time = t_vals,
                    coef = unname(cfs[idx]), se = unname(ses[idx]))
    rbind(d, data.frame(estimator = "TWFE", time = -1L, coef = 0, se = 0))
  } else NULL
  if (!is.null(twfe)) cat("  TWFE OK (", nrow(twfe), "periods)\n")

  # ─── CS-DID setup (yearly, unit = id_month combination) ─────────────
  dt[, id_month_num := as.integer(as.factor(id_month))]
  dt[, gvar_year := ifelse(!is.na(year_month), as.numeric(year_month), 0)]

  # CS-NT (never-treated controls)
  cs_nt <- tryCatch(
    att_gt(yname = "ft90", tname = "year", idname = "id_month_num",
           gname = "gvar_year", data = as.data.frame(dt),
           control_group = "nevertreated", base_period = "universal",
           est_method = "reg", print_details = FALSE),
    error = function(e) { cat("  CS-NT error:", conditionMessage(e), "\n"); NULL })

  nt <- if (!is.null(cs_nt)) {
    agg <- aggte(cs_nt, type = "dynamic", na.rm = TRUE)
    d <- data.frame(estimator = "CS-NT", time = agg$egt,
                    coef = agg$att.egt, se = agg$se.egt)
    d <- d[d$time >= -ev_pre & d$time <= ev_post & is.finite(d$se) & d$se > 0, ]
    if (!any(d$time == -1))
      d <- rbind(d, data.frame(estimator = "CS-NT", time = -1L, coef = 0, se = 0))
    d
  } else NULL
  if (!is.null(nt)) cat("  CS-NT OK\n")

  # CS-NYT (not-yet-treated controls)
  cs_nyt <- tryCatch(
    att_gt(yname = "ft90", tname = "year", idname = "id_month_num",
           gname = "gvar_year", data = as.data.frame(dt),
           control_group = "notyettreated", base_period = "universal",
           est_method = "reg", print_details = FALSE),
    error = function(e) { cat("  CS-NYT error:", conditionMessage(e), "\n"); NULL })

  nyt <- if (!is.null(cs_nyt)) {
    agg <- aggte(cs_nyt, type = "dynamic", na.rm = TRUE)
    d <- data.frame(estimator = "CS-NYT", time = agg$egt,
                    coef = agg$att.egt, se = agg$se.egt)
    d <- d[d$time >= -ev_pre & d$time <= ev_post & is.finite(d$se) & d$se > 0, ]
    if (!any(d$time == -1))
      d <- rbind(d, data.frame(estimator = "CS-NYT", time = -1L, coef = 0, se = 0))
    d
  } else NULL
  if (!is.null(nyt)) cat("  CS-NYT OK\n") else cat("  CS-NYT unavailable\n")

  rbind(twfe, nt, nyt)
}

# ── Per-panel plot (preserved verbatim from original script) ───────────
make_panel <- function(case_info) {
  id <- case_info$id

  if (id == 44) {
    es <- compute_id44()
  } else if (id == 2303) {
    es <- compute_id2303()
  } else {
    es <- tryCatch(load_es_data(id), error = function(e) {
      cat(sprintf("Error loading ID %d: %s\n", id, e$message)); NULL
    })
  }
  if (is.null(es)) return(ggplot() + theme_void())

  keep <- c("TWFE", "CS-NT", "CS-NYT")
  es <- es[es$estimator %in% keep, ]

  # Ensure each estimator has t = -1 reference at zero.
  for (est in unique(es$estimator)) {
    if (!any(es$estimator == est & es$time == -1)) {
      es <- rbind(es, data.frame(estimator = est, time = -1, coef = 0, se = 0))
    }
  }
  es$se[es$time == -1 & (is.na(es$se) | es$se == 0)] <- 0
  es$coef[es$time == -1] <- 0

  avail_ests <- unique(es$estimator)
  common_min <- max(tapply(es$time, es$estimator, min))
  common_max <- min(tapply(es$time, es$estimator, max))
  es <- es[es$time >= common_min & es$time <= common_max, ]

  cat(sprintf("ID %d: estimators = %s, time = [%d, %d]\n",
              id, paste(avail_ests, collapse = ", "), common_min, common_max))

  es$ci_lo <- es$coef - 1.96 * es$se
  es$ci_hi <- es$coef + 1.96 * es$se

  n_est   <- length(avail_ests)
  offsets <- seq(-0.15, 0.15, length.out = n_est)
  names(offsets) <- sort(avail_ests)
  es$time_d    <- es$time + offsets[es$estimator]
  es$estimator <- factor(es$estimator, levels = c("TWFE", "CS-NT", "CS-NYT"))

  ggplot(es, aes(x = time_d, y = coef, color = estimator, shape = estimator)) +
    geom_hline(yintercept = 0,    color = "grey70", linetype = "dashed", linewidth = 0.3) +
    geom_vline(xintercept = -0.5, color = "grey60", linetype = "dotted", linewidth = 0.3) +
    geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi),
                  width = 0.12, linewidth = 0.5, alpha = 0.6) +
    geom_point(size = 2.0, stroke = 1.0) +
    scale_color_manual(values = est_colors, breaks = c("TWFE", "CS-NT", "CS-NYT"),
                       drop = FALSE, name = "Estimator") +
    scale_shape_manual(values = est_shapes, breaks = c("TWFE", "CS-NT", "CS-NYT"),
                       drop = FALSE, name = "Estimator") +
    labs(title = case_info$label, x = "Relative Time to Treatment", y = "ATT") +
    theme_classic(base_size = 13) +
    theme(
      legend.position = "bottom",
      legend.text     = element_text(size = 11),
      legend.key.size = unit(0.45, "cm"),
      plot.title      = element_text(size = 13, face = "bold"),
      plot.margin     = margin(5, 8, 5, 5),
      axis.title      = element_text(size = 12),
      axis.text       = element_text(size = 10)
    )
}

# ── Assemble all six panels ────────────────────────────────────────────
plots <- lapply(cases, make_panel)

# Unified legend
legend_df <- data.frame(
  time_d = c(0, 0, 0), coef = c(0, 0, 0),
  ci_lo  = c(-1, -1, -1), ci_hi = c(1, 1, 1),
  estimator = factor(c("TWFE", "CS-NT", "CS-NYT"),
                     levels = c("TWFE", "CS-NT", "CS-NYT"))
)
legend_plot <- ggplot(legend_df, aes(x = time_d, y = coef,
                                      color = estimator, shape = estimator)) +
  geom_point(size = 3, stroke = 1.0) +
  scale_color_manual(values = est_colors, breaks = c("TWFE", "CS-NT", "CS-NYT"),
                     name = NULL) +
  scale_shape_manual(values = est_shapes, breaks = c("TWFE", "CS-NT", "CS-NYT"),
                     name = NULL) +
  theme_classic(base_size = 13) +
  theme(legend.position = "bottom",
        legend.text     = element_text(size = 12),
        legend.key.size = unit(0.5, "cm"))

get_legend <- function(p) {
  tmp <- ggplot_gtable(ggplot_build(p))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  if (length(leg) > 0) tmp$grobs[[leg]] else NULL
}
legend_grob <- get_legend(legend_plot)

plots_nl <- lapply(plots, function(p) p + theme(legend.position = "none"))

# Layout: 3 rows × 2 cols
design <- "
AB
CD
EF
"
panel_6 <- wrap_plots(
  A = plots_nl[[1]], B = plots_nl[[2]],
  C = plots_nl[[3]], D = plots_nl[[4]],
  E = plots_nl[[5]], F = plots_nl[[6]],
  design = design
)

combined <- wrap_plots(panel_6, legend_grob, ncol = 1, heights = c(1, 0.03))

out_pdf <- file.path(out_dir, "figure_4_4_panel_event_study_6cases.pdf")
ggsave(out_pdf, combined, width = 8, height = 10.5, device = "pdf")
cat("Saved:", out_pdf, "\n")
