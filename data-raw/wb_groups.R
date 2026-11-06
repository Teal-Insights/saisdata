# Rebuild `wb_groups`: the World Bank's country groups.
#
# Run it from the package folder:
#   LANG=en_US.UTF-8 Rscript data-raw/wb_groups.R
# It reads data-raw/source/wb_country_groups.csv (the World Bank's classification,
# served by wbwdi::wdi_get_entities() on 3 November 2026) and writes
# data/wb_groups.rda. It changes no value: same rows, same columns.

library(readr) # read_csv() reads a CSV file into a tibble
library(dplyr) # as_tibble() and n_distinct() for the checks
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/wb_groups.R") # tell here() where this script lives

wb_groups <- read_csv( # read the groups, every column as text
  file = here("data-raw", "source", "wb_country_groups.csv"),
  col_types = cols(.default = col_character()) # six text columns
)

stopifnot( # stop here if the file is not what the help page says
  nrow(problems(wb_groups)) == 0, # every cell parsed cleanly
  nrow(wb_groups) == 217, # 217 countries, no aggregates
  ncol(wb_groups) == 6, # code, wb_code, country, region, income, lending
  n_distinct(wb_groups$code) == 217 # one row per country
)

attr(wb_groups, "spec") <- NULL # drop the column types readr attached
attr(wb_groups, "problems") <- NULL # drop readr's parsing report
wb_groups <- as_tibble(wb_groups) # a plain tibble, nothing else attached

use_data(wb_groups, overwrite = TRUE, compress = "xz") # write the .rda
