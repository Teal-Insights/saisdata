# Copy the course's files into your project

Copies every file listed by
[`sais_example()`](https://teal-insights.github.io/saisdata/reference/sais_example.md)
into a folder of your project, and makes the folder if it is not there
yet. After that the files are yours: read them with
[`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html)
or
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html),
as you would a file you downloaded. Nothing is fetched from the
internet.

## Usage

``` r
copy_course_files(to = "data", overwrite = TRUE)
```

## Arguments

- to:

  The folder to copy into. In the course this is `here::here("data")`,
  the `data` folder of your project.

- overwrite:

  Replace files that are already there? `TRUE` by default, so a damaged
  copy is easy to repair.

## Value

The paths of the copies, invisibly. A message says how many files were
copied and where.

## Examples

``` r
folder <- file.path(tempdir(), "data") # in the course: here::here("data")
copy_course_files(folder)              # copy the nine files there
#> Copied 9 course files to /tmp/Rtmpvqkcqn/data
list.files(folder)                     # see what arrived
#> [1] "owid_co2_per_capita.csv"        "owid_renewable_electricity.csv"
#> [3] "wb-country-classification.xlsx" "wdi_education_spending.csv"    
#> [5] "wdi_electricity_access.csv"     "wdi_health_spending.csv"       
#> [7] "wdi_life_expectancy.csv"        "wdi_poverty.csv"               
#> [9] "wdi_primary_completion.csv"    
library(tidyverse) # load the tidyverse: readr, dplyr and more
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.2.1     ✔ readr     2.2.0
#> ✔ forcats   1.0.1     ✔ stringr   1.6.0
#> ✔ ggplot2   4.0.3     ✔ tibble    3.3.1
#> ✔ lubridate 1.9.5     ✔ tidyr     1.3.2
#> ✔ purrr     1.2.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

# Read a saved series from the copy, as you would a file of your own
life <- read_csv(                               # read a CSV file:
  file.path(folder, "wdi_life_expectancy.csv"), # the copied series
  show_col_types = FALSE                        # without the column report
)                                               # close read_csv()

# Join it to the IMF's countries by code and year
weo |>                                           # start with the panel, then
  filter(str_length(code) == 3, year == 2023) |> # countries in 2023, and then
  left_join(life, by = c("code", "year")) |>     # add life expectancy
  select(name, gross_debt, life_expectancy_years) # keep columns to read
#> # A tibble: 197 × 3
#>    name                     gross_debt life_expectancy_years
#>    <chr>                         <dbl>                 <dbl>
#>  1 Andorra, Principality of       35.4                  84.0
#>  2 Australia                      49.4                  83.1
#>  3 Austria                        77.8                  81.8
#>  4 Belgium                       103.                   82.4
#>  5 Canada                        105.                   81.6
#>  6 Croatia, Republic of           60.9                  78.5
#>  7 Cyprus                         71.1                  81.6
#>  8 Czech Republic                 42.2                  79.8
#>  9 Denmark                        33.0                  81.8
#> 10 Estonia, Republic of           20.3                  78.8
#> # ℹ 187 more rows
```
