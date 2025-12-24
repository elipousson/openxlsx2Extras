# Apply formatting function that supports sheet and dims argument to one or more sheets

`wb_sheets_fmt()` applies a formatting function to one or more sheets
and columns. `sheets` is recycled to match the length of `dims`. `dims`
can be set based on `cols` and `sheets` or set directly.

## Usage

``` r
wb_sheets_fmt(
  wb,
  .f = openxlsx2::wb_add_numfmt,
  cols = NULL,
  sheets = NULL,
  dims = NULL,
  ...
)
```

## Arguments

- .f:

  Formatting function to apply to workbook.

- cols:

  A character vector or list of character vectors. Length of cols is
  recycled to match length of sheets.

- sheets:

  Default to use all workbook sheets.
