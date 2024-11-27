#' Save a workboook object to file while filling file name from assigned
#' workbook title
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [wb_save_ext()] is a helper function extending [openxlsx2::wb_save()] by
#' filling a missing file name with the workbook title and validating the file
#' extension. This function is not stable and may change in the future.
#'
#' @inheritParams openxlsx2::wb_save
#' @inheritDotParams openxlsx2::wb_save
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
                        overwrite = TRUE,
                        ...) {
  if (is.null(file)) {
    core_props <- openxlsx2::wb_get_properties(wb)

    if (!is_string(core_props[["title"]])) {
      cli::cli_abort(
        "{.arg wb} must have a title property when {.arg file} is `NULL`."
      )
    }

    file <- fs::path_ext_set(
      core_props[["title"]],
      "xlsx"
    )
  } else {
    # Validate file extension
    fileext <- fs::path_ext(file)
    fileext <- arg_match0(fileext, "xlsx")
  }

  openxlsx2::wb_save(
    wb = wb,
    file = file,
    overwrite = overwrite,
    ...
  )
}



#' Write data to an xlsx file with additional features
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [write_xlsx_ext()] wraps [wb_add_data_ext()] to provide an equivalent to
#' [openxlsx2::write_xlsx()] with better support for sf and labelled data.
#' Arguments passed to [openxlsx2::wb_workbook()] are ignored if x is a workbook
#' instead of a data frame.
#'
#' @inheritParams openxlsx2::write_xlsx
#' @inheritParams openxlsx2::wb_workbook
#' @param title,subject,category,keywords Additional workbook properties passed
#'   to [openxlsx2::wb_workbook()]. Ignored (with creator and title) if `x` is a
#'   workbook instead of a data frame.
#' @inheritParams wb_add_data_ext
#' @inheritParams wb_save_ext
#' @export
write_xlsx_ext <- function(x,
                           file = NULL,
                           as_table = FALSE,
                           ...,
                           creator = NULL,
                           title = NULL,
                           subject = NULL,
                           category = NULL,
                           datetime_created = Sys.time(),
                           theme = NULL,
                           keywords = NULL,
                           start_row = 1,
                           overwrite = TRUE,
                           geometry = c("drop", "coords", "wkt"),
                           labels = c("drop", "row_before"),
                           call = caller_env()) {
  wb <- x

  # TODO: Implement the as_table argument
  if (as_table) {
    cli::cli_warn(
      "{.code as_table = TRUE} is not yet supported."
    )
  }

  if (is.data.frame(x)) {
    wb <- openxlsx2::wb_workbook(
      creator = creator,
      title = title,
      subject = subject,
      category = category,
      datetime_created = datetime_created,
      theme = theme,
      keywords = keywords
    )

    wb <- openxlsx2::wb_add_worksheet(wb)

    wb <- wb_add_data_ext(
      wb = wb,
      x = x,
      ...,
      start_row = start_row,
      geometry = geometry,
      labels = labels,
      call = call
    )
  }

  wb_save_ext(wb, file = file, overwrite = overwrite)
}
