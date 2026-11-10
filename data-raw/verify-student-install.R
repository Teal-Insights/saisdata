# Check the student experience, in two fresh R sessions.
#
#   Rscript --vanilla data-raw/verify-student-install.R install
#   Rscript --vanilla data-raw/verify-student-install.R use
#
# Point R_LIBS_USER at an empty folder first; "install" refuses a library that
# already holds packages, and it runs the student's exact line. "use" loads all
# three datasets, opens the help pages and runs the small WEO example. Both exit
# with status 1 on any failure.
#
# Set SAISDATA_EXPECT_SHA and SAISDATA_EXPECT_VERSION to also check what R-universe
# served. The script uses only base R.

args <- commandArgs(trailingOnly = TRUE)
step <- if (length(args)) args[[1]] else ""
stopifnot(step %in% c("install", "use"))

check <- function(ok, what) { # print one line per check, and stop on a failure
  cat(if (isTRUE(ok)) "PASS  " else "FAIL  ", what, "\n", sep = "")
  if (!isTRUE(ok)) quit(save = "no", status = 1)
}

library_path <- .libPaths()[1]
tokens <- c("GITHUB_PAT", "GITHUB_TOKEN", "GH_TOKEN")

cat("R:", as.character(getRversion()), "| platform:", R.version$platform, "\n")
cat("pkgType:", .Platform$pkgType, "\n")
cat("interactive():", interactive(), "\n")

if (step == "install") {
  check(
    length(setdiff(list.files(library_path), "00LOCK")) == 0,
    paste("the library starts empty:", basename(library_path))
  )
  check(!any(nzchar(Sys.getenv(tokens))), "no GitHub token in the environment")
  cat(
    "tibble in another library on this machine:",
    nzchar(system.file(package = "tibble")), "\n"
  )
  options(repos = c(CRAN = "https://cran.invalid")) # any CRAN lookup would fail

  # The student's exact line:
  install.packages("saisdata", repos = "https://teal-insights.r-universe.dev")

  check(requireNamespace("saisdata", quietly = TRUE), "saisdata installed")
  check(
    identical(list.files(library_path), "saisdata"),
    "saisdata is the only package it installed"
  )
  quit(save = "no", status = 0)
}

# step == "use": a fresh session, after the install above.
options(repos = c(CRAN = "https://cran.invalid")) # nothing here may need a repository
library(saisdata)

description <- utils::packageDescription("saisdata")
cat("Version:", description$Version, "\n")
cat("Built:", description$Built, "\n")
cat("Repository:", description$Repository, "\n")
cat("RemoteSha:", description$RemoteSha, "\n")
cat("RemoteRef:", description$RemoteRef, "\n")
cat("Packaged:", description$Packaged, "\n")
cat("NeedsCompilation:", description$NeedsCompilation, "\n")

check(identical(description$NeedsCompilation, "no"), "the package needs no compiler")
check(
  grepl("r-universe", description$Repository, fixed = TRUE),
  "it came from the R-universe repository"
)
expect_version <- Sys.getenv("SAISDATA_EXPECT_VERSION")
if (nzchar(expect_version)) {
  check(identical(description$Version, expect_version), paste("version is", expect_version))
}
expect_sha <- Sys.getenv("SAISDATA_EXPECT_SHA")
if (nzchar(expect_sha)) {
  check(identical(description$RemoteSha, expect_sha), paste("commit is", expect_sha))
}

# Load all three datasets.
check(identical(dim(weo), c(6720L, 9L)), "weo is 6,720 rows by 9 columns")
check(identical(dim(weo_groups), c(6L, 36L)), "weo_groups is 6 rows by 36 columns")
check(identical(dim(wb_groups), c(217L, 6L)), "wb_groups is 217 rows by 6 columns")
check(
  isTRUE(all.equal(sum(weo$gdp_usd_bn, na.rm = TRUE), 11900143.713, tolerance = 1e-9)) &&
    isTRUE(all.equal(sum(weo$gross_debt, na.rm = TRUE), 355348.611, tolerance = 1e-9)),
  "the values in weo match the release (two column totals)"
)

# Open the help pages, and read them as text.
pages <- c("weo", "weo_groups", "wb_groups", "saisdata-package")
for (page in pages) {
  found <- do.call(utils::help, list(topic = page, package = "saisdata"))
  check(length(found) == 1, paste0("?", page, " is found"))
  text_file <- tempfile(fileext = ".txt")
  tools::Rd2txt(utils:::.getHelpFile(found), out = text_file, package = "saisdata")
  text <- gsub("\\s+", " ", paste(readLines(text_file, warn = FALSE), collapse = " "))
  check(
    grepl("not an official IMF or World Bank product", text, fixed = TRUE),
    paste0("?", page, " opens and carries the not-official sentence")
  )
}

# The small WEO example, in base R, because this script runs in a library that
# holds only saisdata. The help page, the README and the vignette do the same
# with the tidyverse, and example(weo) below is skipped without it.
kenya <- subset(weo, code == "KEN" & year >= 2020 & year <= 2025)
kenya$net_interest <- kenya$primary_balance - kenya$overall_balance
print(as.data.frame(kenya[, c("year", "gross_debt", "net_interest")]))
check(
  isTRUE(all.equal(kenya$net_interest[kenya$year == 2025], 5.447)),
  "Kenya's 2025 net interest is 5.447 percent of GDP"
)
utils::example("weo", package = "saisdata", ask = FALSE, echo = FALSE)
check(TRUE, "example(weo) runs")

# The join in the vignette.
joined <- merge(subset(weo, year == 2025), wb_groups, by = "code")
check(nrow(joined) == 196, "weo in 2025 joins to wb_groups for 196 countries")

# The rest of what the docs promise.
check(
  nzchar(system.file("LICENSE-data.md", package = "saisdata")),
  "LICENSE-data.md is installed"
)
check(
  "saisdata" %in% utils::vignette(package = "saisdata")$results[, "Item"],
  "the Getting Started vignette is installed"
)
check(length(utils::citation("saisdata")) == 3, "citation() gives three entries")
check(!("tibble" %in% loadedNamespaces()), "it all worked without loading tibble")
cat("All checks passed.\n")
