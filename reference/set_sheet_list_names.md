# Set sheet names for input data

`set_sheet_list_names()` and `as_sheet_names()` are adapted from the
existing functionality for handling sheet names in
[`openxlsx2::write_xlsx()`](https://janmarvin.github.io/openxlsx2/reference/write_xlsx.html).

## Usage

``` r
set_sheet_list_names(
  x,
  sheet_names = NULL,
  ...,
  n_sheets = NULL,
  .prep_fn = prep_wb_data,
  repair = "unique",
  default = "Sheet",
  call = caller_env()
)

as_sheet_names(
  sheet_names = NULL,
  n_sheets = 1,
  default = "Sheet",
  max_length = 31,
  excess_length = c("truncate", "error"),
  repair = "unique",
  quiet = FALSE,
  arg = caller_arg(sheet_names),
  call = caller_env()
)
```

## Source

<https://github.com/JanMarvin/openxlsx2/blob/main/R/write_xlsx.R#L281-L301>

## Arguments

- sheet_names:

  One or more sheet names. Empty values ("" or " ") are replaced using
  the `default` parameter value and position in `sheet_names` vector.

- n_sheets:

  Number of sheet names to return.

- default:

  Default prefix to use for numbered sheets. Default values are used if
  `sheet_names = NULL` or if `n_sheets` is greater than the length of
  `sheet_names`. Defaults to "Sheet".

- max_length:

  Maximum allowed length in characters for sheet names. Must be 31 or
  less.

- excess_length:

  Handling for sheet names that exceed `max_length` in characters.
  "truncate" trims to length of `max_length` and "error" errors.

## Value

`x` with names set to the resolved sheet names.

A character vector of sheet names.

## Examples

``` r
set_sheet_list_names(list(mtcars[1:2, ], mtcars[3:4, ]), sheet_names = c("First", "Second"))
#> $First
#>               mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4      21   6  160 110  3.9 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag  21   6  160 110  3.9 2.875 17.02  0  1    4    4
#> 
#> $Second
#>                 mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Datsun 710     22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> 


as_sheet_names()
#> [1] "Sheet 1"

as_sheet_names("Workbook sheet")
#> [1] "Workbook sheet"

as_sheet_names(c("Workbook sheet", "Workbook sheet"), quiet = TRUE)
#> [1] "Workbook sheet...1" "Workbook sheet...2"

as_sheet_names("Workbook sheet", n_sheets = 2)
#> [1] "Workbook sheet" "Sheet 2"       

as_sheet_names("Sheet names longer than 31 characters are truncated")
#> ! Truncating `"Sheet names longer than 31 characters are truncated"` values to
#>   31 characters.
#> [1] "Sheet names longer than 31 char"
```
