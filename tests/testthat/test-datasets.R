# These pin the snapshot: the schemas and the facts the help pages state.

column_types <- function(x) vapply(x, typeof, character(1))

test_that("weo has the panel's shape and column types", {
  expect_identical(dim(weo), c(6720L, 9L))
  expect_identical(
    column_types(weo),
    c(
      code = "character", name = "character", year = "integer",
      gross_debt = "double", primary_balance = "double", overall_balance = "double",
      gdp_usd_bn = "double", latest_actual = "integer", fiscal_year = "character"
    )
  )
  expect_identical(class(weo), c("tbl_df", "tbl", "data.frame"))
})

test_that("weo covers 197 countries and 13 IMF groups, 2000 to 2031", {
  groups <- grepl("^G[0-9X]", weo$code)
  expect_identical(length(unique(weo$code[!groups])), 197L)
  expect_identical(length(unique(weo$code[groups])), 13L)
  expect_identical(range(weo$year), c(2000L, 2031L))
  expect_false(any(duplicated(weo[, c("code", "year")])))
})

test_that("weo holds the numbers the help page quotes", {
  japan <- subset(weo, code == "JPN" & year == 2025)
  expect_identical(japan$primary_balance, -0.511)
  expect_identical(japan$overall_balance, -0.709)
  expect_equal(japan$primary_balance - japan$overall_balance, 0.198)
  expect_identical(subset(weo, code == "PAK" & year == 2025)$fiscal_year, "July/June")
})

test_that("weo's latest_actual and fiscal_year are missing for 12 of the 13 groups", {
  missing_codes <- unique(weo$code[is.na(weo$latest_actual)])
  expect_identical(length(missing_codes), 12L)
  expect_true(all(grepl("^G[0-9X]", missing_codes)))
  expect_setequal(unique(weo$code[is.na(weo$fiscal_year)]), missing_codes)
})

test_that("weo's totals have not moved", {
  expect_equal(sum(weo$gdp_usd_bn, na.rm = TRUE), 11900143.713, tolerance = 1e-9)
  expect_equal(sum(weo$gross_debt, na.rm = TRUE), 355348.611, tolerance = 1e-9)
  expect_identical(sum(is.na(weo$gross_debt)), 375L)
  expect_identical(sum(is.na(weo$primary_balance)), 502L)
  expect_identical(sum(is.na(weo$overall_balance)), 253L)
  expect_identical(sum(is.na(weo$gdp_usd_bn)), 114L)
})

test_that("weo_groups has the IMF's layout and column types", {
  expect_identical(dim(weo_groups), c(6L, 36L))
  expect_identical(
    names(weo_groups),
    c("group_code", "group", "indicator", "indicator_name", "units", as.character(2001:2031))
  )
  expect_true(all(column_types(weo_groups)[1:5] == "character"))
  expect_true(all(column_types(weo_groups)[6:36] == "double"))
  expect_setequal(weo_groups$group_code, c("G110", "G200"))
  expect_setequal(weo_groups$indicator, c("GGXONLB_NGDP", "GGXCNL_NGDP", "NGDPD"))
  expect_false(anyNA(weo_groups))
})

test_that("weo_groups gives the net interest bill the help page quotes", {
  bill <- function(year) {
    value <- function(indicator) weo_groups[[year]][weo_groups$indicator == indicator]
    sum((value("GGXONLB_NGDP") - value("GGXCNL_NGDP")) * value("NGDPD") / 100)
  }
  expect_equal(bill("2001"), 849, tolerance = 1e-3)
  expect_equal(bill("2025"), 2371.2, tolerance = 1e-4)
})

test_that("wb_groups has one text row per country", {
  expect_identical(dim(wb_groups), c(217L, 6L))
  expect_identical(
    names(wb_groups),
    c("code", "wb_code", "country", "region", "income_level", "lending_type")
  )
  expect_true(all(column_types(wb_groups) == "character"))
  expect_false(any(duplicated(wb_groups$code)))
  expect_false(anyNA(wb_groups))
  expect_identical(length(unique(wb_groups$region)), 7L)
  expect_setequal(
    wb_groups$income_level,
    c("Low income", "Lower middle income", "Upper middle income", "High income")
  )
  expect_setequal(wb_groups$lending_type, c("IDA", "IBRD", "Blend", "Not classified"))
})

test_that("wb_groups recodes only Kosovo and West Bank and Gaza", {
  recoded <- wb_groups[wb_groups$code != wb_groups$wb_code, ]
  expect_setequal(recoded$code, c("KOS", "WBG"))
  expect_setequal(recoded$wb_code, c("XKX", "PSE"))
})

test_that("wb_groups joins to weo as the help page says", {
  countries <- unique(weo$code[!grepl("^G[0-9X]", weo$code)])
  expect_identical(setdiff(countries, wb_groups$code), "TWN")
  expect_identical(length(setdiff(wb_groups$code, countries)), 21L)
})

test_that("the data terms and citation ship with the package", {
  terms <- system.file("LICENSE-data.md", package = "saisdata")
  expect_true(nzchar(terms))
  text <- paste(readLines(terms, encoding = "UTF-8"), collapse = "\n")
  expect_match(text, "This package is not an official IMF or World Bank product.", fixed = TRUE)
  expect_length(utils::citation("saisdata"), 3L)
})
