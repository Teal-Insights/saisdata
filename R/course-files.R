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
#' sais_example()
#' sais_example("wdi_life_expectancy.csv")
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
#' folder <- file.path(tempdir(), "data")
#' copy_course_files(folder)
#' list.files(folder)
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
