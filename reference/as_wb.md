# Coerce a data frame or list of data frames to a workbook

`as_wb()` converts a data frame, a list of data frames, or an Excel file
path to a wbWorkbook object.

## Usage

``` r
as_wb(
  x,
  ...,
  sheet_names = NULL,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = Sys.time(),
  theme = NULL,
  keywords = NULL,
  properties = NULL,
  call = caller_env()
)
```

## Arguments

- x:

  A data frame, a list of data frames, a file path for an Excel file, or
  a `wbWorkbook` object. A `wbWorkbook` is returned "as is" ignoring all
  other parameters. A file path is loaded to a data frame using
  [`openxlsx2::wb_to_df()`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html).

- ...:

  Arguments passed on to
  [`wb_add_data_ext`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)

  `as_table`

  :   Default `FALSE`. If `TRUE`, use
      [`openxlsx2::wb_add_data_table()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data_table.html)
      to add data to workbook. If `FALSE`, use
      [`openxlsx2::wb_add_data()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data.html).
      Additional parameters in `...` are passed to one function or the
      other depending on this value.

  `labels`

  :   Method for handling column labels. "drop" (default), "row_before",
      or "comments". If "row_before", insert column labels in the row
      before the column names. If "comments", add column labels as
      columns on the column names in the start row.

  `list_columns`

  :   String, one of "collapse" (default), "drop", or "asis"

  `sep`

  :   String to use in collapsing list columns. Ignored unless
      `list_columns = "collapse"`. Defaults to `"; "`.

  `geometry`

  :   String, one of "drop" (default), "coords", or "wkt". "coords" uses
      [`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html)
      to convert input to POINT geometry, transforms geometry to
      EPSG:4326, converts geometry to coordinates, and adds new columns
      with names matching `coords`. "wkt" converts geometry to a Well
      Known Text (WKT) character vector using
      [`sf::st_as_text()`](https://r-spatial.github.io/sf/reference/st_as_text.html)
      and replaces the existing geometry column (keeping the existing sf
      column name).

  `coords`

  :   Length 2 character vector with column names to add if
      `geometry = "coords"`. Must be length 2 in longitude, latitude
      order.

  `wb`

  :   A Workbook object containing a worksheet.

  `sheet`

  :   The worksheet to write to. Can be the worksheet index or name.

  `start_row`

  :   A vector specifying the starting row to write `x` to.

  `na.strings`

  :   Value used for replacing `NA` values from `x`. Default looks if
      `options(openxlsx2.na.strings)` is set. Otherwise
      [`na_strings()`](https://janmarvin.github.io/openxlsx2/reference/waivers.html)
      uses the special `#N/A` value within the workbook.

- sheet_names:

  Optional character vector of worksheet names.

- creator:

  Creator of the workbook (your name). Defaults to login username or
  `options("openxlsx2.creator")` if set.

- title, subject, category, keywords:

  Additional arguments passed to
  [`openxlsx2::wb_workbook()`](https://janmarvin.github.io/openxlsx2/reference/wb_workbook.html).

- datetime_created:

  The time of the workbook is created

- theme:

  Optional theme identified by string or number. See **Details** for
  options.

- properties:

  A named list (typically from
  [`openxlsx2::wb_get_properties()`](https://janmarvin.github.io/openxlsx2/reference/properties-wb.html))
  used to set new workbook properties for any values set to `NULL`.
  `datetime_created` defaults to
  [`Sys.time()`](https://rdrr.io/r/base/Sys.time.html) so must be set to
  `NULL` to inherit value from `properties`.

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of
  [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
  information.

## See also

- [`write_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/write_xlsx_ext.md)

- [`map_wb()`](https://elipousson.github.io/openxlsx2Extras/reference/map_wb.md)

## Examples

``` r
as_wb(mtcars[1:3, ])
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1 
#>  Write order: 1

as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1, Sheet 2 
#>  Write order: 1, 2
```
