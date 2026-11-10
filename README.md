
<!-- README.md is generated from README.Rmd. Please edit that file. -->

# saisdata

<!-- badges: start -->

[![R-CMD-check](https://github.com/Teal-Insights/saisdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Teal-Insights/saisdata/actions/workflows/R-CMD-check.yaml)
[![r-universe](https://teal-insights.r-universe.dev/saisdata/badges/version)](https://teal-insights.r-universe.dev/saisdata)
[![Website](https://github.com/Teal-Insights/saisdata/actions/workflows/pkgdown.yaml/badge.svg)](https://teal-insights.github.io/saisdata/)
[![Code license:
MIT](https://img.shields.io/badge/code%20license-MIT-blue.svg)](LICENSE.md)
[![Data terms: IMF and World
Bank](https://img.shields.io/badge/data%20terms-IMF%20and%20World%20Bank-lightgrey.svg)](LICENSE-data.md)
<!-- badges: end -->

`saisdata` holds the course data for the two-day R workshop of the
Master of International Economics and Finance (MIEF) at Johns Hopkins
SAIS, ready to use in R. One line loads everything: `library(saisdata)`.
There are no file paths, no downloads and no CSV files to read.

This package is not an official IMF or World Bank product.

## Installation

Run this one line in the R Console:

``` r
install.packages("saisdata", repos = "https://teal-insights.r-universe.dev")
```

You do not need a GitHub account, devtools, a compiler or a manual
download. The package holds only data and depends on no other package,
so that one repository is all R needs.

R-universe builds ready-made copies for recent versions of R. On an
older or newer R, the same line installs from the source package
instead. That still needs no compiler, because the package holds only
data.

## What is inside

| Dataset | What one row is | Rows | Help page |
|----|----|----|----|
| `weo` | one country (or IMF group) in one year, 2000 to 2031, with twelve indicators as columns: growth, inflation, unemployment, the current account, GDP, GDP per person, population, and the government’s revenue, spending, balances and debt | 6,720 | `?weo` |
| `weo_mini` | twelve rows of `weo` that fit on one screen: six countries, two years, six indicators | 12 | `?weo_mini` |
| `weo_full` | one country, one indicator and one year: all 44 indicators the IMF publishes for countries | 238,459 | `?weo_full` |
| `weo_indicators` | one indicator, with its topic, units and a plain-language description | 44 | `?weo_indicators` |
| `weo_groups` | one IMF country group and one indicator, with the years across, the way the IMF publishes it | 6 | `?weo_groups` |
| `wb_groups` | one country, with its World Bank region, income level and lending type | 217 | `?wb_groups` |

The five `weo` tables come from the IMF’s World Economic Outlook
database of October 2026. `wb_groups` comes from the World Bank, as
served on 3 November 2026. The tables are a frozen snapshot: they do not
change when either institution publishes new numbers. Every help page
says what each column means, the units, the source and what was changed.

The data arrive as tibbles, the tidyverse’s tables. The package itself
needs nothing but R, so it installs fast. The examples on this site use
the tidyverse, as the course does.

## Files for Day 2

Version 0.2.0 adds nine files for the lesson on importing data: a
spreadsheet of the World Bank’s country groups, laid out the way
official files often arrive, and eight saved series from the World Bank
and Our World in Data. Nothing is downloaded.

``` r
library(saisdata)                    # load the course data
sais_example()                       # list the nine files
copy_course_files(here::here("data")) # copy them into your project's data folder
```

After that they are ordinary files in your project. Read the spreadsheet
with `readxl::read_excel()` and a series with `readr::read_csv()`.
`LICENSE-data.md` gives each file’s source and terms.

## Example

This runs offline. It uses the tidyverse, as the course does. Net
interest is not a column: it is the primary balance minus the overall
balance.

``` r
library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more
library(saisdata)  # load the course data: weo, weo_groups, wb_groups

weo |>                                   # start with the panel, and then
  filter(code == "KEN", year >= 2020) |> # keep Kenya from 2020 on, and then
  filter(year <= 2025) |>                # stop at 2025, and then
  mutate(                                # add a column:
    net_interest = primary_balance - overall_balance # net interest
  ) |>                                   # and then
  select(year, gross_debt, net_interest) # keep the columns to read
#> # A tibble: 6 × 3
#>    year gross_debt net_interest
#>   <int>      <dbl>        <dbl>
#> 1  2020       68.0         3.93
#> 2  2021       68.2         4.09
#> 3  2022       67.8         4.37
#> 4  2023       73.4         4.79
#> 5  2024       67.3         5.25
#> 6  2025       71.3         5.45
```

The data are not only about debt. `weo_indicators` says what you can
ask, by topic:

``` r
weo_indicators |>                       # start with the indicators, and then
  filter(topic == "Trade and payments") |> # keep one topic, and then
  select(indicator, units, description) # keep the columns to read
#> # A tibble: 6 × 3
#>   indicator units                  description                                  
#>   <chr>     <chr>                  <chr>                                        
#> 1 BCA_NGDPD Percent of GDP         The current account balance as a share of th…
#> 2 BCA       Billions of US dollars The current account balance in dollars: trad…
#> 3 TX_RPCH   Percent change         Growth in the volume of goods and services t…
#> 4 TXG_RPCH  Percent change         Growth in the volume of goods the country ex…
#> 5 TM_RPCH   Percent change         Growth in the volume of goods and services t…
#> 6 TMG_RPCH  Percent change         Growth in the volume of goods the country im…
```

Twelve indicators are already columns of `weo`. This asks where prices
rose fastest in 2025, among countries that also grew:

``` r
weo |>                                  # start with the panel, and then
  filter(str_length(code) == 3) |>      # keep countries, not IMF groups
  filter(year == 2025, real_gdp_growth > 0) |> # 2025, with a growing economy
  arrange(desc(inflation)) |>           # sort, highest inflation first
  select(name, inflation, real_gdp_growth, current_account_balance) # to read
#> # A tibble: 182 × 4
#>    name                         inflation real_gdp_growth current_account_bala…¹
#>    <chr>                            <dbl>           <dbl>                  <dbl>
#>  1 Venezuela, República Boliva…     252.             9.01                  0.561
#>  2 South Sudan, Republic of          97.6           41.4                  -6.44 
#>  3 Zimbabwe                          81.4            8.29                  3.65 
#>  4 Argentina                         41.9            4.48                 -1.14 
#>  5 Türkiye, Republic of              34.9            3.74                 -1.88 
#>  6 Burundi                           34.0            4.23                 -6.44 
#>  7 Malawi                            28.4            2.49                -13.8  
#>  8 Nigeria                           23.0            4.01                  4.83 
#>  9 Egypt, Arab Republic of           20.4            4.39                 -4.23 
#> 10 Angola                            20.2            3.13                  0.297
#> # ℹ 172 more rows
#> # ℹ abbreviated name: ¹​current_account_balance
```

`wb_groups` joins to `weo` by `code`. This gives the typical country’s
debt in 2025 at each income level.

``` r
weo |>                                  # start with the IMF's panel, and then
  filter(year == 2025) |>               # keep 2025, and then
  inner_join(wb_groups, by = "code") |> # keep rows found in both, by code
  group_by(income_level) |>             # one group per income level, and then
  summarize(                            # collapse each group to one row:
    countries = n(),                    # how many countries went in
    median_debt = median(gross_debt, na.rm = TRUE) # their middle debt
  )                                     # close summarize()
#> # A tibble: 4 × 3
#>   income_level        countries median_debt
#>   <chr>                   <int>       <dbl>
#> 1 High income                67        55.7
#> 2 Low income                 24        52.3
#> 3 Lower middle income        47        49.6
#> 4 Upper middle income        58        54.1
```

`weo_groups` keeps the IMF’s layout, with the years across. Two moves
make it tidy, and one more gives the interest bill in dollars. Added up
over the two groups, that comes to about USD 849 billion in 2001 and USD
2,371.2 billion in 2025. The [Getting Started
article](https://teal-insights.github.io/saisdata/articles/saisdata.html)
has this example and a chart.

``` r
weo_groups |>                                     # start with the table, then
  select(group_code, indicator, `2001`:`2031`) |> # keep codes and years, then
  pivot_longer(                                   # bring the years down:
    cols = `2001`:`2031`,                         # every year column
    names_to = "year",                            # their names go in year
    names_transform = as.integer,                 # as whole numbers
    values_to = "value"                           # their numbers go in value
  ) |>                                            # and then
  pivot_wider(                                    # send the indicators up:
    names_from = indicator,                       # one column per indicator
    values_from = value                           # filled from value
  ) |>                                            # and then
  mutate(                                         # add a column:
    # primary balance minus overall balance, times GDP, in USD billions
    net_interest_usd_bn = (GGXONLB_NGDP - GGXCNL_NGDP) / 100 * NGDPD
  )                                               # close mutate()
#> # A tibble: 62 × 6
#>    group_code  year  NGDPD GGXCNL_NGDP GGXONLB_NGDP net_interest_usd_bn
#>    <chr>      <int>  <dbl>       <dbl>        <dbl>               <dbl>
#>  1 G110        2001 26768.       -1.72        0.572                615.
#>  2 G110        2002 27926.       -3.61       -1.48                 594.
#>  3 G110        2003 31320.       -4.06       -2.10                 614.
#>  4 G110        2004 34743.       -3.29       -1.44                 645.
#>  5 G110        2005 36571.       -2.47       -0.685                654.
#>  6 G110        2006 38472.       -1.43        0.278                656.
#>  7 G110        2007 42039.       -1.34        0.396                731.
#>  8 G110        2008 44432.       -3.59       -1.88                 760.
#>  9 G110        2009 41931.       -8.79       -7.13                 696.
#> 10 G110        2010 43797.       -7.84       -6.15                 744.
#> # ℹ 52 more rows
```

## If the package will not install

Every table is also a CSV file in this repository, as a last chance.
With the tidyverse and the internet, one line reads one:

``` r
library(tidyverse) # load the tidyverse, which reads CSV files

# where the files live
base <- "https://raw.githubusercontent.com/Teal-Insights/saisdata/main/csv/"

weo <- read_csv(str_c(base, "weo.csv")) # the main table, read from GitHub
```

[`csv/README.md`](https://github.com/Teal-Insights/saisdata/tree/main/csv)
lists every file, with the same lines for the other tables and for the
Day 2 files. The course tries things in this order: a live call to the
IMF or the World Bank where a lesson shows one, then the copy saved in
this package, then these files.

## Code license and data terms

The code and the data are under different terms.

- **The package’s code and documentation** are MIT licensed
  ([`LICENSE.md`](LICENSE.md)). That license does not cover the data.
- **The IMF’s data** (`weo`, `weo_groups`) are under the special terms
  for statistical data on the IMF’s [Copyright and Usage
  page](https://www.imf.org/en/About/copyright-and-terms). You may copy,
  publish, distribute and build on them if you credit the IMF, keep them
  accurate and say when you have materially transformed them. For any
  potential commercial reuse, ask <copyright@imf.org> first.
- **The World Bank’s data** (`wb_groups`) are under [CC BY
  4.0](https://creativecommons.org/licenses/by/4.0/) with the added
  terms in its [Terms of Use for
  Datasets](https://www.worldbank.org/ext/en/legal/terms-conditions/datasets).
  You may copy, share and adapt them, commercially too, if you credit
  the World Bank and say what you changed.

[`LICENSE-data.md`](LICENSE-data.md) summarizes both sets of terms, what
this package changed in the data, and what you must do if you pass the
data on. Once the package is installed,
`system.file("LICENSE-data.md", package = "saisdata")` finds the same
file.

Print this line under every chart you make from these data:

> Source: International Monetary Fund, World Economic Outlook Database,
> October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Country
> groups: The World Bank: World Development Indicators: country and
> lending groups (CC BY 4.0). Net interest is the primary balance minus
> the overall balance, calculated for this workshop.

Drop the second sentence if your chart uses no World Bank groups, and
the third if it shows no net interest.

## Rebuilding the data

A clean clone rebuilds `data/` with no internet. From the package
folder, with readr, dplyr, tidyr, stringr, here and usethis installed:

``` sh
LANG=en_US.UTF-8 Rscript data-raw/rebuild-all.R
LANG=en_US.UTF-8 Rscript data-raw/compare-tables.R
```

The first line runs the scripts in `data-raw/`, from the source files in
[`data-raw/source/`](data-raw/source/README.md). The second compares the
result with the original tables, using `identical()`, `all.equal()` and
a column-by-column type check, and fails if they differ. The output of
the comparison made for this release is in
[`data-raw/comparison/`](data-raw/comparison/).
