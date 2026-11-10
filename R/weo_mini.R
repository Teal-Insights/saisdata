#' A mini table you can see whole: twelve rows of `weo`
#'
#' Six countries in two years, with six indicators: twelve rows of [weo], small
#' enough to read every cell. Use it to try a line of code where you can check
#' the answer by eye, then run the same line on [weo].
#'
#' Every row here is a row of `weo`, with the same column names and the same
#' numbers, so what works on one works on the other. The countries are Brazil,
#' Germany, Ghana, Kenya, Nigeria and Pakistan, and the years are 2015 and 2025.
#'
#' @format A tibble with 12 rows and 9 variables:
#' \describe{
#'   \item{code}{chr The country's three-letter ISO code, such as `KEN`.}
#'   \item{name}{chr The country's name, as the IMF writes it.}
#'   \item{year}{int The year: 2015 or 2025.}
#'   \item{gross_debt}{dbl Gross debt of the general government, in percent of GDP.}
#'   \item{primary_balance}{dbl The primary balance, in percent of GDP. Negative means a deficit.}
#'   \item{overall_balance}{dbl The overall balance, in percent of GDP. Negative means a deficit.}
#'   \item{real_gdp_growth}{dbl Real GDP growth, in percent.}
#'   \item{inflation}{dbl Inflation, average consumer prices, in percent.}
#'   \item{gdp_per_capita_usd}{dbl GDP per person at current prices, in US dollars.}
#' }
#'
#' @inheritSection weo Vintage
#'
#' @section Transformations:
#' `data-raw/weo_mini.R` keeps twelve rows and nine columns of [weo]. It changes
#' no value.
#'
#' @inheritSection weo Credit
#'
#' @inheritSection weo Terms of use
#'
#' @source International Monetary Fund, World Economic Outlook Database,
#'   October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
#'   `data-raw/weo_mini.R` from [weo].
#'
#' @seealso [weo], the full panel these rows come from.
#'
#' @examplesIf requireNamespace("tidyverse", quietly = TRUE)
#' library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more
#'
#' # The whole table: twelve rows, nine columns
#' weo_mini
#'
#' # Try a verb where you can check it by eye: debt above 60 percent of GDP
#' weo_mini |>                # start with the mini table, and then
#'   filter(gross_debt > 60)  # keep the rows that pass the test
#'
#' # Then ask something new: where did prices rise faster than output?
#' weo_mini |>                           # start with the mini table, and then
#'   filter(year == 2025) |>             # keep 2025, and then
#'   filter(inflation > real_gdp_growth) # keep inflation above growth
#'
#' # The same line works on the full panel
#' weo |>                                # start with the full panel, and then
#'   filter(year == 2025) |>             # keep 2025, and then
#'   filter(inflation > real_gdp_growth) # keep inflation above growth
"weo_mini"
