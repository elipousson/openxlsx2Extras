# Use `dplyr::group_split` to split a workbook into a list of workbooks

`wb_split()` uses
[`wb_to_df_list()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_to_df_list.md)
to extract the data frames from each sheet of a workbook and then split
the data frames by a `.key` argument then convert each new list of data
frames back into a wbWorkbook object.

## Usage

``` r
wb_split(
  file,
  .by,
  ...,
  .keep = TRUE,
  properties = "inherit",
  wb_params = list()
)
```

## Arguments

- file:

  An xlsx file,
  [wbWorkbook](https://janmarvin.github.io/openxlsx2/reference/wbWorkbook.html)
  object or URL to xlsx file.

- .by:

  Passed to
  [`dplyr::group_split()`](https://dplyr.tidyverse.org/reference/group_split.html).

- ...:

  Arguments passed on to
  [`wb_to_df_list`](https://elipousson.github.io/openxlsx2Extras/reference/wb_to_df_list.md)

  `sheet_names`

  :   Character vector of sheet names. If not supplied, all sheet names
      from the supplied workbook are used.

- .keep:

  Should the grouping columns be kept?

- properties:

  If "inherit" (default) and `file` is a workbook, inherit the workbook
  list element properties from the existing workbook. properties can
  also be `NULL` or a named character vector, a named list, or a bare
  list of the same length as the number of groups defined using the
  `.by` argument.

- wb_params:

  List of additional parameters to pass to
  [`map_wb()`](https://elipousson.github.io/openxlsx2Extras/reference/map_wb.md)
  and
  [`as_wb()`](https://elipousson.github.io/openxlsx2Extras/reference/as_wb.md).

## Value

A list of wbWorkbook objects.

## Examples

``` r
wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))

wb_split(wb, .by = carb)
#> $`1`
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1, Sheet 2 
#>  Write order: 1, 2
#> $`4`
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1, Sheet 2 
#>  Write order: 1, 2
#> $`2`
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1, Sheet 2 
#>  Write order: 1, 2
```
