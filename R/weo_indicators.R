#' What you can ask of the World Economic Outlook: its 44 indicators
#'
#' One row for each indicator in [weo_full], with what it measures in plain
#' words. This is where to look first when you have a question and do not know
#' whether the data can answer it.
#'
#' The indicators are grouped by topic: growth and size, living standards,
#' prices, people and jobs, trade and payments, saving and investment, and
#' government finances. `countries` says how many of the 197 countries report
#' each one, because coverage differs: every country reports growth, and fewer
#' than half report net debt.
#'
#' @format A tibble with 44 rows and 7 variables:
#' \describe{
#'   \item{indicator}{chr The IMF's code for the indicator, as in [weo_full], such as `NGDP_RPCH`.}
#'   \item{indicator_name}{chr The indicator's full name, as the IMF writes it.}
#'   \item{topic}{chr What the indicator is about, one of seven topics, such as "Prices".}
#'   \item{units}{chr How to read the numbers, in plain words, such as "Percent of GDP".}
#'   \item{description}{chr What the indicator measures, in one line of plain language.}
#'   \item{countries}{int How many of the 197 countries report the indicator for at least one year.}
#'   \item{weo_column}{chr The indicator's column in [weo], such as `real_gdp_growth`, for the twelve that have one. Missing (`NA`) for the other 32.}
#' }
#'
#' @inheritSection weo Vintage
#'
#' @section Transformations:
#' The codes, names and country counts come from [weo_full]. The topics, the
#' plain-language units and the descriptions were written for this workshop:
#' the units restate the IMF's own scale and unit, and the descriptions are the
#' workshop's, not the IMF's. They are in
#' `data-raw/source/weo_indicator_notes.csv`.
#'
#' @inheritSection weo_full Credit
#'
#' @inheritSection weo Terms of use
#'
#' @source International Monetary Fund, World Economic Outlook Database,
#'   October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
#'   `data-raw/weo_indicators.R` from [weo_full] and
#'   `data-raw/source/weo_indicator_notes.csv`.
#'
#' @seealso [weo_full], the table these indicators describe.
#'
#' @examplesIf requireNamespace("tidyverse", quietly = TRUE)
#' library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more
#'
#' # The topics, and how many indicators each has
#' weo_indicators |> # start with the indicators, and then
#'   count(topic)    # count the rows in each topic
#'
#' # What can I ask about prices?
#' weo_indicators |>                          # start with the indicators, and then
#'   filter(topic == "Prices") |>             # keep one topic, and then
#'   select(indicator, units, description)    # keep the columns to read
#'
#' # Find an indicator by a word in its description
#' weo_indicators |>                                  # start with the indicators
#'   filter(str_detect(description, "living standards")) |> # search the text
#'   select(indicator, description)                   # keep the columns to read
"weo_indicators"
