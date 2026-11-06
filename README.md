# saisdata

The course data for the SAIS MIEF R workshop, Day 1 and Day 2, ready to use in R. One line loads everything:

```r
library(saisdata) # load the course data: weo, weo_groups and wb_groups
```

No file paths, no downloads, no reading a CSV. The data arrive as tibbles, the tidyverse's tables.

## What is inside

| Dataset | What one row is | Rows | Help page |
|---|---|---|---|
| `weo` | one country (or IMF group) in one year, 2000 to 2031: gross debt, primary balance, overall balance, GDP | 6,720 | `?weo` |
| `weo_groups` | one IMF country group and one indicator, with the years across, the way the IMF publishes it | 6 | `?weo_groups` |
| `wb_groups` | one country, with its World Bank region, income level and lending type | 217 | `?wb_groups` |

`weo` and `weo_groups` come from the IMF's World Economic Outlook database of October 2026. `wb_groups` comes from the World Bank. Every help page says what each column means, in plain words, and how to credit the source.

## Install it

Once `saisdata` is on the Teal Insights r-universe, one line installs it, on Mac or Windows, with no compiler needed:

```r
install.packages( # install a package
  "saisdata", # this one
  repos = c( # look in two places, in this order
    "https://teal-insights.r-universe.dev", # Teal Insights' package site
    "https://cloud.r-project.org" # CRAN, the main archive of R packages
  )
)
```

Until then, or when the network fails, install it from the package file. The package holds only data, so this works on any laptop, with no compiler:

```r
install.packages( # install a package
  "saisdata_0.1.0.tar.gz", # from this file, in the current folder
  repos = NULL, # not from the internet
  type = "source" # from the file as it is
)
```

## A first look

```r
library(tidyverse) # dplyr, tidyr, ggplot2 and friends
library(saisdata) # the course data

weo |> # start with the panel
  filter(code == "KEN", year == 2025) |> # keep Kenya in 2025
  mutate(net_interest = primary_balance - overall_balance) # interest bill
```

The whole game starts from `weo_groups`, which arrives in the IMF's layout. Two moves make it tidy, and one more gives the interest bill in dollars:

```r
weo_groups |> # start with the IMF's layout: years across
  select(-indicator_name, -units) |> # keep the codes, drop the long text
  pivot_longer( # turn the year columns into rows
    cols = `2001`:`2031`, # every year column
    names_to = "year", # the old column names become a year column
    names_transform = as.integer, # "2025" becomes the number 2025
    values_to = "value" # the numbers go into a value column
  ) |>
  pivot_wider( # turn the indicators into columns
    names_from = indicator, # one new column per indicator code
    values_from = value # filled with the numbers
  ) |>
  mutate( # add net interest in billions of US dollars
    net_interest_usd_bn = # the new column's name
      (GGXONLB_NGDP - GGXCNL_NGDP) * # primary minus overall balance
      NGDPD / 100 # times GDP, over 100 (the balances are in percent)
  )
```

Added up over the two groups, that comes to about USD 849 billion in 2001 and USD 2,371.2 billion in 2025.

## Credit and terms

Print this line under every chart you make from these data:

> Source: International Monetary Fund, World Economic Outlook Database, October 2026, https://data.imf.org/en/datasets/IMF.RES:WEO. Country groups: World Bank (CC BY 4.0). Net interest is the primary balance minus the overall balance, calculated for this workshop.

Drop the second sentence if your chart uses no World Bank groups, and the third if it shows no net interest.

- **The package's code** is MIT licensed (`LICENSE`).
- **The IMF's data** (`weo`, `weo_groups`) are under the IMF's terms of use, <https://www.imf.org/en/About/copyright-and-terms>: you may copy, share and build on them if you credit the IMF and say what you changed. Commercial reuse needs the IMF's written permission.
- **The World Bank's data** (`wb_groups`) are under CC BY 4.0, <https://datacatalog.worldbank.org/public-licenses>: you may copy, share and adapt them, commercially too, if you credit the World Bank and say what you changed.

Each help page says what the workshop changed. These data are not an official IMF or World Bank product.

## For maintainers

The data are rebuilt from the workshop's CSV files in `starter/data/`, two folders up from this one. From this folder (`package/saisdata`), run each script in `data-raw/`:

```sh
LANG=en_US.UTF-8 Rscript data-raw/weo.R
LANG=en_US.UTF-8 Rscript data-raw/weo_groups.R
LANG=en_US.UTF-8 Rscript data-raw/wb_groups.R
```

Each script checks its table's size before it writes `data/*.rda`, and changes no number. Then build, check and install from the folder above:

```sh
R CMD build saisdata
R CMD check --no-manual saisdata_0.1.0.tar.gz
R CMD INSTALL saisdata_0.1.0.tar.gz
```

The help pages live in `R/` as roxygen comments. The files in `man/` and `NAMESPACE` were written by hand in roxygen2's format, because roxygen2 was not installed when the package was first built; with roxygen2 installed, `roxygen2::roxygenise()` regenerates them from `R/`.
