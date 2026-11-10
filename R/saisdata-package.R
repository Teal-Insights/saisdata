#' saisdata: course data for the SAIS MIEF R workshop
#'
#' Six datasets, ready to use once you run `library(saisdata)`:
#'
#' * [weo]: the IMF's World Economic Outlook of October 2026, one row per
#'   country (or IMF group) and year, with twelve indicators as columns:
#'   growth, inflation, unemployment, the current account, GDP per person,
#'   population, and the government's revenue, spending, balances and debt.
#' * [weo_mini]: twelve rows of `weo` that fit on one screen.
#' * [weo_full]: all 44 of the IMF's indicators for every country, long.
#' * [weo_indicators]: what each of those indicators measures, in plain words.
#' * [weo_groups]: the same source for the IMF's two big country groups,
#'   laid out as the IMF publishes it, with the years across.
#' * [wb_groups]: the World Bank's region, income level and lending type for
#'   217 countries.
#'
#' For Day 2, [copy_course_files()] copies a spreadsheet and eight saved
#' series into your project, so you can practice importing files.
#'
#' Type `?weo`, or the name of any dataset after a question mark, to open its
#' help page. `vignette("saisdata")` has a short worked example that runs
#' offline.
#'
#' The tables are a frozen snapshot. They do not change when the IMF or the World
#' Bank publishes new numbers.
#'
#' @section Credit:
#' Print this line under every chart you make from these data:
#'
#' Source: International Monetary Fund, World Economic Outlook Database,
#' October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Country
#' groups: The World Bank: World Development Indicators: country and lending
#' groups (CC BY 4.0). Net interest is the primary balance minus the overall
#' balance, calculated for this workshop.
#'
#' Drop the second sentence if your chart uses no World Bank groups, and the
#' third if it shows no net interest.
#'
#' @section Terms of use:
#' The package's code and documentation are MIT licensed. That license does not
#' cover the data. The data keep their own terms: the IMF's terms for statistical
#' data for the five `weo` tables, and CC BY 4.0 with the World Bank's added
#' terms for `wb_groups`. Each dataset's help page summarizes them. The full
#' summary is in the file `LICENSE-data.md`, installed with the package; find it
#' with `system.file("LICENSE-data.md", package = "saisdata")`.
#'
#' This package is not an official IMF or World Bank product.
"_PACKAGE"
