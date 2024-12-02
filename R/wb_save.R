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
    core_props <- wb$get_properties()

    if (!is_string(core_props[["title"]])) {
      cli::cli_abort(
        "{.arg wb} must have a title property when {.arg file} is `NULL`."
      )
    }

    file <- fs::path_ext_set(
      fs::path_sanitize(core_props[["title"]]),
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
#' @inheritParams wb_new_workbook
#' @inheritParams wb_add_data_ext
#' @inheritParams wb_save_ext
#' @param sheet_names,creator,title,subject,category,datetime_created,theme,keywords
#'   Additional workbook properties passed to [wb_new_workbook()]. Ignored (with
#'   creator and title) if `x` is a workbook instead of a data frame.
#' @inheritParams wb_add_data_ext
#' @inheritParams wb_save_ext
#' @export
write_xlsx_ext <- function(x,
                           file = NULL,
                           as_table = FALSE,
                           ...,
                           sheet_names = NULL,
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

  if (is.data.frame(x)) {
    wb <- wb_new_workbook(
      creator = creator,
      title = title,
      subject = subject,
      category = category,
      datetime_created = datetime_created,
      theme = theme,
      keywords = keywords,
      sheet_names = sheet_names
    )

    wb <- wb_add_data_ext(
      wb = wb,
      x = x,
      ...,
      as_table = as_table,
      start_row = start_row,
      geometry = geometry,
      labels = labels,
      call = call
    )
  }

  wb_save_ext(wb, file = file, overwrite = overwrite)
}
