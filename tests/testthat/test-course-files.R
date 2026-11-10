test_that("the course files are listed and found", {
  files <- sais_example()
  expect_true("wb-country-classification.xlsx" %in% files)
  expect_identical(sum(grepl("\\.csv$", files)), 9L)
  expect_true("imf-weo-october-2026.xlsx" %in% files)
  expect_true("wdi_remittances.csv" %in% files)
  expect_true(file.exists(sais_example("wdi_life_expectancy.csv")))
  expect_error(sais_example("no-such-file.csv"), "sais_example\\(\\)")
})

test_that("copy_course_files() makes the folder and copies every file", {
  folder <- file.path(tempfile(), "data")
  expect_message(copied <- copy_course_files(folder), "Copied 11 course files")
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

test_that("the remittances series has one row per country and year, in US dollars, under the IMF's codes", {
  skip_if_not_installed("readr")
  remit <- readr::read_csv(sais_example("wdi_remittances.csv"), show_col_types = FALSE)
  expect_identical(names(remit), c("code", "country", "year", "remittances_usd"))
  expect_identical(anyDuplicated(remit[, c("code", "year")]), 0L)
  expect_true(all(remit$remittances_usd >= 0))
  expect_true(all(remit$code %in% wb_groups$code))
  expect_true(all(remit$year >= 2000 & remit$year <= 2025))
})

test_that("the IMF spreadsheet keeps the IMF's layout, and its numbers are weo's", {
  skip_if_not_installed("readxl")
  sheet <- readxl::read_excel(sais_example("imf-weo-october-2026.xlsx"), sheet = "Countries")
  expect_identical(names(sheet)[1:6], c("COUNTRY.ID", "COUNTRY", "INDICATOR.ID", "INDICATOR", "SCALE", "UNIT"))
  expect_identical(names(sheet)[7:38], as.character(2000:2031))
  expect_identical(length(unique(sheet$COUNTRY.ID)), 197L)
  kenya <- sheet[sheet$COUNTRY.ID == "KEN" & sheet$INDICATOR.ID == "PCPIPCH", ]
  expect_equal(kenya[["2025"]], weo$inflation[weo$code == "KEN" & weo$year == 2025], tolerance = 1e-9)
  growth <- sheet[sheet$COUNTRY.ID == "GHA" & sheet$INDICATOR.ID == "NGDP_RPCH", ]
  expect_equal(growth[["2020"]], weo$real_gdp_growth[weo$code == "GHA" & weo$year == 2020], tolerance = 1e-9)
})
