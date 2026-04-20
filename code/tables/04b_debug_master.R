m <- read.csv(file.path(getwd(), "..",
  "_archive/phase1_consolidation_20260418/research_new_papers/data/did_articles_master.csv"),
  stringsAsFactors=FALSE, encoding="UTF-8")
cat("N rows:", nrow(m), "\n\n")
cat("Journals (top 20):\n")
print(sort(table(m$journal), decreasing=TRUE)[1:20])
cat("\ntipo_did:\n"); print(sort(table(m$tipo_did), decreasing=TRUE)[1:15])
cat("\nsoftware:\n"); print(sort(table(m$software), decreasing=TRUE)[1:15])
cat("\ntem_event_study:\n"); print(sort(table(m$tem_event_study), decreasing=TRUE)[1:10])
cat("\ntem_replication:\n"); print(sort(table(m$tem_replication_package), decreasing=TRUE)[1:10])
cat("\nano range:\n"); print(summary(m$ano))
