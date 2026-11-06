#' World Economic Outlook, October 2026: the two big groups, as the IMF lays them out
#'
#' Six rows from the IMF's World Economic Outlook (WEO) database of October
#' 2026, in the layout the IMF publishes: one row per country group and
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
#'   \item{`2001` to `2031`}{dbl One column per year, holding the indicator's value that year. From 2026 on the values are IMF projections. The names are numbers, so wrap them in backticks when you use them: `` `2025` ``.}
#' }
#'
#' @section Credit:
#' Print this line under every chart you make from these data:
#'
#' Source: International Monetary Fund, World Economic Outlook Database,
#' October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Country
#' groups: World Bank (CC BY 4.0). Net interest is the primary balance minus
#' the overall balance, calculated for this workshop.
#'
#' Drop the second sentence if your chart uses no World Bank groups, and the
#' third if it shows no net interest.
#'
#' @section Terms of use:
#' The IMF lets you download, copy, share and build on these data. Credit the
#' IMF as the source, and say so when you change the data in a material way.
#' Commercial reuse needs the IMF's written permission. The terms are on the
#' IMF's Copyright and Usage page,
#' <https://www.imf.org/en/About/copyright-and-terms>, read on 3 November 2026.
#' What the workshop changed: it kept these six rows of the IMF's Country
#' Groups sheet and the years 2001 to 2031, renamed five columns, and wrote
#' the IMF's `SCALE` and `UNIT` in plain words. No number was changed. These
#' data are not an official IMF product.
#'
#' @source International Monetary Fund, World Economic Outlook Database,
#'   October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
#'   `data-raw/weo_groups.R` from the workshop's file
#'   `weo_2026oct_extract.csv`, an extract of the IMF's workbook
#'   `WEOOct2026all.xlsx`.
#'
#' @seealso [weo] for every country and group, one row per entity and year.
#'
#' @examples
#' # Six rows: two groups times three indicators
#' nrow(weo_groups)
#'
#' # Five columns that describe each row, then one column per year
#' names(weo_groups)
"weo_groups"
