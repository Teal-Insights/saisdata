# Rebuild every table in data/ from the files in data-raw/source/.
#
# Run it from the package folder, in a clean clone or anywhere else:
#   LANG=en_US.UTF-8 Rscript data-raw/rebuild-all.R
# It needs readr, dplyr, tidyr, stringr, here and usethis, and no internet.
# Then data-raw/compare-tables.R checks the result against the baseline.

stopifnot( # stop here if this is not the package folder
  file.exists("DESCRIPTION"),
  file.exists(file.path("data-raw", "source", "weo_2026oct_extract.csv")),
  file.exists(file.path("data-raw", "source", "weo_2026oct_imfweo.csv.gz"))
)

scripts <- c( # in this order: a table comes after the ones it is made from
  "weo_panel.R", # extract to data-raw/source/weo_panel.csv
  "weo.R", # panel and imfweo download to data/weo.rda
  "weo_mini.R", # twelve rows of weo to data/weo_mini.rda
  "weo_full.R", # imfweo download to data/weo_full.rda
  "weo_indicators.R", # weo_full and the notes to data/weo_indicators.rda
  "weo_groups.R", # extract to data/weo_groups.rda
  "wb_groups.R" # World Bank file to data/wb_groups.rda
)

for (script in scripts) { # run each one in its own empty environment
  message("Running data-raw/", script)
  source(file.path("data-raw", script), local = new.env())
}
