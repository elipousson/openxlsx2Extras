# openxlsx2Extras

The goal of openxlsx2Extras is to extend the functionality of the
[{openxlsx2} R package](https://github.com/JanMarvin/openxlsx2).

This package is *very* early stages so expect things to change and break
as I learn more about {openxlsx2} and figure out the appropriate design
for this package.

## Installation

You can install the development version of openxlsx2Extras like so:

``` r
pak::pkg_install("elipousson/openxlsx2Extras")
```

## Example

``` r
library(openxlsx2)
library(openxlsx2Extras)
```

As of December 2024, the main types of functions in
[openxlsx2Extras](https://github.com/elipousson/openxlsx2Extras)
include:

- Wrapper functions for existing
  [openxlsx2](https://janmarvin.github.io/openxlsx2/) functions that add
  some extra features,
  e.g. [`wb_save_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_save_ext.md)
  wraps
  [`openxlsx2::wb_save()`](https://janmarvin.github.io/openxlsx2/reference/wb_save.html)
- Convenience functions for multiple
  [openxlsx2](https://janmarvin.github.io/openxlsx2/) for convenience
  and more concise code,
  e.g. [`openxlsx2Extras::wb_new_workbook()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_new_workbook.md)
  combines
  [`openxlsx2::wb_workbook()`](https://janmarvin.github.io/openxlsx2/reference/wb_workbook.html)
  and
  [`openxlsx2::wb_add_worksheet()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_worksheet.html)
- Other functions that support Markdown formatted text
  ([`wb_add_marquee_text()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_marquee_text.md)),
  lists of workbooks
  ([`map_wb()`](https://elipousson.github.io/openxlsx2Extras/reference/map_wb.md)),
  lists of data frames (`wb_as_df_list()`), and coercion of more kinds
  of objects into spreadsheet-friendly formats
  ([`prep_wb_data()`](https://elipousson.github.io/openxlsx2Extras/reference/prep_wb_data.md))

For example,
[`wb_save_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_save_ext.md)
allows users to set a filename based on the workbook title:

``` r
wb <- wb_workbook(
  title = "Title used for output file"
)

wb <- wb$add_worksheet()

withr::with_tempdir({
  wb_save_ext(wb)
  fs::dir_ls()
})
#> Title used for output file.xlsx
```

[`wb_new_workbook()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_new_workbook.md)
supports creating multiple worksheets in a single function call
(recycling additional arguments like `tab_color` to match the length of
`sheet_names`):

``` r
wb_new_workbook(
  title = "Workbook created with wb_new_workbook",
  sheet_names = c("First sheet", "Second sheet"),
  tab_color = c(wb_color("orange"), wb_color("yellow"))
)
#> A Workbook object.
#>  
#> Worksheets:
#>  Sheets: First sheet, Second sheet 
#>  Write order: 1, 2
```

## Related Projects

Packages extending [openxlsx](https://github.com/ycphs/openxlsx)

- [tablexlsx](https://ddotta.github.io/tablexlsx/)
  [ddotta/tablexlsx](https://github.com/ddotta/tablexlsx)
- `{a11ytables}`
  [co-analysis/a11ytables](https://github.com/co-analysis/a11ytables):
  generate best-practice stats spreadsheets for publication
- `{gtopenxlsx}`
  [yannsay/gtopenxlsx](https://github.com/yannsay/gtopenxlsx): tables to
  xlsx format through openxlsx

Packages extending [openxlsx2](https://github.com/JanMarvin/openxlsx2)

- [flexlsx](https://github.com/pteridin/flexlsx):
  [pteridin/flexlsx](https://github.com/pteridin/flexlsx) add flextables
  to Excel files
- `{a11ytables2}`:
  [matt-dray/a11ytables2](https://github.com/matt-dray/a11ytables2):
  generate best-practice stats spreadsheets for publication

Packages extending [readxl](https://readxl.tidyverse.org)

- [forgts](https://github.com/luisDVA/forgts)
  [luisDVA/forgts](https://github.com/luisDVA/forgts)}: reads a
  spreadsheet and its formatting information to produce gt tables with
  the same cell and text formatting as the input file.

Packages for working with Microsoft Office files

- [officer](https://ardata-fr.github.io/officeverse/)
  [davidgohel/officer](https://github.com/davidgohel/officer/): office
  documents from R
- `{officerExtras}`
  [elipousson/officerExtras](https://github.com/elipousson/officerExtras):
  A R package with {officer} helper functions.
