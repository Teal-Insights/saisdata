# Changelog

## saisdata 0.1.0

First public release.

- Three datasets: `weo` and `weo_groups` from the IMF’s World Economic
  Outlook of October 2026, and `wb_groups` from the World Bank as served
  on 3 November 2026.
- A clean clone rebuilds every table from `data-raw/source/` with no
  internet. `data-raw/comparison/` holds the comparison against the
  course’s original tables: all three are identical.
- `LICENSE-data.md` sets out the IMF’s and the World Bank’s terms,
  separately from the MIT license on the code.
