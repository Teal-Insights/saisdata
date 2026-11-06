
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

## What is inside

| Dataset | What one row is | Rows | Help page |
|----|----|----|----|
| `weo` | one country (or IMF group) in one year, 2000 to 2031: gross debt, primary balance, overall balance, GDP | 6,720 | `?weo` |
| `weo_groups` | one IMF country group and one indicator, with the years across, the way the IMF publishes it | 6 | `?weo_groups` |
| `wb_groups` | one country, with its World Bank region, income level and lending type | 217 | `?wb_groups` |

`weo` and `weo_groups` come from the IMF’s World Economic Outlook
database of October 2026. `wb_groups` comes from the World Bank, as
served on 3 November 2026. The tables are a frozen snapshot: they do not
change when either institution publishes new numbers. Every help page
says what each column means, the units, the source and what was changed.

The data arrive as tibbles if you have the tidyverse, and print as
ordinary data frames if you do not.

## Example

This runs offline. It uses only base R, so it works in a brand new R
library. Net interest is not a column; it is the primary balance minus
the overall balance.

``` r
library(saisdata)

kenya <- subset(weo, code == "KEN" & year >= 2020 & year <= 2025)
kenya$net_interest <- kenya$primary_balance - kenya$overall_balance

as.data.frame(kenya[, c("year", "gross_debt", "net_interest")])
#>      year gross_debt net_interest
#> 5589 2020     67.959        3.925
#> 5590 2021     68.232        4.091
#> 5591 2022     67.800        4.374
#> 5592 2023     73.405        4.786
#> 5593 2024     67.306        5.247
#> 5594 2025     71.269        5.447
```

With the tidyverse, two moves make `weo_groups` tidy, and one more gives
the interest bill in dollars. Added up over the two groups, that comes
to about USD 849 billion in 2001 and USD 2,371.2 billion in 2025. The
[Getting Started
article](https://teal-insights.github.io/saisdata/articles/saisdata.html)
has this example and a chart.

``` r
library(dplyr)
library(tidyr)

weo_groups |>
  select(-indicator_name, -units) |> # keep the codes, drop the long text
  pivot_longer(
    cols = `2001`:`2031`, # every year column
    names_to = "year", # the column names become a year column
    names_transform = as.integer, # "2025" becomes the number 2025
    values_to = "value"
  ) |>
  pivot_wider(names_from = indicator, values_from = value) |> # one per indicator
  mutate(net_interest_usd_bn = (GGXONLB_NGDP - GGXCNL_NGDP) * NGDPD / 100)
#> # A tibble: 62 × 7
#>    group_code group     year  NGDPD GGXCNL_NGDP GGXONLB_NGDP net_interest_usd_bn
#>    <chr>      <chr>    <int>  <dbl>       <dbl>        <dbl>               <dbl>
#>  1 G110       Advance…  2001 26768.       -1.72        0.572                615.
#>  2 G110       Advance…  2002 27926.       -3.61       -1.48                 594.
#>  3 G110       Advance…  2003 31320.       -4.06       -2.10                 614.
#>  4 G110       Advance…  2004 34743.       -3.29       -1.44                 645.
#>  5 G110       Advance…  2005 36571.       -2.47       -0.685                654.
#>  6 G110       Advance…  2006 38472.       -1.43        0.278                656.
#>  7 G110       Advance…  2007 42039.       -1.34        0.396                731.
#>  8 G110       Advance…  2008 44432.       -3.59       -1.88                 760.
#>  9 G110       Advance…  2009 41931.       -8.79       -7.13                 696.
#> 10 G110       Advance…  2010 43797.       -7.84       -6.15                 744.
#> # ℹ 52 more rows
```

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
