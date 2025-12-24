# Prepare data for adding to a workbook

`prep_wb_data()` prepares a data frame for addition to a workbook by
handling list columns and geometry columns (for sf data frames).

## Usage

``` r
prep_wb_data(
  x,
  list_columns = c("collapse", "drop", "asis"),
  sep = "; ",
  geometry = c("drop", "coords", "wkt"),
  coords = c("lon", "lat"),
  call = caller_env()
)
```

## Arguments

- x:

  Required. A data frame or an object coercible to a data frame with
  [`base::as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- list_columns:

  String, one of "collapse" (default), "drop", or "asis"

- sep:

  String to use in collapsing list columns. Ignored unless
  `list_columns = "collapse"`. Defaults to `"; "`.

- geometry:

  String, one of "drop" (default), "coords", or "wkt". "coords" uses
  [`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html)
  to convert input to POINT geometry, transforms geometry to EPSG:4326,
  converts geometry to coordinates, and adds new columns with names
  matching `coords`. "wkt" converts geometry to a Well Known Text (WKT)
  character vector using
  [`sf::st_as_text()`](https://r-spatial.github.io/sf/reference/st_as_text.html)
  and replaces the existing geometry column (keeping the existing sf
  column name).

- coords:

  Length 2 character vector with column names to add if
  `geometry = "coords"`. Must be length 2 in longitude, latitude order.

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of
  [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
  information.

## Examples

``` r
list_df <- vctrs::data_frame(
  num = 1,
  alpha = list(list("A", "B", "C"))
)

prep_wb_data(list_df)
#>   num   alpha
#> 1   1 A; B; C

prep_wb_data(list_df, list_columns = "drop")
#>   num
#> 1   1

prep_wb_data(list_df, list_columns = "asis")
#>   num               alpha
#> 1   1 list("A", "B", "C")

if (rlang::is_installed("sf")) {
  nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))

  prep_wb_data(nc, geometry = "coords")

  prep_wb_data(nc, geometry = "wkt")
}
#> # A tibble: 100 × 15
#>     AREA PERIMETER CNTY_ CNTY_ID NAME  FIPS  FIPSNO CRESS_ID BIR74 SID74 NWBIR74
#>    <dbl>     <dbl> <dbl>   <dbl> <chr> <chr>  <dbl>    <int> <dbl> <dbl>   <dbl>
#>  1 0.114      1.44  1825    1825 Ashe  37009  37009        5  1091     1      10
#>  2 0.061      1.23  1827    1827 Alle… 37005  37005        3   487     0      10
#>  3 0.143      1.63  1828    1828 Surry 37171  37171       86  3188     5     208
#>  4 0.07       2.97  1831    1831 Curr… 37053  37053       27   508     1     123
#>  5 0.153      2.21  1832    1832 Nort… 37131  37131       66  1421     9    1066
#>  6 0.097      1.67  1833    1833 Hert… 37091  37091       46  1452     7     954
#>  7 0.062      1.55  1834    1834 Camd… 37029  37029       15   286     0     115
#>  8 0.091      1.28  1835    1835 Gates 37073  37073       37   420     0     254
#>  9 0.118      1.42  1836    1836 Warr… 37185  37185       93   968     4     748
#> 10 0.124      1.43  1837    1837 Stok… 37169  37169       85  1612     1     160
#> # ℹ 90 more rows
#> # ℹ 4 more variables: BIR79 <dbl>, SID79 <dbl>, NWBIR79 <dbl>, geometry <chr>
```
