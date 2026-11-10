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
folder <- file.path(tempdir(), "data")
copy_course_files(folder)
#> Copied 9 course files to /tmp/RtmpYeqS5P/data
list.files(folder)
#> [1] "owid_co2_per_capita.csv"        "owid_renewable_electricity.csv"
#> [3] "wb-country-classification.xlsx" "wdi_education_spending.csv"    
#> [5] "wdi_electricity_access.csv"     "wdi_health_spending.csv"       
#> [7] "wdi_life_expectancy.csv"        "wdi_poverty.csv"               
#> [9] "wdi_primary_completion.csv"    
```
