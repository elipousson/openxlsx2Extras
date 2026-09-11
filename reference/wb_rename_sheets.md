# Rename workbook sheets using a tidyselect syntax

`wb_rename_sheets()` and `wb_rename_sheets_with()` use the tidyselect
package to rename sheets.

## Usage

``` r
wb_rename_sheets(wb, ...)

wb_rename_sheets_with(wb, .fn, .sheets = tidyselect::everything())
```

## Arguments

- wb:

  A `wbWorkbook` object.

- ...:

  For `wb_rename_sheets()`, `<new_name> = <old_name>` pairs passed to
  [`tidyselect::eval_rename()`](https://tidyselect.r-lib.org/reference/eval_select.html)
  specifying how to rename sheets.

- .fn:

  Function used to transform the selected sheet names.

- .sheets:

  Tidyselect expression selecting which sheets to rename. Defaults to
  all sheets.

## Value

A `wbWorkbook` object.

A `wbWorkbook` object.

## Examples

``` r
wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
wb_rename_sheets(wb, sales = "a", inventory = "b")
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: sales, inventory 
#>  Write order: 1, 2 

wb2 <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
wb_rename_sheets_with(wb2, \(x) paste0("sheet_", x))
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: sheet_a, sheet_b 
#>  Write order: 1, 2 
```
