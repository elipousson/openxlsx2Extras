# Add data using `openxlsx2::wb_add_data()` with extra features

**\[experimental\]**

`wb_add_data_ext()` extends
[`openxlsx2::wb_add_data()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data.html)
to add data to a workbook with special handling for input data with
geometry or list columns (using
[`prep_wb_data()`](https://elipousson.github.io/openxlsx2Extras/reference/prep_wb_data.md))
and labelled data.

## Usage

``` r
wb_add_data_ext(
  wb,
  x,
  sheet = current_sheet(),
  ...,
  start_row = 1,
  list_columns = c("collapse", "drop", "asis"),
  sep = "; ",
  geometry = c("drop", "coords", "wkt"),
  coords = c("lon", "lat"),
  labels = c("drop", "row_before", "comments"),
  as_table = FALSE,
  na.strings = openxlsx2::na_strings(),
  call = caller_env()
)
```

## Arguments

- wb:

  A Workbook object containing a worksheet.

- x:

  Required. A data frame or an object coercible to a data frame with
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- sheet:

  The worksheet to write to. Can be the worksheet index or name.

- ...:

  Arguments passed on to
  [`openxlsx2::wb_add_data`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data.html),
  [`openxlsx2::wb_add_data_table`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data_table.html)

  `dims`

  :   Spreadsheet cell range that will determine `start_col` and
      `start_row`: "A1", "A1:B2", "A:B"

  `start_col`

  :   A vector specifying the starting column to write `x` to.

  `array`

  :   A bool if the function written is of type array

  `col_names`

  :   If `TRUE`, column names of `x` are written.

  `row_names`

  :   If `TRUE`, the row names of `x` are written.

  `with_filter`

  :   If `TRUE`, add filters to the column name row. NOTE: can only have
      one filter per worksheet.

  `name`

  :   The name of a named region if specified.

  `apply_cell_style`

  :   Should we write cell styles to the workbook

  `remove_cell_style`

  :   keep the cell style?

  `inline_strings`

  :   write characters as inline strings

  `enforce`

  :   enforce that selected dims is filled. For this to work, `dims`
      must match `x`

  `table_style`

  :   Any table style name or "none" (see
      [`vignette("openxlsx2_style_manual")`](https://janmarvin.github.io/openxlsx2/articles/openxlsx2_style_manual.html))

  `table_name`

  :   Name of table in workbook. The table name must be unique.

  `first_column`

  :   logical. If `TRUE`, the first column is bold.

  `last_column`

  :   logical. If `TRUE`, the last column is bold.

  `banded_rows`

  :   logical. If `TRUE`, rows are color banded.

  `banded_cols`

  :   logical. If `TRUE`, the columns are color banded.

  `total_row`

  :   logical. With the default `FALSE` no total row is added.

- start_row:

  A vector specifying the starting row to write `x` to.

- list_columns:

  String, one of "collapse" (default), "drop", or "asis"

- sep:

  String to use in collapsing list columns. Ignored unless
  `list_columns = "collapse"`. Defaults to `"; "`.

- geometry:

  String, one of "drop" (default), "coords", or "wkt". "coords" uses
  [`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html)
  to convert input to POINT geometry, transforms geometry to EPSG:4326,
  converts geometry to coordinates, and adds new columns with names
  matching `coords`. "wkt" converts geometry to a Well Known Text (WKT)
  character vector using
  [`sf::st_as_text()`](https://r-spatial.github.io/sf/reference/st_as_text.html)
  and replaces the existing geometry column (keeping the existing sf
  column name).

- coords:

  Length 2 character vector with column names to add if
  `geometry = "coords"`. Must be length 2 in longitude, latitude order.

- labels:

  Method for handling column labels. "drop" (default), "row_before", or
  "comments". If "row_before", insert column labels in the row before
  the column names. If "comments", add column labels as columns on the
  column names in the start row.

- as_table:

  Default `FALSE`. If `TRUE`, use
  [`openxlsx2::wb_add_data_table()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data_table.html)
  to add data to workbook. If `FALSE`, use
  [`openxlsx2::wb_add_data()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data.html).
  Additional parameters in `...` are passed to one function or the other
  depending on this value.

- na.strings:

  Value used for replacing `NA` values from `x`. Default looks if
  `options(openxlsx2.na.strings)` is set. Otherwise
  [`na_strings()`](https://janmarvin.github.io/openxlsx2/reference/waivers.html)
  uses the special `#N/A` value within the workbook.

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of
  [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
  information.

## Examples

``` r
wb <- wb_new_workbook("mtcars")

wb_add_data_ext(wb, mtcars)
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: mtcars 
#>  Write order: 1

wb_add_data_ext(wb, mtcars, as_table = TRUE)
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: mtcars 
#>  Write order: 1
```
