# Add a named list of styles to a workbook

`wb_add_styles()` extends
[`openxlsx2::wb_add_style()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_style.html)
by allowing the addition of multiple styles as a named list.

## Usage

``` r
wb_add_styles(wb, styles, style_names = NULL)
```

## Arguments

- wb:

  A
  [wbWorkbook](https://janmarvin.github.io/openxlsx2/reference/wbWorkbook.html)
  object.

- styles:

  Required. List or style xml character, created by a ⁠create\_\*()⁠
  function. Passed to `style` argument of
  [`openxlsx2::wb_add_style()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_style.html).

- style_names:

  Optional if styles is a named list.

## Value

A `wbWorkbook` object.

## Examples

``` r
wb <- openxlsx2::wb_workbook()
wb <- openxlsx2::wb_add_worksheet(wb)

style <- openxlsx2::create_dxfs_style(font_color = openxlsx2::wb_color(hex = "FF0000"))
wb_add_styles(wb, styles = style, style_names = "myred")
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: Sheet 1 
#>  Write order: 1 
```
