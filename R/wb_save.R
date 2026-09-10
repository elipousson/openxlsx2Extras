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
#' @examples
#'
#' withr::with_tempdir({
#'   wb <- wb_new_workbook(
#'     title = "Title used for output file",
#'     sheet_name = "Sheet 1"
#'   )
#'
#'   wb_save_ext(wb)
#'
#'   fs::dir_ls()
#' })
#'
#' @returns A `wbWorkbook` object, saved to `file` as a side effect.
#' @export
wb_save_ext <- function(
  wb,
  file = NULL,
  overwrite = TRUE,
  flush = FALSE
) {
  if (is.null(file)) {
    # Get properties
    core_props <- wb$get_properties()

    # Check for title
    if (!is_string(core_props[["title"]])) {
      cli::cli_abort(
        "{.arg wb} must have a title property when {.arg file} is `NULL`."
      )
    }

    # Build file path from title
    file <- fs::path_ext_set(
      fs::path_sanitize(core_props[["title"]]),
      "xlsx"
    )
  } else {
    # Validate file extension if not set by title
    fileext <- tolower(fs::path_ext(file))
    fileext <- arg_match0(fileext, "xlsx")
  }

  # Use `na.strings` value if supplied (even if input is already a workbook)
  openxlsx2::wb_save(
    wb = wb,
    file = file,
    overwrite = overwrite,
    flush = flush
  )
}


#' Write data to an xlsx file with additional features
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [write_xlsx_ext()] wraps [wb_add_data_ext()] to provide an equivalent to
#' [openxlsx2::write_xlsx()] with additional features. Arguments passed to
#' [openxlsx2::wb_workbook()] are ignored if x is a workbook instead of a data
#' frame.
#'
#' @param x Required. A `wbWorkbook` object, a data frame, or a bare list of
#'   data frames. x can also be any object coercible to a data frame (other than
#'   a bare list) by [base::as.data.frame()]. If x is a named list and
#'   `sheet_names` is supplied, the existing names for x are ignored.
#' @inheritParams wb_new_workbook
#' @inheritParams wb_add_data_ext
#' @param title,subject,category,keywords Additional workbook properties passed
#'   to [wb_new_workbook()]. Ignored (with creator and title) if `x` is a
#'   workbook instead of a data frame.
#' @inheritParams wb_add_data_ext
#' @inheritParams wb_save_ext
#' @inheritParams openxlsx2::wb_save
#' @examples
#' withr::with_tempdir({
#'   # Write data frame to XLSX file
#'   write_xlsx_ext(mtcars, "mtcars.xlsx")
#'
#'   # Write data frame to XLSX file with workbook title
#'   write_xlsx_ext(mtcars, title = "mtcars data")
#'
#'   # Write list of data frames to XLSX file with named sheets
#'   write_xlsx_ext(
#'     list(mtcars = mtcars, anscombe = anscombe),
#'     "datasets-list.xlsx"
#'   )
#'
#'   # List output files
#'   fs::dir_ls()
#' })
#'
#' @returns Invisibly returns `x` unmodified. The workbook built from `x` is
#'   saved to `file` as a side effect.
#' @export
write_xlsx_ext <- function(
  x,
  file = NULL,
  ...,
  sheet_names = NULL,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = Sys.time(),
  theme = NULL,
  keywords = NULL,
  as_table = FALSE,
  start_row = 1,
  geometry = "drop",
  labels = "drop",
  na = openxlsx2::na_strings(),
  na.strings = lifecycle::deprecated(),
  overwrite = TRUE,
  call = caller_env()
) {
  if (lifecycle::is_present(na.strings)) {
    lifecycle::deprecate_soft(
      "0.0.0.9000",
      "write_xlsx_ext(na.strings = )",
      "write_xlsx_ext(na = )"
    )
    na <- na.strings
  }

  # If x is a wbWorkbook object, use wb_save_ext to save to file
  # All other arguments except file, path, and overwrite are ignored
  if (is_wb(x)) {
    return(wb_save_ext(x, file = file, overwrite = overwrite))
  }

  wb <- as_wb(
    x = x,
    creator = creator,
    title = title,
    subject = subject,
    category = category,
    datetime_created = datetime_created,
    theme = theme,
    keywords = keywords,
    sheet_names = sheet_names,
    ...,
    na = na,
    as_table = as_table,
    start_row = start_row,
    geometry = geometry,
    labels = labels,
    call = call
  )

  # Save workbook to file
  wb_save_ext(wb, file = file, overwrite = overwrite)

  # Invisibly return x w/o modification
  invisible(x)
}
