# Rebuild `weo`: the tidy World Economic Outlook panel, October 2026.
#
# Run it from the package folder, package/saisdata:
#   LANG=en_US.UTF-8 Rscript data-raw/weo.R
# It reads starter/data/weo_panel.csv (made by starter/prep/prepare_data.R)
# and writes data/weo.rda. It changes no value: same rows, same columns.

library(readr) # read_csv() reads a CSV file into a tibble
library(dplyr) # as_tibble() and n_distinct() for the checks
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/weo.R") # tell here() where this script lives

weo <- read_csv( # read the panel, giving every column its type
  file = here("..", "..", "starter", "data", "weo_panel.csv"), # the file
  col_types = cols( # name each type, so readr guesses nothing
    code = col_character(), # the entity's code, such as KEN or G110
    name = col_character(), # the entity's name, as the IMF writes it
    year = col_integer(), # the year, 2000 to 2031
    gross_debt = col_double(), # gross debt, percent of GDP
    primary_balance = col_double(), # primary balance, percent of GDP
    overall_balance = col_double(), # overall balance, percent of GDP
    gdp_usd_bn = col_double(), # GDP, billions of US dollars
    latest_actual = col_integer(), # last year with actual fiscal data
    fiscal_year = col_character() # months of the year, e.g. July/June
  )
)

stopifnot( # stop here if the file is not what the help page says
  nrow(problems(weo)) == 0, # every cell parsed cleanly
  nrow(weo) == 6720, # 210 entities times 32 years
  ncol(weo) == 9, # the nine columns of the panel
  n_distinct(weo$code) == 210, # 197 countries and 13 IMF groups
  min(weo$year) == 2000, # the first year
  max(weo$year) == 2031 # the last year, the furthest projection
)

attr(weo, "spec") <- NULL # drop the column types readr attached
attr(weo, "problems") <- NULL # drop readr's parsing report
weo <- as_tibble(weo) # a plain tibble, nothing else attached

use_data(weo, overwrite = TRUE, compress = "xz") # write data/weo.rda
