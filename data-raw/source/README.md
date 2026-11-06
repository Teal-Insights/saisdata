# Source files

These three files are all that `data-raw/rebuild-all.R` needs. They are copies of the course's source files, byte for byte. The terms in [`LICENSE-data.md`](../../LICENSE-data.md) apply to them too. This repository's MIT license does not.

| File | Rows | What one row is | SHA-256 |
|---|---|---|---|
| `weo_2026oct_extract.csv` | 2,704 | one country (or IMF group) and one indicator, with the years across | `fb20d827faf2faf66eabbe53280d23ca643d3b5547e0d7756e56b1cc5073e879` |
| `weo_panel.csv` | 6,720 | one country (or IMF group) in one year | `8d3839febedb99b21501af6e7a87f3c87e9a763a3f564fe0a828f34a9f703e31` |
| `wb_country_groups.csv` | 217 | one country | `43a4962b1768d3989ef738f62a310ed92604e5153adc24408771c54362c06967` |

## `weo_2026oct_extract.csv`

An extract of `WEOOct2026all.xlsx`, the "October 2026 WEO Entire Dataset in Excel" file on the IMF's [WEO page](https://data.imf.org/en/datasets/IMF.RES:WEO). The workbook used has SHA-256 `2aa4f70a05931197b41ed7e0202dc56eee8d816858ac14521e4f8f5dbc38696c`. It is not in this repository.

The extract was made in three steps:

1. It stacks the workbook's Countries sheet (197 countries) and Country Groups sheet (13 groups), in the IMF's order.
2. It keeps 13 of the 44 indicators, the years 2000 to 2031, and 9 of the 29 descriptive columns, under the IMF's own names.
3. It writes each number in its shortest form. The workbook holds -0.709 as -0.70899999999999996. No value changed.

The 13 indicators are `GGR_NGDP`, `GGX_NGDP`, `GGXCNL_NGDP`, `GGXONLB_NGDP`, `GGXWDG_NGDP`, `GGXWDN_NGDP`, `NGDPD`, `NGDPDPC`, `NGDP_RPCH`, `PCPIPCH`, `LUR`, `LP` and `BCA_NGDPD`. The package's tables use four of them.

The file's line count is higher than its row count because some cells of `METHODOLOGY_NOTES` run over several lines.

## `weo_panel.csv`

`data-raw/weo_panel.R` makes this file from the extract, and `data-raw/rebuild-all.R` writes it again every time. The bytes come out the same.

## `wb_country_groups.csv`

The World Bank's classification, from `wbwdi::wdi_get_entities()` (wbwdi 1.0.3) on 3 November 2026. It keeps the 217 countries, drops the World Bank's aggregates, renames the columns, and uses the IMF's codes for Kosovo (`KOS`, the World Bank's `XKX`) and West Bank and Gaza (`WBG`, the World Bank's `PSE`). The World Bank's own code stays in `wb_code`.
