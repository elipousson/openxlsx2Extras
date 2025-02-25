% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/properties.R
\name{wb_set_properties_ext}
\alias{wb_set_properties_ext}
\title{Set workbook properties}
\usage{
wb_set_properties_ext(
  wb,
  ...,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = NULL,
  datetime_modified = NULL,
  modifier = NULL,
  keywords = NULL,
  comments = NULL,
  manager = NULL,
  company = NULL,
  custom = NULL,
  properties = NULL
)
}
\arguments{
\item{wb}{A Workbook object}

\item{...}{Must be empty.}

\item{creator}{Creator of the workbook (your name). Defaults to login username or \code{options("openxlsx2.creator")} if set.}

\item{title, subject, category, keywords, comments, manager, company}{Workbook property, a string.}

\item{datetime_created}{The time of the workbook is created}

\item{datetime_modified}{The time of the workbook was last modified}

\item{modifier}{A character string indicating who was the last person to modify the workbook}

\item{custom}{A named vector of custom properties added to the workbook}

\item{properties}{A named character vector or named list of properties used
as default values for any other parameter that is not explicitly set.}
}
\value{
A workbook with modified properties.
}
\description{
\code{\link[=wb_set_properties_ext]{wb_set_properties_ext()}} extends \code{\link[openxlsx2:properties-wb]{openxlsx2::wb_set_properties()}} by adding
a properties argument that uses a named list to default default values for
existing properties.
}
