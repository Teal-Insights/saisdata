#' Find a file that comes with the course
#'
#' The package carries a few files for the Day 2 lesson on importing data: a
#' spreadsheet of the World Bank's country groups, and eight saved series from
#' the World Bank and Our World in Data. `sais_example()` gives the path to
#' one of them, the way `readxl::readxl_example()` does for readxl's files.
#'
#' @param file The name of a file, such as `"wb-country-classification.xlsx"`.
#'   Leave it out to list every file.
#' @return The path to the file, as text. With no `file`, the names of all
#'   the files.
#' @seealso [copy_course_files()] to copy them all into your project.
#' @examples
#' sais_example()                          # list every file
#' sais_example("wdi_life_expectancy.csv") # the path to one of them
#' @examplesIf requireNamespace("tidyverse", quietly = TRUE) && requireNamespace("readxl", quietly = TRUE)
#' library(tidyverse) # load the tidyverse: readr, dplyr and more
#' library(readxl)    # load readxl, which reads Excel files
#'
#' # A saved series from the World Bank: one row per country and year
#' read_csv(                                  # read a CSV file:
#'   sais_example("wdi_life_expectancy.csv"), # this one, from the package
#'   show_col_types = FALSE                   # without the column report
#' )                                          # close read_csv()
#'
#' # The spreadsheet: a title and a note sit above the table, so skip 3 rows
#' read_excel(                                       # read an Excel file:
#'   sais_example("wb-country-classification.xlsx"), # this one
#'   skip = 3                                        # start at the header row
#' )                                                 # close read_excel()
#' @export
sais_example <- function(file = NULL) {
  folder <- system.file("extdata", package = "saisdata")
  if (is.null(file)) {
    return(list.files(folder))
  }
  path <- file.path(folder, file)
  if (!file.exists(path)) {
    stop(
      "saisdata has no file called '", file, "'. ",
      "Run sais_example() to list the files it has.",
      call. = FALSE
    )
  }
  path
}

#' Copy the course's files into your project
#'
#' Copies every file listed by [sais_example()] into a folder of your project,
#' and makes the folder if it is not there yet. After that the files are
#' yours: read them with `readxl::read_excel()` or `readr::read_csv()`, as you
#' would a file you downloaded. Nothing is fetched from the internet.
#'
#' @param to The folder to copy into. In the course this is
#'   `here::here("data")`, the `data` folder of your project.
#' @param overwrite Replace files that are already there? `TRUE` by default,
#'   so a damaged copy is easy to repair.
#' @return The paths of the copies, invisibly. A message says how many files
#'   were copied and where.
#' @examples
#' folder <- file.path(tempdir(), "data") # in the course: here::here("data")
#' copy_course_files(folder)              # copy the nine files there
#' list.files(folder)                     # see what arrived
#' @examplesIf requireNamespace("tidyverse", quietly = TRUE)
#' library(tidyverse) # load the tidyverse: readr, dplyr and more
#'
#' # Read a saved series from the copy, as you would a file of your own
#' life <- read_csv(                               # read a CSV file:
#'   file.path(folder, "wdi_life_expectancy.csv"), # the copied series
#'   show_col_types = FALSE                        # without the column report
#' )                                               # close read_csv()
#'
#' # Join it to the IMF's countries by code and year
#' weo |>                                           # start with the panel, then
#'   filter(str_length(code) == 3, year == 2023) |> # countries in 2023, and then
#'   left_join(life, by = c("code", "year")) |>     # add life expectancy
#'   select(name, gross_debt, life_expectancy_years) # keep columns to read
#' @export
copy_course_files <- function(to = "data", overwrite = TRUE) {
  dir.create(to, showWarnings = FALSE, recursive = TRUE)
  from <- list.files(
    system.file("extdata", package = "saisdata"),
    full.names = TRUE
  )
  copied <- file.copy(from, to, overwrite = overwrite)
  message(
    "Copied ", sum(copied), " course files to ",
    normalizePath(to, winslash = "/")
  )
  invisible(file.path(to, basename(from)))
}
