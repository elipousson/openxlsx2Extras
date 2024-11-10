#' Add data using `openxlsx2::wb_add_data()` with extra features
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [wb_add_data_ext()] extends [openxlsx2::wb_add_data()] to add data to a
#' workbook with special handling for sf input objects and labelled data.
#'
#' @inheritParams openxlsx2::wb_add_data
#' @inheritDotParams openxlsx2::wb_add_data
#' @param geometry String, one of "drop" (default), "coords", or "wkt". Both
#'   "coords" and  "wkt" are not yet supported.
#' @param labels Method for handling column labels. "drop" (default) or
#'   "row_before". If "row_before", insert column labels in the row before the
#'   column names.
#' @inheritParams rlang::args_error_context
#' @export
#' @importFrom openxlsx2 wb_add_data
wb_add_data_ext <- function(wb,
                            x,
                            ...,
                            start_row = 1,
                            geometry = c("drop", "coords", "wkt"),
                            labels = c("drop", "row_before"),
                            call = caller_env()) {
  is_sf_obj <- inherits(x, "sf")
  geometry <- rlang::arg_match(geometry, error_call = call)

  if (is_sf_obj && geometry == "drop") {
    x[[attr(x, "sf_column")]] <- NULL
    x <- as.data.frame(x)
  } else if (is_sf_obj && geometry == "coords") {
    check_installed("sf", call = call)
    # FIXME: Add handling for converting geometry to coordinate columns
  } else if (is_sf_obj) {
    cli::cli_abort(
      '{.code geometry = "wkt"} is not yet supported.',
      call = call
    )
  }

  labels <- rlang::arg_match(labels, error_call = call)

  if (labels == "row_before") {
    col_labels <- get_col_labels(x)

    if (!is.null(labels)) {
      labels <- as.data.frame(t(as.data.frame(labels)))
      wb <- openxlsx2::wb_add_data(wb, x = labels, start_row = start_row, col_names = FALSE)
      start_row <- start_row + 1
    }

    wb <- openxlsx2::wb_add_data(wb, x = x, ..., start_row = start_row)
  }

  wb
}

#' Get label attributes from each column in a data frame
#' @noRd
get_col_labels <- function(data) {
  unlist(lapply(data, \(x) attr(x, "label")))
}
