# Rebuild `weo_full`: the whole October 2026 World Economic Outlook for
# countries, tidy and long.
#
# Run it from the package folder:
#   LANG=en_US.UTF-8 Rscript data-raw/weo_full.R
# It reads data-raw/source/weo_2026oct_imfweo.csv.gz (saved by
# data-raw/weo_download.R from imfweo) and data-raw/source/weo_indicator_notes.csv
# (plain-language units), keeps the 197 countries, rounds to three decimals and
# writes data/weo_full.rda.

library(readr) # read_csv() reads a CSV file into a tibble
library(dplyr) # filter(), mutate(), select() and left_join()
library(stringr) # str_detect() tells a country's code from a group's
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/weo_full.R") # tell here() where this script lives

pull <- read_csv( # read the saved download, giving every column its type
  file = here("data-raw", "source", "weo_2026oct_imfweo.csv.gz"), # the file
  col_types = cols( # name each type, so readr guesses nothing
    entity_name = col_character(), # the country's or group's name
    entity_id = col_character(), # ISO code for a country, digits for a group
    series_name = col_character(), # the IMF's name for the indicator
    units = col_character(), # the IMF's unit, missing for some indicators
    series_id = col_character(), # the IMF's code for the indicator
    year = col_integer(), # the year, 2000 to 2031
    value = col_double() # the number
  )
)

notes <- read_csv( # read the plain-language units for each indicator
  file = here("data-raw", "source", "weo_indicator_notes.csv"), # the file
  col_types = cols(.default = col_character()) # every column is text
)

weo_full <- pull |> # start from the download
  filter(str_detect(entity_id, "^[A-Z]{3}$")) |> # keep countries: ISO codes
  left_join( # add the plain-language units
    select(notes, series_id = indicator, plain_units = units),
    by = "series_id"
  ) |>
  transmute( # the seven columns, in order, with plain names
    code = entity_id, # the country's three-letter code
    name = entity_name, # the country's name, as the IMF writes it
    indicator = series_id, # the IMF's code for the indicator
    indicator_name = series_name, # the IMF's name for the indicator
    units = plain_units, # the units, in plain words
    year = year, # the year
    value = round(value, 3) # three decimals, the precision the IMF publishes
  ) |>
  arrange(code, indicator, year) # by country, then indicator, then year

stopifnot( # stop here if the table is not what the help page says
  nrow(problems(pull)) == 0, # every cell of the download parsed cleanly
  nrow(weo_full) == 238459, # one row per value the IMF publishes for a country
  ncol(weo_full) == 7, # the seven columns
  n_distinct(weo_full$code) == 197, # the 197 countries
  n_distinct(weo_full$indicator) == 44, # the 44 indicators
  !anyNA(weo_full), # no missing cell: a missing value has no row
  min(weo_full$year) == 2000, # the first year
  max(weo_full$year) == 2031, # the last year, the furthest projection
  !any(duplicated(weo_full[, c("code", "indicator", "year")])) # one row each
)

attr(weo_full, "spec") <- NULL # drop the column types readr attached
attr(weo_full, "problems") <- NULL # drop readr's parsing report
weo_full <- as_tibble(weo_full) # a plain tibble, nothing else attached

use_data(weo_full, overwrite = TRUE, compress = "xz") # write data/weo_full.rda
