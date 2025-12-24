# Format logical vector columns to use replacement values

`fmt_lgl_cols()` uses
[`vec_fmt_lgl()`](https://elipousson.github.io/openxlsx2Extras/reference/vec_fmt_lgl.md)
to format all (or specified) logical vector columns to use replacement
values.

## Usage

``` r
fmt_lgl_cols(
  .data,
  .cols = tidyselect::where(is.logical),
  values = c("Y", "N")
)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- .cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to transform. You can't select grouping columns because they
  are already automatically handled by the verb (i.e.
  [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  or [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)).

- values:

  Default to `c("Y", "N")` Length 2 vector where first element replaces
  `TRUE` and the second element replaces `FALSE`.

## Examples

``` r
fmt_lgl_cols(data.frame(x = c(TRUE, FALSE, TRUE)))
#>   x
#> 1 Y
#> 2 N
#> 3 Y
```
