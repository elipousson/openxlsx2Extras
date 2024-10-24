
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openxlsx2Extras

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

The goal of openxlsx2Extras is to extend the functionality of the
{openxlsx2} R package.

## Installation

You can install the development version of openxlsx2Extras like so:

``` r
pak::pkg_install("elipousson/openxlsx2Extras")
```

## Example

This is a basic example which shows how to use `wb_save_ext()` to set a
filename based on the workbook title:

``` r
library(openxlsx2)
library(openxlsx2Extras)

withr::with_tempdir({
  wb_workbook(
    title = "Title used for output file"
  ) |>
    wb_add_worksheet() |>
    wb_save_ext()

  fs::dir_ls()
})
#> Title used for output file.xlsx
```
