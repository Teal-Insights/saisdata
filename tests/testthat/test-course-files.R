test_that("the course files are listed and found", {
  files <- sais_example()
  expect_true("wb-country-classification.xlsx" %in% files)
  expect_identical(sum(grepl("\\.csv$", files)), 8L)
  expect_true(file.exists(sais_example("wdi_life_expectancy.csv")))
  expect_error(sais_example("no-such-file.csv"), "sais_example\\(\\)")
})

test_that("copy_course_files() makes the folder and copies every file", {
  folder <- file.path(tempfile(), "data")
  expect_message(copied <- copy_course_files(folder), "Copied 9 course files")
  expect_identical(sort(basename(copied)), sort(sais_example()))
  expect_true(all(file.exists(copied)))
})

test_that("the spreadsheet holds the same countries as wb_groups, under the World Bank's codes", {
  skip_if_not_installed("readxl")
  sheet <- readxl::read_excel(sais_example("wb-country-classification.xlsx"), skip = 3)
  expect_identical(names(sheet), c("Economy", "Code", "Region", "Income group", "Lending category"))
  expect_identical(nrow(sheet), nrow(wb_groups))
  expect_setequal(sheet$Code, wb_groups$wb_code)
})
