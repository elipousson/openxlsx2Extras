#' Set workbook column widths
#'
#' [wb_set_col_widths_ext()] extends [openxlsx2::wb_set_col_widths()] by making
#' `cols` optional (defaults to all columns) and allows setting columns based on
#' column names (rather than index position alone).
#'
#' @inheritParams openxlsx2::wb_set_col_widths
#' @seealso
#'  [openxlsx2::wb_data()], [openxlsx2::col_widths-wb()]
#' @examples
#' wb <- as_wb(mtcars)
#'
#' wb_set_col_widths_ext(wb, cols = "drat")
#'
#' # `cols` is optional
#' wb_set_col_widths_ext(wb)
#'
#' @keywords internal
#' @export
#' @importFrom openxlsx2 wb_data wb_set_col_widths
wb_set_col_widths_ext <- function(wb,
                                  cols = NULL,
                                  widths = "auto",
                                  sheet = current_sheet()) {
  cols <- cols %||% seq(ncol(openxlsx2::wb_data(wb, sheet = sheet)))

  if (any(is.na(suppressWarnings(as.integer(cols))))) {
    cols <- wb_cols_to_index(
      wb,
      cols = cols,
      sheet = sheet
    )
  }

  openxlsx2::wb_set_col_widths(
    wb = wb,
    sheet = sheet,
    cols = cols,
    widths = widths
  )
}
