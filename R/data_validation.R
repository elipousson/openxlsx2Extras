#' Prepare a character vector as a data validation string
#'
#' [as_data_validation_value()] collapses a character vector as a single string
#' for use as a validation `value` argument by
#' [openxlsx2::wb_add_data_validation()] when `type = "list"`.
#'
#' @param x A character vector of options to allow in cell validation.
#' @param allow_blank If `TRUE`, add a blank space `" "` to the returned values.
#' @export
as_data_validation_value <- function(x, allow_blank = TRUE) {
  stopifnot(is.character(x))

  if (allow_blank) {
    x <- c(" ", x)
  }

  paste0('"', paste0(x, collapse = ","), '"')
}
