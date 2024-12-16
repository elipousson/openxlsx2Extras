#' Apply formatting function that supports sheet and dims argument to one or
#' more sheets
#'
#' [wb_sheets_fmt()] applies a formatting function to one or more sheets and
#' columns. `sheets` is recycled to match the length of `dims`. `dims` can be
#' set based on `cols` and `sheets` or set directly.
#'
#' @param .f Formatting function to apply to workbook.
#' @inheritParams wb_sheets_cols_to_dims
#' @keywords internal
#' @export
#' @importFrom openxlsx2 wb_add_numfmt
#' @importFrom vctrs vec_recycle
wb_sheets_fmt <- function(wb,
                          .f = openxlsx2::wb_add_numfmt,
                          cols = NULL,
                          sheets = NULL,
                          dims = NULL,
                          ...) {
  dims <- dims %||% wb_sheets_cols_to_dims(
    wb,
    cols = cols,
    sheets = sheets
  )

  sheets <- vctrs::vec_recycle(sheets, size = length(dims))

  for (i in seq_along(sheets)) {
    wb <- .f(wb, sheet = sheets[[i]], dims = dims[[i]], ...)
  }

  wb
}
