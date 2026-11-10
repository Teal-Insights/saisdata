# Rebuild `weo_indicators`: one row per indicator in `weo_full`, with what it
# measures in plain words.
#
# Run it from the package folder, after data-raw/weo_full.R:
#   LANG=en_US.UTF-8 Rscript data-raw/weo_indicators.R
# It reads data/weo_full.rda and data-raw/source/weo_indicator_notes.csv, counts
# the countries that report each indicator, and writes data/weo_indicators.rda.

library(readr) # read_csv() reads a CSV file into a tibble
library(dplyr) # group_by(), summarize(), left_join() and select()
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/weo_indicators.R") # tell here() where this script lives

load(here("data", "weo_full.rda")) # the long table this one describes

notes <- read_csv( # the topic, units and description written for the course
  file = here("data-raw", "source", "weo_indicator_notes.csv"), # the file
  col_types = cols(.default = col_character()) # every column is text
)

coverage <- weo_full |> # start from the long table
  group_by(indicator, indicator_name) |> # one group per indicator
  summarize( # collapse each group to one row
    countries = n_distinct(code), # how many countries report it
    .groups = "drop" # and drop the grouping
  )

weo_indicators <- notes |> # start from the notes, which set the order
  left_join(coverage, by = "indicator") |> # add the IMF's name and the count
  select( # the seven columns, in order
    indicator, # the IMF's code, as in weo_full
    indicator_name, # the IMF's name
    topic, # what the indicator is about
    units, # the units, in plain words
    description, # what it measures, in one line
    countries, # how many of the 197 countries report it
    weo_column # its column in weo, where it has one
  )

stopifnot( # stop here if the table is not what the help page says
  nrow(weo_indicators) == 44, # the 44 indicators
  setequal(weo_indicators$indicator, unique(weo_full$indicator)), # all of them
  !anyNA(weo_indicators[, c("indicator_name", "topic", "units", "description", "countries")]),
  sum(!is.na(weo_indicators$weo_column)) == 12, # twelve are columns of weo
  all(nchar(weo_indicators$description) <= 180) # each description is one line
)

attr(weo_indicators, "spec") <- NULL # drop the column types readr attached
attr(weo_indicators, "problems") <- NULL # drop readr's parsing report
weo_indicators <- as_tibble(weo_indicators) # a plain tibble

use_data(weo_indicators, overwrite = TRUE, compress = "xz") # write the .rda
