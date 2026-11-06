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
# Rows, then columns
dim(weo)
#> [1] 6720    9

# The first six rows
head(weo)
#> # A tibble: 6 × 9
#>   code  name          year gross_debt primary_balance overall_balance gdp_usd_bn
#>   <chr> <chr>        <int>      <dbl>           <dbl>           <dbl>      <dbl>
#> 1 AND   Andorra, Pr…  2000       NA            NA              NA           1.43
#> 2 AND   Andorra, Pr…  2001       15.8           1.48            0.658       1.55
#> 3 AND   Andorra, Pr…  2002       15.3           1.68            0.978       1.76
#> 4 AND   Andorra, Pr…  2003       15.2           2.27            1.76        2.36
#> 5 AND   Andorra, Pr…  2004       15.1           2.43            1.86        2.90
#> 6 AND   Andorra, Pr…  2005       14.8           0.268          -0.081       3.16
#> # ℹ 2 more variables: latest_actual <int>, fiscal_year <chr>

# Kenya since 2020, with its net interest bill in percent of GDP
kenya <- subset(weo, code == "KEN" & year >= 2020 & year <= 2025)
kenya$net_interest <- kenya$primary_balance - kenya$overall_balance
kenya[, c("year", "gross_debt", "net_interest")]
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
