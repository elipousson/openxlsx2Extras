#' Create a new workbook and add named work sheets
#'
#' [wb_new_workbook()] is a convenience function wrapping
#' [openxlsx2::wb_workbook()] and [openxlsx2::wb_add_worksheet()] to offer quick
#' and easy setup for new workbooks.
#'
#' @param sheet_names Optional character vector of worksheet names.
#' @inheritParams as_sheet_names
#' @param title,subject,category,keywords Additional arguments passed to
#'   [openxlsx2::wb_workbook()].
#' @inheritDotParams openxlsx2::wb_add_worksheet -sheet -wb
#' @inheritParams openxlsx2::wb_workbook
#' @examples
#' wb_new_workbook()
#'
#' wb_new_workbook("Sheet 1")
#'
#' wb_new_workbook(c("Data", "Analysis"))
#'
#' @returns A `wbWorkbook` object.
#' @export
wb_new_workbook <- function(
    sheet_names = NULL,
    ...,
    default = "Sheet",
    creator = NULL,
    title = NULL,
    subject = NULL,
    category = NULL,
    datetime_created = Sys.time(),
    theme = NULL,
    keywords = NULL) {
  wb <- openxlsx2::wb_workbook(
    creator = creator,
    title = title,
    subject = subject,
    category = category,
    datetime_created = datetime_created,
    theme = theme,
    keywords = keywords
  )

  if (is.null(sheet_names)) {
    return(wb)
  }

  sheet_names <- as_sheet_names(
    sheet_names = sheet_names,
    default = default
  )

  # TODO: Add support for .params argument to pass list of options for each
  # sheet

  for (nm in sheet_names) {
    wb$add_worksheet(
      sheet = nm,
      ...
    )
  }

  wb
}
