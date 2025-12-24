# Write data to an xlsx file with additional features

**\[experimental\]**

`write_xlsx_ext()` wraps
[`wb_add_data_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)
to provide an equivalent to
[`openxlsx2::write_xlsx()`](https://janmarvin.github.io/openxlsx2/reference/write_xlsx.html)
with additional features. Arguments passed to
[`openxlsx2::wb_workbook()`](https://janmarvin.github.io/openxlsx2/reference/wb_workbook.html)
are ignored if x is a workbook instead of a data frame.

## Usage

``` r
write_xlsx_ext(
  x,
  file = NULL,
  ...,
  sheet_names = NULL,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = Sys.time(),
  theme = NULL,
  keywords = NULL,
  as_table = FALSE,
  start_row = 1,
  geometry = "drop",
  labels = "drop",
  na.strings = openxlsx2::na_strings(),
  overwrite = TRUE,
  call = caller_env()
)
```

## Arguments

- x:

  Required. A `wbWorkbook` object, a data frame, or a bare list of data
  frames. x can also be any object coercible to a data frame (other than
  a bare list) by
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).
  If x is a named list and `sheet_names` is supplied, the existing names
  for x are ignored.

- file:

  A path to save the workbook to

- ...:

  additional arguments

- sheet_names:

  Optional character vector of worksheet names.

- creator:

  Creator of the workbook (your name). Defaults to login username or
  `options("openxlsx2.creator")` if set.

- title, subject, category, keywords:

  Additional workbook properties passed to
  [`wb_new_workbook()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_new_workbook.md).
  Ignored (with creator and title) if `x` is a workbook instead of a
  data frame.

- datetime_created:

  The time of the workbook is created

- theme:

  Optional theme identified by string or number. See **Details** for
  options.

- as_table:

  Default `FALSE`. If `TRUE`, use
  [`openxlsx2::wb_add_data_table()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data_table.html)
  to add data to workbook. If `FALSE`, use
  [`openxlsx2::wb_add_data()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data.html).
  Additional parameters in `...` are passed to one function or the other
  depending on this value.

- start_row:

  A vector specifying the starting row to write `x` to.

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

- labels:

  Method for handling column labels. "drop" (default), "row_before", or
  "comments". If "row_before", insert column labels in the row before
  the column names. If "comments", add column labels as columns on the
  column names in the start row.

- na.strings:

  Value used for replacing `NA` values from `x`. Default looks if
  `options(openxlsx2.na.strings)` is set. Otherwise
  [`na_strings()`](https://janmarvin.github.io/openxlsx2/reference/waivers.html)
  uses the special `#N/A` value within the workbook.

- overwrite:

  If `FALSE`, will not overwrite when `file` already exists.

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of
  [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
  information.

## Examples

``` r
withr::with_tempdir({
  # Write data frame to XLSX file
  write_xlsx_ext(mtcars, "mtcars.xlsx")

  # Write data frame to XLSX file with workbook title
  write_xlsx_ext(mtcars, title = "mtcars data")

  # Write list of data frames to XLSX file with named sheets
  write_xlsx_ext(
    list(mtcars = mtcars, anscombe = anscombe),
    "datasets-list.xlsx"
  )

  # List output files
  fs::dir_ls()
})
#> datasets-list.xlsx mtcars data.xlsx   mtcars.xlsx        
```
