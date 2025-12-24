# Prepare a data frame with Excel style class values for formatting by openxlsx2

**\[experimental\]**

## Usage

``` r
set_excel_fmt_class(
  data,
  cols,
  fmt_class = "currency",
  multiple = TRUE,
  strict = FALSE
)
```

## Arguments

- data:

  A data frame with columns to format.

- cols:

  Column names or numbers to modify.

- fmt_class:

  Excel style class, one of: c("currency", "accounting", "hyperlink",
  "percentage", "scientific", "formula"). Length is recycled to match
  length of cols using
  [`vctrs::vec_recycle()`](https://vctrs.r-lib.org/reference/vec_recycle.html).

- multiple:

  Whether `arg` may contain zero or several values.

- strict:

  If `TRUE`, error if any character values in cols are not included in
  the names of `data`. Default `FALSE`.

## Details

`set_excel_fmt_class()` applies a style to each specified column. See
the openxlsx2 documentation for more information on this feature:
<https://janmarvin.github.io/openxlsx2/articles/openxlsx2_style_manual.html#numfmts2>
