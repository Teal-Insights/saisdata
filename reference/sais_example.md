# Find a file that comes with the course

The package carries a few files for the Day 2 lesson on importing data:
a spreadsheet of the World Bank's country groups, a spreadsheet in the
IMF's own layout, and nine saved series from the World Bank and Our
World in Data. `sais_example()` gives the path to one of them, the way
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
sais_example()                          # list every file
#>  [1] "imf-weo-october-2026.xlsx"      "owid_co2_per_capita.csv"       
#>  [3] "owid_renewable_electricity.csv" "wb-country-classification.xlsx"
#>  [5] "wdi_education_spending.csv"     "wdi_electricity_access.csv"    
#>  [7] "wdi_health_spending.csv"        "wdi_life_expectancy.csv"       
#>  [9] "wdi_poverty.csv"                "wdi_primary_completion.csv"    
#> [11] "wdi_remittances.csv"           
sais_example("wdi_life_expectancy.csv") # the path to one of them
#> [1] "/home/runner/work/_temp/Library/saisdata/extdata/wdi_life_expectancy.csv"
library(tidyverse) # load the tidyverse: readr, dplyr and more
library(readxl)    # load readxl, which reads Excel files

# A saved series from the World Bank: one row per country and year
read_csv(                                  # read a CSV file:
  sais_example("wdi_life_expectancy.csv"), # this one, from the package
  show_col_types = FALSE                   # without the column report
)                                          # close read_csv()
#> # A tibble: 5,425 × 4
#>    code  country  year life_expectancy_years
#>    <chr> <chr>   <dbl>                 <dbl>
#>  1 ABW   Aruba    2000                  72.9
#>  2 ABW   Aruba    2001                  73.0
#>  3 ABW   Aruba    2002                  73.1
#>  4 ABW   Aruba    2003                  73.2
#>  5 ABW   Aruba    2004                  73.2
#>  6 ABW   Aruba    2005                  73.4
#>  7 ABW   Aruba    2006                  73.5
#>  8 ABW   Aruba    2007                  73.6
#>  9 ABW   Aruba    2008                  73.8
#> 10 ABW   Aruba    2009                  74.0
#> # ℹ 5,415 more rows

# The spreadsheet: a title and a note sit above the table, so skip 3 rows
read_excel(                                       # read an Excel file:
  sais_example("wb-country-classification.xlsx"), # this one
  skip = 3                                        # start at the header row
)                                                 # close read_excel()
#> # A tibble: 217 × 5
#>    Economy              Code  Region           `Income group` `Lending category`
#>    <chr>                <chr> <chr>            <chr>          <chr>             
#>  1 Aruba                ABW   Latin America &… High income    Not classified    
#>  2 Afghanistan          AFG   Middle East, No… Low income     IDA               
#>  3 Angola               AGO   Sub-Saharan Afr… Lower middle … IBRD              
#>  4 Albania              ALB   Europe & Centra… Upper middle … IBRD              
#>  5 Andorra              AND   Europe & Centra… High income    Not classified    
#>  6 United Arab Emirates ARE   Middle East, No… High income    Not classified    
#>  7 Argentina            ARG   Latin America &… Upper middle … IBRD              
#>  8 Armenia              ARM   Europe & Centra… Upper middle … IBRD              
#>  9 American Samoa       ASM   East Asia & Pac… High income    Not classified    
#> 10 Antigua and Barbuda  ATG   Latin America &… High income    IBRD              
#> # ℹ 207 more rows
```
