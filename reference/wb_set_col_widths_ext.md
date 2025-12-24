# Set workbook column widths

`wb_set_col_widths_ext()` extends
[`openxlsx2::wb_set_col_widths()`](https://janmarvin.github.io/openxlsx2/reference/col_widths-wb.html)
by making `cols` optional (defaults to all columns) and allows setting
columns based on column names (rather than index position alone).

## Usage

``` r
wb_set_col_widths_ext(
  wb,
  cols = NULL,
  widths = "auto",
  sheet = current_sheet()
)
```

## Arguments

- wb:

  A `wbWorkbook` object.

- cols:

  Indices of cols to set/remove column widths.

- widths:

  Width to set `cols` to specified column width or `"auto"` for
  automatic sizing. `widths` is recycled to the length of `cols`.
  openxlsx2 sets the default width is 8.43, as this is the standard in
  some spreadsheet software. See **Details** for general information on
  column widths.

- sheet:

  A name or index of a worksheet, a vector in the case of `remove_`

## See also

[`openxlsx2::wb_data()`](https://janmarvin.github.io/openxlsx2/reference/wb_data.html),
[`openxlsx2::col_widths-wb()`](https://janmarvin.github.io/openxlsx2/reference/col_widths-wb.html)

## Examples

``` r
wb <- as_wb(mtcars)

wb_set_col_widths_ext(wb, cols = "drat")

# `cols` is optional
wb_set_col_widths_ext(wb)
```
