# Comparison with the course's original tables

Both files hold the unedited output of `data-raw/compare-tables.R`, run after a rebuild from a clean clone.

- `against-workshop-tarball.txt` compares the rebuilt tables with `saisdata_0.1.0.tar.gz`, the package the course used before this public release. That tarball is not in this repository, so its SHA-256 is printed instead.
- `against-first-commit.txt` compares them with the original `data/*.rda` in this repository's first commit. Anyone with a full clone can repeat this one.

The `rebuild-data` GitHub Actions workflow repeats the rebuild and the second comparison on every push.
