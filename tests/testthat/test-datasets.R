# These pin the snapshot: the schemas and the facts the help pages state.

column_types <- function(x) vapply(x, typeof, character(1))

test_that("weo has the panel's shape and column types", {
  expect_identical(dim(weo), c(6720L, 17L))
  expect_identical(
    column_types(weo),
    c(
      code = "character", name = "character", year = "integer",
      gross_debt = "double", primary_balance = "double", overall_balance = "double",
      gdp_usd_bn = "double", latest_actual = "integer", fiscal_year = "character",
      real_gdp_growth = "double", inflation = "double", unemployment_rate = "double",
      current_account_balance = "double", gdp_per_capita_usd = "double",
      population_mn = "double", revenue = "double", expenditure = "double"
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

test_that("weo's eight added columns hold the numbers the help pages quote", {
  kenya <- subset(weo, code == "KEN" & year == 2025)
  expect_identical(kenya$real_gdp_growth, 4.633)
  expect_identical(kenya$inflation, 4.068)
  expect_identical(kenya$current_account_balance, -2.769)
  expect_identical(kenya$gdp_per_capita_usd, 2547.502)
  expect_identical(kenya$population_mn, 53.354)
  expect_identical(kenya$revenue, 17.482)
  expect_identical(kenya$expenditure, 23.972)
  expect_true(is.na(kenya$unemployment_rate))
  reporting <- unique(weo$code[!is.na(weo$unemployment_rate) & !grepl("^G[0-9X]", weo$code)])
  expect_identical(length(reporting), 118L)
})

test_that("in weo, revenue minus expenditure is the overall balance for every country", {
  countries <- weo[!grepl("^G[0-9X]", weo$code), ]
  gap <- abs(countries$revenue - countries$expenditure - countries$overall_balance)
  expect_lte(max(gap, na.rm = TRUE), 0.0021)
})

test_that("weo's added columns are missing where the help page says", {
  groups <- grepl("^G[0-9X]", weo$code)
  expect_true(all(is.na(weo$gdp_per_capita_usd[groups])))
  expect_true(all(is.na(weo$population_mn[groups])))
  expect_identical(sum(is.na(weo$real_gdp_growth)), 123L)
  expect_identical(sum(is.na(weo$inflation)), 148L)
  expect_identical(sum(is.na(weo$unemployment_rate)), 3084L)
})

test_that("weo_mini is twelve rows of weo, with nothing changed", {
  expect_identical(dim(weo_mini), c(12L, 9L))
  expect_identical(class(weo_mini), c("tbl_df", "tbl", "data.frame"))
  expect_setequal(weo_mini$code, c("BRA", "DEU", "GHA", "KEN", "NGA", "PAK"))
  expect_setequal(weo_mini$year, c(2015L, 2025L))
  expect_false(anyNA(weo_mini))
  from_weo <- weo[weo$code %in% weo_mini$code & weo$year %in% c(2015L, 2025L), names(weo_mini)]
  from_weo <- from_weo[order(from_weo$code, from_weo$year), ]
  expect_identical(as.data.frame(from_weo), as.data.frame(weo_mini))
})

test_that("weo_full has one row per country, indicator and year with a value", {
  expect_identical(dim(weo_full), c(238459L, 7L))
  expect_identical(
    column_types(weo_full),
    c(
      code = "character", name = "character", indicator = "character",
      indicator_name = "character", units = "character", year = "integer",
      value = "double"
    )
  )
  expect_identical(class(weo_full), c("tbl_df", "tbl", "data.frame"))
  expect_identical(length(unique(weo_full$code)), 197L)
  expect_identical(length(unique(weo_full$indicator)), 44L)
  expect_identical(range(weo_full$year), c(2000L, 2031L))
  expect_false(anyNA(weo_full))
  expect_false(any(duplicated(weo_full[, c("code", "indicator", "year")])))
})

test_that("weo_full agrees with weo wherever they overlap", {
  columns <- weo_indicators[!is.na(weo_indicators$weo_column), ]
  expect_identical(nrow(columns), 12L)
  countries <- weo[!grepl("^G[0-9X]", weo$code), ]
  for (i in seq_len(nrow(columns))) {
    long <- weo_full[weo_full$indicator == columns$indicator[i], c("code", "year", "value")]
    wide <- countries[!is.na(countries[[columns$weo_column[i]]]), c("code", "year", columns$weo_column[i])]
    both <- merge(long, wide, by = c("code", "year"), all = TRUE)
    expect_identical(nrow(both), nrow(long), info = columns$indicator[i])
    expect_identical(both$value, both[[columns$weo_column[i]]], info = columns$indicator[i])
  }
})

test_that("weo_indicators describes every indicator in weo_full", {
  expect_identical(dim(weo_indicators), c(44L, 7L))
  expect_identical(
    names(weo_indicators),
    c("indicator", "indicator_name", "topic", "units", "description", "countries", "weo_column")
  )
  expect_setequal(weo_indicators$indicator, unique(weo_full$indicator))
  expect_false(any(duplicated(weo_indicators$indicator)))
  expect_false(anyNA(weo_indicators[, c("indicator_name", "topic", "units", "description", "countries")]))
  expect_identical(length(unique(weo_indicators$topic)), 7L)
  expect_true(all(nchar(weo_indicators$description) <= 180))
  expect_true(all(weo_indicators$weo_column[!is.na(weo_indicators$weo_column)] %in% names(weo)))
  growth <- weo_indicators[weo_indicators$indicator == "NGDP_RPCH", ]
  expect_identical(growth$countries, 197L)
  expect_identical(growth$weo_column, "real_gdp_growth")
  units <- unique(weo_full[, c("indicator", "units")])
  expect_identical(nrow(units), 44L)
  both <- merge(units, weo_indicators[, c("indicator", "units")], by = "indicator")
  expect_identical(both$units.x, both$units.y)
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
