# Compare the tables a student gets from R-universe with the original package.
#
#   R_LIBS_USER=<library holding the R-universe install> \
#     SAISDATA_BASELINE_TARBALL=<path to the original tarball> \
#     Rscript --vanilla data-raw/verification/compare-installed.R
#
# data-raw/compare-tables.R compares a rebuild in this repo. This one compares what
# actually comes down the student's install line. It exits 1 if any table differs.

baseline_tarball <- Sys.getenv("SAISDATA_BASELINE_TARBALL")
stopifnot(file.exists(baseline_tarball))

folder <- tempfile()
dir.create(folder)
utils::untar(baseline_tarball, exdir = folder)
baseline <- new.env()
for (file in list.files(file.path(folder, "saisdata", "data"), full.names = TRUE)) {
  load(file, envir = baseline)
}

library(saisdata, lib.loc = .libPaths()[1])
description <- utils::packageDescription("saisdata")
cat("Installed version:", description$Version, "\n")
cat("Installed from:", description$Repository, "\n")
cat("Commit:", description$RemoteSha, "\n\n")

same <- TRUE
for (table in c("weo", "weo_groups", "wb_groups")) {
  original <- get(table, envir = baseline)
  served <- get(table, envir = asNamespace("saisdata"))
  column_types_match <- identical(
    vapply(original, function(x) class(x)[1], ""),
    vapply(served, function(x) class(x)[1], "")
  )
  all_equal <- all.equal(original, served, tolerance = 0)
  cat(table, "\n", sep = "")
  cat("  identical():", identical(original, served), "\n")
  cat("  all.equal(tolerance = 0):", isTRUE(all_equal), "\n")
  cat("  column types match:", column_types_match, "\n")
  same <- same && identical(original, served) && isTRUE(all_equal) && column_types_match
}

cat("\nResult:", if (same) "SAME" else "DIFFERENT", "\n")
if (!same) quit(save = "no", status = 1)
