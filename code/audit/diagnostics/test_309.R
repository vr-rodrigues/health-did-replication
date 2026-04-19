suppressPackageStartupMessages({ library(haven); library(dplyr); library(did); library(jsonlite) })
meta <- fromJSON("data/metadata/309.json")
df_full <- haven::read_dta(meta$data$file)
cat("Raw rows:", nrow(df_full), "\n")
cat("Columns:", paste(head(names(df_full), 15), collapse=","), "\n")
if (!is.null(meta$data$sample_filter) && nchar(meta$data$sample_filter) > 0) {
  df_full <- df_full %>% filter(!!rlang::parse_expr(meta$data$sample_filter))
  cat("After filter:", nrow(df_full), "\n")
}
for (expr in meta$preprocessing$construct_vars %||% character(0)) eval(parse(text=expr))
df <- df_full
idname <- meta$variables$unit_id
tname <- meta$variables$time
gname <- meta$variables$gvar_cs
yname <- meta$variables$outcome
cat("id:", idname, "| t:", tname, "| g:", gname, "| y:", yname, "\n")
cat("Treated cohorts:"); print(table(df[[gname]], useNA="ifany"))

df$st <- df[[idname]] <- as.numeric(df[[idname]])
df[[tname]] <- as.numeric(df[[tname]])
df[[gname]] <- as.numeric(df[[gname]])

cat("\n=== allow_unbalanced=FALSE ===\n")
r1 <- tryCatch(att_gt(yname=yname, tname=tname, idname=idname, gname=gname,
  data=as.data.frame(df), control_group="nevertreated", panel=TRUE,
  allow_unbalanced_panel=FALSE, base_period="universal"),
  error=function(e) list(err=conditionMessage(e)))
if (!is.null(r1$err)) cat("ERR:",r1$err,"\n") else {
  a <- tryCatch(aggte(r1,type="simple",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("simple:", if(!is.null(a$err)) a$err else a$overall.att, "\n")
}

cat("\n=== allow_unbalanced=TRUE ===\n")
r2 <- tryCatch(att_gt(yname=yname, tname=tname, idname=idname, gname=gname,
  data=as.data.frame(df), control_group="nevertreated", panel=TRUE,
  allow_unbalanced_panel=TRUE, base_period="universal"),
  error=function(e) list(err=conditionMessage(e)))
if (!is.null(r2$err)) cat("ERR:",r2$err,"\n") else {
  a <- tryCatch(aggte(r2,type="simple",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("simple:", if(!is.null(a$err)) a$err else a$overall.att, "\n")
}
