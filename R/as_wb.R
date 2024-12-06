#' Coerce a data frame or list of data frames to a workbook
#'
#' [as_wb()] converts a data frame or list of data frames to a wbWorkbook
#' object.
#'
#' @param x Typically, a data frame or list of data frames. A wbWorkbook is
#'   returned as-is ignoring all other parameters. If `type = "any"`, x can also
#'   be an object that is coercible to a data frame.
#' @param type Type of objects to allow. "df-list" allows data frames and lists
#'   of data frames. "df" allows data frames only. "any" allows any input
#'   (allowing the option for [wb_add_data_ext()] to coerce objects to data
#'   frames).
#' @inheritDotParams wb_add_data_ext -x
#' @inheritParams wb_new_workbook
#' @inheritParams rlang::args_error_context
#' @seealso [write_xlsx_ext()]
#' @examples
#' as_wb(mtcars)
#'
#' as_wb(list(mtcars, mtcars))
#'
#' @export
as_wb <- function(x,
                  ...,
                  sheet_names = NULL,
                  creator = NULL,
                  title = NULL,
                  subject = NULL,
                  category = NULL,
                  datetime_created = Sys.time(),
                  theme = NULL,
                  keywords = NULL,
                  properties = NULL,
                  type = c("df-list", "df", "any"),
                  call = caller_env()) {
  # If x is a wbWorkbook object, use wb_save_ext to save to file
  # All other arguments except file, path, and overwrite are ignored
  if (inherits(x, "wbWorkbook")) {
    return(x)
    # cli::cli_abort(
    #   "{.arg x} must be a data frame or a list of data frames,
    #   not a workbook.",
    #   call = call
    # )
  }

  type <- arg_match(type, error_call = call)

  if (!is.data.frame(x) && (type == "df")) {
    cli::cli_abort(
      "{.arg x} must be a data frame when {.code type = df}.",
      call = call
    )
  }

  bare_list_input <- is_bare_list(x)

  # Put data frame or other non-list object in a bare list
  if (bare_list_input && type != "any") {
    stopifnot(
      all(purrr::map_lgl(x, is.data.frame))
    )
  } else if (!bare_list_input) {
    x <- list(x)
  }

  # Set names for list (set_sheet_list_names warns if x is named and sheet_names
  # is supplied)
  sheet_data <- set_sheet_list_names(
    x = x,
    sheet_names = sheet_names,
    .prep_fn = NULL,
    call = call
  )

  sheet_names <- names(sheet_data)

  # Create new workbook
  wb <- wb_new_workbook(
    creator = creator,
    title = title,
    subject = subject,
    category = category,
    datetime_created = datetime_created,
    theme = theme,
    keywords = keywords,
    sheet_names = sheet_names,
    properties = properties
  )

  # Add data for each named sheet
  for (nm in sheet_names) {
    # TODO: Add support for recycling parameters
    # See wb_new_workbook for an example of how to do this
    wb <- wb_add_data_ext(
      wb = wb,
      x = sheet_data[[nm]],
      sheet = nm,
      ...,
      call = call
    )
  }

  wb
}

#' Convert an object to a list of workbooks
#'
#' [map_wb()] takes a list and returns a list of wbWorkbook objects.
#'
#' @inheritParams as_wb
#' @inheritDotParams as_wb
#' @keywords internal
#' @returns A list of wbWorkbook objects.
#' @export
map_wb <- function(x, ...) {
  purrr::map(
    x,
    \(x) {
      as_wb(x, ...)
    }
  )
}
