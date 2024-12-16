#' Get a list of dimensions from one or more sheets
#'
#' [wb_sheets_cols_to_dims()] gets a list of dimension specifications based on
#' columns. Used to get dimensions for multiple column ranges across multiple
#' sheets.
#'
#' @param cols A character vector or list of character vectors. Length of cols
#'   is recycled to match length of sheets.
#' @param sheets Default to use all workbook sheets.
#' @keywords internal
#' @export
wb_sheets_cols_to_dims <- function(wb,
                                   cols,
                                   sheets = NULL) {
  sheets <- sheets %||% openxlsx2::wb_get_sheet_names(wb)

  if (is.character(cols) && has_length(sheets, 1)) {
    cols <- list(cols)
  }

  cols <- vctrs::vec_recycle(
    cols,
    size = length(sheets)
  )

  purrr::imap(
    sheets,
    \(x, idx) {
      wb_cols_to_dims(wb, sheet = x, cols = cols[[idx]])
    }
  )
}

#' @keywords internal
#' @rdname wb_sheets_cols_to_dims
#' @export
wb_cols_to_index <- function(wb,
                             cols,
                             sheet = current_sheet()) {
  values <- names(openxlsx2::wb_data(wb, sheet = sheet))

  match(
    cols,
    values
  )
}

#' @keywords internal
#' @rdname wb_sheets_cols_to_dims
#' @export
wb_cols_to_dims <- function(wb,
                            cols,
                            sheet = current_sheet()) {
  openxlsx2::wb_dims(x = openxlsx2::wb_data(wb, sheet = sheet), cols = cols)
}
