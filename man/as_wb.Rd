% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as_wb.R
\name{as_wb}
\alias{as_wb}
\title{Coerce a data frame or list of data frames to a workbook}
\usage{
as_wb(
  x,
  ...,
  sheet_names = NULL,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = Sys.time(),
  theme = NULL,
  keywords = NULL,
  properties = NULL,
  call = caller_env()
)
}
\arguments{
\item{x}{A data frame, a list of data frames, a file path for an Excel file,
or a \code{wbWorkbook} object. A \code{wbWorkbook} is returned "as is" ignoring all
other parameters. A file path is loaded to a data frame using
\code{\link[openxlsx2:wb_to_df]{openxlsx2::wb_to_df()}}.}

\item{...}{
  Arguments passed on to \code{\link[=wb_add_data_ext]{wb_add_data_ext}}
  \describe{
    \item{\code{as_table}}{Default \code{FALSE}. If \code{TRUE}, use
\code{\link[openxlsx2:wb_add_data_table]{openxlsx2::wb_add_data_table()}} to add data to workbook. If \code{FALSE}, use
\code{\link[openxlsx2:wb_add_data]{openxlsx2::wb_add_data()}}. Additional parameters in \code{...} are passed to
one function or the other depending on this value.}
    \item{\code{labels}}{Method for handling column labels. "drop" (default) or
"row_before". If "row_before", insert column labels in the row before the
column names.}
    \item{\code{list_columns}}{String, one of "collapse" (default), "drop", or "asis"}
    \item{\code{sep}}{String to use in collapsing list columns. Ignored unless
\code{list_columns = "collapse"}. Defaults to \code{"; "}.}
    \item{\code{geometry}}{String, one of "drop" (default), "coords", or "wkt". "coords"
uses \code{\link[sf:geos_unary]{sf::st_centroid()}} to convert input to POINT geometry, transforms
geometry to EPSG:4326, converts geometry to coordinates, and adds new
columns with names matching \code{coords}. "wkt" converts geometry to a Well
Known Text (WKT) character vector using \code{\link[sf:st_as_text]{sf::st_as_text()}} and replaces the
existing geometry column (keeping the existing sf column name).}
    \item{\code{coords}}{Length 2 character vector with column names to add if \code{geometry = "coords"}. Must be length 2 in longitude, latitude order.}
    \item{\code{wb}}{A Workbook object containing a worksheet.}
    \item{\code{sheet}}{The worksheet to write to. Can be the worksheet index or name.}
    \item{\code{start_row}}{A vector specifying the starting row to write \code{x} to.}
  }}

\item{sheet_names}{Optional character vector of worksheet names.}

\item{creator}{Creator of the workbook (your name). Defaults to login username or \code{options("openxlsx2.creator")} if set.}

\item{title, subject, category, keywords}{Additional arguments passed to
\code{\link[openxlsx2:wb_workbook]{openxlsx2::wb_workbook()}}.}

\item{datetime_created}{The time of the workbook is created}

\item{theme}{Optional theme identified by string or number.
See \strong{Details} for options.}

\item{properties}{A named list (typically from
\code{\link[openxlsx2:properties-wb]{openxlsx2::wb_get_properties()}}) used to set new workbook properties for
any values set to \code{NULL}. \code{datetime_created} defaults to \code{\link[=Sys.time]{Sys.time()}} so
must be set to \code{NULL} to inherit value from \code{properties}.}

\item{call}{The execution environment of a currently
running function, e.g. \code{caller_env()}. The function will be
mentioned in error messages as the source of the error. See the
\code{call} argument of \code{\link[rlang:abort]{abort()}} for more information.}
}
\description{
\code{\link[=as_wb]{as_wb()}} converts a data frame, a list of data frames, or an Excel file path
to a wbWorkbook object.
}
\examples{
as_wb(mtcars[1:3, ])

as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))

}
\seealso{
\itemize{
\item \code{\link[=write_xlsx_ext]{write_xlsx_ext()}}
\item \code{\link[=map_wb]{map_wb()}}
}
}
