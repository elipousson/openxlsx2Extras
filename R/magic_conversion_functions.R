#' @title Magic Conversion Functions
#' @description A set of functions to convert between CSV and XLSX formats using
#'  flexible input and output options.
#'
#' @details
#' These functions allow seamless conversion between CSV and XLSX formats.
#' - `csv_to_wb`: Reads one or more CSV files and writes them to a workbook
#'  object.
#' - `csv_to_xlsx`: Converts CSV files to an XLSX file.
#' - `xlsx_to_csv`: Converts an XLSX file to a CSV file.
#'
#' @name magic_conversion_functions
#'
#' @importFrom utils read.csv write.csv
#' @importFrom openxlsx2 write_xlsx wb_to_df
#'
#' @examples
#' # Create example CSV file
#' csv <- tempfile(fileext = ".csv")
#' utils::write.csv(x = mtcars, file = csv)
#'
#' # Convert CSV to Workbook
#' wb <- csv_to_wb(csv = csv)
#'
#' # Convert CSV to XLSX
#' xlsx <- openxlsx2::temp_xlsx()
#' csv_to_xlsx(csv = csv, xlsx = xlsx)
#'
#' # Convert XLSX back to CSV
#' xlsx_to_csv(xlsx = xlsx, csv = csv)
NULL

#' @rdname magic_conversion_functions
#' @param csv,xlsx name of input and output files. It is possible to pass
#'  multiple CSV files when creating a workbook or XLSX file. If these inputs
#'  are named, the names will be used as worksheet names.
#' @param fun a function used to read or write the csv file. Defaults to
#'  [utils::read.csv()] and [utils::write.csv()], but other functions from other
#'  packages can be used too
#' @param ... additional arguments passed to [openxlsx2::write_xlsx()]
#' @export
csv_to_wb <- function(csv, fun = utils::read.csv, ...) {
  x <- lapply(csv, fun)
  openxlsx2::write_xlsx(x = x, ...)
}

#' @rdname magic_conversion_functions
#' @export
csv_to_xlsx <- function(csv, xlsx, fun = utils::read.csv, ...) {
  csv_to_wb(csv = csv, fun = fun, ...)$save(file = xlsx)
}

#' @rdname magic_conversion_functions
#' @param sheet a sheet in the workbook (either an index or a sheet name)
#' @param ... additional arguments passed to `fun`
#' @export
xlsx_to_csv <- function(xlsx, csv, sheet = 1, fun = utils::write.csv, ...) {
  fun(openxlsx2::wb_to_df(file = xlsx, sheet = sheet), file = csv, ...)
}
