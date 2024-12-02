#' Add data using `openxlsx2::wb_add_data()` with extra features
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [wb_add_data_ext()] extends [openxlsx2::wb_add_data()] to add data to a
#' workbook with special handling for input data with geometry or list columns
#' (using [prep_wb_data()]) and labelled data.
#'
#' @inheritParams openxlsx2::wb_add_data
#' @inheritDotParams openxlsx2::wb_add_data
#' @inheritParams prep_wb_data
#' @param labels Method for handling column labels. "drop" (default) or
#'   "row_before". If "row_before", insert column labels in the row before the
#'   column names.
#' @export
#' @importFrom openxlsx2 wb_add_data
wb_add_data_ext <- function(wb,
                            x,
                            ...,
                            start_row = 1,
                            geometry = c("drop", "coords", "wkt"),
                            list_columns = c("drop", "concat", "asis"),
                            labels = c("drop", "row_before"),
                            call = caller_env()) {
  x <- prep_wb_data(
    x,
    geometry = geometry,
    list_columns = list_columns,
    call = call
  )

  labels <- arg_match(labels, error_call = call)

  if (labels == "row_before") {
    col_labels <- get_col_labels(x)

    if (!is.null(labels)) {
      labels <- as.data.frame(t(as.data.frame(labels)))
      wb <- openxlsx2::wb_add_data(wb, x = labels, start_row = start_row, col_names = FALSE)
      start_row <- start_row + 1
    }
  }

  wb <- openxlsx2::wb_add_data(wb, x = x, ..., start_row = start_row)

  wb
}

#' Get label attributes from each column in a data frame
#' @noRd
get_col_labels <- function(data) {
  # TODO: See if this should be replaced w/ vapply or map_chr
  unlist(lapply(data, \(x) attr(x, "label")))
}
