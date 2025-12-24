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

  An xlsx file,
  [wbWorkbook](https://janmarvin.github.io/openxlsx2/reference/wbWorkbook.html)
  object or URL to xlsx file.

- sheet:

  Defaults to 1.

- ...:

  Arguments passed on to
  [`openxlsx2::read_xlsx`](https://janmarvin.github.io/openxlsx2/reference/wb_to_df.html)

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

  `named_region`

  :   Character string with a `named_region` (defined name or table). If
      no sheet is selected, the first appearance will be selected. See
      [`wb_get_named_regions()`](https://janmarvin.github.io/openxlsx2/reference/named_region-wb.html)

  `check_names`

  :   If `TRUE` then the names of the variables in the data frame are
      checked to ensure that they are syntactically valid variable
      names.

  `show_hyperlinks`

  :   If `TRUE` instead of the displayed text, hyperlink targets are
      shown.

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
