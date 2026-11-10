# Find a file that comes with the course

The package carries a few files for the Day 2 lesson on importing data:
a spreadsheet of the World Bank's country groups, and eight saved series
from the World Bank and Our World in Data. `sais_example()` gives the
path to one of them, the way
[`readxl::readxl_example()`](https://readxl.tidyverse.org/reference/readxl_example.html)
does for readxl's files.

## Usage

``` r
sais_example(file = NULL)
```

## Arguments

- file:

  The name of a file, such as `"wb-country-classification.xlsx"`. Leave
  it out to list every file.

## Value

The path to the file, as text. With no `file`, the names of all the
files.

## See also

[`copy_course_files()`](https://teal-insights.github.io/saisdata/reference/copy_course_files.md)
to copy them all into your project.

## Examples

``` r
sais_example()
#> [1] "owid_co2_per_capita.csv"        "owid_renewable_electricity.csv"
#> [3] "wb-country-classification.xlsx" "wdi_education_spending.csv"    
#> [5] "wdi_electricity_access.csv"     "wdi_health_spending.csv"       
#> [7] "wdi_life_expectancy.csv"        "wdi_poverty.csv"               
#> [9] "wdi_primary_completion.csv"    
sais_example("wdi_life_expectancy.csv")
#> [1] "/home/runner/work/_temp/Library/saisdata/extdata/wdi_life_expectancy.csv"
```
