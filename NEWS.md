# saisdata 0.2.0

Files for Day 2, so the course needs no download.

- `inst/extdata/` now carries a spreadsheet of the World Bank's country groups, laid out the way official files often arrive (a title and a source note above the table), and eight saved series from the World Bank and Our World in Data, one CSV each.
- `sais_example()` lists those files or gives the path to one. `copy_course_files()` copies them all into a folder of your project.
- The three datasets are unchanged.

# saisdata 0.1.0

First public release.

- Three datasets: `weo` and `weo_groups` from the IMF's World Economic Outlook of October 2026, and `wb_groups` from the World Bank as served on 3 November 2026.
- A clean clone rebuilds every table from `data-raw/source/` with no internet. `data-raw/comparison/` holds the comparison against the course's original tables: all three are identical.
- `LICENSE-data.md` sets out the IMF's and the World Bank's terms, separately from the MIT license on the code.
