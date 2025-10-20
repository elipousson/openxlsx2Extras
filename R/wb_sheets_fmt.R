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
wb_sheets_fmt <- function(
  wb,
  .f = openxlsx2::wb_add_numfmt,
  cols = NULL,
  sheets = NULL,
  dims = NULL,
  ...
) {
  dims <- dims %||%
    wb_sheets_cols_to_dims(
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

#' Rename workbook sheets using a tidyselect syntax
#'
#' `wb_rename_sheets()` and `wb_rename_sheets_with()` use the tidyselect package
#'  to rename sheets.
#'
#' @export
wb_rename_sheets <- function(
  wb,
  ...
) {
  existing_sheet_names <- openxlsx2::wb_get_sheet_names(wb)

  check_installed("tidyselect")

  new_sheet_names <- tidyselect::eval_rename(
    expr = rlang::expr(c(...)),
    data = existing_sheet_names
  )

  if (length(new_sheet_names) == 0) {
    return(wb)
  }

  purrr::reduce(
    seq_along(new_sheet_names),
    \(x, y) {
      openxlsx2::wb_set_sheet_names(
        wb = x,
        old = existing_sheet_names[y],
        new = names(new_sheet_names)[y]
      )
    },
    .init = wb
  )
}

#' @rdname wb_rename_sheets
#' @export
wb_rename_sheets_with <- function(wb, .fn, .sheets = tidyselect::everything()) {
  existing_sheet_names <- openxlsx2::wb_get_sheet_names(wb)

  check_installed("tidyselect")

  select_sheet_names <- tidyselect::eval_select(
    expr = .sheets,
    data = existing_sheet_names
  )

  new_sheet_names <- set_names(
    select_sheet_names,
    .fn(names(select_sheet_names))
  )

  purrr::reduce(
    seq_along(new_sheet_names),
    \(x, y) {
      openxlsx2::wb_set_sheet_names(
        wb = x,
        old = existing_sheet_names[y],
        new = names(new_sheet_names)[y]
      )
    },
    .init = wb
  )
}
