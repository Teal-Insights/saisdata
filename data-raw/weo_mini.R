# Rebuild `weo_mini`: twelve rows of `weo` that fit on one screen.
#
# Run it from the package folder, after data-raw/weo.R:
#   LANG=en_US.UTF-8 Rscript data-raw/weo_mini.R
# It reads data/weo.rda, keeps six countries, two years and nine columns, and
# writes data/weo_mini.rda. It changes no value: every row is a row of weo.

library(dplyr) # filter(), select() and arrange()
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/weo_mini.R") # tell here() where this script lives

load(here("data", "weo.rda")) # the panel this table is cut from

weo_mini <- weo |> # start from the panel
  filter( # keep twelve rows:
    code %in% c("BRA", "DEU", "GHA", "KEN", "NGA", "PAK"), # six countries
    year %in% c(2015, 2025) # in two years, ten years apart
  ) |>
  select( # keep nine columns: who, when, and six indicators
    code, name, year, # the country and the year
    gross_debt, primary_balance, overall_balance, # the government's books
    real_gdp_growth, inflation, gdp_per_capita_usd # growth, prices, incomes
  ) |>
  arrange(code, year) # by country, then year

stopifnot( # stop here if the table is not what the help page says
  nrow(weo_mini) == 12, # six countries times two years
  ncol(weo_mini) == 9, # the nine columns
  !anyNA(weo_mini), # every cell has a value
  n_distinct(weo_mini$code) == 6 # the six countries
)

weo_mini <- as_tibble(weo_mini) # a plain tibble, nothing else attached

use_data(weo_mini, overwrite = TRUE, compress = "xz") # write data/weo_mini.rda
