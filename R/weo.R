#' World Economic Outlook, October 2026: the tidy country panel
#'
#' Four indicators from the IMF's World Economic Outlook (WEO) database of
#' October 2026, laid out tidy: one row per entity and year, one column per
#' variable. An entity is one of 197 countries or one of 13 IMF country
#' groups, and the years run from 2000 to 2031, so the panel has 6,720 rows.
#'
#' The WEO mixes actual data and IMF projections in one row. `latest_actual`
#' marks where the actual data stop. For most countries the fiscal numbers are
#' actual through 2025, and from 2026 on almost every value is an IMF
#' projection.
#'
#' Net interest is not a column. It is one line of arithmetic,
#' `primary_balance - overall_balance`: the interest the government pays minus
#' the interest it receives, in percent of GDP. For Japan in 2025 that is
#' -0.511 minus -0.709, which is 0.198.
#'
#' To tell a group from a country, look at the code. An IMF group's code
#' starts with G and then a digit or an X (`G110`); a country's second
#' character is a letter (Ghana is `GHA`).
#'
#' @format A tibble with 6,720 rows and 9 variables:
#' \describe{
#'   \item{code}{chr The entity's code. A country has its three-letter ISO code (the IMF uses `KOS` for Kosovo and `WBG` for West Bank and Gaza); an IMF group has a code that starts with G and a digit or an X, such as `G110` for Advanced Economies.}
#'   \item{name}{chr The entity's name, as the IMF writes it, such as "Egypt, Arab Republic of".}
#'   \item{year}{int The year, 2000 to 2031.}
#'   \item{gross_debt}{dbl Gross debt of the general government, everything it owes, in percent of GDP (the IMF's `GGXWDG_NGDP`).}
#'   \item{primary_balance}{dbl The primary balance: revenue minus spending, with interest left out on both sides, in percent of GDP (`GGXONLB_NGDP`). Negative means a deficit.}
#'   \item{overall_balance}{dbl The overall balance: revenue minus all spending, interest included, in percent of GDP (`GGXCNL_NGDP`). Negative means a deficit.}
#'   \item{gdp_usd_bn}{dbl GDP at current prices, in billions of US dollars (`NGDPD`).}
#'   \item{latest_actual}{int The last year with actual fiscal data; later years are IMF estimates or projections. Missing (`NA`) for 12 of the 13 IMF groups.}
#'   \item{fiscal_year}{chr The months of the year the WEO shows the fiscal numbers in: "January/December" for most countries, "July/June" for Pakistan. Missing for 12 of the 13 IMF groups.}
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
#' What the workshop changed: it kept four of the WEO's indicators, gave them
#' plain names, reshaped them to one row per entity and year, and rounded them
#' to three decimals. These data are not an official IMF product.
#'
#' @source International Monetary Fund, World Economic Outlook Database,
#'   October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
#'   `data-raw/weo.R` from the workshop's file `weo_panel.csv`, which is made
#'   from the IMF's workbook `WEOOct2026all.xlsx`.
#'
#' @seealso [weo_groups] for the IMF's own layout of its two big groups;
#'   [wb_groups] to add the World Bank's income levels and regions.
#'
#' @examples
#' # Rows, then columns
#' dim(weo)
#'
#' # The first six rows
#' head(weo)
"weo"
