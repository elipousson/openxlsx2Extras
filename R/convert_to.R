#' Convert CSV to XLSX files or XLSX to CSV
#'
#' @description A set of functions to convert between CSV and XLSX formats using
#'  flexible input and output options.
#'
#' @details
#' These functions allow seamless conversion between CSV and XLSX formats:
#'
#' - `csv_to_wb`: Reads one or more CSV files and writes them to a workbook
#'  object.
#' - `csv_to_xlsx`: Converts one or more CSV files to a XLSX file.
#' - `xlsx_to_csv`: Converts an XLSX file to a CSV file.
#'
#' @name convert_to
#' @author Jordan Mark Barbone \email{jmbarbone@gmail.com}
#' @author Jan Marvin Garbuszus \email{jan.garbuszus@ruhr-uni-bochum.de}
#' @author Eli Pousson \email{eli.pousson@gmail.com}
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
#' xlsx_to_csv(x = xlsx, csv = csv)
NULL

#' @rdname convert_to
#' @param file Path or paths to input files. For [csv_to_wb()], users
#' can pass multiple CSV files when creating a workbook or xlsx file.  If these
#' inputs are named, the names are used as worksheet names.
#' @param new_file Path to output file. Optional. If `new_file` is not supplied
#' and `file` is a string, `new_file` is set to use the same path with a new
#' file extension or (if file is not a string) `new_file` is set to a temporary
#' file.
#' @param .f Function used to read or write the csv file. Defaults to
#' `utils::read.csv` for [csv_to_wb()] and [csv_to_xlsx()] and
#' `utils::write.csv` for [xlsx_to_csv()]. Other functions are allowed but must
#' use the input or output file name as the second argument.
#' @param ... additional arguments passed to [openxlsx2::write_xlsx()]
#' @export
csv_to_wb <- function(file,
                      new_file = NULL,
                      .f = utils::read.csv,
                      ...) {
  x <- lapply(file, .f)
  openxlsx2::write_xlsx(x = x, file = set_new_file(file, new_file), ...)
}

#' @rdname convert_to
#' @export
csv_to_xlsx <- function(file,
                        new_file = NULL,
                        .f = utils::read.csv,
                        ...) {
  csv_to_wb(
    file,
    .f = .f,
    ...
  )$save(
    file = set_new_file(file, new_file, ext = "xlsx")
  )
}

#' @rdname convert_to
#' @param sheet A sheet in the workbook specified by `file` (either an index or
#' a sheet name). Defaults to 1.
#' @param ext File extension for output file. Defaults to "csv".
#' @param ... Additional arguments passed to `.f`
#' @export
xlsx_to_csv <- function(file,
                        new_file = NULL,
                        sheet = 1,
                        .f = utils::write.csv,
                        ext = "csv",
                        ...) {
  .f(
    openxlsx2::wb_to_df(
      file = file,
      sheet = sheet
    ),
    set_new_file(file, new_file, ext = ext),
    ...
  )
}

#' [set_new_file()] sets new_file based on file or as temporary file.
#' @noRd
#' @importFrom fs path_ext_set file_temp
set_new_file <- function(file = NULL,
                         new_file = NULL,
                         tmp_dir = tempdir(),
                         ext = "xlsx") {
  if (!is.null(new_file)) {
    return(new_file)
  }

  if (is.character(file)) {
    return(fs::path_ext_set(file, ext))
  }

  fs::file_temp(tmp_dir = tmp_dir, ext = ext)
}
