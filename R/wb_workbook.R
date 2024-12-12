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
#' @param properties A named list (typically from
#'   [openxlsx2::wb_get_properties()]) used to set new workbook properties for
#'   any values set to `NULL`. `datetime_created` defaults to [Sys.time()] so
#'   must be set to `NULL` to inherit value from `properties`.
#' @inheritDotParams openxlsx2::wb_add_worksheet -sheet -wb
#' @inheritParams openxlsx2::wb_workbook
#' @inheritParams rlang::args_error_context
#' @seealso [as_wb()]
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
    keywords = NULL,
    properties = NULL,
    call = caller_env()) {
  if (is.character(properties)) {
    properties <- as.list(properties)
  }

  wb <- openxlsx2::wb_workbook(
    title = title %||% properties[["title"]],
    subject = subject %||% properties[["subject"]],
    category = category %||% properties[["category"]],
    datetime_created = datetime_created %||% properties[["datetime_created"]],
    theme = theme %||% properties[["theme"]],
    keywords = keywords %||% properties[["keywords"]]
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
  params <- vctrs::vec_recycle_common(
    ...,
    .size = length(sheet_names),
    .call = call
  )

  # FIXME: There must be a more performant way to handle this
  for (i in seq_along(sheet_names)) {
    sheet_params <- purrr::map(
      params,
      \(x) {
        vctrs::vec_slice(
          x,
          i = i
        )
      }
    )

    wb <- rlang::exec(
      openxlsx2::wb_add_worksheet,
      wb = wb,
      sheet = sheet_names[[i]],
      !!!sheet_params
    )
  }

  wb
}
