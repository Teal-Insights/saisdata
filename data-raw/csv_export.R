# Write every table as a CSV file in csv/, the last-chance copies.
#
# Run it from the package folder, after the tables are built:
#   LANG=en_US.UTF-8 Rscript data-raw/csv_export.R
# The package's tables are the backup for every live call in the course. These
# files are the backup for the package: if saisdata will not install on a
# laptop, one read_csv() line reads a table straight from GitHub. csv/ is not
# part of the installed package.
#
# It reads data/*.rda and writes one file per table. weo_full is gzipped,
# because it is long; read_csv() reads a .csv.gz file as it reads a .csv file.
# It then reads every file back and stops unless it equals the table.

library(readr) # write_csv(), format_csv() and read_csv()
library(dplyr) # as_tibble() for the comparison
library(here) # here() builds paths from the package folder

here::i_am("data-raw/csv_export.R") # tell here() where this script lives

tables <- c( # every table in the package, by name
  "weo", "weo_mini", "weo_indicators", "weo_full", "weo_groups", "wb_groups"
)
dir.create(here("csv"), showWarnings = FALSE) # make the folder, if it is new

same_table <- function(csv, table) { # do a file's cells equal a table's?
  if (!identical(names(csv), names(table))) return(FALSE) # the same columns
  if (nrow(csv) != nrow(table)) return(FALSE) # and the same number of rows
  all(vapply(names(table), function(column) { # then, column by column,
    a <- csv[[column]] # the file's values
    b <- table[[column]] # the table's values
    if (is.integer(b)) a <- as.integer(a) # a whole-number column reads back so
    identical(is.na(a), is.na(b)) && all(a == b, na.rm = TRUE) # cell for cell
  }, logical(1)))
}

for (name in tables) { # one table at a time
  env <- new.env() # an empty place to load it
  load(here("data", paste0(name, ".rda")), envir = env) # load the table
  table <- env[[name]] # take it out
  long <- name == "weo_full" # the long table is gzipped
  path <- here("csv", paste0(name, if (long) ".csv.gz" else ".csv")) # its file
  text <- format_csv(table, na = "") # the table as CSV text, blanks for NA

  written <- file.exists(path) && # is the file already there,
    same_table(read_csv(path, show_col_types = FALSE, guess_max = 300000), table)
  if (!written) { # write it only if it is missing or out of date,
    con <- if (long) gzfile(path, "wb") else file(path, "wb") # so that a
    writeLines(text, con, sep = "", useBytes = TRUE) # rebuild changes no byte
    close(con) # of a file that is already right
  }

  back <- read_csv(path, show_col_types = FALSE, guess_max = 300000) # read back
  stopifnot(same_table(back, table)) # stop unless the file equals the table
  message(sprintf("csv/%s: %d rows, %d columns", basename(path), nrow(back), ncol(back)))
}
