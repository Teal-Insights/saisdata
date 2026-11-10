# World Economic Outlook, October 2026: the two big groups, as the IMF lays them out

Six rows from the IMF's World Economic Outlook (WEO) database of October
2026, in the layout the IMF publishes. One row is one country group and
one indicator, with the years across as columns. The two groups,
Advanced Economies and Emerging Market and Developing Economies,
together cover the world. The three indicators, the primary balance, the
overall balance and GDP, are all you need to work out what the world's
governments pay in interest.

## Usage

``` r
weo_groups
```

## Format

A tibble with 6 rows and 36 variables:

- group_code:

  chr The IMF's code for the group: `G110` for Advanced Economies,
  `G200` for Emerging Market and Developing Economies (`COUNTRY.ID` in
  the IMF's file).

- group:

  chr The group's name, as the IMF writes it (`COUNTRY`).

- indicator:

  chr The IMF's code for the indicator (`INDICATOR.ID`): `GGXONLB_NGDP`
  is the primary balance, `GGXCNL_NGDP` the overall balance, and `NGDPD`
  GDP at current prices.

- indicator_name:

  chr The indicator's full name, as the IMF writes it (`INDICATOR`),
  such as "Net lending (+) / net borrowing (-), General government,
  Percent of GDP".

- units:

  chr How to read the numbers: "Percent of GDP" for the two balances and
  "Billions of US dollars" for GDP (the IMF's `SCALE` and `UNIT`
  columns, in plain words).

- `2001` to `2031`:

  dbl One column per year, holding the indicator's value that year. From
  2026 on the values are IMF projections. The names are numbers, so wrap
  them in backticks when you use them: `` `2025` ``.

## Source

International Monetary Fund, World Economic Outlook Database, October
2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
`data-raw/weo_groups.R` from `data-raw/source/weo_2026oct_extract.csv`,
an extract of the IMF's workbook `WEOOct2026all.xlsx`.

## Details

This is what data look like in the wild. To work with them in R you tidy
them first:
[`tidyr::pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html)
turns the year columns into rows, and
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
turns the indicators into columns.

Net interest in billions of US dollars is the primary balance minus the
overall balance, times GDP, divided by 100. Added up over the two groups
it comes to about USD 849 billion in 2001 and USD 2,371.2 billion in
2025. The groups' balances are averages of their members' balances,
weighted by GDP, so this total is an approximation.

The years start in 2001, the first year the IMF gives a primary balance
for both groups.

## Vintage

The IMF's World Economic Outlook database of October 2026. This table is
a frozen snapshot of that release: it does not change when the IMF
publishes a new WEO or revises these numbers.

## Transformations

The IMF's workbook `WEOOct2026all.xlsx` went through two steps. First,
an extract stacked its Countries and Country Groups sheets, kept 13 of
44 indicators, the years 2000 to 2031 and 9 of 29 descriptive columns,
and wrote each number in its shortest form. Second,
`data-raw/weo_groups.R` kept these six rows and the years 2001 to 2031,
renamed five columns, and wrote the IMF's `SCALE` and `UNIT` in plain
words. No number was changed.

## Credit

Print this line under every chart you make from these data:

Source: International Monetary Fund, World Economic Outlook Database,
October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Country
groups: The World Bank: World Development Indicators: country and
lending groups (CC BY 4.0). Net interest is the primary balance minus
the overall balance, calculated for this workshop.

Drop the second sentence if your chart uses no World Bank groups, and
the third if it shows no net interest.

## Terms of use

The package's MIT license does not cover these data. They are under the
special terms for statistical data on the IMF's Copyright and Usage
page, <https://www.imf.org/en/About/copyright-and-terms> (effective 11
October 2024, read on 6 November 2026), which name the World Economic
Outlook database. You may download, extract, copy, build on, publish and
distribute the data if you credit the IMF in the form above, do not
alter the data in a way that intentionally affects their nature or
accuracy, and say so next to the credit when you materially transform
them. If you pass the data on, make reasonable efforts to tell your
users about these terms. The IMF gives no warranty. For any potential
commercial reuse, ask copyright@imf.org first. The IMF's general terms
still apply where the data terms are silent: imply no endorsement, and
do not use its content to train large language models without its
explicit permission. See
`system.file("LICENSE-data.md", package = "saisdata")`.

This package is not an official IMF or World Bank product.

## See also

[weo](https://teal-insights.github.io/saisdata/reference/weo.md) for
every country and group, one row per entity and year.

## Examples

``` r
library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more

# The IMF's layout: one row per group and indicator, with the years across
weo_groups
#> # A tibble: 6 × 36
#>   group_code group     indicator indicator_name units   `2001`   `2002`   `2003`
#>   <chr>      <chr>     <chr>     <chr>          <chr>    <dbl>    <dbl>    <dbl>
#> 1 G110       Advanced… NGDPD     Gross domesti… Bill…  2.68e+4  2.79e+4  3.13e+4
#> 2 G110       Advanced… GGXCNL_N… Net lending (… Perc… -1.72e+0 -3.61e+0 -4.06e+0
#> 3 G110       Advanced… GGXONLB_… Primary net l… Perc…  5.72e-1 -1.48e+0 -2.10e+0
#> 4 G200       Emerging… NGDPD     Gross domesti… Bill…  7.32e+3  7.24e+3  8.15e+3
#> 5 G200       Emerging… GGXCNL_N… Net lending (… Perc… -2.83e+0 -3.32e+0 -2.63e+0
#> 6 G200       Emerging… GGXONLB_… Primary net l… Perc…  3.69e-1 -3.16e-1  3.42e-1
#> # ℹ 28 more variables: `2004` <dbl>, `2005` <dbl>, `2006` <dbl>, `2007` <dbl>,
#> #   `2008` <dbl>, `2009` <dbl>, `2010` <dbl>, `2011` <dbl>, `2012` <dbl>,
#> #   `2013` <dbl>, `2014` <dbl>, `2015` <dbl>, `2016` <dbl>, `2017` <dbl>,
#> #   `2018` <dbl>, `2019` <dbl>, `2020` <dbl>, `2021` <dbl>, `2022` <dbl>,
#> #   `2023` <dbl>, `2024` <dbl>, `2025` <dbl>, `2026` <dbl>, `2027` <dbl>,
#> #   `2028` <dbl>, `2029` <dbl>, `2030` <dbl>, `2031` <dbl>

# Tidy it, then work out each group's net interest bill in dollars
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
