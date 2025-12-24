# Extended helper to specify the dims or cols arguments

`wb_dims_ext()` extends
[`openxlsx2::wb_dims()`](https://janmarvin.github.io/openxlsx2/reference/wb_dims.html)
by allowing a workbook input used to set `x` and supporting tidy
selection for the `cols` argument.

## Usage

``` r
wb_dims_ext(
  wb = NULL,
  sheet = openxlsx2::current_sheet(),
  cols,
  x = NULL,
  select = NULL,
  start_row = NULL,
  start_col = NULL,
  error_call = rlang::caller_env()
)
```

## Arguments

- select:

  A string, one of the followings. it improves the selection of various
  parts of `x` One of "x", "data", "col_names", or "row_names". `"data"`
  will only select the data part, excluding row names and column names
  (default if `cols` or `rows` are specified) `"x"` Includes the data,
  column and row names if they are present. (default if none of `rows`
  and `cols` are provided) `"col_names"` will only return column names
  `"row_names"` Will only return row names.
