# A mini table you can see whole: twelve rows of `weo`

Six countries in two years, with six indicators: twelve rows of
[weo](https://teal-insights.github.io/saisdata/reference/weo.md), small
enough to read every cell. Use it to try a line of code where you can
check the answer by eye, then run the same line on
[weo](https://teal-insights.github.io/saisdata/reference/weo.md).

## Usage

``` r
weo_mini
```

## Format

A tibble with 12 rows and 9 variables:

- code:

  chr The country's three-letter ISO code, such as `KEN`.

- name:

  chr The country's name, as the IMF writes it.

- year:

  int The year: 2015 or 2025.

- gross_debt:

  dbl Gross debt of the general government, in percent of GDP.

- primary_balance:

  dbl The primary balance, in percent of GDP. Negative means a deficit.

- overall_balance:

  dbl The overall balance, in percent of GDP. Negative means a deficit.

- real_gdp_growth:

  dbl Real GDP growth, in percent.

- inflation:

  dbl Inflation, average consumer prices, in percent.

- gdp_per_capita_usd:

  dbl GDP per person at current prices, in US dollars.

## Source

International Monetary Fund, World Economic Outlook Database, October
2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
`data-raw/weo_mini.R` from
[weo](https://teal-insights.github.io/saisdata/reference/weo.md).

## Details

Every row here is a row of `weo`, with the same column names and the
same numbers, so what works on one works on the other. The countries are
Brazil, Germany, Ghana, Kenya, Nigeria and Pakistan, and the years are
2015 and 2025.

## Transformations

`data-raw/weo_mini.R` keeps twelve rows and nine columns of
[weo](https://teal-insights.github.io/saisdata/reference/weo.md). It
changes no value.

## Vintage

The IMF's World Economic Outlook database of October 2026. This table is
a frozen snapshot of that release: it does not change when the IMF
publishes a new WEO or revises these numbers.

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

[weo](https://teal-insights.github.io/saisdata/reference/weo.md), the
full panel these rows come from.

## Examples

``` r
library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more

# The whole table: twelve rows, nine columns
weo_mini
#> # A tibble: 12 × 9
#>    code  name    year gross_debt primary_balance overall_balance real_gdp_growth
#>    <chr> <chr>  <int>      <dbl>           <dbl>           <dbl>           <dbl>
#>  1 BRA   Brazil  2015       71.7          -0.853          -9.28           -3.55 
#>  2 BRA   Brazil  2025       93.3          -0.134          -7.43            2.29 
#>  3 DEU   Germa…  2015       71.0           1.99            0.913           1.77 
#>  4 DEU   Germa…  2025       62.7          -2.06           -2.92            0.229
#>  5 GHA   Ghana   2015       53.9           0.938          -4.01            2.12 
#>  6 GHA   Ghana   2025       48.8           2.13           -1.35            5.95 
#>  7 KEN   Kenya   2015       45.8          -4.22           -6.68            4.97 
#>  8 KEN   Kenya   2025       71.3          -1.04           -6.49            4.63 
#>  9 NGA   Niger…  2015       14.9          -1.90           -2.70            2.65 
#> 10 NGA   Niger…  2025       36.1           0.807          -1.76            4.01 
#> 11 PAK   Pakis…  2015       59.1          -0.454          -4.74            3.81 
#> 12 PAK   Pakis…  2025       72.8           2.43           -5.37            3.18 
#> # ℹ 2 more variables: inflation <dbl>, gdp_per_capita_usd <dbl>

# Try a verb where you can check it by eye: debt above 60 percent of GDP
weo_mini |>                # start with the mini table, and then
  filter(gross_debt > 60)  # keep the rows that pass the test
#> # A tibble: 6 × 9
#>   code  name     year gross_debt primary_balance overall_balance real_gdp_growth
#>   <chr> <chr>   <int>      <dbl>           <dbl>           <dbl>           <dbl>
#> 1 BRA   Brazil   2015       71.7          -0.853          -9.28           -3.55 
#> 2 BRA   Brazil   2025       93.3          -0.134          -7.43            2.29 
#> 3 DEU   Germany  2015       71.0           1.99            0.913           1.77 
#> 4 DEU   Germany  2025       62.7          -2.06           -2.92            0.229
#> 5 KEN   Kenya    2025       71.3          -1.04           -6.49            4.63 
#> 6 PAK   Pakist…  2025       72.8           2.43           -5.37            3.18 
#> # ℹ 2 more variables: inflation <dbl>, gdp_per_capita_usd <dbl>

# Then ask something new: where did prices rise faster than output?
weo_mini |>                           # start with the mini table, and then
  filter(year == 2025) |>             # keep 2025, and then
  filter(inflation > real_gdp_growth) # keep inflation above growth
#> # A tibble: 5 × 9
#>   code  name     year gross_debt primary_balance overall_balance real_gdp_growth
#>   <chr> <chr>   <int>      <dbl>           <dbl>           <dbl>           <dbl>
#> 1 BRA   Brazil   2025       93.3          -0.134           -7.43           2.29 
#> 2 DEU   Germany  2025       62.7          -2.06            -2.92           0.229
#> 3 GHA   Ghana    2025       48.8           2.13            -1.35           5.95 
#> 4 NGA   Nigeria  2025       36.1           0.807           -1.76           4.01 
#> 5 PAK   Pakist…  2025       72.8           2.43            -5.37           3.18 
#> # ℹ 2 more variables: inflation <dbl>, gdp_per_capita_usd <dbl>

# The same line works on the full panel
weo |>                                # start with the full panel, and then
  filter(year == 2025) |>             # keep 2025, and then
  filter(inflation > real_gdp_growth) # keep inflation above growth
#> # A tibble: 111 × 17
#>    code  name         year gross_debt primary_balance overall_balance gdp_usd_bn
#>    <chr> <chr>       <int>      <dbl>           <dbl>           <dbl>      <dbl>
#>  1 AUS   Australia    2025       51.9           -1.94           -2.89     1841. 
#>  2 AUT   Austria      2025       81.4           -2.87           -4.18      580. 
#>  3 BEL   Belgium      2025      108.            -3.40           -5.17      725. 
#>  4 CAN   Canada       2025      114.            -1.90           -1.67     2321. 
#>  5 HRV   Croatia, R…  2025       56.3           -1.97           -3.01      105. 
#>  6 EST   Estonia, R…  2025       24.0           -1.78           -1.97       47.3
#>  7 FIN   Finland      2025       88.4           -3.52           -3.84      318. 
#>  8 FRA   France       2025      116.            -2.99           -5.07     3383. 
#>  9 DEU   Germany      2025       62.7           -2.06           -2.92     5116. 
#> 10 GRC   Greece       2025      147.             4.88            1.73      280. 
#> # ℹ 101 more rows
#> # ℹ 10 more variables: latest_actual <int>, fiscal_year <chr>,
#> #   real_gdp_growth <dbl>, inflation <dbl>, unemployment_rate <dbl>,
#> #   current_account_balance <dbl>, gdp_per_capita_usd <dbl>,
#> #   population_mn <dbl>, revenue <dbl>, expenditure <dbl>
```
