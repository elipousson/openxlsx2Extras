#' Add data using `openxlsx2::wb_add_data()` with extra features
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [wb_add_data_ext()] extends [openxlsx2::wb_add_data()] to add data to a
#' workbook with special handling for input data with geometry or list columns
#' (using [prep_wb_data()]) and labelled data.
#'
#' @inheritParams prep_wb_data
#' @inheritParams openxlsx2::wb_add_data
#' @param as_table Default `FALSE`. If `TRUE`, use
#'   [openxlsx2::wb_add_data_table()] to add data to workbook. If `FALSE`, use
#'   [openxlsx2::wb_add_data()]. Additional parameters in `...` are passed to
#'   one function or the other depending on this value.
#' @inheritDotParams openxlsx2::wb_add_data
#' @inheritDotParams openxlsx2::wb_add_data_table
#' @param labels Method for handling column labels. "drop" (default) or
#'   "row_before". If "row_before", insert column labels in the row before the
#'   column names.
#' @export
#' @examples
#' wb <- wb_new_workbook("mtcars")
#'
#' wb_add_data_ext(wb, mtcars)
#'
#' wb_add_data_ext(wb, mtcars, as_table = TRUE)
#'
#' @importFrom openxlsx2 wb_add_data
wb_add_data_ext <- function(
  wb,
  x,
  sheet = current_sheet(),
  ...,
  start_row = 1,
  list_columns = c("collapse", "drop", "asis"),
  sep = "; ",
  geometry = c("drop", "coords", "wkt"),
  coords = c("lon", "lat"),
  labels = c("drop", "row_before"),
  as_table = FALSE,
  call = caller_env()
) {
  # TODO: Add support for data frame list inputs
  # if (!is.dataframe(x) && all(purr::map_lgl(x, is.data.frame))) {
  # }

  x <- prep_wb_data(
    x,
    list_columns = list_columns,
    sep = sep,
    geometry = geometry,
    coords = coords,
    call = call
  )

  # Add sheet if it doesn't already exist
  if (
    !inherits(sheet, "openxlsx2_waiver") &&
      is_string(sheet) &&
      !(sheet %in% wb$sheet_names)
  ) {
    wb <- wb$add_worksheet(sheet = sheet)
  }

  labels <- arg_match(labels, error_call = call)

  if (labels == "row_before") {
    col_labels <- get_col_labels(x)

    if (!is.null(col_labels)) {
      col_labels <- as.data.frame(t(as.data.frame(col_labels)))
      wb <- wb$add_data(
        x = col_labels,
        sheet = sheet,
        start_row = start_row,
        col_names = FALSE
      )
      start_row <- start_row + 1
    }
  }

  if (as_table) {
    wb$add_data_table(x = x, sheet = sheet, ..., start_row = start_row)
  } else {
    wb$add_data(x = x, sheet = sheet, ..., start_row = start_row)
  }

  wb
}

#' Get label attributes from each column in a data frame
#' @noRd
get_col_labels <- function(data) {
  # TODO: See if this should be replaced w/ vapply or map_chr
  unlist(lapply(data, \(x) attr(x, "label")))
}
