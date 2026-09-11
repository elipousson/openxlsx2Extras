# Rename workbook sheets using a tidyselect syntax

`wb_rename_sheets()` and `wb_rename_sheets_with()` use the tidyselect
package to rename sheets.

## Usage

``` r
wb_rename_sheets(wb, ...)

wb_rename_sheets_with(wb, .fn, .sheets = tidyselect::everything())
```

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
