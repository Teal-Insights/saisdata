# saisdata 0.3.1

Two more files for the lesson on bringing in data and combining sources. No table changed.

- `wdi_remittances.csv` is new: personal remittances received, in current US dollars, for 193 countries from 2000 to 2025, from the World Bank's World Development Indicators (series `BX.TRF.PWKR.CD.DT`), pulled with the wbwdi package on 10 November 2026. It is the saved copy of the lesson's one live call.
- `imf-weo-october-2026.xlsx` is new: growth, inflation, unemployment and the current account balance for the 197 countries, in the layout of the IMF's own workbook, with one row for each country and indicator and a column for each year. Its numbers are the ones in `weo`.
- `copy_course_files()` now copies eleven files.

# saisdata 0.3.0

International economic data, not only debt data.

- `weo` gains eight columns: `real_gdp_growth`, `inflation`, `unemployment_rate`, `current_account_balance`, `gdp_per_capita_usd`, `population_mn`, `revenue` and `expenditure`. Its first nine columns are unchanged, to the last number, so code written for 0.2.0 gives the same answers.
- `weo_full` is new: all 44 indicators the IMF publishes for the 197 countries, 2000 to 2031, tidy and long (238,459 rows).
- `weo_indicators` is new: one row per indicator, with its topic, its units in plain words, a one-line description, how many countries report it, and its column in `weo` where it has one.
- `weo_mini` is new: twelve rows of `weo` (six countries, two years, six indicators) that fit on one screen.
- Every table is also a CSV file in the repository's `csv/` folder, as a last chance when the package will not install. `read_csv()` reads one straight from GitHub. The folder is not part of the installed package.
- The new numbers come from the same October 2026 release, downloaded with the imfweo package. The build checks the download against the IMF's workbook, cell by cell, for the 13 indicators they share: no number differs.

# saisdata 0.2.0

Files for Day 2, so the course needs no download.

- `inst/extdata/` now carries a spreadsheet of the World Bank's country groups, laid out the way official files often arrive (a title and a source note above the table), and eight saved series from the World Bank and Our World in Data, one CSV each.
- `sais_example()` lists those files or gives the path to one. `copy_course_files()` copies them all into a folder of your project.
- The three datasets are unchanged.
- Every example now uses the tidyverse, as the course does: the help pages, the README and the Getting Started article. The package still needs nothing but R to install, and an example is skipped where the tidyverse is not installed.

# saisdata 0.1.0

First public release.

- Three datasets: `weo` and `weo_groups` from the IMF's World Economic Outlook of October 2026, and `wb_groups` from the World Bank as served on 3 November 2026.
- A clean clone rebuilds every table from `data-raw/source/` with no internet. `data-raw/comparison/` holds the comparison against the course's original tables: all three are identical.
- `LICENSE-data.md` sets out the IMF's and the World Bank's terms, separately from the MIT license on the code.
