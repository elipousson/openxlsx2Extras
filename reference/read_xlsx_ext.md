# Create a data frame from a Workbook (with extra features)

**\[experimental\]**

`read_xlsx_ext()` uses
[`openxlsx2::read_xlsx()`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html)
with a few added features:

- allows use of a name repair argument (`"unique_quite"` by default) to
  avoid blank `""` or `NA` values for column names.

- allows vector inputs for the file or sheet argument. These parameters
  are recycled to a common length and result in the return of a data
  frame list unless the `combine = TRUE` is set. If `combine = TRUE`,
  set `names_to` (passed to
  [`purrr::list_rbind`](https://purrr.tidyverse.org/reference/list_c.html))
  to combined the file basename values (default) or full path values as
  a column (depending on the `names_from` argument). `names_from` can
  also be a length \> 1 character vector that can be recycled to match
  the length of file.

## Usage

``` r
read_xlsx_ext(
  file,
  sheet = 1,
  ...,
  names_from = "basename",
  names_to = rlang::zap(),
  combine = TRUE,
  repair = "unique_quiet"
)
```

## Arguments

- file:

  A workbook file path, a
  [wbWorkbook](https://janmarvin.github.io/openxlsx2/reference/wbWorkbook.html)
  object, or a valid URL.

- sheet:

  Defaults to 1.

- ...:

  Arguments passed on to
  [`openxlsx2::read_xlsx`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html)

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

- names_to:

  By default, `names(x)` are lost. To keep them, supply a string to
  `names_to` and the names will be saved into a column with that name.
  If `names_to` is supplied and `x` is not named, the position of the
  elements will be used instead of the names.

- combine:

  If `TRUE`, always return a data frames. If `FALSE`, return a list of
  data frames.

- repair:

  Either a string or a function. If a string, it must be one of
  `"check_unique"`, `"minimal"`, `"unique"`, `"universal"`,
  `"unique_quiet"`, or `"universal_quiet"`. If a function, it is invoked
  with a vector of minimal names and must return minimal names,
  otherwise an error is thrown.

  - Minimal names are never `NULL` or `NA`. When an element doesn't have
    a name, its minimal name is an empty string.

  - Unique names are unique. A suffix is appended to duplicate names to
    make them unique.

  - Universal names are unique and syntactic, meaning that you can
    safely use the names as variables without causing a syntax error.

  The `"check_unique"` option doesn't perform any name repair. Instead,
  an error is raised if the names don't suit the `"unique"` criteria.

  The options `"unique_quiet"` and `"universal_quiet"` are here to help
  the user who calls this function indirectly, via another function
  which exposes `repair` but not `quiet`. Specifying
  `repair = "unique_quiet"` is like specifying
  `repair = "unique", quiet = TRUE`. When the `"*_quiet"` options are
  used, any setting of `quiet` is silently overridden.

## Value

A data frame, or (if `combine = FALSE`) a list of data frames.

## Examples

``` r
xlsx <- openxlsx2::temp_xlsx()
openxlsx2::write_xlsx(mtcars, xlsx)

read_xlsx_ext(xlsx)
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 11 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 12 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 13 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 14 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 15 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 16 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 17 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 18 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 19 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 20 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 21 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 22 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 23 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 24 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 25 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 26 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 27 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 28 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 29 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 30 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 31 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 32 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```
