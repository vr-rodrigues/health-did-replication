# ===========================================================================
# goodman_bacon_all.R — Goodman-Bacon Decomposition for ALL articles
# Metadata-driven approach. 3-category plot style (reference image).
# Run from the replication package root (working directory = package root)
# ===========================================================================
suppressPackageStartupMessages({
  library(haven); library(dplyr); library(bacondecomp)
  library(ggplot2); library(jsonlite)
})

# WARNING: Requires original data from each article's replication package.
# Run from replication package root.
base_dir  <- getwd()
meta_root <- file.path(base_dir, "results", "by_article")
out_root  <- file.path(base_dir, "results", "by_article")
ensure_out_dir <- function(id) {
  d <- file.path(out_root, id)
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
  d
}

cat("========== Goodman-Bacon Decomposition — All Articles ==========\n\n")

# ── Plot helper: 3-category style (reference image) ──────────────────────
bacon_plot <- function(b, author_label, out_file) {
  dd_avg <- sum(b$estimate * b$weight)

  # Remap 4 bacondecomp types → 3 categories
  b$group <- dplyr::case_when(
    b$type %in% c("Earlier vs Later Treated", "Later vs Earlier Treated") ~ "Timing groups",
    b$type == "Later vs Always Treated"  ~ "Always treated vs timing",
    b$type == "Treated vs Untreated"     ~ "Never treated vs timing",
    TRUE ~ b$type
  )
  b$group <- factor(b$group, levels = c("Never treated vs timing",
                                         "Timing groups",
                                         "Always treated vs timing"))

  shapes <- c("Timing groups" = 1, "Always treated vs timing" = 17,
              "Never treated vs timing" = 4)
  colors <- c("Timing groups" = "black", "Always treated vs timing" = "grey50",
              "Never treated vs timing" = "black")
  fills  <- c("Timing groups" = NA, "Always treated vs timing" = "grey50",
              "Never treated vs timing" = NA)

  p <- ggplot(b, aes(x = weight, y = estimate, shape = group, color = group, fill = group)) +
    geom_hline(yintercept = dd_avg, linetype = "dashed", linewidth = 0.8, color = "black") +
    geom_hline(yintercept = 0, linetype = "solid", linewidth = 0.2, color = "grey80") +
    geom_point(size = 2.5, stroke = 0.8) +
    scale_shape_manual(values = shapes, drop = FALSE) +
    scale_color_manual(values = colors, drop = FALSE) +
    scale_fill_manual(values = fills, drop = FALSE) +
    labs(x = "Weight", y = "2x2 DD Estimate", title = author_label) +
    theme_classic(base_size = 11) +
    theme(legend.position = "bottom", legend.title = element_blank()) +
    guides(shape = guide_legend(override.aes = list(size = 3)))

  ggsave(out_file, p, width = 7, height = 4.5)
  cat("  Saved:", basename(out_file), "\n")
}

# ── Helper: aggregate RCS/individual to panel ─────────────────────────────
agg_panel <- function(df, unit, time_var, y, treat, w = NULL) {
  df$..u <- as.integer(df[[unit]])
  df$..t <- as.integer(df[[time_var]])
  df$..y <- as.numeric(df[[y]])
  df$..d <- as.numeric(df[[treat]])

  if (!is.null(w) && w %in% names(df)) {
    df$..w <- as.numeric(df[[w]])
    panel <- df %>%
      filter(!is.na(..y) & !is.na(..d) & !is.na(..w) & ..w > 0) %>%
      group_by(..u, ..t) %>%
      summarise(y = weighted.mean(..y, ..w, na.rm = TRUE),
                d = round(weighted.mean(..d, ..w, na.rm = TRUE)),
                .groups = "drop")
  } else {
    panel <- df %>%
      filter(!is.na(..y) & !is.na(..d)) %>%
      group_by(..u, ..t) %>%
      summarise(y = mean(..y, na.rm = TRUE),
                d = round(mean(..d, na.rm = TRUE)),
                .groups = "drop")
  }
  panel$d <- as.integer(panel$d)
  as.data.frame(panel)
}

# ── Helper: balance panel ─────────────────────────────────────────────────
balance_panel <- function(panel) {
  n_t <- n_distinct(panel$..t)
  panel %>%
    group_by(..u) %>%
    filter(n() == n_t) %>%
    ungroup() %>%
    as.data.frame()
}

# ── Generic metadata-driven runner ────────────────────────────────────────
run_bacon_meta <- function(result_id) {
  meta_file <- file.path(meta_root, result_id, "metadata.json")
  if (!file.exists(meta_file)) {
    cat("  [SKIP] metadata.json not found\n")
    return(invisible(NULL))
  }
  meta <- fromJSON(meta_file)

  author <- meta$author_label
  cat(sprintf("[ID %s] %s\n", result_id, author))

  # ── Load data ──────────────────────────────────────────────────────────
  data_file <- meta$data$file
  fmt <- meta$data$format
  if (!file.exists(data_file)) {
    cat("  [SKIP] Data file not found:", data_file, "\n")
    return(invisible(NULL))
  }
  if (fmt == "dta") {
    df <- haven::read_dta(data_file)
  } else if (fmt == "csv") {
    df <- read.csv(data_file, stringsAsFactors = FALSE)
  } else {
    cat("  [SKIP] Unknown format:", fmt, "\n")
    return(invisible(NULL))
  }
  df <- as.data.frame(df)

  # ── Apply sample_filter ────────────────────────────────────────────────
  sf <- meta$data$sample_filter
  if (!is.null(sf) && nchar(trimws(sf)) > 0) {
    tryCatch({
      df <- df[eval(parse(text = sf), envir = df), ]
      df <- df[!is.na(df[[1]]), ]  # drop NAs from filter
    }, error = function(e) cat("  Warning: sample_filter error:", conditionMessage(e), "\n"))
  }

  # ── Run construct_vars ─────────────────────────────────────────────────
  cvars <- meta$preprocessing$construct_vars
  if (!is.null(cvars) && length(cvars) > 0) {
    for (cv in cvars) {
      tryCatch(eval(parse(text = cv), envir = environment()),
               error = function(e) cat("  Warning construct_var:", conditionMessage(e), "\n"))
    }
  }

  # ── Apply time_recode (non-sequential years → sequential integers) ───
  tr <- meta$preprocessing$time_recode
  if (!is.null(tr) && length(tr) > 0) {
    time_var_name <- meta$variables$time
    old_vals <- as.numeric(names(tr))
    new_vals <- as.numeric(unlist(tr))
    df[[time_var_name]] <- new_vals[match(df[[time_var_name]], old_vals)]
    df <- df[!is.na(df[[time_var_name]]), ]
    cat("  Applied time_recode:", paste(old_vals, "->", new_vals, collapse = ", "), "\n")
  }

  # ── Extract key variables ──────────────────────────────────────────────
  unit_id  <- meta$variables$unit_id
  time_var <- meta$variables$time
  outcome  <- meta$variables$outcome
  treat    <- meta$variables$treatment_twfe
  # Defensive weight parsing: JSON {} → list() not NULL (Pattern 44)
  .w <- meta$variables$weight
  wt <- if (is.null(.w) || (is.list(.w) && length(.w) == 0) ||
            !is.character(.w) || length(.w) == 0 ||
            identical(as.character(.w), "null") ||
            identical(as.character(.w), ""))
         NULL else as.character(.w)[1]

  # ── Check variables exist ──────────────────────────────────────────────
  needed <- c(unit_id, time_var, outcome, treat)
  missing <- setdiff(needed, names(df))
  if (length(missing) > 0) {
    cat("  [SKIP] Missing variables:", paste(missing, collapse = ", "), "\n")
    return(invisible(NULL))
  }

  # ── Build panel ────────────────────────────────────────────────────────
  ds <- meta$panel_setup$data_structure
  if (ds == "repeated_cross_section") {
    cat("  RCS → aggregating to panel...\n")
    panel <- agg_panel(df, unit_id, time_var, outcome, treat, wt)
  } else {
    # Panel data — create standard columns
    panel <- data.frame(
      ..u = as.integer(df[[unit_id]]),
      ..t = as.integer(df[[time_var]]),
      y   = as.numeric(df[[outcome]]),
      d   = as.integer(df[[treat]])
    )
    panel <- panel[!is.na(panel$y) & !is.na(panel$d), ]
  }

  # ── Balance ────────────────────────────────────────────────────────────
  panel <- balance_panel(panel)

  if (nrow(panel) == 0) {
    cat("  [SKIP] Empty panel after balancing\n")
    return(invisible(NULL))
  }

  n_units <- n_distinct(panel$..u)
  n_times <- n_distinct(panel$..t)
  n_treat <- sum(panel$d == 1)
  cat(sprintf("  Panel: %d units x %d periods, treated obs: %d (%.1f%%)\n",
              n_units, n_times, n_treat, 100 * mean(panel$d == 1)))

  if (n_times < 3) {
    cat("  [SKIP] Bacon requires >= 3 periods\n")
    return(invisible(NULL))
  }
  if (n_treat == 0 || n_treat == nrow(panel)) {
    cat("  [SKIP] No variation in treatment\n")
    return(invisible(NULL))
  }
  # Skip very large staggered panels (Bacon is O(cohorts^2 * T^2))
  if (nrow(panel) > 50000) {
    cat("  [SKIP] Panel too large for Bacon (", nrow(panel), "obs). Consider subsampling.\n")
    return(invisible(NULL))
  }

  # ── Run Bacon ──────────────────────────────────────────────────────────
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    dd_avg <- sum(b$estimate * b$weight)
    cat(sprintf("  Bacon DD avg: %.5f\n", dd_avg))

    grp <- b %>% group_by(type) %>%
      summarise(n = n(), avg_est = round(mean(estimate), 5),
                sum_wt = round(sum(weight), 4), .groups = "drop")
    print(grp)

    out_dir <- ensure_out_dir(result_id)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, author, file.path(out_dir, "bacon_decomposition.pdf"))

  }, error = function(e) cat("  Bacon error:", conditionMessage(e), "\n"))

  cat("\n")
  invisible(NULL)
}

# ═══════════════════════════════════════════════════════════════════════════
# SPECIAL CASES — articles needing custom pre-processing beyond metadata
# ═══════════════════════════════════════════════════════════════════════════

# ── ID 9: Dranove — Post_avg from L0-L9 columns ─────────────────────────
run_bacon_9 <- function() {
  cat("[ID 9] Dranove et al. (2021)\n")
  df <- read_dta("data/raw/9/2020.01.27/Analysis_simplified/Input/state x quarter - Final.dta")
  df <- df %>% filter(sample1 == 1)
  if ("LX" %in% names(df)) df$L9 <- df$LX
  l_cols <- intersect(paste0("L", 0:9), names(df))
  df$Post_avg <- as.integer(rowSums(df[, l_cols, drop = FALSE], na.rm = TRUE) > 0)

  panel <- data.frame(
    ..u = as.integer(df$state_r), ..t = as.integer(df$yq),
    y = as.numeric(df$lnpriceperpresc), d = as.integer(df$Post_avg)
  ) %>% filter(!is.na(y))
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(9)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Dranove et al. (2021)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}

# ── ID 21: Buchmueller — complex event-time construction ─────────────────
run_bacon_21 <- function() {
  cat("[ID 21] Buchmueller, Carey (2018)\n")
  df <- read_dta("data/raw/21/id_36.dta")
  df$GT4pres[!is.na(df$GT4pres) & df$GT4pres == 99999] <- NA
  df$insample <- as.integer(as.character(haven::as_factor(df$sample)) == "all")
  state_ch <- tryCatch(as.character(haven::as_factor(df$state)),
                       error = function(e) as.character(df$state))
  df$eventhalfyear <- as.numeric(df$halfyear) - 105L
  df$eventhalfyear[state_ch %in% c("New York","Tennessee")] <-
    df$eventhalfyear[state_ch %in% c("New York","Tennessee")] - 2
  df$eventhalfyear[state_ch == "Delaware"]  <- df$eventhalfyear[state_ch == "Delaware"]  + 1
  df$eventhalfyear[state_ch == "Ohio"]      <- df$eventhalfyear[state_ch == "Ohio"]      + 1
  df$eventhalfyear[state_ch == "Oklahoma"]  <- df$eventhalfyear[state_ch == "Oklahoma"]  + 3
  df$eventhalfyear[state_ch == "Nevada"]    <- df$eventhalfyear[state_ch == "Nevada"]    + 10
  df$eventhalfyear[state_ch == "Louisiana"] <- df$eventhalfyear[state_ch == "Louisiana"] + 9
  df <- as.data.frame(group_by(df, ssastate) |>
          mutate(evermustaccess = max(mustaccess, na.rm = TRUE)))
  df$Post_avg <- as.integer(!is.na(df$eventhalfyear) & df$eventhalfyear >= 0 & df$evermustaccess == 1)
  df <- df[df$insample == 1 & !is.na(df$GT4pres), ]

  panel <- data.frame(
    ..u = as.integer(df$ssastate), ..t = as.integer(df$halfyear),
    y = as.numeric(df$GT4pres), d = as.integer(df$Post_avg)
  ) %>% filter(!is.na(y))
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(21)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Buchmueller, Carey (2018)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}

# ── ID 47: Clemens — time recode + RCS ───────────────────────────────────
run_bacon_47 <- function() {
  cat("[ID 47] Clemens (2015)\n")
  df <- read_dta("data/raw/47/replication/AEJApp2013-0169AnalysisData.dta")
  df <- df %>% filter(
    workersB != 0, childpresent != 0, parentfirmsize != 0,
    !actyear %in% c(1993, 1994, 1995), actyear < 1998,
    parentsmallfirm == 1, !state_fips %in% c(25, 34, 21, 33)
  )
  df$t <- dplyr::case_when(
    df$actyear == 1987 ~ 1L, df$actyear == 1988 ~ 2L, df$actyear == 1989 ~ 3L,
    df$actyear == 1990 ~ 4L, df$actyear == 1991 ~ 5L, df$actyear == 1992 ~ 6L,
    df$actyear == 1996 ~ 7L, df$actyear == 1997 ~ 8L, TRUE ~ NA_integer_)
  df$post1 <- as.integer(df$actyear >= 1993 & df$actyear <= 1997)
  df$Post_avg <- as.numeric(df$communityratingstate2) * df$post1

  panel <- agg_panel(df, "state_fips", "t", "priv_ins_cov_supp", "Post_avg", "perwt")
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(47)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Clemens (2015)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}

# ── ID 76: Lawler — Stata month bug + RCS ────────────────────────────────
run_bacon_76 <- function() {
  cat("[ID 76] Lawler, Yewell (2023)\n")
  df <- read_dta("data/raw/76/id_342.dta") %>% filter(mobil == 2)
  BASE_DATE <- as.Date("1960-01-01")
  df <- df %>% mutate(
    start_month = as.integer(format(BASE_DATE + as.integer(start_ym), "%m")),
    post6       = as.integer(start_year <= byear),
    post6       = ifelse(start_year == byear & start_month > 6, 0L, post6),
    Post_avg    = post6 * baby_babyfr
  )
  panel <- agg_panel(df, "fips", "byear", "bf_ever", "Post_avg", "rddwt")
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(76)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Lawler, Yewell (2023)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}

# ── ID 79: Carpenter — RCS ───────────────────────────────────────────────
run_bacon_79 <- function() {
  cat("[ID 79] Carpenter, Lawler (2019)\n")
  df <- read_dta("data/raw/79/id_8.dta") %>% filter(!is.na(Meas_newlybind))
  df$Post_avg <- as.numeric(df$TDcont_mandate)
  panel <- agg_panel(df, "fips", "year12", "P_U13TDAP", "Post_avg", "provwt")
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(79)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Carpenter, Lawler (2019)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}

# ── ID 97: Bhalotra — composite unit ─────────────────────────────────────
run_bacon_97 <- function() {
  cat("[ID 97] Bhalotra et al. (2021)\n")
  df <- read_dta("data/raw/97/Working-Datasets/analysisfile_8595.dta") %>%
    filter(treated2 >= 1, rur < 1, small_city == 1)
  df$treated_did <- as.numeric(df$treated2) - 1
  df$Post_avg <- as.numeric(df$treated_post)
  df$comp_unit <- as.integer(df$mun_reg) * 10L + as.integer(df$treated2)

  panel <- agg_panel(df, "comp_unit", "year_reg", "ins_rate_under5", "Post_avg")
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(97)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Bhalotra et al. (2021)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}

# ── ID 133: Hoynes — cell_id composite unit ──────────────────────────────
run_bacon_133 <- function() {
  cat("[ID 133] Hoynes et al. (2015)\n")
  df <- read_dta("data/raw/133/id_21.dta") %>%
    filter(effective >= 1991, effective <= 1998, dmeducgrp <= 2, marital == 2) %>%
    mutate(
      lowbirth = lowbirth * 100,
      after    = as.integer(effective >= 1994 & effective <= 1998),
      Post_avg = treat1 * after,
      cell_id  = as.integer(parvar) * 100L + as.integer(stateres)
    )
  panel <- agg_panel(df, "cell_id", "effective", "lowbirth", "Post_avg", "cellnum")
  panel <- balance_panel(panel)

  cat(sprintf("  Panel: %d units x %d periods\n", n_distinct(panel$..u), n_distinct(panel$..t)))
  tryCatch({
    b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)
    cat(sprintf("  Bacon DD avg: %.5f\n", sum(b$estimate * b$weight)))
    b %>% group_by(type) %>% summarise(n=n(), avg=round(mean(estimate),5), wt=round(sum(weight),4), .groups="drop") %>% print()
    out_dir <- ensure_out_dir(133)
    write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
    bacon_plot(b, "Hoynes et al. (2015)", file.path(out_dir, "bacon_decomposition.pdf"))
  }, error = function(e) cat("  Error:", conditionMessage(e), "\n"))
  cat("\n")
}


# ═══════════════════════════════════════════════════════════════════════════
# RUN ALL ARTICLES
# ═══════════════════════════════════════════════════════════════════════════

# Special cases (custom pre-processing)
run_bacon_9()
run_bacon_21()
run_bacon_47()
run_bacon_76()
run_bacon_79()
run_bacon_97()
run_bacon_133()

# Metadata-driven articles (generic runner)
generic_ids <- c("25", "44", "60", "65", "80", "91", "92", "125",
                 "147", "201", "209", "210", "219", "228", "233",
                 "234", "236", "241", "242", "253", "254", "262", "263", "266",
                 "267", "271")

for (rid in generic_ids) {
  tryCatch(
    run_bacon_meta(rid),
    error = function(e) cat(sprintf("  [ID %s] FATAL: %s\n\n", rid, conditionMessage(e)))
  )
  gc(verbose = FALSE)
}

cat("\n========== ALL DONE ==========\n")
