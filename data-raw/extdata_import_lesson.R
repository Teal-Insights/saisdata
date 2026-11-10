# Adds two files to inst/extdata/ for the import lesson, as rebuilt to the
# lesson blueprint of 10 November 2026:
#   wdi_remittances.csv       personal remittances received, current US$
#   imf-weo-october-2026.xlsx four indicators in the IMF's own layout
# Run from the package root: Rscript data-raw/extdata_import_lesson.R
# Needs dplyr, readr, tidyr and writexl. The remittances pull needs the
# internet and the wbwdi package; a saved copy of the pull is in
# data-raw/source/, and the script uses it unless SAISDATA_PULL=1 is set.

library(dplyr)
library(readr)

load("data/wb_groups.rda") # the World Bank's 217 countries, with both codes

# 1. Remittances -----------------------------------------------------------
# Personal remittances, received (current US$), World Development Indicators
# series BX.TRF.PWKR.CD.DT, pulled with wbwdi::wdi_get() on 10 November 2026.
pull_file <- "data-raw/source/wdi_remittances_pull.rds"
if (Sys.getenv("SAISDATA_PULL") == "1") {
  pulled <- wbwdi::wdi_get(
    entities = "all", indicators = "BX.TRF.PWKR.CD.DT",
    start_year = 2000, end_year = 2025
  )
  saveRDS(pulled, pull_file)
}
pulled <- readRDS(pull_file)

# Countries only, rows with a value, and the IMF's codes for Kosovo and for
# West Bank and Gaza, as in the other saved series: wb_groups holds both codes
remittances <- pulled |>
  filter(!is.na(value)) |>
  inner_join(
    select(wb_groups, code, wb_code, country),
    by = c("entity_id" = "wb_code")
  ) |>
  transmute(code, country, year, remittances_usd = round(value)) |>
  arrange(code, year)
stopifnot(
  !anyDuplicated(select(remittances, code, year)),
  all(remittances$remittances_usd >= 0),
  n_distinct(remittances$code) > 150
)
write_csv(remittances, "inst/extdata/wdi_remittances.csv")

# 2. The IMF's own layout ----------------------------------------------------
# The Countries sheet of the IMF's workbook has one row for each country and
# indicator, and a column for each year. This file keeps that layout for four
# indicators, the 197 countries and the years 2000 to 2031, from the extract
# of the workbook in data-raw/source/ (see LICENSE-data.md).
extract <- read_csv(
  "data-raw/source/weo_2026oct_extract.csv",
  col_types = cols(.default = col_character())
)
keep <- c("NGDP_RPCH", "PCPIPCH", "LUR", "BCA_NGDPD")
sheet <- extract |>
  filter(INDICATOR.ID %in% keep, !grepl("^G[0-9X]", COUNTRY.ID)) |>
  select(COUNTRY.ID, COUNTRY, INDICATOR.ID, INDICATOR, SCALE, UNIT, `2000`:`2031`) |>
  mutate(across(`2000`:`2031`, as.numeric)) |>
  arrange(COUNTRY.ID, match(INDICATOR.ID, keep))
stopifnot(n_distinct(sheet$COUNTRY.ID) == 197, all(keep %in% sheet$INDICATOR.ID))
notes <- data.frame(
  Note = c(
    "Countries holds four indicators from the International Monetary Fund's World Economic Outlook database, October 2026, in the layout of the IMF's own workbook: one row for each country and indicator, and a column for each year.",
    "The indicators are real GDP growth (NGDP_RPCH), inflation (PCPIPCH), the unemployment rate (LUR) and the current account balance in percent of GDP (BCA_NGDPD), for the years 2000 to 2031.",
    "Source: International Monetary Fund, World Economic Outlook Database, October 2026, https://data.imf.org/en/datasets/IMF.RES:WEO.",
    "Saved for the SAIS MIEF R workshop.",
    "Not an official IMF product."
  ),
  stringsAsFactors = FALSE
)
writexl::write_xlsx(
  list(Countries = as.data.frame(sheet), Notes = notes),
  "inst/extdata/imf-weo-october-2026.xlsx"
)
