# Test: can CS-DID run on paper 201 monthly individual-level data?
# Currently the pipeline collapses to state×year (drops individual ctrls).
# Goal: verify whether CS-DID works with panel=FALSE on full monthly RCS.

suppressPackageStartupMessages({
  library(haven); library(dplyr); library(did)
})

base_dir <- getwd()
dta_file <- file.path(base_dir, "data", "raw", "201", "extracted", "files", "atus.dta")
cat("Loading", dta_file, "\n")
df <- haven::read_dta(dta_file)
cat("Raw rows:", nrow(df), "cols:", ncol(df), "\n")

# Apply sample filter
df <- df[df$hh_child == 1, ]
cat("After hh_child==1:", nrow(df), "\n")

# Construct gvar_CS per metadata
gvar_tbl <- df %>% filter(pslm_state_lag2 == 1) %>%
  group_by(fips) %>% summarise(first_t = min(time), .groups = "drop")
df <- df %>% left_join(gvar_tbl, by = "fips") %>%
  mutate(gvar_CS = ifelse(!is.na(first_t), as.numeric(first_t), 0))
cat("gvar_CS distribution:\n"); print(table(df$gvar_CS > 0))

# Check unique individuals per fips-time cell
cat("\nObs per fips-time cell:\n")
cells <- df %>% count(fips, time)
print(summary(cells$n))
cat("Total cells:", nrow(cells), "\n")

# Try att_gt on monthly-individual-level with panel=FALSE
cat("\n===== Attempt 1: CS-DID no controls, panel=FALSE =====\n")
t0 <- Sys.time()
res1 <- tryCatch({
  att_gt(yname = "carehh_k", tname = "time", idname = "fips",
         gname = "gvar_CS",
         data = as.data.frame(df),
         control_group = "nevertreated",
         panel = FALSE,
         weightsname = "wt06",
         allow_unbalanced_panel = FALSE,
         base_period = "universal")
}, error = function(e) list(error = conditionMessage(e)))
cat("Elapsed:", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "s\n")

if (!is.null(res1$error)) {
  cat("ERROR:", res1$error, "\n")
} else {
  cat("SUCCESS — first 3 ATT(g,t):\n")
  print(head(res1$att, 3))
  cat("Simple aggregate:\n")
  print(aggte(res1, type = "simple", na.rm = TRUE)$overall.att)
}

# Try with controls if no-ctrls worked
if (is.null(res1$error)) {
  cat("\n===== Attempt 2: CS-DID WITH controls =====\n")
  t0 <- Sys.time()
  ctrls <- c("female","age","poverty","non_white","hisp","mar",
             "hs","scoll","collg","grad","cohabit","hh_numkids",
             "kids15","kids617","rural")
  xf <- as.formula(paste0("~", paste(ctrls, collapse = " + ")))
  res2 <- tryCatch({
    att_gt(yname = "carehh_k", tname = "time", idname = "fips",
           gname = "gvar_CS",
           xformla = xf,
           data = as.data.frame(df),
           control_group = "nevertreated",
           panel = FALSE,
           weightsname = "wt06",
           allow_unbalanced_panel = FALSE,
           base_period = "universal",
           est_method = "dr")
  }, error = function(e) list(error = conditionMessage(e)))
  cat("Elapsed:", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "s\n")

  if (!is.null(res2$error)) {
    cat("ERROR:", res2$error, "\n")
  } else {
    cat("SUCCESS — Simple aggregate with controls:\n")
    print(aggte(res2, type = "simple", na.rm = TRUE)$overall.att)
  }
}
