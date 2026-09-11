# Rename column names in workbook data

Use
[`tidyselect::eval_rename()`](https://tidyselect.r-lib.org/reference/eval_select.html)
to rename columns in workbook data.

## Usage

``` r
wb_rename_data(wb, ..., sheet = 1, start_row = 1, start_col = 1)
```

## Arguments

- wb:

  A `wbWorkbook` object.

- ...:

  `<new_name> = <old_name>` pairs passed to
  [`tidyselect::eval_rename()`](https://tidyselect.r-lib.org/reference/eval_select.html)
  specifying how to rename columns.

- sheet:

  Sheet containing the column names to rename. Defaults to 1.

- start_row:

  Row number containing the column names. Defaults to 1.

- start_col:

  Column number where data starts. Defaults to 1.

## Value

A `wbWorkbook` object.

## Examples

``` r
wb <- as_wb(mtcars[1:3, c("mpg", "hp")])

wb_rename_data(wb, MPG = mpg, HP = hp)
```
