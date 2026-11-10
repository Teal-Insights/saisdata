#' World Economic Outlook, October 2026: every indicator, for every country
#'
#' The whole of the IMF's World Economic Outlook (WEO) database of October 2026
#' for the 197 countries, tidy and long: one row is one country, one indicator
#' and one year. It holds all 44 indicators the IMF publishes for countries,
#' from 2000 to 2031: growth, prices, jobs, trade, saving, investment and the
#' government's books.
#'
#' [weo_indicators] lists the 44 indicators with what each one measures. Start
#' there to find what you can ask. [weo] has twelve of them already laid out as
#' columns, which is easier for a first analysis.
#'
#' A row exists only where the IMF has a value. A country and year the IMF
#' leaves blank has no row here, where [weo] would show `NA`. So count the
#' years a country has before you chart it.
#'
#' The last years are IMF projections. For most countries the numbers are
#' actual through 2024 or 2025; `latest_actual` in [weo] says where the fiscal
#' data stop.
#'
#' @format A tibble with 238,459 rows and 7 variables:
#' \describe{
#'   \item{code}{chr The country's three-letter ISO code (the IMF uses `KOS` for Kosovo and `WBG` for West Bank and Gaza). It matches `code` in [weo] and [wb_groups].}
#'   \item{name}{chr The country's name, as the IMF writes it, such as "Egypt, Arab Republic of".}
#'   \item{indicator}{chr The IMF's code for the indicator, such as `NGDP_RPCH` for real GDP growth. [weo_indicators] explains each code.}
#'   \item{indicator_name}{chr The indicator's full name, as the IMF writes it.}
#'   \item{units}{chr How to read the number, in plain words, such as "Percent of GDP" or "Billions of US dollars".}
#'   \item{year}{int The year, 2000 to 2031.}
#'   \item{value}{dbl The number, in the units the row names.}
#' }
#'
#' @inheritSection weo Vintage
#'
#' @section Transformations:
#' `data-raw/weo_download.R` downloaded the release with the
#' [imfweo](https://github.com/Teal-Insights/r-imfweo) package and saved it.
#' `data-raw/weo_full.R` keeps the 197 countries (the 13 IMF groups are in
#' [weo]), renames the columns, writes the units in plain words from the IMF's
#' own scale and unit, and rounds to three decimals. For the 13 indicators it
#' shares with the IMF's workbook extract, `data-raw/weo.R` checks the download
#' cell by cell: no number differs.
#'
#' @section Credit:
#' Print this line under every chart you make from these data:
#'
#' Source: International Monetary Fund, World Economic Outlook Database,
#' October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>.
#'
#' @inheritSection weo Terms of use
#'
#' @source International Monetary Fund, World Economic Outlook Database,
#'   October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>, downloaded
#'   with `imfweo::weo_get(year = 2026, release = "Fall")`. Built by
#'   `data-raw/weo_full.R` from `data-raw/source/weo_2026oct_imfweo.csv.gz`.
#'
#' @seealso [weo_indicators] for what each indicator measures; [weo] for twelve
#'   indicators laid out as columns.
#'
#' @examplesIf requireNamespace("tidyverse", quietly = TRUE)
#' library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more
#'
#' # One row per country, indicator and year
#' weo_full
#'
#' # Investment as a share of GDP in 2025: who invests the most?
#' weo_full |>                        # start with the long table, and then
#'   filter(indicator == "NID_NGDP") |> # keep one indicator, and then
#'   filter(year == 2025) |>          # keep one year, and then
#'   arrange(desc(value)) |>          # sort, largest first, and then
#'   select(name, units, value)       # keep the columns to read
#'
#' # Saving and investment side by side for one country: indicators up into columns
#' weo_full |>                                  # start with the long table, then
#'   filter(code == "IDN") |>                   # keep Indonesia, and then
#'   filter(indicator %in% c("NGSD_NGDP", "NID_NGDP")) |> # two indicators
#'   select(year, indicator, value) |>          # keep what the pivot needs
#'   pivot_wider(                               # send the indicators up:
#'     names_from = indicator,                  # one column per indicator
#'     values_from = value                      # filled from value
#'   )                                          # close pivot_wider()
"weo_full"
