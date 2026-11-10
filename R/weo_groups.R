#' World Economic Outlook, October 2026: the two big groups, as the IMF lays them out
#'
#' Six rows from the IMF's World Economic Outlook (WEO) database of October
#' 2026, in the layout the IMF publishes. One row is one country group and one
#' indicator, with the years across as columns. The two groups, Advanced
#' Economies and Emerging Market and Developing Economies, together cover the
#' world. The three indicators, the primary balance, the overall balance and
#' GDP, are all you need to work out what the world's governments pay in
#' interest.
#'
#' This is what data look like in the wild. To work with them in R you tidy
#' them first: `tidyr::pivot_longer()` turns the year columns into rows, and
#' `tidyr::pivot_wider()` turns the indicators into columns.
#'
#' Net interest in billions of US dollars is the primary balance minus the
#' overall balance, times GDP, divided by 100. Added up over the two groups it
#' comes to about USD 849 billion in 2001 and USD 2,371.2 billion in 2025. The
#' groups' balances are averages of their members' balances, weighted by GDP,
#' so this total is an approximation.
#'
#' The years start in 2001, the first year the IMF gives a primary balance for
#' both groups.
#'
#' @format A tibble with 6 rows and 36 variables:
#' \describe{
#'   \item{group_code}{chr The IMF's code for the group: `G110` for Advanced Economies, `G200` for Emerging Market and Developing Economies (`COUNTRY.ID` in the IMF's file).}
#'   \item{group}{chr The group's name, as the IMF writes it (`COUNTRY`).}
#'   \item{indicator}{chr The IMF's code for the indicator (`INDICATOR.ID`): `GGXONLB_NGDP` is the primary balance, `GGXCNL_NGDP` the overall balance, and `NGDPD` GDP at current prices.}
#'   \item{indicator_name}{chr The indicator's full name, as the IMF writes it (`INDICATOR`), such as "Net lending (+) / net borrowing (-), General government, Percent of GDP".}
#'   \item{units}{chr How to read the numbers: "Percent of GDP" for the two balances and "Billions of US dollars" for GDP (the IMF's `SCALE` and `UNIT` columns, in plain words).}
#'   \item{`2001` to `2031`}{dbl One column per year, holding the indicator's value that year. From 2026 on the values are IMF projections. The names are numbers, so wrap them in backticks when you use them: \code{`2025`}.}
#' }
#'
#' @section Vintage:
#' The IMF's World Economic Outlook database of October 2026. This table is a
#' frozen snapshot of that release: it does not change when the IMF publishes a
#' new WEO or revises these numbers.
#'
#' @section Transformations:
#' The IMF's workbook `WEOOct2026all.xlsx` went through two steps. First, an
#' extract stacked its Countries and Country Groups sheets, kept 13 of 44
#' indicators, the years 2000 to 2031 and 9 of 29 descriptive columns, and wrote
#' each number in its shortest form. Second, `data-raw/weo_groups.R` kept these six
#' rows and the years 2001 to 2031, renamed five columns, and wrote the IMF's
#' `SCALE` and `UNIT` in plain words. No number was changed.
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
#' The package's MIT license does not cover these data. They are under the special
#' terms for statistical data on the IMF's Copyright and Usage page,
#' <https://www.imf.org/en/About/copyright-and-terms> (effective 11 October 2024,
#' read on 6 November 2026), which name the World Economic Outlook database. You
#' may download, extract, copy, build on, publish and distribute the data if you
#' credit the IMF in the form above, do not alter the data in a way that
#' intentionally affects their nature or accuracy, and say so next to the credit
#' when you materially transform them. If you pass the data on, make reasonable
#' efforts to tell your users about these terms. The IMF gives no warranty. For any
#' potential commercial reuse, ask copyright@imf.org first. The IMF's general
#' terms still apply where the data terms are silent: imply no endorsement, and do
#' not use its content to train large language models without its explicit
#' permission. See `system.file("LICENSE-data.md", package = "saisdata")`.
#'
#' This package is not an official IMF or World Bank product.
#'
#' @source International Monetary Fund, World Economic Outlook Database,
#'   October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
#'   `data-raw/weo_groups.R` from `data-raw/source/weo_2026oct_extract.csv`, an
#'   extract of the IMF's workbook `WEOOct2026all.xlsx`.
#'
#' @seealso [weo] for every country and group, one row per entity and year.
#'
#' @examplesIf requireNamespace("tidyverse", quietly = TRUE)
#' library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more
#'
#' # The IMF's layout: one row per group and indicator, with the years across
#' weo_groups
#'
#' # Tidy it, then work out each group's net interest bill in dollars
#' weo_groups |>                                     # start with the table, then
#'   select(group_code, indicator, `2001`:`2031`) |> # keep codes and years, then
#'   pivot_longer(                                   # bring the years down:
#'     cols = `2001`:`2031`,                         # every year column
#'     names_to = "year",                            # their names go in year
#'     names_transform = as.integer,                 # as whole numbers
#'     values_to = "value"                           # their numbers go in value
#'   ) |>                                            # and then
#'   pivot_wider(                                    # send the indicators up:
#'     names_from = indicator,                       # one column per indicator
#'     values_from = value                           # filled from value
#'   ) |>                                            # and then
#'   mutate(                                         # add a column:
#'     # primary balance minus overall balance, times GDP, in USD billions
#'     net_interest_usd_bn = (GGXONLB_NGDP - GGXCNL_NGDP) / 100 * NGDPD
#'   )                                               # close mutate()
"weo_groups"
