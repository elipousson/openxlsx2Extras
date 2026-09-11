#' Rename workbook sheets using a tidyselect syntax
#'
#' `wb_rename_sheets()` and `wb_rename_sheets_with()` use the tidyselect package
#'  to rename sheets.
#'
#' @examples
#' wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
#' wb_rename_sheets(wb, sales = "a", inventory = "b")
#'
#' wb2 <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
#' wb_rename_sheets_with(wb2, \(x) paste0("sheet_", x))
#'
#' @returns A `wbWorkbook` object.
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
#' @returns A `wbWorkbook` object.
#' @export
wb_rename_sheets_with <- function(wb, .fn, .sheets = tidyselect::everything()) {
  existing_sheet_names <- openxlsx2::wb_get_sheet_names(wb)

  check_installed("tidyselect")

  select_sheet_names <- tidyselect::eval_select(
    expr = .sheets,
    data = existing_sheet_names
  )

  existing_sheet_names <- existing_sheet_names[select_sheet_names]

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

#' Rename column names in workbook data
#'
#' Use [tidyselect::eval_rename()] to rename columns in workbook data.
#'
#' @examples
#' wb <- as_wb(mtcars[1:3, c("mpg", "hp")])
#'
#' wb_rename_data(wb, MPG = mpg, HP = hp)
#'
#' @returns A `wbWorkbook` object.
#' @export
wb_rename_data <- function(
  wb,
  ...,
  sheet = 1,
  start_row = 1,
  start_col = 1
) {
  check_installed("tidyselect")

  existing_col_names <- openxlsx2::wb_read(
    wb,
    sheet = sheet,
    rows = start_row,
    start_col = start_col
  )

  replacement_col_names <- names(existing_col_names)

  new_col_names <- tidyselect::eval_rename(
    expr = rlang::expr(c(...)),
    data = existing_col_names
  )

  if (length(new_col_names) == 0) {
    return(wb)
  }

  replacement_col_names[new_col_names] <- names(new_col_names)

  replacement_col_names <- as.data.frame(t(as.data.frame(
    replacement_col_names
  )))

  openxlsx2::wb_add_data(
    wb,
    sheet = sheet,
    x = replacement_col_names,
    col_names = FALSE,
    start_row = start_row,
    start_col = start_col
  )
}
