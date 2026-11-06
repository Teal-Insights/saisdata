# Rebuild `weo_groups`: the IMF's own layout for its two big country groups.
#
# Run it from the package folder, package/saisdata:
#   LANG=en_US.UTF-8 Rscript data-raw/weo_groups.R
# It reads starter/data/weo_2026oct_extract.csv, the workshop's extract of the
# IMF's workbook WEOOct2026all.xlsx, and writes data/weo_groups.rda. It keeps
# six rows and the years 2001 to 2031, renames five columns and writes the
# IMF's SCALE and UNIT in plain words. It changes no number.

library(readr) # read_csv() reads a CSV file into a tibble
library(dplyr) # filter(), mutate(), case_when() and select()
library(stringr) # str_detect() for one of the checks
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/weo_groups.R") # tell here() where this script lives

extract <- read_csv( # read the whole extract, every year as a number
  file = here("..", "..", "starter", "data", "weo_2026oct_extract.csv"),
  col_types = cols( # name each type, so readr guesses nothing
    .default = col_double(), # the 32 year columns hold numbers
    COUNTRY.ID = col_character(), # the IMF's code for the entity
    COUNTRY = col_character(), # the entity's name
    INDICATOR.ID = col_character(), # the IMF's code for the indicator
    INDICATOR = col_character(), # the indicator's full name
    SCALE = col_character(), # Units, Billions or Millions
    UNIT = col_character(), # Percent or US dollar
    METHODOLOGY_NOTES = col_character(), # the IMF's notes
    LATEST_ACTUAL_ANNUAL_DATA = col_character(), # e.g. 2025 or FY2024/25
    START_END_MONTHS_OF_REPORTING_YEAR = col_character() # e.g. July/June
  )
)

weo_groups <- extract |> # start from the extract
  filter( # keep six rows: two groups times three indicators
    COUNTRY.ID %in% c("G110", "G200"), # Advanced; Emerging and Developing
    INDICATOR.ID %in% c("GGXONLB_NGDP", "GGXCNL_NGDP", "NGDPD") # 3 series
  ) |>
  mutate( # write SCALE and UNIT as one plain phrase
    units = case_when( # one phrase per pair the six rows use
      SCALE == "Billions" & UNIT == "US dollar" ~ "Billions of US dollars",
      SCALE == "Units" & UNIT == "Percent" ~ "Percent of GDP"
    )
  ) |>
  select( # keep and rename the columns, in the IMF's order
    group_code = COUNTRY.ID, # G110 or G200
    group = COUNTRY, # the group's name
    indicator = INDICATOR.ID, # the indicator's code
    indicator_name = INDICATOR, # the indicator's full name
    units, # how to read the numbers
    `2001`:`2031` # the years across, as the IMF publishes them
  )

stopifnot( # stop here if the table is not what the help page says
  nrow(problems(extract)) == 0, # every cell of the extract parsed cleanly
  nrow(weo_groups) == 6, # two groups times three indicators
  ncol(weo_groups) == 36, # five text columns and 31 years
  !anyNA(weo_groups$units), # every row got its plain units
  all(str_detect( # the percent rows really are percent of GDP
    weo_groups$indicator_name[weo_groups$units == "Percent of GDP"],
    "Percent of GDP$"
  )),
  !anyNA(select(weo_groups, `2001`:`2031`)) # a number in every year
)

attr(weo_groups, "spec") <- NULL # drop the column types readr attached
attr(weo_groups, "problems") <- NULL # drop readr's parsing report
weo_groups <- as_tibble(weo_groups) # a plain tibble, nothing else attached

use_data(weo_groups, overwrite = TRUE, compress = "xz") # write the .rda
