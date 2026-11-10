# Builds the files in inst/extdata/ for the Day 2 import lesson.
# Run from the package root: Rscript data-raw/extdata.R
# Needs the package's own data (load_all or an installed copy) and writexl.

load("data/wb_groups.rda") # the World Bank's country groups, as a table

# 1. A spreadsheet laid out the way official files often arrive: a title and
#    a source note above the table, the World Bank's own column names and its
#    own country codes, and a second sheet of notes.
header <- c("Economy", "Code", "Region", "Income group", "Lending category")
body <- data.frame(
  wb_groups$country, wb_groups$wb_code, wb_groups$region,
  wb_groups$income_level, wb_groups$lending_type,
  stringsAsFactors = FALSE
)
names(body) <- paste0("X", 1:5)
top <- data.frame(
  X1 = c(
    "World Bank country and lending groups",
    "Source: The World Bank, World Development Indicators, as served on 3 November 2026 (CC BY 4.0).",
    NA,
    header[1]
  ),
  X2 = c(NA, NA, NA, header[2]),
  X3 = c(NA, NA, NA, header[3]),
  X4 = c(NA, NA, NA, header[4]),
  X5 = c(NA, NA, NA, header[5]),
  stringsAsFactors = FALSE
)
notes <- data.frame(
  Note = c(
    "Code is the World Bank's own three-letter code. It differs from the IMF's for Kosovo (XKX here, KOS at the IMF) and for West Bank and Gaza (PSE here, WBG at the IMF).",
    "Income group and lending category are the World Bank's, as served on 3 November 2026.",
    "Saved for the SAIS MIEF R workshop. Not an official World Bank product."
  ),
  stringsAsFactors = FALSE
)
writexl::write_xlsx(
  list(`List of economies` = rbind(top, body), Notes = notes),
  "inst/extdata/wb-country-classification.xlsx",
  col_names = FALSE
)

# 2. The eight saved series are copied as they are from the workshop's
#    repository (starter/data/extra/), where data-raw scripts built them on
#    3 November 2026. Their sources and terms are in LICENSE-data.md.
