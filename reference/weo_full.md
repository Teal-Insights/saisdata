# World Economic Outlook, October 2026: every indicator, for every country

The whole of the IMF's World Economic Outlook (WEO) database of October
2026 for the 197 countries, tidy and long: one row is one country, one
indicator and one year. It holds all 44 indicators the IMF publishes for
countries, from 2000 to 2031: growth, prices, jobs, trade, saving,
investment and the government's books.

## Usage

``` r
weo_full
```

## Format

A tibble with 238,459 rows and 7 variables:

- code:

  chr The country's three-letter ISO code (the IMF uses `KOS` for Kosovo
  and `WBG` for West Bank and Gaza). It matches `code` in
  [weo](https://teal-insights.github.io/saisdata/reference/weo.md) and
  [wb_groups](https://teal-insights.github.io/saisdata/reference/wb_groups.md).

- name:

  chr The country's name, as the IMF writes it, such as "Egypt, Arab
  Republic of".

- indicator:

  chr The IMF's code for the indicator, such as `NGDP_RPCH` for real GDP
  growth.
  [weo_indicators](https://teal-insights.github.io/saisdata/reference/weo_indicators.md)
  explains each code.

- indicator_name:

  chr The indicator's full name, as the IMF writes it.

- units:

  chr How to read the number, in plain words, such as "Percent of GDP"
  or "Billions of US dollars".

- year:

  int The year, 2000 to 2031.

- value:

  dbl The number, in the units the row names.

## Source

International Monetary Fund, World Economic Outlook Database, October
2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>, downloaded with
`imfweo::weo_get(year = 2026, release = "Fall")`. Built by
`data-raw/weo_full.R` from `data-raw/source/weo_2026oct_imfweo.csv.gz`.

## Details

[weo_indicators](https://teal-insights.github.io/saisdata/reference/weo_indicators.md)
lists the 44 indicators with what each one measures. Start there to find
what you can ask.
[weo](https://teal-insights.github.io/saisdata/reference/weo.md) has
twelve of them already laid out as columns, which is easier for a first
analysis.

A row exists only where the IMF has a value. A country and year the IMF
leaves blank has no row here, where
[weo](https://teal-insights.github.io/saisdata/reference/weo.md) would
show `NA`. So count the years a country has before you chart it.

The last years are IMF projections. For most countries the numbers are
actual through 2024 or 2025; `latest_actual` in
[weo](https://teal-insights.github.io/saisdata/reference/weo.md) says
where the fiscal data stop.

## Transformations

`data-raw/weo_download.R` downloaded the release with the
[imfweo](https://github.com/Teal-Insights/r-imfweo) package and saved
it. `data-raw/weo_full.R` keeps the 197 countries (the 13 IMF groups are
in [weo](https://teal-insights.github.io/saisdata/reference/weo.md)),
renames the columns, writes the units in plain words from the IMF's own
scale and unit, and rounds to three decimals. For the 13 indicators it
shares with the IMF's workbook extract, `data-raw/weo.R` checks the
download cell by cell: no number differs.

## Credit

Print this line under every chart you make from these data:

Source: International Monetary Fund, World Economic Outlook Database,
October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>.

## Vintage

The IMF's World Economic Outlook database of October 2026. This table is
a frozen snapshot of that release: it does not change when the IMF
publishes a new WEO or revises these numbers.

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

[weo_indicators](https://teal-insights.github.io/saisdata/reference/weo_indicators.md)
for what each indicator measures;
[weo](https://teal-insights.github.io/saisdata/reference/weo.md) for
twelve indicators laid out as columns.

## Examples

``` r
library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more

# One row per country, indicator and year
weo_full
#> # A tibble: 238,459 × 7
#>    code  name                        indicator indicator_name units  year  value
#>    <chr> <chr>                       <chr>     <chr>          <chr> <int>  <dbl>
#>  1 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2000  0.213
#>  2 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2001  0.31 
#>  3 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2002 -0.333
#>  4 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2003 -0.167
#>  5 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2004  0.274
#>  6 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2005  0.116
#>  7 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2006  0.314
#>  8 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2007  0.259
#>  9 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2008  0.001
#> 10 ABW   Aruba, Kingdom of the Neth… BCA       Current accou… Bill…  2009  0.177
#> # ℹ 238,449 more rows

# Investment as a share of GDP in 2025: who invests the most?
weo_full |>                        # start with the long table, and then
  filter(indicator == "NID_NGDP") |> # keep one indicator, and then
  filter(year == 2025) |>          # keep one year, and then
  arrange(desc(value)) |>          # sort, largest first, and then
  select(name, units, value)       # keep the columns to read
#> # A tibble: 171 × 3
#>    name                            units          value
#>    <chr>                           <chr>          <dbl>
#>  1 Mauritania, Islamic Republic of Percent of GDP  54.9
#>  2 Bhutan                          Percent of GDP  54.4
#>  3 Algeria                         Percent of GDP  48.9
#>  4 Iran, Islamic Republic of       Percent of GDP  45.7
#>  5 Gabon                           Percent of GDP  44.9
#>  6 China, People's Republic of     Percent of GDP  38.9
#>  7 Tanzania, United Republic of    Percent of GDP  35.9
#>  8 Benin                           Percent of GDP  35.8
#>  9 Dominica                        Percent of GDP  35.7
#> 10 Maldives                        Percent of GDP  35.5
#> # ℹ 161 more rows

# Saving and investment side by side for one country: indicators up into columns
weo_full |>                                  # start with the long table, then
  filter(code == "IDN") |>                   # keep Indonesia, and then
  filter(indicator %in% c("NGSD_NGDP", "NID_NGDP")) |> # two indicators
  select(year, indicator, value) |>          # keep what the pivot needs
  pivot_wider(                               # send the indicators up:
    names_from = indicator,                  # one column per indicator
    values_from = value                      # filled from value
  )                                          # close pivot_wider()
#> # A tibble: 32 × 3
#>     year NGSD_NGDP NID_NGDP
#>    <int>     <dbl>    <dbl>
#>  1  2000      24.9     25.1
#>  2  2001      24.7     25.3
#>  3  2002      23.4     24.2
#>  4  2003      26.7     28.1
#>  5  2004      24.0     27.4
#>  6  2005      23.6     28.6
#>  7  2006      25.8     29.0
#>  8  2007      24.4     28.7
#>  9  2008      33.0     33.0
#> 10  2009      33.0     31.2
#> # ℹ 22 more rows
```
