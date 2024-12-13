% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_wb_data.R
\name{prep_wb_data}
\alias{prep_wb_data}
\title{Prepare data for adding to a workbook}
\usage{
prep_wb_data(
  x,
  list_columns = c("collapse", "drop", "asis"),
  sep = "; ",
  geometry = c("drop", "coords", "wkt"),
  coords = c("lon", "lat"),
  call = caller_env()
)
}
\arguments{
\item{x}{Required. A data frame or an object coercible to a data frame with
\code{\link[base:as.data.frame]{base::as.data.frame()}}.}

\item{list_columns}{String, one of "collapse" (default), "drop", or "asis"}

\item{sep}{String to use in collapsing list columns. Ignored unless
\code{list_columns = "collapse"}. Defaults to \code{"; "}.}

\item{geometry}{String, one of "drop" (default), "coords", or "wkt". "coords"
uses \code{\link[sf:geos_unary]{sf::st_centroid()}} to convert input to POINT geometry, transforms
geometry to EPSG:4326, converts geometry to coordinates, and adds new
columns with names matching \code{coords}. "wkt" converts geometry to a Well
Known Text (WKT) character vector using \code{\link[sf:st_as_text]{sf::st_as_text()}} and replaces the
existing geometry column (keeping the existing sf column name).}

\item{coords}{Length 2 character vector with column names to add if \code{geometry = "coords"}. Must be length 2 in longitude, latitude order.}

\item{call}{The execution environment of a currently
running function, e.g. \code{caller_env()}. The function will be
mentioned in error messages as the source of the error. See the
\code{call} argument of \code{\link[rlang:abort]{abort()}} for more information.}
}
\description{
\code{\link[=prep_wb_data]{prep_wb_data()}} prepares a data frame for addition to a workbook by handling
list columns and geometry columns (for sf data frames).
}
\examples{

list_df <- vctrs::data_frame(
  num = 1,
  alpha = list(list("A", "B", "C"))
)

prep_wb_data(list_df)

prep_wb_data(list_df, list_columns = "drop")

prep_wb_data(list_df, list_columns = "asis")

if (rlang::is_installed("sf")) {
  nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))

  prep_wb_data(nc, geometry = "coords")

  prep_wb_data(nc, geometry = "wkt")
}

}
\keyword{utils}
