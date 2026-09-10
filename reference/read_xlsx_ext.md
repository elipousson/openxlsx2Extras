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
