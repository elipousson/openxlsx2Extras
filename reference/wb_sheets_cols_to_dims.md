# Get a list of dimensions from one or more sheets

`wb_sheets_cols_to_dims()` gets a list of dimension specifications based
on columns. Used to get dimensions for multiple column ranges across
multiple sheets.

## Usage

``` r
wb_sheets_cols_to_dims(
  wb,
  cols,
  sheets = NULL,
  start_row = NULL,
  start_col = NULL
)

wb_cols_to_index(
  wb,
  cols,
  sheet = current_sheet(),
  start_row = NULL,
  start_col = NULL
)

wb_cols_to_dims(
  wb,
  cols,
  sheet = current_sheet(),
  start_row = NULL,
  start_col = NULL
)
```

## Arguments

- cols:

  A character vector or list of character vectors. Length of cols is
  recycled to match length of sheets.

- sheets:

  Default to use all workbook sheets.

## Value

A list of dims character strings, one per sheet.

An integer vector of column positions matching `cols`.

A dims character string covering `cols`.

## Examples

``` r
wb <- as_wb(mtcars[1:5, ])

wb_cols_to_index(wb, cols = c("mpg", "hp"), sheet = "Sheet 1")
#> [1] 1 4

wb_cols_to_dims(wb, cols = c("mpg", "hp"), sheet = "Sheet 1")
#> [1] "A2:A6,D2:D6"

wb_sheets_cols_to_dims(wb, cols = c("mpg", "hp"), sheets = "Sheet 1")
#> [[1]]
#> [1] "A2:A6,D2:D6"
#> 
```
