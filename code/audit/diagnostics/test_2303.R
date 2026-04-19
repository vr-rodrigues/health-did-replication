suppressPackageStartupMessages({ library(dplyr); library(fixest); library(did) })

df <- read.csv("data/raw/2303/analysis_data.csv", stringsAsFactors = FALSE)
cat("N obs:", nrow(df), "| plants:", length(unique(df$id)), "| months:", length(unique(df$ym)), "\n")

# ============ Spec B investigation ==============
cat("\n=== Spec B: TWFE no controls, same FE override (id^month + prov^year^month) ===\n")

# The template's FE override
res_no_ctrl <- tryCatch(
  feols(ft90 ~ tbp | id^month + prov^year^month,
        data = df, cluster = ~id),
  error = function(e) list(err = conditionMessage(e))
)
if (!is.null(res_no_ctrl$err)) cat("ERROR:", res_no_ctrl$err, "\n") else {
  cat(sprintf("  beta = %.4f, SE = %.4f, N = %d\n",
              coef(res_no_ctrl)["tbp"], se(res_no_ctrl)["tbp"], nobs(res_no_ctrl)))
}

# Spec with controls
cat("\n=== Spec A comparison: TWFE with 7 weather controls (sanity check) ===\n")
res_with <- tryCatch(
  feols(ft90 ~ tbp + temperature + precipitation + windspeed + humidity +
          winddirection1 + winddirection2 + winddirection3 |
          id^month + prov^year^month,
        data = df, cluster = ~id),
  error = function(e) list(err = conditionMessage(e))
)
if (!is.null(res_with$err)) cat("ERROR:", res_with$err, "\n") else {
  cat(sprintf("  beta = %.4f, SE = %.4f, N = %d\n",
              coef(res_with)["tbp"], se(res_with)["tbp"], nobs(res_with)))
}

# ============ Spec A investigation (CS-DID with controls, IPW not DR) ==============
cat("\n=== CS-DID with 7 controls, est_method=ipw (less memory) ===\n")
# Coerce for att_gt
df$id <- as.numeric(df$id); df$ym <- as.numeric(df$ym); df$gvar_CS <- as.numeric(df$gvar_CS)
xf <- ~temperature + precipitation + windspeed + humidity + winddirection1 + winddirection2 + winddirection3

t0 <- Sys.time()
res_cs_ipw <- tryCatch(
  att_gt(yname = "ft90", tname = "ym", idname = "id", gname = "gvar_CS",
         xformla = xf, data = as.data.frame(df),
         control_group = "nevertreated", panel = TRUE,
         allow_unbalanced_panel = FALSE, base_period = "universal",
         est_method = "ipw"),
  error = function(e) list(err = conditionMessage(e))
)
cat("Elapsed:", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "s\n")
if (!is.null(res_cs_ipw$err)) cat("ERROR:", res_cs_ipw$err, "\n") else {
  a <- tryCatch(aggte(res_cs_ipw, type = "simple", na.rm = TRUE), error = function(e) list(err = conditionMessage(e)))
  cat("simple:", if (!is.null(a$err)) a$err else a$overall.att, "\n")
  ad <- tryCatch(aggte(res_cs_ipw, type = "dynamic", na.rm = TRUE), error = function(e) list(err = conditionMessage(e)))
  cat("dynamic:", if (!is.null(ad$err)) ad$err else ad$overall.att, "\n")
}
