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

  :   Logical; if `FALSE`, the worksheet grid lines are hidden.

  `row_col_headers`

  :   Logical; if `FALSE`, row numbers and column letters are hidden.

  `tab_color`

  :   The color of the worksheet tab. Accepts a
      [`wb_color()`](https://janmarvin.github.io/openxlsx2/reference/wb_color.html)
      object, a standard R color name, or a hex color code (e.g.,
      "#4F81BD").

  `zoom`

  :   The sheet zoom level as a percentage; a numeric value between 10
      and 400. Values below 10 default to 10.

  `header,footer`

  :   Default character vectors of length three for the left, center,
      and right sections of the header or footer.

  `odd_header,odd_footer`

  :   Specific definitions for odd-numbered pages. Defaults to the
      values provided in `header` and `footer`.

  `even_header,even_footer`

  :   Specific definitions for even-numbered pages. Defaults to the
      values provided in `header` and `footer`.

  `first_header,first_footer`

  :   Specific definitions for the first page of the worksheet. Defaults
      to the values provided in `header` and `footer`.

  `visible`

  :   The visibility state of the sheet. One of "visible", "hidden", or
      "veryHidden".

  `has_drawing`

  :   *defunct*

  `paper_size`

  :   An integer code representing a standard paper size. Refer to
      [`wb_page_setup()`](https://janmarvin.github.io/openxlsx2/reference/wb_page_setup.html)
      for a complete list of codes.

  `orientation`

  :   The page orientation, either "portrait" or "landscape".

  `hdpi,vdpi`

  :   The horizontal and vertical DPI (dots per inch) for printing and
      rendering. Can be set globally via `options("openxlsx2.hdpi")`.

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
#>  

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
