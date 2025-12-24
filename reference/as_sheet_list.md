# Prepare a data frame or list of data frames for inclusion in a workbook

`as_sheet_list()` prepares a list of data frames for inclusion in a
workbook.

## Usage

``` r
as_sheet_list(
  x,
  sheet_names = NULL,
  ...,
  n_sheets = NULL,
  .prep_fn = prep_wb_data,
  repair = "unique",
  default = "Sheet",
  call = caller_env()
)
```

## Arguments

- sheet_names:

  One or more sheet names. Empty values ("" or " ") are replaced using
  the `default` parameter value and position in `sheet_names` vector.

- ...:

  Arguments passed on to
  [`prep_wb_data`](https://elipousson.github.io/openxlsx2Extras/reference/prep_wb_data.md)

  `x`

  :   Required. A data frame or an object coercible to a data frame with
      [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

  `list_columns`

  :   String, one of "collapse" (default), "drop", or "asis"

  `sep`

  :   String to use in collapsing list columns. Ignored unless
      `list_columns = "collapse"`. Defaults to `"; "`.

  `geometry`

  :   String, one of "drop" (default), "coords", or "wkt". "coords" uses
      [`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html)
      to convert input to POINT geometry, transforms geometry to
      EPSG:4326, converts geometry to coordinates, and adds new columns
      with names matching `coords`. "wkt" converts geometry to a Well
      Known Text (WKT) character vector using
      [`sf::st_as_text()`](https://r-spatial.github.io/sf/reference/st_as_text.html)
      and replaces the existing geometry column (keeping the existing sf
      column name).

  `coords`

  :   Length 2 character vector with column names to add if
      `geometry = "coords"`. Must be length 2 in longitude, latitude
      order.

  `call`

  :   The execution environment of a currently running function, e.g.
      `caller_env()`. The function will be mentioned in error messages
      as the source of the error. See the `call` argument of
      [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
      information.

- n_sheets:

  Number of sheet names to return.

- .prep_fn:

  Function to use in preparing list of input objects. Defaults to
  [`prep_wb_data()`](https://elipousson.github.io/openxlsx2Extras/reference/prep_wb_data.md).

- default:

  Default prefix to use for numbered sheets. Default values are used if
  `sheet_names = NULL` or if `n_sheets` is greater than the length of
  `sheet_names`. Defaults to "Sheet".

## Value

A named list of data frames.

## Examples

``` r
x <- head(mtcars, 1)
y <- tail(mtcars, 1)

as_sheet_list(x)
#> $`Sheet 1`
#>           mpg cyl disp  hp drat   wt  qsec vs am gear carb
#> Mazda RX4  21   6  160 110  3.9 2.62 16.46  0  1    4    4
#> 

as_sheet_list(list(x, y))
#> $`Sheet 1`
#>           mpg cyl disp  hp drat   wt  qsec vs am gear carb
#> Mazda RX4  21   6  160 110  3.9 2.62 16.46  0  1    4    4
#> 
#> $`Sheet 2`
#>             mpg cyl disp  hp drat   wt qsec vs am gear carb
#> Volvo 142E 21.4   4  121 109 4.11 2.78 18.6  1  1    4    2
#> 

as_sheet_list(list(head = x, tail = y))
#> $head
#>           mpg cyl disp  hp drat   wt  qsec vs am gear carb
#> Mazda RX4  21   6  160 110  3.9 2.62 16.46  0  1    4    4
#> 
#> $tail
#>             mpg cyl disp  hp drat   wt qsec vs am gear carb
#> Volvo 142E 21.4   4  121 109 4.11 2.78 18.6  1  1    4    2
#> 

as_sheet_list(list(head = x, y))
#> $head
#>           mpg cyl disp  hp drat   wt  qsec vs am gear carb
#> Mazda RX4  21   6  160 110  3.9 2.62 16.46  0  1    4    4
#> 
#> $`Sheet 2`
#>             mpg cyl disp  hp drat   wt qsec vs am gear carb
#> Volvo 142E 21.4   4  121 109 4.11 2.78 18.6  1  1    4    2
#> 
```
