# Convert a workbook to a list of data frames

`wb_to_df_list()` uses
[`openxlsx2::wb_to_df()`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html)
to extract each sheet of a workbook object into a data frame. Additional
parameters `...` are recycled to match the length of sheet names.

## Usage

``` r
wb_to_df_list(file, sheet_names = NULL, ...)
```

## Arguments

- file:

  A workbook file path, a
  [wbWorkbook](https://janmarvin.github.io/openxlsx2/reference/wbWorkbook.html)
  object, or a valid URL.

- sheet_names:

  Character vector of sheet names. If not supplied, all sheet names from
  the supplied workbook are used.

- ...:

  Arguments passed on to
  [`openxlsx2::wb_to_df`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html)

  `sheet`

  :   The name or index of the worksheet to read. Defaults to the first
      sheet.

  `start_row,start_col`

  :   Optional numeric values specifying the first row or column to
      begin data discovery.

  `row_names`

  :   Logical; if TRUE, uses the first column of the selection as row
      names.

  `col_names`

  :   Logical; if TRUE, uses the first row of the selection as column
      headers.

  `skip_empty_rows,skip_empty_cols`

  :   Logical; if TRUE, filters out rows or columns containing only
      missing values.

  `skip_hidden_rows,skip_hidden_cols`

  :   Logical; if TRUE, excludes rows or columns marked as hidden in the
      worksheet metadata.

  `rows,cols`

  :   Optional numeric vectors specifying the exact indices to read.

  `detect_dates`

  :   Logical; if TRUE, identifies date and datetime styles for
      conversion.

  `na`

  :   A character vector or a named list (e.g.,
      `list(strings = "", numbers = -99)`) defining values to treat as
      `NA`.

  `fill_merged_cells`

  :   Logical; if TRUE, propagates the top-left value of a merged range
      to all cells in that range.

  `dims`

  :   A character string defining the range. Supports wildcards (e.g.,
      "A1:++" or "A-:+5").

  `show_formula`

  :   Logical; if TRUE, returns the formula strings instead of
      calculated values.

  `convert`

  :   Logical; if TRUE, attempts to coerce columns to appropriate R
      classes.

  `types`

  :   A named vector (numeric or character) to explicitly define column
      types.

  `named_region`

  :   A character string referring to a defined name or spreadsheet
      Table.

  `keep_attributes`

  :   Logical; if TRUE, attaches metadata such as the internal type
      table (tt) and types as attributes to the output.

  `check_names`

  :   Logical; if TRUE, ensures column names are syntactically valid R
      names via
      [`make.names()`](https://rdrr.io/r/base/make.names.html).

  `show_hyperlinks`

  :   Logical; if TRUE, replaces cell values with their underlying
      hyperlink targets.

  `apply_numfmts`

  :   Logical; if TRUE, applies spreadsheet number formatting and
      returns strings.

## Value

A list of data frame lists.

## Examples

``` r
wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))

wb_to_df_list(wb)
#> $`Sheet 1`
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 2 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> 3 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> 4 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> 
#> $`Sheet 2`
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 2 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> 3 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> 4 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
#> 

wb_to_df_list(wb, "Sheet 1")
#> $`Sheet 1`
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 2 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> 3 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> 4 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> 
```
