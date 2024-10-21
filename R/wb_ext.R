#' Save a workboook object to file while filling file name from assigned
#' workbook title
#'
#' [wb_save_ext()] is a helper function that fills in the file name when saving
#' based on the XSLX title. This function is not stable and may change in the
#' future.
#'
#' @inheritParams openxlsx2::wb_save
#' @examples
#'
#' library(openxlsx2)
#'
#' withr::with_tempdir({
#'   wb_workbook(
#'     title = "Title used for output file"
#'   ) |>
#'     wb_add_worksheet() |>
#'     wb_save_ext()
#'
#'   fs::dir_ls()
#' })
#'
#' @export
wb_save_ext <- function(wb,
                        file = NULL,
                        ...) {
  if (is.null(file)) {
    core_props <- openxlsx2::wb_get_properties(wb)

    file <- fs::path_ext_set(
      core_props[["title"]],
      "xlsx"
    )
  }

  openxlsx2::wb_save(
    wb = wb,
    file = file,
    ...
  )
}
