# Convert an object to a list of workbooks

`map_wb()` takes a list and returns a list of `wbWorkbook` objects.
`properties` is recycled to match the length of the input x.

## Usage

``` r
map_wb(x, ..., properties = NULL, .progress = FALSE)
```

## Arguments

- x:

  A data frame, a list of data frames, a file path for an Excel file, or
  a `wbWorkbook` object. A `wbWorkbook` is returned "as is" ignoring all
  other parameters. A file path is loaded to a data frame using
  [`openxlsx2::wb_to_df()`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html).

- ...:

  Arguments passed on to
  [`as_wb`](https://elipousson.github.io/openxlsx2Extras/reference/as_wb.md)

  `sheet_names`

  :   Optional character vector of worksheet names.

  `title,subject,category,keywords`

  :   Additional arguments passed to
      [`openxlsx2::wb_workbook()`](https://janmarvin.github.io/openxlsx2/reference/wb_workbook.html).

  `creator`

  :   Creator of the workbook (your name). Defaults to login username or
      `options("openxlsx2.creator")` if set.

  `datetime_created`

  :   The time of the workbook is created

  `theme`

  :   Optional theme identified by string or number. See **Details** for
      options.

  `call`

  :   The execution environment of a currently running function, e.g.
      `caller_env()`. The function will be mentioned in error messages
      as the source of the error. See the `call` argument of
      [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
      information.

- properties:

  A named list (typically from
  [`openxlsx2::wb_get_properties()`](https://janmarvin.github.io/openxlsx2/reference/properties-wb.html))
  used to set new workbook properties for any values set to `NULL`.
  `datetime_created` defaults to
  [`Sys.time()`](https://rdrr.io/r/base/Sys.time.html) so must be set to
  `NULL` to inherit value from `properties`.

- .progress:

  Whether to show a progress bar. Use `TRUE` to turn on a basic progress
  bar, use a string to give it a name, or see
  [progress_bars](https://purrr.tidyverse.org/reference/progress_bars.html)
  for more details.

## Value

A list of wbWorkbook objects.

## Examples

``` r
map_wb(list(mtcars[1:3, ], mtcars[4:6, ]))
#> [[1]]
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1 
#>  Write order: 1
#> [[2]]
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1 
#>  Write order: 1
```
