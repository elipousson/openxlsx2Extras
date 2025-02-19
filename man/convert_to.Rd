% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert_to.R
\name{convert_to}
\alias{convert_to}
\alias{csv_to_wb}
\alias{csv_to_xlsx}
\alias{xlsx_to_csv}
\title{Convert CSV to XLSX files or XLSX to CSV}
\usage{
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
}
\arguments{
\item{file}{Path or paths to input files. For \code{\link[=csv_to_wb]{csv_to_wb()}}, users
can pass multiple CSV files when creating a workbook or xlsx file.  If these
inputs are named, the names are used as worksheet names.}

\item{new_file}{Path to output file. Optional. If \code{new_file} is not supplied
and \code{file} is a string, \code{new_file} is set to use the same path with a new
file extension or (if file is not a string) \code{new_file} is set to a temporary
file.}

\item{.f}{Function used to read or write the csv file. Defaults to
\code{utils::read.csv} for \code{\link[=csv_to_wb]{csv_to_wb()}} and \code{\link[=csv_to_xlsx]{csv_to_xlsx()}} and
\code{utils::write.csv} for \code{\link[=xlsx_to_csv]{xlsx_to_csv()}}. Other functions are allowed but must
use the input or output file name as the second argument.}

\item{...}{Additional arguments passed to \code{.f}}

\item{sheet}{A sheet in the workbook specified by \code{file} (either an index or
a sheet name). Defaults to 1.}

\item{ext}{File extension for output file. Defaults to "csv".}
}
\description{
A set of functions to convert between CSV and XLSX formats using
flexible input and output options.
}
\details{
These functions allow seamless conversion between CSV and XLSX formats:
\itemize{
\item \code{csv_to_wb}: Reads one or more CSV files and writes them to a workbook
object.
\item \code{csv_to_xlsx}: Converts one or more CSV files to a XLSX file.
\item \code{xlsx_to_csv}: Converts an XLSX file to a CSV file.
}
}
\examples{
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
}
\author{
Jordan Mark Barbone \email{jmbarbone@gmail.com}

Jan Marvin Garbuszus \email{jan.garbuszus@ruhr-uni-bochum.de}

Eli Pousson \email{eli.pousson@gmail.com}
}
