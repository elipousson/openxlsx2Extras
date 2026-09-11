# Prepare a character vector as a data validation string

`as_data_validation_value()` collapses a character vector as a single
string for use as a validation `value` argument by
[`openxlsx2::wb_add_data_validation()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data_validation.html)
when `type = "list"`.

## Usage

``` r
as_data_validation_value(x, allow_blank = TRUE)
```

## Arguments

- x:

  A character vector of options to allow in cell validation.

- allow_blank:

  If `TRUE`, add a blank space `" "` to the returned values.

## Value

A length-1 character string with `x` collapsed into a comma-separated,
quoted list.

## Examples

``` r
as_data_validation_value(c("Option A", "Option B", "Option C"))
#> [1] "\" ,Option A,Option B,Option C\""
```
