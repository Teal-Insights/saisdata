# Rebuild `weo`: the tidy World Economic Outlook panel, October 2026.
#
# Run it from the package folder:
#   LANG=en_US.UTF-8 Rscript data-raw/weo.R
# It reads three files in data-raw/source/:
#   weo_panel.csv (made by data-raw/weo_panel.R): the panel's first nine columns.
#   weo_2026oct_imfweo.csv.gz (saved by data-raw/weo_download.R): eight more
#     indicators, from the imfweo package.
#   weo_2026oct_extract.csv: the IMF's workbook, to check the download against.
# It writes data/weo.rda. The first nine columns are the panel's, unchanged: same
# rows, same order, same numbers.

library(readr) # read_csv() reads a CSV file into a tibble
library(dplyr) # filter(), mutate(), select(), left_join() and the checks
library(tidyr) # pivot_longer() and pivot_wider()
library(stringr) # str_detect() and str_c()
library(here) # here() builds paths from the package folder
library(usethis) # use_data() saves the tibble into data/

here::i_am("data-raw/weo.R") # tell here() where this script lives

panel <- read_csv( # read the panel, giving every column its type
  file = here("data-raw", "source", "weo_panel.csv"), # the file
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
) |>
  mutate( # give each entity the code the panel uses
    code = case_when( # imfweo numbers the groups; the panel's codes start with G
      str_detect(entity_id, "^[A-Z]{3}$") ~ entity_id, # a country keeps its code
      entity_id == "123" ~ "GX123", # Other Advanced Economies
      .default = str_c("G", entity_id) # every other group: G and its number
    ),
    value = round(value, 3) # three decimals, the precision the IMF publishes
  )

old_names <- c( # the four indicators already in the panel
  GGXWDG_NGDP = "gross_debt", # gross debt, percent of GDP
  GGXONLB_NGDP = "primary_balance", # primary balance, percent of GDP
  GGXCNL_NGDP = "overall_balance", # overall balance, percent of GDP
  NGDPD = "gdp_usd_bn" # GDP, billions of US dollars
)

new_names <- c( # the eight indicators this script adds, with their plain names
  NGDP_RPCH = "real_gdp_growth", # real GDP, percent change
  PCPIPCH = "inflation", # average consumer prices, percent change
  LUR = "unemployment_rate", # percent of the labor force
  BCA_NGDPD = "current_account_balance", # percent of GDP
  NGDPDPC = "gdp_per_capita_usd", # GDP per person, US dollars
  LP = "population_mn", # millions of people
  GGR_NGDP = "revenue", # general government revenue, percent of GDP
  GGX_NGDP = "expenditure" # general government spending, percent of GDP
)

# Check 1: the download and the panel name the same 210 entities.
entities <- distinct(pull, code, name = entity_name) # the download's entities
stopifnot( # stop here if any code or name differs
  identical(arrange(entities, code), arrange(distinct(panel, code, name), code))
)

# Check 2: where the download overlaps the panel, the numbers agree, cell by cell.
overlap <- pull |> # start from the download
  filter(series_id %in% names(old_names)) |> # keep the four panel indicators
  transmute(code, year, column = unname(old_names[series_id]), download = value)
in_panel <- panel |> # start from the panel
  select(code, year, all_of(unname(old_names))) |> # its four numeric columns
  pivot_longer( # one row per cell
    cols = all_of(unname(old_names)),
    names_to = "column",
    values_to = "panel"
  ) |>
  filter(!is.na(panel)) # the download has a row only where there is a value
both <- full_join(in_panel, overlap, by = c("code", "year", "column")) # line up
stopifnot( # stop here if a cell is missing on one side, or differs
  !anyNA(both$panel), !anyNA(both$download), all(both$panel == both$download)
)

# Check 3: where the download overlaps the IMF's workbook, the numbers agree.
extract <- read_csv( # read the extract of the workbook
  file = here("data-raw", "source", "weo_2026oct_extract.csv"), # the file
  col_types = cols( # name each type, so readr guesses nothing
    .default = col_double(), # the 32 year columns hold numbers
    COUNTRY.ID = col_character(), COUNTRY = col_character(),
    INDICATOR.ID = col_character(), INDICATOR = col_character(),
    SCALE = col_character(), UNIT = col_character(),
    METHODOLOGY_NOTES = col_character(),
    LATEST_ACTUAL_ANNUAL_DATA = col_character(),
    START_END_MONTHS_OF_REPORTING_YEAR = col_character()
  )
) |>
  select(code = COUNTRY.ID, series_id = INDICATOR.ID, `2000`:`2031`) |>
  pivot_longer( # the years go from columns to rows
    cols = `2000`:`2031`,
    names_to = "year",
    values_to = "workbook",
    names_transform = as.integer
  ) |>
  filter(!is.na(workbook)) |> # keep the cells with a value
  mutate(workbook = round(workbook, 3)) # three decimals, as above
against_workbook <- full_join( # line the two sources up, cell by cell
  extract,
  pull |> # the same indicators, from the download
    filter(series_id %in% unique(extract$series_id)) |>
    select(code, series_id, year, download = value),
  by = c("code", "series_id", "year")
)
stopifnot( # stop here if a cell is missing on one side, or differs
  all(names(new_names) %in% extract$series_id), # the extract has all eight
  !anyNA(against_workbook$workbook), !anyNA(against_workbook$download),
  all(against_workbook$workbook == against_workbook$download)
)

added <- pull |> # start from the download
  filter(series_id %in% names(new_names)) |> # keep the eight new indicators
  transmute(code, year, column = unname(new_names[series_id]), value) |>
  pivot_wider(names_from = column, values_from = value) |> # one per column
  select(code, year, all_of(unname(new_names))) # in the order above

weo <- panel |> # start from the panel: its nine columns, rows and order
  left_join(added, by = c("code", "year")) # add the eight new columns

# Check 4: the new columns hang together with the old ones, for countries.
countries <- filter(weo, str_detect(code, "^[A-Z]{3}$")) # the 197 countries
balance_gap <- countries |> # revenue minus spending is the overall balance
  filter(!is.na(revenue), !is.na(expenditure), !is.na(overall_balance)) |>
  mutate(gap = abs(revenue - expenditure - overall_balance)) |>
  pull(gap)
stopifnot( # stop here unless every country-year agrees to rounding
  max(balance_gap) <= 0.0021
)

stopifnot( # stop here if the table is not what the help page says
  nrow(problems(panel)) == 0, # every cell of the panel parsed cleanly
  nrow(problems(pull)) == 0, # and of the download
  nrow(weo) == 6720, # 210 entities times 32 years
  ncol(weo) == 17, # the panel's nine columns and eight more
  identical(names(weo)[1:9], names(panel)), # the first nine are the panel's,
  all(vapply( # column by column, with not one value changed
    names(panel),
    function(column) identical(weo[[column]], panel[[column]]),
    logical(1)
  )),
  n_distinct(weo$code) == 210, # 197 countries and 13 IMF groups
  min(weo$year) == 2000, # the first year
  max(weo$year) == 2031 # the last year, the furthest projection
)

attr(weo, "spec") <- NULL # drop the column types readr attached
attr(weo, "problems") <- NULL # drop readr's parsing report
weo <- as_tibble(weo) # a plain tibble, nothing else attached

use_data(weo, overwrite = TRUE, compress = "xz") # write data/weo.rda
