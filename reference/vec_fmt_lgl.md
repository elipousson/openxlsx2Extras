# Format a logical vector to specified values

Format a logical vector to specified values

## Usage

``` r
vec_fmt_lgl(x, values = c("Y", "N"))
```

## Arguments

- x:

  A logical vector.

- values:

  Default to `c("Y", "N")` Length 2 vector where first element replaces
  `TRUE` and the second element replaces `FALSE`.

## Examples

``` r
vec_fmt_lgl(c(TRUE, FALSE))
#> [1] "Y" "N"

vec_fmt_lgl(c(TRUE, FALSE), c("Yes", "No"))
#> [1] "Yes" "No" 
```
