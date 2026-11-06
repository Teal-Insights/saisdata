# Data terms

The MIT license in `LICENSE` and `LICENSE.md` covers this package's code and documentation. It does not cover the data. The data keep the terms of the institutions that publish them.

| Dataset | Published by | Terms |
|---|---|---|
| `weo`, `weo_groups` | International Monetary Fund | The IMF's special terms for statistical data |
| `wb_groups` | The World Bank | CC BY 4.0, with the World Bank's added terms for datasets |

This package is not an official IMF or World Bank product.

Neither institution has sponsored, approved or endorsed it. The terms below are a plain-language summary, read on 6 November 2026. The institutions' own pages control, and they can change.

## The IMF's data: `weo` and `weo_groups`

**The terms.** The section "The Use of IMF Data" on the IMF's Copyright and Usage page, <https://www.imf.org/en/About/copyright-and-terms> (effective 11 October 2024). It names the World Economic Outlook database as covered data, and it sets aside the general limits on IMF content where it gives wider permission.

**What you may do.** Download, extract, copy, make derivative works from, publish, distribute and use the data.

**What you must do.**

- Credit the IMF wherever the data are distributed or reproduced, in the form the IMF gives: `Source: International Monetary Fund, Database Name, <link to the dataset>`. For these tables that is: Source: International Monetary Fund, World Economic Outlook Database, October 2026, <https://data.imf.org/en/datasets/IMF.RES:WEO>.
- Keep the data accurate. Do not alter them in a way that intentionally affects their nature or accuracy.
- If you materially transform the data, say so next to the credit. Net interest is one example: it is a calculation, not an IMF series.
- If you make the data available to other people, in any kind of distribution or download environment, make reasonable efforts to tell them about these terms and to promote compliance. This file, the help pages and the README are how this package does that. If you pass the data on, keep this file with them.
- If you sell the data as a standalone product, tell buyers they are free from the IMF.

**Commercial reuse.** The IMF asks that any potential commercial reuse start with an email to copyright@imf.org requesting permission. This package is free, and nothing in it is sold. If your own use is commercial, ask the IMF.

**The IMF's general terms still apply where the data terms are silent.** In particular: do not imply that the IMF endorses or is affiliated with your work; do not use the IMF's seal or identifying marks without its permission; do not bulk-download from IMF sites by automated means without its explicit permission; and do not use its content to train large language models without its explicit permission. The IMF provides the data as is, with no warranty.

**What this package changed.**

- `data-raw/source/weo_2026oct_extract.csv` is an extract of the IMF's workbook `WEOOct2026all.xlsx`. It stacks the Countries and Country Groups sheets, keeps 13 of 44 indicators, the years 2000 to 2031 and 9 of 29 descriptive columns, and writes each number in its shortest form. No value changed.
- `weo` keeps four of those indicators, gives them plain names, reshapes them to one row per entity and year, rounds them to three decimals, and adds two columns worked out from the IMF's labels: `latest_actual` and `fiscal_year`.
- `weo_groups` keeps six rows of the extract and the years 2001 to 2031, renames five columns, and writes the IMF's `SCALE` and `UNIT` in plain words. No number changed.

If you republish `weo` itself, add this next to the credit: Reshaped and rounded to three decimals by the saisdata R package.

## The World Bank's data: `wb_groups`

**The terms.** The World Bank's Terms of Use for Datasets, <https://www.worldbank.org/ext/en/legal/terms-conditions/datasets> (last updated 23 March 2018), and its licensing page, <https://datacatalog.worldbank.org/public-licenses>. Datasets in the World Bank's Data Catalog are under the Creative Commons Attribution 4.0 International license, <https://creativecommons.org/licenses/by/4.0/>, unless labeled otherwise. The classification by income and lending group is published with the World Development Indicators, <https://datacatalog.worldbank.org/search/dataset/0037712/world-development-indicators>, which the catalog labels CC BY 4.0.

**What you may do.** Copy, share and adapt the data, for any purpose, commercial use included.

**What you must do.**

- Credit the World Bank in the format it gives: `The World Bank: Dataset name: Data source (if known)`. For this table that is: The World Bank: World Development Indicators: country and lending groups.
- Say what you changed, and link to the license.
- When you share the data, pass on the same attribution requirement. The World Bank's terms say that giving the web address of its Terms of Use for Datasets is enough: <https://www.worldbank.org/ext/en/legal/terms-conditions/datasets>.
- Do not imply that the World Bank takes part in, sponsors, approves or endorses your use, and do not use its name, marks or logo to suggest an association.

**What the World Bank adds to CC BY 4.0.** Disputes under the license go to non-binding mediation and then, if not settled within 45 days, to arbitration. Using the data means agreeing to this. The World Bank gives no warranty.

**What this package changed.** It keeps the 217 countries and drops the World Bank's aggregates such as "Sub-Saharan Africa"; renames the columns; and uses the IMF's codes for Kosovo (`KOS`, the World Bank's `XKX`) and West Bank and Gaza (`WBG`, the World Bank's `PSE`), so that one join matches every country. The World Bank's own code stays in `wb_code`.

## The line to print under a chart

> Source: International Monetary Fund, World Economic Outlook Database, October 2026, https://data.imf.org/en/datasets/IMF.RES:WEO. Country groups: The World Bank: World Development Indicators: country and lending groups (CC BY 4.0). Net interest is the primary balance minus the overall balance, calculated for this workshop.

Drop the second sentence if your chart uses no World Bank groups, and the third if it shows no net interest.

## How to cite the data in a report

- International Monetary Fund. 2026. World Economic Outlook Database, October 2026. Washington, DC: IMF. <https://data.imf.org/en/datasets/IMF.RES:WEO>.
- The World Bank: World Development Indicators: country and lending groups. Retrieved on 3 November 2026. CC BY 4.0. <https://datacatalog.worldbank.org/search/dataset/0037712/world-development-indicators>.

In R, `citation("saisdata")` prints these with a citation for the package.
