# Compare the tables in data/ with a baseline, and stop with an error if they differ.
#
# Run it from the package folder, after data-raw/rebuild-all.R:
#   LANG=en_US.UTF-8 Rscript data-raw/compare-tables.R
#
# The baseline is one of two things:
#   SAISDATA_BASELINE_TARBALL set: a saisdata source tarball. The script installs it
#     into a temporary library and reads the three tables from there.
#   Otherwise: the first commit of this repository, which holds the original
#     data/*.rda. A clean clone with full history can run this with nothing else.
#
# The script needs only base R, tools and git. It exits with status 1 on any
# difference, so a caller can act on its exit code.
#
# Version 0.3.0 widened `weo` with eight columns and added three tables. The
# baseline has neither. So `weo` is compared on the baseline's nine columns,
# which must be identical, and the added columns and new tables are listed with
# their shapes and file hashes.

tables <- c("weo", "weo_groups", "wb_groups") # the three datasets with a baseline
new_tables <- c("weo_full", "weo_indicators", "weo_mini") # added in 0.3.0

read_from_rda <- function(dir) { # load the three tables from .rda files in a folder
  out <- list()
  for (name in tables) {
    env <- new.env()
    load(file.path(dir, paste0(name, ".rda")), envir = env)
    out[[name]] <- env[[name]]
  }
  out
}

read_from_tarball <- function(tarball) { # install a tarball, read the tables from it
  lib <- tempfile("baseline-lib-")
  dir.create(lib)
  utils::install.packages(tarball, lib = lib, repos = NULL, type = "source", quiet = TRUE)
  out <- list()
  for (name in tables) {
    env <- new.env()
    utils::data(list = name, package = "saisdata", lib.loc = lib, envir = env)
    out[[name]] <- env[[name]]
  }
  out
}

read_from_first_commit <- function() { # pull the .rda files out of git's first commit
  first <- system2("git", c("rev-list", "--max-parents=0", "HEAD"), stdout = TRUE)
  dir <- tempfile("baseline-rda-")
  dir.create(dir)
  for (name in tables) {
    path <- paste0("data/", name, ".rda")
    status <- system2(
      "git", c("show", paste0(first[1], ":", path)),
      stdout = file.path(dir, basename(path))
    )
    stopifnot(status == 0)
  }
  list(id = first[1], tables = read_from_rda(dir))
}

column_types <- function(x) { # one row per column: its name, class and storage type
  data.frame(
    column = names(x),
    class = vapply(x, function(col) paste(class(col), collapse = "/"), character(1)),
    typeof = vapply(x, typeof, character(1)),
    row.names = NULL
  )
}

sorted_attributes <- function(x) { # attributes by name: their order carries no meaning
  found <- attributes(x)
  found[order(names(found))]
}

encodings <- function(x) { # the encoding of every string, by column
  text <- vapply(x, is.character, logical(1))
  lapply(x[text], Encoding)
}

sha256 <- function(path) { # tools::sha256sum() needs R 4.5; older R uses the shell
  if ("sha256sum" %in% getNamespaceExports("tools")) {
    return(unname(getExportedValue("tools", "sha256sum")(path)))
  }
  tool <- if (nzchar(Sys.which("shasum"))) c("shasum", "-a", "256") else "sha256sum"
  out <- system2(tool[1], c(tool[-1], shQuote(path)), stdout = TRUE)
  sub(" .*$", "", out[1])
}

baseline_tarball <- Sys.getenv("SAISDATA_BASELINE_TARBALL")
if (nzchar(baseline_tarball)) {
  baseline <- read_from_tarball(baseline_tarball)
  cat("Baseline: tarball", basename(baseline_tarball), "\n")
  cat("  SHA-256:", sha256(baseline_tarball), "\n")
} else {
  first_commit <- read_from_first_commit()
  baseline <- first_commit$tables
  cat("Baseline: first commit of this repository,", first_commit$id, "\n")
}
rebuilt <- read_from_rda("data")
cat("Rebuilt:  data/*.rda in this checkout\n")
cat("R version:", as.character(getRversion()), "\n")
for (pkg in c("readr", "dplyr", "tidyr", "stringr", "usethis")) { # the versions used
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("  %s %s\n", pkg, as.character(utils::packageVersion(pkg))))
  }
}
cat("Source files:\n")
for (file in sort(list.files(file.path("data-raw", "source"), pattern = "[.]csv$", full.names = TRUE))) {
  cat(sprintf("  %s  %s\n", sha256(file), basename(file)))
}

failed <- FALSE
for (name in tables) { # compare one table at a time
  old <- baseline[[name]]
  new <- rebuilt[[name]]
  added <- setdiff(names(new), names(old)) # columns the baseline does not have
  if (length(added) > 0) { # compare on the baseline's columns, in its order
    cat("\n", name, " has ", length(added), " columns the baseline lacks: ",
      paste(added, collapse = ", "), "\n", sep = "")
    new <- new[names(old)]
  }
  same_identical <- identical(old, new)
  same_all_equal <- isTRUE(all.equal(old, new, tolerance = 0))
  same_types <- identical(column_types(old), column_types(new))
  same_attributes <- identical(sorted_attributes(old), sorted_attributes(new))
  same_encodings <- identical(encodings(old), encodings(new))

  cat("\n== ", name, " ==\n", sep = "")
  cat("Rows and columns, baseline:", dim(old), " rebuilt:", dim(new), "\n")
  cat("Class, baseline:", class(old), " rebuilt:", class(new), "\n")
  cat("identical():                 ", same_identical, "\n")
  cat("all.equal(tolerance = 0):    ", same_all_equal, "\n")
  cat("Column names and types match:", same_types, "\n")
  cat("Attributes match:            ", same_attributes, "\n")
  cat("String encodings match:      ", same_encodings, "\n")
  cat("data/", name, ".rda SHA-256: ", sha256(file.path("data", paste0(name, ".rda"))), "\n", sep = "")
  cat("Column by column (name, class, typeof, missing values, baseline == rebuilt):\n")
  columns <- column_types(new)
  columns$missing <- vapply(new, function(col) sum(is.na(col)), integer(1))
  columns$same <- vapply(
    names(new),
    function(col) identical(old[[col]], new[[col]]),
    logical(1)
  )
  print(columns, row.names = FALSE)

  if (!all(same_identical, same_all_equal, same_types, same_attributes, same_encodings, columns$same)) {
    failed <- TRUE
    cat("DIFFERENT:", name, "\n")
    print(all.equal(old, new, tolerance = 0))
  }
}

cat("\n== Tables with no baseline ==\n")
for (name in new_tables) { # list each new table: its shape and its file's hash
  env <- new.env()
  load(file.path("data", paste0(name, ".rda")), envir = env)
  cat(sprintf(
    "%s: %d rows, %d columns, data/%s.rda SHA-256: %s\n",
    name, nrow(env[[name]]), ncol(env[[name]]), name,
    sha256(file.path("data", paste0(name, ".rda")))
  ))
}

cat("\nResult:", if (failed) "DIFFERENT" else "SAME", "\n")
if (failed) quit(save = "no", status = 1)
