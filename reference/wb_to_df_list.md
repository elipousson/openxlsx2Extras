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

  An xlsx file,
  [wbWorkbook](https://janmarvin.github.io/openxlsx2/reference/wbWorkbook.html)
  object or URL to xlsx file.

- sheet_names:

  Character vector of sheet names. If not supplied, all sheet names from
  the supplied workbook are used.

- ...:

  Arguments passed on to
  [`openxlsx2::wb_to_df`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html)

  `sheet`

  :   Either sheet name or index. When missing the first sheet in the
      workbook is selected.

  `start_row`

  :   first row to begin looking for data.

  `start_col`

  :   first column to begin looking for data.

  `row_names`

  :   If `TRUE`, the first col of data will be used as row names.

  `col_names`

  :   If `TRUE`, the first row of data will be used as column names.

  `skip_empty_rows`

  :   If `TRUE`, empty rows are skipped.

  `skip_empty_cols`

  :   If `TRUE`, empty columns are skipped.

  `skip_hidden_rows`

  :   If `TRUE`, hidden rows are skipped.

  `skip_hidden_cols`

  :   If `TRUE`, hidden columns are skipped.

  `rows`

  :   A numeric vector specifying which rows in the xlsx file to read.
      If `NULL`, all rows are read.

  `cols`

  :   A numeric vector specifying which columns in the xlsx file to
      read. If `NULL`, all columns are read.

  `detect_dates`

  :   If `TRUE`, attempt to recognize dates and perform conversion.

  `na.strings`

  :   A character vector of strings which are to be interpreted as `NA`.
      Blank cells will be returned as `NA`.

  `na.numbers`

  :   A numeric vector of digits which are to be interpreted as `NA`.
      Blank cells will be returned as `NA`.

  `fill_merged_cells`

  :   If `TRUE`, the value in a merged cell is given to all cells within
      the merge.

  `dims`

  :   Character string of type "A1:B2" as optional dimensions to be
      imported.

  `show_formula`

  :   If `TRUE`, the underlying Excel formulas are shown.

  `convert`

  :   If `TRUE`, a conversion to dates and numerics is attempted.

  `types`

  :   A named numeric indicating, the type of the data. Names must match
      the returned data. See **Details** for more.

  `named_region`

  :   Character string with a `named_region` (defined name or table). If
      no sheet is selected, the first appearance will be selected. See
      [`wb_get_named_regions()`](https://janmarvin.github.io/openxlsx2/reference/named_region-wb.html)

  `keep_attributes`

  :   If `TRUE` additional attributes are returned. (These are used
      internally to define a cell type.)

  `check_names`

  :   If `TRUE` then the names of the variables in the data frame are
      checked to ensure that they are syntactically valid variable
      names.

  `show_hyperlinks`

  :   If `TRUE` instead of the displayed text, hyperlink targets are
      shown.

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
