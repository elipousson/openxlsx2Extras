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
wb_sheets_cols_to_dims <- function(
  wb,
  cols,
  sheets = NULL,
  start_row = NULL,
  start_col = NULL
) {
  sheets <- sheets %||% openxlsx2::wb_get_sheet_names(wb)

  if (is.character(cols) && has_length(sheets, 1)) {
    cols <- list(cols)
  }

  cols <- vctrs::vec_recycle(
    cols,
    size = length(sheets)
  )
  # TODO: Recycle sizes for start_row and start_col also

  purrr::imap(
    sheets,
    \(x, idx) {
      wb_cols_to_dims(
        wb,
        sheet = x,
        cols = cols[[idx]],
        start_row = start_row,
        start_col = start_col
      )
    }
  )
}

#' @keywords internal
#' @rdname wb_sheets_cols_to_dims
#' @export
wb_cols_to_index <- function(
  wb,
  cols,
  sheet = current_sheet(),
  start_row = NULL,
  start_col = NULL
) {
  values <- names(openxlsx2::wb_data(
    wb,
    sheet = sheet,
    start_row = start_row,
    start_col = start_col
  ))

  match(
    cols,
    values
  )
}

#' @keywords internal
#' @rdname wb_sheets_cols_to_dims
#' @export
wb_cols_to_dims <- function(
  wb,
  cols,
  sheet = current_sheet(),
  start_row = NULL,
  start_col = NULL
) {
  openxlsx2::wb_dims(
    x = openxlsx2::wb_data(
      wb,
      sheet = sheet,
      start_row = start_row,
      start_col = start_col
    ),
    cols = cols
  )
}

#' Extended helper to specify the dims or cols arguments
#'
#' [wb_dims_ext()] extends [openxlsx2::wb_dims()] by allowing a workbook input
#' used to set `x` and supporting tidy selection for the `cols` argument.
#'
#' @inheritParams openxlsx2::wb_dims
#' @keywords internal
#' @export
wb_dims_ext <- function(
  wb = NULL,
  sheet = openxlsx2::current_sheet(),
  cols,
  x = NULL,
  select = NULL,
  start_row = NULL,
  start_col = NULL,
  error_call = rlang::caller_env()
) {
  x <- x %||%
    openxlsx2::wb_data(
      wb,
      sheet = sheet,
      start_row = start_row,
      start_col = start_col
    )

  rlang::check_installed("tidyselect")

  cols <- tidyselect::eval_select(
    expr = rlang::enquo(cols),
    data = x,
    error_call = error_call
  )

  # FIXME: Improve handling for integer(0) cols
  stopifnot(
    length(cols) != 0
  )

  if (!is.null(select) && select == "cols") {
    return(cols)
  }

  openxlsx2::wb_dims(
    x = x,
    cols = cols,
    select = select
  )
}
