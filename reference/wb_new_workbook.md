# Create a new workbook and add named work sheets

`wb_new_workbook()` is a convenience function wrapping
[`openxlsx2::wb_workbook()`](https://janmarvin.github.io/openxlsx2/reference/wb_workbook.html)
and
[`openxlsx2::wb_add_worksheet()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_worksheet.html)
to offer quick and easy setup for new workbooks.

## Usage

``` r
wb_new_workbook(
  sheet_names = NULL,
  ...,
  default = "Sheet",
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

- sheet_names:

  Optional character vector of worksheet names.

- ...:

  Arguments passed on to
  [`openxlsx2::wb_add_worksheet`](https://janmarvin.github.io/openxlsx2/reference/wb_add_worksheet.html)

  `grid_lines`

  :   A logical. If `FALSE`, the worksheet grid lines will be hidden.

  `row_col_headers`

  :   A logical. If `FALSE`, the worksheet colname and rowname will be
      hidden.

  `tab_color`

  :   Color of the sheet tab. A
      [`wb_color()`](https://janmarvin.github.io/openxlsx2/reference/wb_color.html),
      a valid color (belonging to
      [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html))
      or a valid hex color beginning with "#".

  `zoom`

  :   The sheet zoom level, a numeric between 10 and 400 as a
      percentage. (A zoom value smaller than 10 will default to 10.)

  `header,odd_header,even_header,first_header,footer,odd_footer,even_footer,first_footer`

  :   Character vector of length 3 corresponding to positions left,
      center, right. `header` and `footer` are used to default
      additional arguments. Setting `even`, `odd`, or `first`, overrides
      `header`/`footer`. Use `NA` to skip a position.

  `visible`

  :   If `FALSE`, sheet is hidden else visible.

  `has_drawing`

  :   If `TRUE` prepare a drawing output (TODO does this work?)

  `paper_size`

  :   An integer corresponding to a paper size. See
      [`wb_page_setup()`](https://janmarvin.github.io/openxlsx2/reference/wb_page_setup.html)
      for details.

  `orientation`

  :   One of "portrait" or "landscape"

  `hdpi,vdpi`

  :   Horizontal and vertical DPI. Can be set with
      `options("openxlsx2.dpi" = X)`, `options("openxlsx2.hdpi" = X)` or
      `options("openxlsx2.vdpi" = X)`

- default:

  Default prefix to use for numbered sheets. Default values are used if
  `sheet_names = NULL` or if `n_sheets` is greater than the length of
  `sheet_names`. Defaults to "Sheet".

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

## Value

A `wbWorkbook` object.

## See also

[`as_wb()`](https://elipousson.github.io/openxlsx2Extras/reference/as_wb.md)

## Examples

``` r
wb_new_workbook()
#> A Workbook object.
#>  
#> Worksheets:
#>  No worksheets attached

wb_new_workbook("Sheet 1")
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1 
#>  Write order: 1

wb_new_workbook(c("Data", "Analysis"))
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Data, Analysis 
#>  Write order: 1, 2
```
