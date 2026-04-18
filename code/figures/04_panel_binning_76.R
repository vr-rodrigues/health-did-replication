###############################################################################
# 04_panel_binning_76.R — Figure 4.5: 4-panel composite for Lawler & Yewell (2023)
# (a) Event study: TWFE vs CS-NYT
# (b) Sensitivity: TWFE binned vs unbinned vs CS-NYT
# (c) ESW weights on L_4
# (d) Progressive binning on L_4
#
# WARNING: This script requires the original Lawler & Yewell (2023) replication
# data. The path is set via results/by_article/76/metadata.json ($data$file). See
# data_availability_statement.md for instructions on obtaining the raw data.
#
# Output: output/figures/figure_4_5_panel_binning_76.pdf
###############################################################################
suppressPackageStartupMessages({
  library(haven); library(dplyr); library(fixest); library(ggplot2)
  library(jsonlite); library(patchwork)
})

# Portable: run from replication package root
base_dir <- getwd()
source(file.path(base_dir, "code", "utils", "eventstudyweights.R"))

meta <- fromJSON(file.path(base_dir, "results", "by_article", "76", "metadata.json"))

# ── Common theme ───────────────────────────────────────────────────────
theme_panel <- theme_classic(base_size = 14) +
  theme(plot.title = element_text(size = 14, face = "bold"),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 11),
        legend.position = "bottom",
        legend.text = element_text(size = 11),
        legend.title = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        plot.margin = margin(4, 6, 4, 4))

# ═══════════════════════════════════════════════════════════════════════
# PANEL (a): Event study — TWFE vs CS-NYT
# ═══════════════════════════════════════════════════════════════════════
cat("Panel (a): Event study\n")
es_data <- read.csv(file.path(base_dir, "results", "by_article", "76", "event_study_data.csv"), stringsAsFactors = FALSE)
es_plot <- es_data %>%
  filter(estimator %in% c("TWFE", "CS-NYT")) %>%
  mutate(
    ci_lo = coef - 1.96 * se,
    ci_hi = coef + 1.96 * se,
    estimator = factor(estimator, levels = c("TWFE", "CS-NYT"))
  )
# Add reference
for (est in c("TWFE", "CS-NYT")) {
  if (!any(es_plot$time == -1 & es_plot$estimator == est)) {
    es_plot <- rbind(es_plot, data.frame(estimator = est, time = -1,
                                          coef = 0, se = 0, ci_lo = 0, ci_hi = 0))
  }
}
es_plot <- es_plot %>%
  mutate(time_d = time + ifelse(estimator == "TWFE", -0.1, 0.1))

pa <- ggplot(es_plot, aes(x = time_d, y = coef, color = estimator, shape = estimator)) +
  geom_hline(yintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.3) +
  geom_vline(xintercept = -0.5, color = "grey60", linetype = "dotted", linewidth = 0.3) +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0.12, linewidth = 0.5, alpha = 0.6) +
  geom_point(size = 2.0, stroke = 1.0) +
  scale_color_manual(values = c("TWFE" = "black", "CS-NYT" = "forestgreen")) +
  scale_shape_manual(values = c("TWFE" = 3, "CS-NYT" = 4)) +
  labs(x = "Relative time", y = "ATT",
       title = "(a) Event study: TWFE vs CS-NYT") +
  theme_panel

# ═══════════════════════════════════════════════════════════════════════
# PANEL (b): Sensitivity — TWFE binned vs unbinned vs CS-NYT
# ═══════════════════════════════════════════════════════════════════════
cat("Panel (b): Sensitivity binning\n")
df <- read_dta(meta$data$file) %>% filter(mobil == 2)
for (cmd in meta$preprocessing$construct_vars) eval(parse(text = cmd))

bf <- ifelse(!is.na(df$baby_babyfr), df$baby_babyfr, 0)
df$m_treat <- ifelse(!is.na(df$baby_babyfr) & df$baby_babyfr == 1,
                     as.integer(df$byear) - as.integer(df$start_year),
                     NA_integer_)

all_ctrls <- c("WIC_ever","frstbrn","married","female",
               "law1","law2","law3","law4","law5","mleave","mdcdexpand",
               "unemp_rate","styr_perblack","styr_perhispan",
               "styr_perother_eth","styr_perfemale","styr_perlt21",
               "styr_per21_64","styr_HSrate","styr_uni4rate","styr_povrate")
fe_str <- "fips + byear + childnm + mom_ed + raceeth_cat + mom_agegrp"

# TWFE BINNED — full sample
df$m_treat_b <- case_when(
  is.na(df$m_treat) ~ NA_integer_,
  df$m_treat <= -5  ~ -5L,
  df$m_treat >= 4   ~ 4L,
  TRUE              ~ as.integer(df$m_treat)
)
es_dum_b <- c("F_5","F_4","F_3","F_2","L_0","L_1","L_2","L_3","L_4")
for (v in c(-5,-4,-3,-2,0,1,2,3,4)) {
  nm <- if (v < 0) paste0("F_", abs(v)) else paste0("L_", v)
  df[[nm]] <- ifelse(!is.na(df$m_treat_b) & df$m_treat_b == v, bf, 0)
}
fml_b <- as.formula(paste("bf_ever ~",
  paste(c(es_dum_b, all_ctrls), collapse = " + "), "|", fe_str))
fit_b <- feols(fml_b, data = df, weights = ~rddwt, cluster = ~fips)

twfe_binned <- rbind(
  data.frame(time = c(-5,-4,-3,-2,0,1,2,3,4),
             coef = unname(coef(fit_b)[es_dum_b]),
             se   = unname(se(fit_b)[es_dum_b]),
             estimator = "TWFE (binned)"),
  data.frame(time = -1, coef = 0, se = 0, estimator = "TWFE (binned)"))

# TWFE UNBINNED — restricted to [-8, 8]
df_u <- df %>% filter(is.na(m_treat) | (m_treat >= -8 & m_treat <= 8))
ty_u <- df_u$byear[!is.na(df_u$m_treat)]
df_u <- df_u %>% filter(byear >= min(ty_u) & byear <= max(ty_u))
bf_u <- ifelse(!is.na(df_u$baby_babyfr), df_u$baby_babyfr, 0)
unb_range <- seq(-8L, 8L); unb_range <- unb_range[unb_range != -1L]
unb_names <- character(length(unb_range))
for (i in seq_along(unb_range)) {
  v <- unb_range[i]
  nm <- if (v < 0) paste0("UF_", abs(v)) else paste0("UL_", v)
  unb_names[i] <- nm
  df_u[[nm]] <- ifelse(!is.na(df_u$m_treat) & df_u$m_treat == v, bf_u, 0)
}
fml_u <- as.formula(paste("bf_ever ~",
  paste(c(unb_names, all_ctrls), collapse = " + "), "|", fe_str))
fit_u <- feols(fml_u, data = df_u, weights = ~rddwt, cluster = ~fips)

twfe_unb <- rbind(
  data.frame(time = unb_range,
             coef = unname(coef(fit_u)[unb_names]),
             se   = unname(se(fit_u)[unb_names]),
             estimator = "TWFE (unbinned)"),
  data.frame(time = -1, coef = 0, se = 0, estimator = "TWFE (unbinned)"))

# CS-NYT from saved data
cs_nyt <- es_data %>% filter(estimator == "CS-NYT") %>%
  mutate(estimator = "CS-NYT")
if (!any(cs_nyt$time == -1))
  cs_nyt <- rbind(cs_nyt, data.frame(estimator = "CS-NYT", time = -1, coef = 0, se = 0))

all_sens <- bind_rows(twfe_binned, twfe_unb, cs_nyt) %>%
  filter(!is.na(coef)) %>%
  mutate(ci_lo = coef - 1.96 * se, ci_hi = coef + 1.96 * se,
         estimator = factor(estimator,
           levels = c("TWFE (binned)", "TWFE (unbinned)", "CS-NYT")),
         time_d = time + case_when(
           estimator == "TWFE (binned)"   ~ -0.15,
           estimator == "TWFE (unbinned)" ~  0.00,
           estimator == "CS-NYT"          ~  0.15))

pb <- ggplot(all_sens, aes(x = time_d, y = coef, color = estimator, shape = estimator)) +
  geom_hline(yintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.3) +
  geom_vline(xintercept = -0.5, color = "grey60", linetype = "dotted", linewidth = 0.3) +
  annotate("rect", xmin = -5.5, xmax = 4.5, ymin = -Inf, ymax = Inf,
           fill = "grey90", alpha = 0.3) +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0.12, linewidth = 0.5, alpha = 0.6) +
  geom_point(size = 2.0, stroke = 1.0) +
  scale_color_manual(values = c("TWFE (binned)" = "black",
                                 "TWFE (unbinned)" = "grey55",
                                 "CS-NYT" = "forestgreen")) +
  scale_shape_manual(values = c("TWFE (binned)" = 3,
                                 "TWFE (unbinned)" = 1,
                                 "CS-NYT" = 4)) +
  labs(x = "Relative time", y = "ATT",
       title = "(b) Sensitivity: binned vs unbinned") +
  theme_panel

# ═══════════════════════════════════════════════════════════════════════
# PANEL (c): ESW weights on L_4
# ═══════════════════════════════════════════════════════════════════════
cat("Panel (c): ESW weights\n")
ev_pre <- meta$analysis$event_pre; ev_post <- meta$analysis$event_post
idname <- meta$variables$unit_id; tname <- meta$variables$time
gcsname <- meta$variables$gvar_cs; cname <- meta$variables$cluster
wname <- meta$variables$weight; add_fes <- meta$variables$additional_fes
tw_ctrls <- meta$variables$twfe_controls

df$gvar_num_esw <- as.numeric(df[[gcsname]])
df$raw_rel_esw  <- as.numeric(df[[tname]]) - df$gvar_num_esw
df$rel_time_esw <- ifelse(!is.na(df$gvar_num_esw) & df$gvar_num_esw > 0,
                          df$raw_rel_esw, NA_real_)

never_bin   <- -(ev_pre + 2L)
far_pre_bin <- -(ev_pre + 1L)
df$rel_time_binned_esw <- as.integer(dplyr::case_when(
  is.na(df$gvar_num_esw) | df$gvar_num_esw == 0 ~ never_bin,
  df$raw_rel_esw < -ev_pre   ~ far_pre_bin,
  df$raw_rel_esw >= ev_post  ~ as.integer(ev_post),
  TRUE                       ~ as.integer(df$raw_rel_esw)
))

bin_values <- c(far_pre_bin, seq(-ev_pre, ev_post))
bin_values <- bin_values[bin_values != -1L]
bin_names  <- character(length(bin_values))
for (i in seq_along(bin_values)) {
  v <- bin_values[i]
  nm <- if (v == far_pre_bin) paste0("F_", ev_pre + 1L)
        else if (v < 0) paste0("F_", abs(v))
        else paste0("L_", v)
  bin_names[i] <- nm
  df[[nm]] <- as.integer(df$rel_time_binned_esw == v)
}
last_bin <- paste0("L_", ev_post)

w <- esw_compute(
  data = df, bin_vars = bin_names, unit_fe = idname, time_fe = tname,
  cohort_var = "gvar_num_esw", reltime_var = "rel_time_esw",
  covariates = if (length(tw_ctrls) > 0) tw_ctrls else NULL,
  extra_fes = if (length(add_fes) > 0) add_fes else NULL,
  weights_var = wname
)

agg <- esw_aggregate(w, last_bin)
agg$spec <- "Binned"
agg_exp <- data.frame(rel_time = agg$rel_time,
                       weight = ifelse(agg$rel_time == ev_post, 1.0, 0.0),
                       n_obs = 0L, spec = "Expected")
combined_w <- rbind(agg, agg_exp)
combined_w$spec <- factor(combined_w$spec, levels = c("Expected", "Binned"))

pc <- ggplot(combined_w, aes(x = rel_time, y = weight,
                              color = spec, linetype = spec)) +
  geom_line(linewidth = 0.6) +
  geom_point(data = subset(combined_w, spec == "Binned"), size = 1.2, alpha = 0.6) +
  geom_hline(yintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.3) +
  geom_vline(xintercept = -0.5, color = "grey70", linetype = "dotted", linewidth = 0.3) +
  scale_color_manual(values = c("Expected" = "grey50", "Binned" = "black")) +
  scale_linetype_manual(values = c("Expected" = "dashed", "Binned" = "solid")) +
  labs(x = "Relative time",
       y = bquote("Weight on " * hat(beta)[L[4]]),
       title = "(c) Event-study weights on L_4") +
  theme_panel

# ═══════════════════════════════════════════════════════════════════════
# PANEL (d): Progressive binning
# ═══════════════════════════════════════════════════════════════════════
cat("Panel (d): Progressive binning\n")
k_values <- seq(0, 16, by = 2)
prog_res <- data.frame(k = integer(), coef = numeric(), se = numeric(),
                        ci_lo = numeric(), ci_hi = numeric())

for (k in k_values) {
  lo <- -(5L + k); hi <- 4L + k
  dft <- df %>% filter(is.na(m_treat) | (m_treat >= lo & m_treat <= hi))
  ty <- dft$byear[!is.na(dft$m_treat)]
  dft <- dft %>% filter(byear >= min(ty) & byear <= max(ty))

  dft$m_treat_b <- case_when(
    is.na(dft$m_treat) ~ NA_integer_,
    dft$m_treat <= -5  ~ -5L,
    dft$m_treat >= 4   ~ 4L,
    TRUE               ~ as.integer(dft$m_treat)
  )
  bf_k <- ifelse(!is.na(dft$baby_babyfr), dft$baby_babyfr, 0)
  for (v in c(-5,-4,-3,-2,0,1,2,3,4)) {
    nm <- if (v < 0) paste0("F_", abs(v)) else paste0("L_", v)
    dft[[nm]] <- ifelse(!is.na(dft$m_treat_b) & dft$m_treat_b == v, bf_k, 0)
  }

  fit_k <- tryCatch(
    feols(fml_b, data = dft, weights = ~rddwt, cluster = ~fips),
    error = function(e) NULL)

  if (!is.null(fit_k) && "L_4" %in% names(coef(fit_k))) {
    b <- coef(fit_k)["L_4"]; s <- se(fit_k)["L_4"]
    prog_res <- rbind(prog_res, data.frame(
      k = k, coef = b, se = s, ci_lo = b - 1.96*s, ci_hi = b + 1.96*s))
  }
}

pd <- ggplot(prog_res, aes(x = k, y = coef)) +
  geom_hline(yintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.3) +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0.3, linewidth = 0.5) +
  geom_point(size = 2.0) +
  scale_x_continuous(breaks = k_values) +
  labs(x = expression("Additional periods binned (" * pm * "k)"),
       y = bquote(hat(beta)[L[4]]),
       title = "(d) Progressive binning on L_4") +
  theme_panel +
  theme(legend.position = "none")

# ═══════════════════════════════════════════════════════════════════════
# Combine
# ═══════════════════════════════════════════════════════════════════════
cat("Combining panels...\n")
panel <- (pa + pb) / (pc + pd)

out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

out_pdf <- file.path(out_dir, "figure_4_5_panel_binning_76.pdf")
ggsave(out_pdf, panel, width = 14, height = 8)
cat("Saved:", out_pdf, "\n")

cat("\nDONE\n")
