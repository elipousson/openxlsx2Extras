# Rename column names in workbook data

Use
[`tidyselect::eval_rename()`](https://tidyselect.r-lib.org/reference/eval_select.html)
to rename columns in workbook data.

## Usage

``` r
wb_rename_data(wb, ..., sheet = 1, start_row = 1, start_col = 1)
```
