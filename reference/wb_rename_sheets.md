# Rename workbook sheets using a tidyselect syntax

`wb_rename_sheets()` and `wb_rename_sheets_with()` use the tidyselect
package to rename sheets.

## Usage

``` r
wb_rename_sheets(wb, ...)

wb_rename_sheets_with(wb, .fn, .sheets = tidyselect::everything())
```
