% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wb_save.R
\name{write_xlsx_ext}
\alias{write_xlsx_ext}
\title{Write data to an xlsx file with additional features}
\usage{
write_xlsx_ext(
  x,
  file = NULL,
  ...,
  sheet_names = NULL,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = Sys.time(),
  theme = NULL,
  keywords = NULL,
  as_table = FALSE,
  start_row = 1,
  geometry = "drop",
  labels = "drop",
  overwrite = TRUE,
  call = caller_env()
)
}
\arguments{
\item{x}{Required. A \code{wbWorkbook} object, a data frame, or a bare list of
data frames. x can also be any object coercible to a data frame (other than
a bare list) by \code{\link[base:as.data.frame]{base::as.data.frame()}}. If x is a named list and
\code{sheet_names} is supplied, the existing names for x are ignored.}

\item{file}{A path to save the workbook to}

\item{...}{additional arguments}

\item{sheet_names}{Optional character vector of worksheet names.}

\item{creator}{Creator of the workbook (your name). Defaults to login username or \code{options("openxlsx2.creator")} if set.}

\item{title, subject, category, keywords}{Additional workbook properties passed
to \code{\link[=wb_new_workbook]{wb_new_workbook()}}. Ignored (with creator and title) if \code{x} is a
workbook instead of a data frame.}

\item{datetime_created}{The time of the workbook is created}

\item{theme}{Optional theme identified by string or number.
See \strong{Details} for options.}

\item{as_table}{Default \code{FALSE}. If \code{TRUE}, use
\code{\link[openxlsx2:wb_add_data_table]{openxlsx2::wb_add_data_table()}} to add data to workbook. If \code{FALSE}, use
\code{\link[openxlsx2:wb_add_data]{openxlsx2::wb_add_data()}}. Additional parameters in \code{...} are passed to
one function or the other depending on this value.}

\item{start_row}{A vector specifying the starting row to write \code{x} to.}

\item{geometry}{String, one of "drop" (default), "coords", or "wkt". "coords"
uses \code{\link[sf:geos_unary]{sf::st_centroid()}} to convert input to POINT geometry, transforms
geometry to EPSG:4326, converts geometry to coordinates, and adds new
columns with names matching \code{coords}. "wkt" converts geometry to a Well
Known Text (WKT) character vector using \code{\link[sf:st_as_text]{sf::st_as_text()}} and replaces the
existing geometry column (keeping the existing sf column name).}

\item{labels}{Method for handling column labels. "drop" (default) or
"row_before". If "row_before", insert column labels in the row before the
column names.}

\item{overwrite}{If \code{FALSE}, will not overwrite when \code{file} already exists.}

\item{call}{The execution environment of a currently
running function, e.g. \code{caller_env()}. The function will be
mentioned in error messages as the source of the error. See the
\code{call} argument of \code{\link[rlang:abort]{abort()}} for more information.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

\code{\link[=write_xlsx_ext]{write_xlsx_ext()}} wraps \code{\link[=wb_add_data_ext]{wb_add_data_ext()}} to provide an equivalent to
\code{\link[openxlsx2:write_xlsx]{openxlsx2::write_xlsx()}} with additional features. Arguments passed to
\code{\link[openxlsx2:wb_workbook]{openxlsx2::wb_workbook()}} are ignored if x is a workbook instead of a data
frame.
}
\examples{
withr::with_tempdir({
  # Write data frame to XLSX file
  write_xlsx_ext(mtcars, "mtcars.xlsx")

  # Write data frame to XLSX file with workbook title
  write_xlsx_ext(mtcars, title = "mtcars data")

  # Write list of data frames to XLSX file with named sheets
  write_xlsx_ext(
    list(mtcars = mtcars, anscombe = anscombe),
    "datasets-list.xlsx"
  )

  # List output files
  fs::dir_ls()
})

}
