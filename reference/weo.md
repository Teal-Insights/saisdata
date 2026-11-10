# World Economic Outlook, October 2026: the tidy country panel

Four indicators from the IMF's World Economic Outlook (WEO) database of
October 2026, laid out tidy. One row is one entity in one year, and each
variable has its own column. An entity is one of 197 countries or one of
13 IMF country groups, and the years run from 2000 to 2031, so the panel
has 6,720 rows.

## Usage

``` r
weo
```

## Format

A tibble with 6,720 rows and 9 variables:

- code:

  chr The entity's code. A country has its three-letter ISO code (the
  IMF uses `KOS` for Kosovo and `WBG` for West Bank and Gaza); an IMF
  group has a code that starts with G and a digit or an X, such as
  `G110` for Advanced Economies.

- name:

  chr The entity's name, as the IMF writes it, such as "Egypt, Arab
  Republic of".

- year:

  int The year, 2000 to 2031.

- gross_debt:

  dbl Gross debt of the general government, everything it owes, in
  percent of GDP (the IMF's `GGXWDG_NGDP`).

- primary_balance:

  dbl The primary balance: revenue minus spending, with interest left
  out on both sides, in percent of GDP (`GGXONLB_NGDP`). Negative means
  a deficit.

- overall_balance:

  dbl The overall balance: revenue minus all spending, interest
  included, in percent of GDP (`GGXCNL_NGDP`). Negative means a deficit.

- gdp_usd_bn:

  dbl GDP at current prices, in billions of US dollars (`NGDPD`).

- latest_actual:

  int The last year with actual fiscal data; later years are IMF
  estimates or projections. Missing (`NA`) for 12 of the 13 IMF groups.

- fiscal_year:

  chr The months of the year the WEO shows the fiscal numbers in:
  "January/December" for most countries, and others such as "July/June"
  for Pakistan. Missing for 12 of the 13 IMF groups.

## Source

International Monetary Fund, World Economic Outlook Database, October
2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>. Built by
`data-raw/weo.R` from `data-raw/source/weo_panel.csv`, which
`data-raw/weo_panel.R` makes from
`data-raw/source/weo_2026oct_extract.csv`, an extract of the IMF's
workbook `WEOOct2026all.xlsx`.

## Details

The WEO mixes actual data and IMF projections in one row.
`latest_actual` marks where the actual data stop. For most countries the
fiscal numbers are actual through 2025, and from 2026 on almost every
value is an IMF projection.

Net interest is not a column. It is one line of arithmetic,
`primary_balance - overall_balance`: the interest the government pays
minus the interest it receives, in percent of GDP. For Japan in 2025
that is -0.511 minus -0.709, which is 0.198.

To tell a group from a country, look at the code. An IMF group's code
starts with G and then a digit or an X (`G110`); a country's second
character is a letter (Ghana is `GHA`).

## Vintage

The IMF's World Economic Outlook database of October 2026. This table is
a frozen snapshot of that release: it does not change when the IMF
publishes a new WEO or revises these numbers.

## Transformations

The IMF's workbook `WEOOct2026all.xlsx` went through two steps. First,
an extract stacked its Countries and Country Groups sheets, kept 13 of
44 indicators, the years 2000 to 2031 and 9 of 29 descriptive columns,
and wrote each number in its shortest form. Second,
`data-raw/weo_panel.R` kept the four indicators here, gave them plain
names, reshaped them to one row per entity and year, and rounded them to
three decimals. It also added two columns from the IMF's labels.
`fiscal_year` is the IMF's own label. `latest_actual` turns the IMF's
label, such as FY2024/25, into one calendar year, following the rule in
the IMF's notes for that country.

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

[weo_groups](https://teal-insights.github.io/saisdata/reference/weo_groups.md)
for the IMF's own layout of its two big groups;
[wb_groups](https://teal-insights.github.io/saisdata/reference/wb_groups.md)
to add the World Bank's income levels and regions.

## Examples

``` r
library(tidyverse) # load the tidyverse: dplyr, ggplot2, tidyr and more

# Every column, with its type and its first values
glimpse(weo)
#> Rows: 6,720
#> Columns: 9
#> $ code            <chr> "AND", "AND", "AND", "AND", "AND", "AND", "AND", "AND"…
#> $ name            <chr> "Andorra, Principality of", "Andorra, Principality of"…
#> $ year            <int> 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, …
#> $ gross_debt      <dbl> NA, 15.774, 15.266, 15.163, 15.105, 14.760, 17.165, 20…
#> $ primary_balance <dbl> NA, 1.475, 1.676, 2.273, 2.430, 0.268, -0.994, -2.046,…
#> $ overall_balance <dbl> NA, 0.658, 0.978, 1.764, 1.855, -0.081, -1.436, -2.828…
#> $ gdp_usd_bn      <dbl> 1.429, 1.547, 1.758, 2.362, 2.896, 3.158, 3.456, 3.952…
#> $ latest_actual   <int> 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, …
#> $ fiscal_year     <chr> "January/December", "January/December", "January/Decem…

# Kenya since 2020, with its net interest bill in percent of GDP
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

# The typical country's debt in each year
weo |>                                   # start with the panel, and then
  filter(str_length(code) == 3) |>       # keep countries, not IMF groups
  group_by(year) |>                      # make one group per year, and then
  summarize(                             # collapse each group to one row:
    median_debt = median(gross_debt, na.rm = TRUE) # the middle value
  )                                      # close summarize()
#> # A tibble: 32 × 2
#>     year median_debt
#>    <int>       <dbl>
#>  1  2000        53.6
#>  2  2001        52.4
#>  3  2002        53.7
#>  4  2003        49.8
#>  5  2004        46.8
#>  6  2005        43.2
#>  7  2006        36.8
#>  8  2007        32.9
#>  9  2008        33.4
#> 10  2009        36.4
#> # ℹ 22 more rows

# Kenya's debt over time, as a chart
weo |>                                    # start with the panel, and then
  filter(code == "KEN") |>                # keep Kenya's rows, and then
  ggplot(aes(x = year, y = gross_debt)) + # years across, debt up
  geom_line() +                           # draw a line
  labs(                                   # add the words:
    title = "Kenya's government debt",    # the title
    subtitle = "Percent of GDP. The last years are IMF projections", # units
    x = NULL,                             # no x axis title
    y = NULL                              # no y axis title
  )                                       # close labs()
```
