###############################################################################
# 01_aggregate_scatter.R — Aggregate plots: TWFE vs CS-DID
# Produces: Figures 4.1, 4.3 (and group/simple variants)
#
# Output files:
#   output/figures/figure_4_1_aggregate_scatter_dynamic.pdf
#   output/figures/figure_4_3_variation_pct_dynamic.pdf
#   output/figures/agregado_group.pdf
#   output/figures/agregado_simple.pdf
#   output/figures/variacao_pct_group.pdf
#   output/figures/variacao_pct_simple.pdf
###############################################################################
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(jsonlite); library(ggrepel)
  library(grid); library(gridExtra)
})

# Portable path: run from replication package root
base_dir    <- getwd()
results_dir <- file.path(base_dir, "results", "by_article")
out_dir     <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# ============ LOAD ALL RESULTS ============
all_dirs <- list.dirs(results_dir, recursive = FALSE, full.names = TRUE)
ids <- basename(all_dirs)
ids <- ids[grepl("^[0-9]+$", ids)]
ids <- sort(as.integer(ids))
# Exclude duplicates + paper-auditor FAIL (2026-04-19: 234,242,380)
ids <- ids[!ids %in% c(357, 382, 438, 234, 242, 380)]

rows <- list()
for (id in ids) {
  dir <- file.path(results_dir, id)
  meta_file <- file.path(dir, "metadata.json")
  res_file  <- file.path(dir, "results.csv")
  if (!file.exists(meta_file) || !file.exists(res_file)) next

  meta <- tryCatch(fromJSON(meta_file), error = function(e) NULL)
  if (is.null(meta)) next
  res <- tryCatch(read.csv(res_file, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(res)) next

  gcol <- function(name) {
    if (name %in% names(res)) as.numeric(res[[name]][1]) else NA_real_
  }

  # Metadata: how many TWFE controls does the paper declare? Used for the
  # matched-protocol figure variant (Spec A): only papers with twfe_controls
  # non-empty require the CS-DID version that also uses those controls.
  n_twfe_controls <- if (!is.null(meta$variables$twfe_controls))
                      length(meta$variables$twfe_controls) else 0

  if ("estimator" %in% names(res)) {
    beta_twfe <- se_twfe <- NA
    twfe_row <- res[res$estimator == "TWFE", ]
    if (nrow(twfe_row) > 0) { beta_twfe <- as.numeric(twfe_row$att[1]); se_twfe <- as.numeric(twfe_row$se[1]) }
    csnt_row <- res[res$estimator == "CS-NT", ]
    csnyt_row <- res[res$estimator == "CS-NYT", ]
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label, group_label = meta$group_label,
      n_twfe_controls = n_twfe_controls,
      beta_twfe = beta_twfe, se_twfe = se_twfe,
      att_nt_group = if (nrow(csnt_row) > 0) as.numeric(csnt_row$att[1]) else NA,
      se_nt_group = if (nrow(csnt_row) > 0) as.numeric(csnt_row$se[1]) else NA,
      att_nyt_group = if (nrow(csnyt_row) > 0) as.numeric(csnyt_row$att[1]) else NA,
      se_nyt_group = if (nrow(csnyt_row) > 0) as.numeric(csnyt_row$se[1]) else NA,
      att_nt_simple = NA, se_nt_simple = NA, att_nyt_simple = NA, se_nyt_simple = NA,
      att_nt_dynamic = NA, se_nt_dynamic = NA, att_nyt_dynamic = NA, se_nyt_dynamic = NA,
      att_cs_nt_with_ctrls = NA, se_cs_nt_with_ctrls = NA,
      att_cs_nt_with_ctrls_dyn = NA, se_cs_nt_with_ctrls_dyn = NA,
      cs_nt_with_ctrls_status = NA_character_,
      beta_twfe_no_ctrls = NA, se_twfe_no_ctrls = NA,
      stringsAsFactors = FALSE)
  } else {
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label, group_label = meta$group_label,
      n_twfe_controls = n_twfe_controls,
      beta_twfe = gcol("beta_twfe"), se_twfe = gcol("se_twfe"),
      att_nt_group = gcol("att_csdid_nt"), se_nt_group = gcol("se_csdid_nt"),
      att_nyt_group = gcol("att_csdid_nyt"), se_nyt_group = gcol("se_csdid_nyt"),
      att_nt_simple = gcol("att_nt_simple"), se_nt_simple = gcol("se_nt_simple"),
      att_nyt_simple = gcol("att_nyt_simple"), se_nyt_simple = gcol("se_nyt_simple"),
      att_nt_dynamic = gcol("att_nt_dynamic"), se_nt_dynamic = gcol("se_nt_dynamic"),
      att_nyt_dynamic = gcol("att_nyt_dynamic"), se_nyt_dynamic = gcol("se_nyt_dynamic"),
      att_cs_nt_with_ctrls = gcol("att_cs_nt_with_ctrls"),
      se_cs_nt_with_ctrls  = gcol("se_cs_nt_with_ctrls"),
      att_cs_nt_with_ctrls_dyn = gcol("att_cs_nt_with_ctrls_dyn"),
      se_cs_nt_with_ctrls_dyn  = gcol("se_cs_nt_with_ctrls_dyn"),
      cs_nt_with_ctrls_status = if ("cs_nt_with_ctrls_status" %in% names(res))
                                  as.character(res$cs_nt_with_ctrls_status[1]) else NA_character_,
      beta_twfe_no_ctrls = gcol("beta_twfe_no_ctrls"),
      se_twfe_no_ctrls   = gcol("se_twfe_no_ctrls"),
      stringsAsFactors = FALSE)
  }
}

all_data <- bind_rows(rows)
cat(sprintf("Loaded %d articles\n\n", nrow(all_data)))

# ============ AESTHETICS ============
cat_colors <- c(
  "Concordant"="black", "Significance\nloss"="steelblue",
  "Significance\ngain"="forestgreen", "Sign\nreversal"="firebrick",
  "Sign reversal\n(insig)"="grey50", "Both\ninsignificant"="grey50")
cat_shapes <- c(
  "Concordant"=16, "Significance\nloss"=17,
  "Significance\ngain"=15, "Sign\nreversal"=4,
  "Sign reversal\n(insig)"=4, "Both\ninsignificant"=1)
cat_levels <- names(cat_colors)

# ============ BUILD + CLASSIFY ============
build_agg <- function(all_data, agg_type) {
  # agg_type "matched": matched-protocol Spec A vs TWFE-with-controls.
  #   - Papers with twfe_controls non-empty AND cs_nt_with_ctrls_status=="OK"
  #     use att_cs_nt_with_ctrls_dyn.
  #   - Papers with twfe_controls empty use att_nt_dynamic (no controls either side
  #     = same as Spec B = same as Spec C).
  #   - Papers where Spec A failed (status != OK OR att == 0 with SE NA)
  #     are EXCLUDED from the matched-protocol figure — the matched gap is
  #     not estimable in those cases.
  if (agg_type == "group") {
    nt_att <- "att_nt_group"; nt_se <- "se_nt_group"
    nyt_att <- "att_nyt_group"; nyt_se <- "se_nyt_group"
    fb_nt_att <- "att_nt_dynamic"; fb_nt_se <- "se_nt_dynamic"
    fb_nyt_att <- "att_nyt_dynamic"; fb_nyt_se <- "se_nyt_dynamic"
  } else if (agg_type == "simple") {
    nt_att <- "att_nt_simple"; nt_se <- "se_nt_simple"
    nyt_att <- "att_nyt_simple"; nyt_se <- "se_nyt_simple"
    fb_nt_att <- "att_nt_dynamic"; fb_nt_se <- "se_nt_dynamic"
    fb_nyt_att <- "att_nyt_dynamic"; fb_nyt_se <- "se_nyt_dynamic"
  } else if (agg_type == "matched") {
    # Matched Spec A: use CS-with-ctrls for papers that have them.
    df <- all_data %>%
      filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0)
    df$att_cs <- NA_real_; df$se_cs <- NA_real_; df$cs_source <- NA_character_
    for (i in seq_len(nrow(df))) {
      if (df$n_twfe_controls[i] == 0) {
        # Symmetric unconditional: both estimators see no controls.
        if (!is.na(df$att_nt_dynamic[i]) && !is.na(df$se_nt_dynamic[i]) && df$se_nt_dynamic[i] > 0) {
          df$att_cs[i]   <- df$att_nt_dynamic[i]
          df$se_cs[i]    <- df$se_nt_dynamic[i]
          df$cs_source[i] <- "NT-unconditional (matched)"
        } else if (!is.na(df$att_nyt_dynamic[i]) && !is.na(df$se_nyt_dynamic[i]) && df$se_nyt_dynamic[i] > 0) {
          df$att_cs[i]   <- df$att_nyt_dynamic[i]
          df$se_cs[i]    <- df$se_nyt_dynamic[i]
          df$cs_source[i] <- "NYT-unconditional (matched)"
        }
      } else {
        # Paper has twfe_controls: we need Spec A CS-DID-with-ctrls.
        status_ok <- !is.na(df$cs_nt_with_ctrls_status[i]) &&
                     df$cs_nt_with_ctrls_status[i] == "OK"
        nonzero   <- !is.na(df$att_cs_nt_with_ctrls_dyn[i]) &&
                     abs(df$att_cs_nt_with_ctrls_dyn[i]) > 1e-9 &&
                     !is.na(df$se_cs_nt_with_ctrls_dyn[i]) &&
                     df$se_cs_nt_with_ctrls_dyn[i] > 0
        if (status_ok && nonzero) {
          df$att_cs[i]   <- df$att_cs_nt_with_ctrls_dyn[i]
          df$se_cs[i]    <- df$se_cs_nt_with_ctrls_dyn[i]
          df$cs_source[i] <- "NT-with-ctrls (matched)"
        }
        # If Spec A failed (collapse to 0 / NA), leave att_cs NA → will be filtered out below.
      }
    }
    df <- df %>% filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0)
    # Short-circuit: skip the dplyr pipeline below, classify directly.
    crit <- 1.96
    df <- df %>% mutate(
      z_twfe = beta_twfe / se_twfe, z_cs = att_cs / se_twfe,
      ratio_att = att_cs / beta_twfe, ratio_se = se_cs / se_twfe,
      sig_twfe = abs(beta_twfe / se_twfe) > crit,
      sig_cs   = abs(att_cs / se_cs) > crit,
      same_sign = sign(beta_twfe) == sign(att_cs),
      category = factor(case_when(
        !same_sign & (sig_twfe | sig_cs) ~ "Sign\nreversal",
        !same_sign & !sig_twfe & !sig_cs ~ "Sign reversal\n(insig)",
        same_sign & sig_twfe & sig_cs    ~ "Concordant",
        same_sign & sig_twfe & !sig_cs   ~ "Significance\nloss",
        same_sign & !sig_twfe & sig_cs   ~ "Significance\ngain",
        same_sign & !sig_twfe & !sig_cs  ~ "Both\ninsignificant",
        TRUE ~ "Other"), levels = cat_levels),
      short_label = gsub(" et al\\.", "", author_label),
      short_label = gsub(" \\(\\d{4}[a-z]?\\)", "", short_label))
    return(df)
  } else if (agg_type == "dynamic") {
    # OFFICIAL COMPOSITE — simplified 2-level cascade.
    #   Spec A (matched): TWFE and CS-DID both see the same covariate structure.
    #     * Papers with no TWFE controls       -> beta_twfe + unconditional CS-DID.
    #     * Papers with TWFE controls, valid   -> beta_twfe + att_cs_nt_with_ctrls_dyn.
    #   Spec C (asymmetric fallback): TWFE w/ ctrls vs unconditional CS-DID.
    #     * Used when the paper has controls but Spec A is degenerate
    #       (doubly-robust CS-DID returns att=0 with se=NA, Pattern 42).
    # The TWFE side always uses the paper's original beta_twfe (with its own
    # controls). Fallback (C) papers are flagged is_fallback=TRUE and get a
    # dagger in the plot. NT is the preferred CS estimator; NYT is a fallback
    # only for papers where NT never estimated (e.g. IDs 44, 210).
    df <- all_data %>%
      filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0)
    df$att_cs <- NA_real_; df$se_cs <- NA_real_
    df$cs_source <- NA_character_
    df$is_fallback <- FALSE
    df$spec <- NA_character_

    pick_cs_unc <- function(i) {
      # Prefer dynamic, fall back to group (static) when dynamic is NA.
      if (!is.na(df$att_nt_dynamic[i]) && !is.na(df$se_nt_dynamic[i]) &&
          df$se_nt_dynamic[i] > 0)
        return(list(att = df$att_nt_dynamic[i], se = df$se_nt_dynamic[i],
                    lab = "NT-unconditional"))
      if (!is.na(df$att_nyt_dynamic[i]) && !is.na(df$se_nyt_dynamic[i]) &&
          df$se_nyt_dynamic[i] > 0)
        return(list(att = df$att_nyt_dynamic[i], se = df$se_nyt_dynamic[i],
                    lab = "NYT-unconditional"))
      if (!is.na(df$att_nt_group[i]) && !is.na(df$se_nt_group[i]) &&
          df$se_nt_group[i] > 0)
        return(list(att = df$att_nt_group[i], se = df$se_nt_group[i],
                    lab = "NT-unconditional (static)"))
      if (!is.na(df$att_nyt_group[i]) && !is.na(df$se_nyt_group[i]) &&
          df$se_nyt_group[i] > 0)
        return(list(att = df$att_nyt_group[i], se = df$se_nyt_group[i],
                    lab = "NYT-unconditional (static)"))
      NULL
    }

    for (i in seq_len(nrow(df))) {
      if (df$n_twfe_controls[i] == 0) {
        # Paper has no TWFE controls -> Spec A trivially matched (both unconditional)
        cs <- pick_cs_unc(i)
        if (!is.null(cs)) {
          df$att_cs[i]    <- cs$att
          df$se_cs[i]     <- cs$se
          df$cs_source[i] <- paste0(cs$lab, " (no controls either side)")
          df$spec[i]      <- "A_no_ctrls"
        }
      } else {
        # Paper has TWFE controls -> try Spec A matched (CS w/ same controls)
        specA_ok <- !is.na(df$att_cs_nt_with_ctrls_dyn[i]) &&
                    abs(df$att_cs_nt_with_ctrls_dyn[i]) > 1e-9 &&
                    !is.na(df$se_cs_nt_with_ctrls_dyn[i]) &&
                    df$se_cs_nt_with_ctrls_dyn[i] > 0
        if (specA_ok) {
          df$att_cs[i]    <- df$att_cs_nt_with_ctrls_dyn[i]
          df$se_cs[i]     <- df$se_cs_nt_with_ctrls_dyn[i]
          df$cs_source[i] <- "NT-with-ctrls (Spec A matched)"
          df$spec[i]      <- "A_w_ctrls"
        } else {
          # Spec C fallback: TWFE w/ ctrls vs CS-DID unconditional (asymmetric)
          cs <- pick_cs_unc(i)
          if (!is.null(cs)) {
            df$att_cs[i]      <- cs$att
            df$se_cs[i]       <- cs$se
            df$cs_source[i]   <- paste0(cs$lab, " (Spec C fallback)")
            df$is_fallback[i] <- TRUE
            df$spec[i]        <- "C"
          }
        }
      }
    }
    df <- df %>% filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0)
    crit <- 1.96
    df <- df %>% mutate(
      z_twfe = beta_twfe / se_twfe, z_cs = att_cs / se_twfe,
      ratio_att = att_cs / beta_twfe, ratio_se = se_cs / se_twfe,
      sig_twfe = abs(beta_twfe / se_twfe) > crit,
      sig_cs   = abs(att_cs / se_cs) > crit,
      same_sign = sign(beta_twfe) == sign(att_cs),
      category = factor(case_when(
        !same_sign & (sig_twfe | sig_cs) ~ "Sign\nreversal",
        !same_sign & !sig_twfe & !sig_cs ~ "Sign reversal\n(insig)",
        same_sign & sig_twfe & sig_cs    ~ "Concordant",
        same_sign & sig_twfe & !sig_cs   ~ "Significance\nloss",
        same_sign & !sig_twfe & sig_cs   ~ "Significance\ngain",
        same_sign & !sig_twfe & !sig_cs  ~ "Both\ninsignificant",
        TRUE ~ "Other"), levels = cat_levels),
      short_label = gsub(" et al\\.", "", author_label),
      short_label = gsub(" \\(\\d{4}[a-z]?\\)", "", short_label))
    cat(sprintf("  Composite: %d Spec A (w/ ctrls) + %d Spec A (no ctrls, trivial) + %d Spec C (asymmetric fallback) = %d total\n",
                sum(df$spec == "A_w_ctrls"),
                sum(df$spec == "A_no_ctrls"),
                sum(df$spec == "C"),
                nrow(df)))
    return(df)
  } else {
    nt_att <- "att_nt_dynamic"; nt_se <- "se_nt_dynamic"
    nyt_att <- "att_nyt_dynamic"; nyt_se <- "se_nyt_dynamic"
    fb_nt_att <- "att_nt_group"; fb_nt_se <- "se_nt_group"
    fb_nyt_att <- "att_nyt_group"; fb_nyt_se <- "se_nyt_group"
  }

  df <- all_data %>%
    filter(!is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0) %>%
    mutate(
      att_cs = .data[[nt_att]], se_cs = .data[[nt_se]], cs_source = "NT",
      att_cs = ifelse(is.na(att_cs), .data[[nyt_att]], att_cs),
      se_cs  = ifelse(is.na(se_cs), .data[[nyt_se]], se_cs),
      cs_source = ifelse(is.na(.data[[nt_att]]) & !is.na(.data[[nyt_att]]), "NYT", cs_source),
      att_cs = ifelse(is.na(att_cs), .data[[fb_nt_att]], att_cs),
      se_cs  = ifelse(is.na(se_cs), .data[[fb_nt_se]], se_cs),
      att_cs = ifelse(is.na(att_cs), .data[[fb_nyt_att]], att_cs),
      se_cs  = ifelse(is.na(se_cs), .data[[fb_nyt_se]], se_cs),
      is_fallback = FALSE
    ) %>%
    filter(!is.na(att_cs) & !is.na(se_cs) & se_cs > 0)

  crit <- 1.96
  df %>% mutate(
    z_twfe = beta_twfe / se_twfe, z_cs = att_cs / se_twfe,
    ratio_att = att_cs / beta_twfe, ratio_se = se_cs / se_twfe,
    sig_twfe = abs(beta_twfe / se_twfe) > crit,
    sig_cs   = abs(att_cs / se_cs) > crit,
    same_sign = sign(beta_twfe) == sign(att_cs),
    category = factor(case_when(
      !same_sign & (sig_twfe | sig_cs) ~ "Sign\nreversal",
      !same_sign & !sig_twfe & !sig_cs ~ "Sign reversal\n(insig)",
      same_sign & sig_twfe & sig_cs    ~ "Concordant",
      same_sign & sig_twfe & !sig_cs   ~ "Significance\nloss",
      same_sign & !sig_twfe & sig_cs   ~ "Significance\ngain",
      same_sign & !sig_twfe & !sig_cs  ~ "Both\ninsignificant",
      TRUE ~ "Other"), levels = cat_levels),
    short_label = gsub(" et al\\.", "", author_label),
    short_label = gsub(" \\(\\d{4}[a-z]?\\)", "", short_label))
}

# ============ INSET HISTOGRAM ============
make_hist_grob <- function(vals, title_text, xlab_text, xlim_range = NULL) {
  vals <- vals[is.finite(vals)]; if (length(vals) < 3) return(nullGrob())
  mn <- round(mean(vals), 2); md <- round(median(vals), 2)
  p <- ggplot(data.frame(x = vals), aes(x = x)) +
    geom_histogram(fill = "grey70", color = "grey40", bins = 15, linewidth = 0.2) +
    geom_vline(xintercept = 1, color = "black", linetype = "dashed", linewidth = 0.3) +
    annotate("text", x = Inf, y = Inf, hjust = 1.1, vjust = 1.3,
             label = sprintf("Mean = %.2f\nMedian = %.2f", mn, md), size = 2.8) +
    labs(title = title_text, x = xlab_text, y = NULL) +
    theme_classic(base_size = 8.5) +
    theme(plot.title = element_text(size = 8.5, face = "bold"),
          axis.text.y = element_blank(), axis.ticks.y = element_blank(),
          plot.background = element_rect(fill = "white", color = "grey60", linewidth = 0.3),
          plot.margin = margin(3, 4, 2, 4))
  if (!is.null(xlim_range)) p <- p + coord_cartesian(xlim = xlim_range)
  ggplotGrob(p)
}

# ============ SCATTER ============
make_scatter <- function(df, agg_label, show_insets = TRUE) {
  max_abs <- max(abs(c(df$z_twfe, df$z_cs)), na.rm = TRUE); lim <- ceiling(max_abs * 1.1)
  p <- ggplot(df, aes(x = z_twfe, y = z_cs, color = category, shape = category)) +
    geom_hline(yintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.3) +
    geom_vline(xintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.3) +
    geom_abline(slope = 1, intercept = 0, color = "grey60", linetype = "dashed", linewidth = 0.4) +
    geom_point(size = 2.8) +
    scale_color_manual(values = cat_colors, drop = TRUE, name = NULL) +
    scale_shape_manual(values = cat_shapes, drop = TRUE, name = NULL) +
    scale_x_continuous(limits = c(-lim, lim), breaks = seq(-20, 20, by = 5)) +
    scale_y_continuous(limits = c(-lim, lim), breaks = seq(-20, 20, by = 5)) +
    labs(x = "TWFE z-score", y = "CS-DID / TWFE SE",
         title = sprintf("TWFE vs. CS-DID aggte(%s) — %d articles", agg_label, nrow(df))) +
    theme_classic(base_size = 14) +
    theme(legend.position = "bottom", legend.text = element_text(size = 10, lineheight = 0.9),
          plot.title = element_text(size = 14, face = "bold")) +
    guides(color = guide_legend(nrow = 1, override.aes = list(size = 3))) +
    coord_fixed(ratio = 1)
  if (!show_insets) return(p)
  valid_att <- df$ratio_att[df$same_sign & is.finite(df$ratio_att) & abs(df$ratio_att) < 5]
  valid_se  <- df$ratio_se[is.finite(df$ratio_se) & df$ratio_se > 0 & df$ratio_se < 5]
  h1 <- make_hist_grob(valid_att, "Ratio of Point Estimates:\nCS / TWFE", "CS / TWFE", c(-0.5, 3.5))
  h2 <- make_hist_grob(valid_se, "Ratio of SE Estimates:\nCS / TWFE", "SE(CS) / SE(TWFE)", c(0, 4))
  p + annotation_custom(h1, xmin=-lim, xmax=-lim*0.25, ymin=lim*0.4, ymax=lim*0.98) +
      annotation_custom(h2, xmin=lim*0.25, xmax=lim, ymin=-lim*0.98, ymax=-lim*0.4)
}

# ============ DOT CHART ============
make_dot <- function(df, agg_label) {
  # If there are fallback papers (Spec C asymmetric because Spec A failed),
  # prefix their author label with a dagger and append an explanatory note.
  has_fb_col <- "is_fallback" %in% names(df)
  any_fb <- has_fb_col && any(df$is_fallback, na.rm = TRUE)
  df2 <- df %>% mutate(
    plot_label = if (has_fb_col)
                   ifelse(is_fallback,
                          paste0("\u2020 ", author_label),
                          author_label)
                 else author_label,
    delta_pct = (att_cs - beta_twfe) / abs(beta_twfe) * 100,
    delta_pct_cap = pmin(pmax(delta_pct, -300), 300),
    label_pct = paste0(sprintf("%+.1f", delta_pct), "%"),
    # For values that exceed the axis cap, flip the label direction so it
    # reads INSIDE the bar (toward zero) instead of outside the capped tip
    # (which would overlap the author-name column on the left).
    is_capped = abs(delta_pct) > 300,
    label_hjust = dplyr::case_when(
      is_capped & delta_pct_cap < 0 ~ -0.15,   # capped negative: label on the right of point
      is_capped & delta_pct_cap > 0 ~  1.15,   # capped positive: label on the left of point
      delta_pct_cap >= 0            ~ -0.15,   # uncapped positive: label right
      TRUE                          ~  1.15),  # uncapped negative: label left
    plot_label = reorder(plot_label, delta_pct))
  # Relabel "Both insignificant" to avoid truncation on narrow legends,
  # and replace the newline in category labels (\n) with a space for the legend.
  cat_labels_display <- setNames(gsub("\n", " ", names(cat_colors)), names(cat_colors))
  p <- ggplot(df2, aes(x = delta_pct_cap, y = plot_label)) +
    geom_vline(xintercept = 0, color = "gray70", linetype = "dashed", linewidth = 0.4) +
    geom_segment(aes(x = 0, xend = delta_pct_cap, yend = plot_label, color = category), linewidth = 0.6) +
    geom_point(aes(color = category, shape = category), size = 3.2) +
    geom_label(aes(label = label_pct, hjust = label_hjust),
               size = 3.8, label.size = NA, label.padding = unit(0.10, "lines"),
               fill = "white", alpha = 0.92) +
    scale_color_manual(values = cat_colors, labels = cat_labels_display,
                       drop = TRUE, name = NULL) +
    scale_shape_manual(values = cat_shapes, labels = cat_labels_display,
                       drop = TRUE, name = NULL) +
    scale_x_continuous(breaks = seq(-300, 300, 50),
                       labels = paste0(seq(-300, 300, 50), "%"),
                       expand = expansion(mult = c(0.02, 0.02))) +
    coord_cartesian(xlim = c(-325, 325), clip = "off") +
    labs(x = expression(Delta * "% = (CS-DID - TWFE) / |TWFE|"), y = NULL,
         title = sprintf("Variation: CS-DID aggte(%s) vs. TWFE - %d articles", agg_label, nrow(df))) +
    theme_classic(base_size = 14) +
    theme(legend.position = "bottom",
          legend.text = element_text(size = 11),
          legend.key.size = unit(0.55, "cm"),
          legend.spacing.x = unit(0.3, "cm"),
          plot.title = element_text(size = 16, face = "bold"),
          plot.margin = margin(t = 6, r = 30, b = 6, l = 8),
          axis.text.y = element_text(size = 11),
          axis.text.x = element_text(size = 12),
          axis.title.x = element_text(size = 13, margin = margin(t = 8))) +
    guides(color = guide_legend(nrow = 1, byrow = TRUE, override.aes = list(size = 3)))
  if (any_fb) {
    note_txt <- "\u2020 TWFE with controls vs CS-DID without controls."
    p <- p + labs(caption = note_txt) +
      theme(plot.caption = element_text(size = 11, hjust = 0, face = "italic",
                                        margin = margin(t = 8)))
  }
  p
}

# ============ GENERATE ============
out_names <- list(
  group   = list(scatter = "agregado_group.pdf",
                 dot     = "variacao_pct_group.pdf"),
  simple  = list(scatter = "agregado_simple.pdf",
                 dot     = "variacao_pct_simple.pdf"),
  dynamic = list(scatter = "figure_4_1_aggregate_scatter_dynamic.pdf",
                 dot     = "figure_4_3_variation_pct_dynamic.pdf"),
  matched = list(scatter = "figure_4_1_aggregate_scatter_matched.pdf",
                 dot     = NULL)   # variacao_pct_matched not used in dissertation
)

for (agg in c("group", "simple", "dynamic", "matched")) {
  cat(sprintf("\n=== aggte(%s) ===\n", agg))
  df <- build_agg(all_data, agg)
  if (nrow(df) == 0) { cat("  No data\n"); next }
  cat(sprintf("  N articles: %d\n", nrow(df)))
  print(table(df$category))
  # Dynamic composite scatter omits the two ratio-histogram insets so the
  # reader focuses on the per-article classification; the fallback message
  # lives in the figure caption instead.
  insets <- agg != "dynamic"
  ggsave(file.path(out_dir, out_names[[agg]]$scatter),
         make_scatter(df, agg, show_insets = insets), width=9, height=9)
  if (!is.null(out_names[[agg]]$dot))
    ggsave(file.path(out_dir, out_names[[agg]]$dot), make_dot(df, agg), width=12, height=14)
  cat(sprintf("  Saved: %s%s\n",
              out_names[[agg]]$scatter,
              if (!is.null(out_names[[agg]]$dot)) paste0(", ", out_names[[agg]]$dot) else ""))
}

cat("\nDone: 01_aggregate_scatter.R\n")
