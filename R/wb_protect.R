#' Protect one or more sheets in a workbook
#'
#' @param properties Defaults to `c("insertColumns", "insertRows",
#' "deleteColumns", "deleteRows")`
#' @inheritParams openxlsx2::wb_protect_worksheet
#' @export
wb_protect_worksheets <- function(
  wb,
  sheet = NULL,
  protect = TRUE,
  password = NULL,
  properties = c(
    "insertColumns",
    "insertRows",
    "deleteColumns",
    "deleteRows"
  )
) {
  sheet <- sheet %||% wb$sheet_names

  purrr::reduce(
    sheet,
    \(x, y) {
      openxlsx2::wb_protect_worksheet(
        wb = x,
        sheet = y,
        properties = properties,
        protect = protect,
        password = password
      )
    },
    .init = wb
  )
}
