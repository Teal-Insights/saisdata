# Rebuild data-raw/source/weo_panel.csv from the IMF extract.
#
# Run it from the package folder:
#   LANG=en_US.UTF-8 Rscript data-raw/weo_panel.R
# It reads data-raw/source/weo_2026oct_extract.csv, keeps four indicators, makes
# one row per entity and year, adds two facts about each entity's fiscal year,
# rounds to three decimals and writes the panel. data-raw/weo.R turns the panel
# into data/weo.rda.

library(readr) # read_csv() and write_csv()
library(dplyr) # filter(), mutate(), select() and left_join()
library(tidyr) # pivot_longer() and pivot_wider()
library(stringr) # str_extract() and str_detect()
library(here) # here() builds paths from the package folder

here::i_am("data-raw/weo_panel.R") # tell here() where this script lives

raw <- read_csv( # read the extract, giving every column its type
  file = here("data-raw", "source", "weo_2026oct_extract.csv"), # the file
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

# The IMF gives two facts about each entity's fiscal numbers in the overall
# balance's row: the months of its fiscal year, and the last year with actual
# data. A label such as FY2024/25 spans two calendar years, and the IMF's notes
# say how the WEO turns it into one:
#   FY(t-1/t) = CY(t) shows FY2024/25 as 2025, the year it ends.
#   A weighted average of two fiscal years needs the later one too, so the latest
#   actual year is the year FY2024/25 starts, 2024.
#   With no formula, an October to September year counts as the year it ends, like
#   every other October to September country in the file; any other, as the year
#   it starts.
fiscal_facts <- raw |> # start from the extract
  filter(INDICATOR.ID == "GGXCNL_NGDP") |> # one row per entity
  transmute( # keep the three columns that matter here
    code = COUNTRY.ID, # the entity's code
    fiscal_year = START_END_MONTHS_OF_REPORTING_YEAR, # e.g. July/June
    label = LATEST_ACTUAL_ANNUAL_DATA, # e.g. 2025 or FY2024/25
    notes = replace_na(METHODOLOGY_NOTES, "") # the IMF's notes, or nothing
  ) |>
  mutate( # work out the calendar year the label stands for
    first_year = as.integer(str_extract(label, "[0-9]{4}")), # the first year
    weighted = str_detect(notes, "weighted average|\\*FY\\("), # two years mixed
    ends_formula = str_detect(notes, "FY\\(t-1/t\\) ?= ?CY\\(t\\)") & !weighted,
    starts_formula = str_detect(notes, "FY\\(t/t\\+1\\) ?= ?CY\\(t\\)") & !weighted,
    no_formula = !weighted & !ends_formula & !starts_formula, # the notes say none
    shown_as_end_year = str_detect(label, "^FY") & # a fiscal-year label, and
      (ends_formula | (no_formula & fiscal_year == "October/September")),
    latest_actual = if_else(shown_as_end_year, first_year + 1L, first_year)
  ) |>
  select(code, latest_actual, fiscal_year) # keep what the panel needs

plain_names <- c( # the four indicators, with their plain names
  GGXWDG_NGDP = "gross_debt", # gross debt, percent of GDP
  GGXONLB_NGDP = "primary_balance", # primary balance, percent of GDP
  GGXCNL_NGDP = "overall_balance", # overall balance, percent of GDP
  NGDPD = "gdp_usd_bn" # GDP, billions of US dollars
)

panel <- raw |> # start from the extract again
  filter(INDICATOR.ID %in% names(plain_names)) |> # keep the four indicators
  select( # keep the identifiers and the years
    code = COUNTRY.ID, # the entity's code
    name = COUNTRY, # the entity's name
    indicator = INDICATOR.ID, # the indicator's code
    `2000`:`2031` # the years across
  ) |>
  pivot_longer( # the years go from columns to rows
    cols = `2000`:`2031`, # every year column
    names_to = "year", # the column names become a year column
    values_to = "value", # the numbers go into a value column
    names_transform = as.integer # "2025" becomes the number 2025
  ) |>
  mutate(indicator = unname(plain_names[indicator])) |> # plain names
  pivot_wider(names_from = indicator, values_from = value) |> # one per column
  left_join(fiscal_facts, by = "code") |> # add the two fiscal facts
  select( # the panel's nine columns, in order
    code, name, year,
    gross_debt, primary_balance, overall_balance, gdp_usd_bn,
    latest_actual, fiscal_year
  ) |>
  mutate(across( # three decimals, the precision the IMF publishes
    c(gross_debt, primary_balance, overall_balance, gdp_usd_bn),
    \(x) round(x, 3)
  ))

stopifnot( # stop here if the panel is not what the help page says
  nrow(problems(raw)) == 0, # every cell of the extract parsed cleanly
  nrow(panel) == 6720, # 210 entities times 32 years
  ncol(panel) == 9 # the nine columns of the panel
)

write_csv( # write the panel, with empty cells where the IMF has no value
  panel,
  here("data-raw", "source", "weo_panel.csv"),
  na = ""
)
