# Convert CSV to XLSX files or XLSX to CSV

A set of functions to convert between CSV and XLSX formats using
flexible input and output options.

## Usage

``` r
csv_to_wb(file, new_file = NULL, .f = utils::read.csv, ...)

csv_to_xlsx(file, new_file = NULL, .f = utils::read.csv, ...)

xlsx_to_csv(
  file,
  new_file = NULL,
  sheet = 1,
  .f = utils::write.csv,
  ext = "csv",
  ...
)
```

## Arguments

- file:

  Path or paths to input files. For `csv_to_wb()`, users can pass
  multiple CSV files when creating a workbook or xlsx file. If these
  inputs are named, the names are used as worksheet names.

- new_file:

  Path to output file. Optional. If `new_file` is not supplied and
  `file` is a string, `new_file` is set to use the same path with a new
  file extension or (if file is not a string) `new_file` is set to a
  temporary file.

- .f:

  Function used to read or write the csv file. Defaults to
  [`utils::read.csv`](https://rdrr.io/r/utils/read.table.html) for
  `csv_to_wb()` and `csv_to_xlsx()` and
  [`utils::write.csv`](https://rdrr.io/r/utils/write.table.html) for
  `xlsx_to_csv()`. Other functions are allowed but must use the input or
  output file name as the second argument.

- ...:

  Additional arguments passed to `.f`

- sheet:

  A sheet in the workbook specified by `file` (either an index or a
  sheet name). Defaults to 1.

- ext:

  File extension for output file. Defaults to "csv".

## Details

These functions allow seamless conversion between CSV and XLSX formats:

- `csv_to_wb`: Reads one or more CSV files and writes them to a workbook
  object.

- `csv_to_xlsx`: Converts one or more CSV files to a XLSX file.

- `xlsx_to_csv`: Converts an XLSX file to a CSV file.

## Author

Jordan Mark Barbone <jmbarbone@gmail.com>

Jan Marvin Garbuszus <jan.garbuszus@ruhr-uni-bochum.de>

Eli Pousson <eli.pousson@gmail.com>

## Examples

``` r
# Create example CSV file
csv <- tempfile(fileext = ".csv")
utils::write.csv(x = mtcars, file = csv)

# Convert CSV to Workbook
wb <- csv_to_wb(file = csv)

# Convert CSV to XLSX
xlsx <- openxlsx2::temp_xlsx()
csv_to_xlsx(file = csv, new_file = xlsx)

# Convert XLSX back to CSV
xlsx_to_csv(file = xlsx, new_file = csv)
```
