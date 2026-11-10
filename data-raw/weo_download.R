# Download the October 2026 World Economic Outlook with imfweo, and save it.
#
# This is the one script here that needs the internet. Run it from the package
# folder, once per release:
#   LANG=en_US.UTF-8 Rscript data-raw/weo_download.R
# It needs imfweo 0.2.0.9000 or later, the first build that knows the October
# 2026 release:
#   install.packages("imfweo", repos = "https://teal-insights.r-universe.dev")
# It writes data-raw/source/weo_2026oct_imfweo.csv.gz: what weo_get() returned,
# every entity and every series, 2000 to 2031, one row per value, with each
# number written in its shortest form (-0.709, where the IMF's file holds
# -0.70899999999999996). No value changes at three decimals.
# data-raw/rebuild-all.R reads that file and needs no internet.

library(imfweo) # weo_get() downloads a WEO release
library(readr) # write_csv() writes the table, gzipped
library(here) # here() builds paths from the package folder

here::i_am("data-raw/weo_download.R") # tell here() where this script lives

stopifnot( # stop here unless this imfweo knows the release
  utils::packageVersion("imfweo") >= "0.2.0.9000"
)

pull <- weo_get( # download one release
  year = 2026, # the 2026 edition
  release = "Fall", # the October release
  start_year = 2000 # the package's tables start in 2000
)

stopifnot( # stop here if the download is not the shape the build expects
  identical(
    names(pull),
    c("entity_name", "entity_id", "series_name", "units", "series_id", "year", "value")
  ),
  min(pull$year) == 2000, # the first year
  max(pull$year) == 2031, # the last year, the furthest projection
  length(unique(pull$entity_id)) == 210, # 197 countries and 13 IMF groups
  !anyNA(pull$value) # weo_get() returns a row only where the IMF has a value
)

write_csv( # save the pull, gzipped, as it came
  pull,
  here("data-raw", "source", "weo_2026oct_imfweo.csv.gz")
)
