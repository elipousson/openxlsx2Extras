# Rename column names in workbook data

Use
[`tidyselect::eval_rename()`](https://tidyselect.r-lib.org/reference/eval_select.html)
to rename columns in workbook data.

## Usage

``` r
wb_rename_data(wb, ..., sheet = 1, start_row = 1, start_col = 1)
```

## Value

A `wbWorkbook` object.

## Examples

``` r
wb <- as_wb(mtcars[1:3, c("mpg", "hp")])

wb_rename_data(wb, MPG = mpg, HP = hp)
```
