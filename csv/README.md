# Last-chance copies of the tables

Every table in the package, as a CSV file. They are here for one case: `saisdata` will not install on a laptop, and a class is waiting. One line then reads a table straight from GitHub, with nothing but the tidyverse.

The order to try things in:

1. **A live call** to the IMF or the World Bank, where a lesson shows one. It is always optional.
2. **The package.** `library(saisdata)` holds a saved copy of everything the course uses. It needs no internet once installed.
3. **These files.** They need the internet, and nothing else.

## Read a table

```r
library(tidyverse) # load the tidyverse, which reads CSV files

# where the files live
base <- "https://raw.githubusercontent.com/Teal-Insights/saisdata/main/csv/"

weo <- read_csv(str_c(base, "weo.csv"))                       # the main table
weo_mini <- read_csv(str_c(base, "weo_mini.csv"))             # twelve rows of it
weo_indicators <- read_csv(str_c(base, "weo_indicators.csv")) # what you can ask
weo_full <- read_csv(str_c(base, "weo_full.csv.gz"))          # every indicator
weo_groups <- read_csv(str_c(base, "weo_groups.csv"))         # the IMF's layout
wb_groups <- read_csv(str_c(base, "wb_groups.csv"))           # World Bank groups
```

After that the tables answer to the same names as in the package, and the course's code runs unchanged. One difference: `year` and `latest_actual` come back as numbers that could hold decimals (`<dbl>`), where the package stores whole numbers (`<int>`). No line in the course depends on it.

## The files

| File | Table | Rows | Columns |
|---|---|---|---|
| `weo.csv` | `weo` | 6,720 | 17 |
| `weo_mini.csv` | `weo_mini` | 12 | 9 |
| `weo_indicators.csv` | `weo_indicators` | 44 | 7 |
| `weo_full.csv.gz` | `weo_full` | 238,459 | 7 |
| `weo_groups.csv` | `weo_groups` | 6 | 36 |
| `wb_groups.csv` | `wb_groups` | 217 | 6 |

`weo_full` is gzipped because it is long. `read_csv()` reads it as it reads the others.

## The files for Day 2

The spreadsheet and the eight saved series that `copy_course_files()` copies are in the repository too, under `inst/extdata/`. If the package is missing, read a series from there:

```r
# where the Day 2 files live
day2 <- "https://raw.githubusercontent.com/Teal-Insights/saisdata/main/inst/extdata/"

life <- read_csv(str_c(day2, "wdi_life_expectancy.csv")) # a saved series
```

The spreadsheet is a file to download, not a table to read from a link:

```r
dir.create(here::here("data"), showWarnings = FALSE)   # make the data folder
download.file(                                         # download a file:
  str_c(day2, "wb-country-classification.xlsx"),       # from here
  here::here("data", "wb-country-classification.xlsx"), # to here
  mode = "wb"                                          # as it is, byte for byte
)                                                      # close download.file()
```

## How they are made

`data-raw/csv_export.R` writes them from the package's tables, reads each one back and stops unless it equals the table, cell for cell. `data-raw/rebuild-all.R` runs it last. The folder is not part of the installed package.

The data keep their own terms, as in the package: see [`LICENSE-data.md`](../LICENSE-data.md). These files are not an official IMF or World Bank product.
