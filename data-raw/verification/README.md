# Verifying the student's install

These files check what a student gets from the one install line:

```r
install.packages("saisdata", repos = "https://teal-insights.r-universe.dev")
```

R-universe builds the `v0.1.0` tag, commit `3f5fa806daedb171f091f60d5652d88b7af08fc3`. Its registry, [Teal-Insights/teal-insights.r-universe.dev](https://github.com/Teal-Insights/teal-insights.r-universe.dev), pins that tag, so a push to `main` does not change what students install.

## Results, 6 and 7 November 2026

| Where | R | What R installed | Result |
|---|---|---|---|
| This Mac, by hand ([`mac-student-run.txt`](mac-student-run.txt)) | 4.4.2 | source package | pass |
| macOS CI | 4.3.3, 4.4.3 | source package | pass |
| macOS CI | 4.5.3 | binary, `big-sur-arm64` | pass |
| macOS CI | 4.6.2 | binary, `sonoma-arm64` | pass |
| macOS CI | 4.7.0 (R-devel) | source package, after a warning that the R 4.7 binary index is missing | pass |
| Windows CI | 4.1.3, 4.3.3, 4.4.3 | source package | pass |
| Windows CI | 4.5.3, 4.6.2, 4.7.0 (R-devel) | binary | pass |

The CI run is [verify-install 42325320567](https://github.com/Teal-Insights/saisdata/actions/runs/42325320567), and [`ci-install-summary.txt`](ci-install-summary.txt) keeps the key lines of each job. These are automated checks on GitHub's machines, not a check by a person at a Windows computer.

In every case the install ran in an empty library, with no GitHub token and in an interactive session, and it did not stop to ask anything. The source package holds only data, so no case needed a compiler: on the Mac, fake compilers first on the PATH recorded no call, and on Windows no compiler was on the PATH at all. A fresh session then loaded all three datasets, opened the help pages, checked two column totals against the release, ran the Kenya example and `example(weo)`, and found the vignette, the data terms and the citation.

On this Mac:

- The install contacted only two hosts: `teal-insights.r-universe.dev`, and `r2.ropensci.org`, where R-universe redirects every download. There was no CRAN and no GitHub. A network that filters traffic has to allow both hosts.
- The fresh sessions ran with the network denied by `sandbox-exec`. A control step first showed that the sandbox blocks a download.
- The tables installed from R-universe are `identical()` to the tables in the course's original tarball, `saisdata_0.1.0.tar.gz` (SHA-256 `72aa9823fa50a8ddff1bb16362d03c6f07bdbbf159b3b1fd0ec7e01093431968`). See [`compare-installed-output.txt`](compare-installed-output.txt).

[`check-as-cran-at-tag.txt`](check-as-cran-at-tag.txt) is `R CMD check --as-cran --no-manual` on a `git archive` of the tag. It reports 0 errors, 0 warnings and 2 notes. "New submission" appears because the package is not on CRAN. "Unable to verify current time" appears because the web service R asks for the time did not answer. It says nothing about the package. The [R-CMD-check workflow](https://github.com/Teal-Insights/saisdata/actions/runs/42273891888) for the tag also passes, including the PDF manual.

## Running it again

```sh
data-raw/verification/run-mac.sh 3f5fa806daedb171f091f60d5652d88b7af08fc3 0.1.0
gh workflow run verify-install.yaml -f expect_sha=3f5fa806daedb171f091f60d5652d88b7af08fc3 -f expect_version=0.1.0
```

`run-mac.sh` needs `python3` for [`log-hosts-proxy.py`](log-hosts-proxy.py), which records the hosts. To repeat the table comparison, install the package into an empty library and run [`compare-installed.R`](compare-installed.R) with `SAISDATA_BASELINE_TARBALL` set to the original tarball.
