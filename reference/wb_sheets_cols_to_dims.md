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
