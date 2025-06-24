#' Set workbook properties
#'
#' [wb_set_properties_ext()] extends [openxlsx2::wb_set_properties()] by adding
#' a properties argument that uses a named list to default default values for
#' existing properties.
#'
#' @inheritParams openxlsx2::wb_set_properties
#' @param ... Must be empty.
#' @param properties A named character vector or named list of properties used
#'   as default values for any other parameter that is not explicitly set.
#' @returns A workbook with modified properties.
#' @export
wb_set_properties_ext <- function(
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
) {
  if (is.character(properties)) {
    properties <- as.list(properties)
  }

  check_dots_unnamed(...)

  stopifnot(
    is.null(properties) || is_bare_list(properties) && is_named(properties)
  )

  openxlsx2::wb_set_properties(
    wb,
    creator = creator %||% properties[["creator"]],
    title = title %||% properties[["title"]],
    subject = subject %||% properties[["subject"]],
    category = category %||% properties[["category"]],
    datetime_created = datetime_created %||% properties[["datetime_created"]],
    datetime_modified = datetime_modified %||%
      properties[["datetime_modified"]],
    modifier = modifier %||% properties[["modifier"]],
    keywords = keywords %||% properties[["keywords"]],
    comments = comments %||% properties[["comments"]],
    manager = manager %||% properties[["manager"]],
    company = company %||% properties[["company"]],
    custom = custom %||% properties[["custom"]]
  )
}
