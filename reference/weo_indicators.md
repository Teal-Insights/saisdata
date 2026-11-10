# What you can ask of the World Economic Outlook: its 44 indicators

One row for each indicator in
[weo_full](https://teal-insights.github.io/saisdata/reference/weo_full.md),
with what it measures in plain words. This is where to look first when
you have a question and do not know whether the data can answer it.

## Usage

``` r
weo_indicators
```

## Format

A tibble with 44 rows and 7 variables:

- indicator:

  chr The IMF's code for the indicator, as in
  [weo_full](https://teal-insights.github.io/saisdata/reference/weo_full.md),
  such as `NGDP_RPCH`.

- indicator_name:

  chr The indicator's full name, as the IMF writes it.

- topic:

  chr What the indicator is about, one of seven topics, such as
  "Prices".

- units:

  chr How to read the numbers, in plain words, such as "Percent of GDP".

- description:

  chr What the indicator measures, in one line of plain language.

- countries:

  int How many of the 197 countries report the indicator for at least
  one year.

- weo_column:

  chr The indicator's column in
  [weo](https://teal-insights.github.io/saisdata/reference/weo.md), such
  as `real_gdp_growth`, for the twelve that have one. Missing (`NA`) for
  the other 32.

## Source

International Monetary Fund, World Economic Outlook Database, October
2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
`data-raw/weo_indicators.R` from
[weo_full](https://teal-insights.github.io/saisdata/reference/weo_full.md)
and `data-raw/source/weo_indicator_notes.csv`.

## Details

The indicators are grouped by topic: growth and size, living standards,
prices, people and jobs, trade and payments, saving and investment, and
government finances. `countries` says how many of the 197 countries
report each one, because coverage differs: every country reports growth,
and fewer than half report net debt.

## Transformations

The codes, names and country counts come from
[weo_full](https://teal-insights.github.io/saisdata/reference/weo_full.md).
The topics, the plain-language units and the descriptions were written
for this workshop: the units restate the IMF's own scale and unit, and
the descriptions are the workshop's, not the IMF's. They are in
`data-raw/source/weo_indicator_notes.csv`.

## Vintage

The IMF's World Economic Outlook database of October 2026. This table is
a frozen snapshot of that release: it does not change when the IMF
publishes a new WEO or revises these numbers.

## Credit

Print this line under every chart you make from these data:

Source: International Monetary Fund, World Economic Outlook Database,
October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>.

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

[weo_full](https://teal-insights.github.io/saisdata/reference/weo_full.md),
the table these indicators describe.

## Examples

``` r
library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more

# The topics, and how many indicators each has
weo_indicators |> # start with the indicators, and then
  count(topic)    # count the rows in each topic
#> # A tibble: 7 × 2
#>   topic                     n
#>   <chr>                 <int>
#> 1 Government finances      14
#> 2 Growth and size           8
#> 3 Living standards          6
#> 4 People and jobs           3
#> 5 Prices                    5
#> 6 Saving and investment     2
#> 7 Trade and payments        6

# What can I ask about prices?
weo_indicators |>                          # start with the indicators, and then
  filter(topic == "Prices") |>             # keep one topic, and then
  select(indicator, units, description)    # keep the columns to read
#> # A tibble: 5 × 3
#>   indicator units          description                                          
#>   <chr>     <chr>          <chr>                                                
#> 1 PCPIPCH   Percent change Inflation: how much consumer prices rose on average …
#> 2 PCPIEPCH  Percent change Inflation measured from the end of one year to the e…
#> 3 PCPI      Index          The level of consumer prices, averaged over the year.
#> 4 PCPIE     Index          The level of consumer prices at the end of the year. 
#> 5 NGDP_D    Index          The price level of everything in GDP. Its change is …

# Find an indicator by a word in its description
weo_indicators |>                                  # start with the indicators
  filter(str_detect(description, "living standards")) |> # search the text
  select(indicator, description)                   # keep the columns to read
#> # A tibble: 2 × 2
#>   indicator  description                                                        
#>   <chr>      <chr>                                                              
#> 1 PPPPC      GDP per person at purchasing power parity, which adjusts for price…
#> 2 NGDPRPPPPC GDP per person at purchasing power parity with inflation taken out…
```
