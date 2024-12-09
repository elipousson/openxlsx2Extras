#' Coerce a data frame or list of data frames to a workbook
#'
#' [as_wb()] converts a data frame, a list of data frames, or an Excel file path
#' to a wbWorkbook object.
#'
#' @param x A data frame, a list of data frames, a file path for an Excel file,
#'   or a `wbWorkbook` object. A `wbWorkbook` is returned "as is" ignoring all
#'   other parameters. A file path is loaded to a data frame using
#'   [openxlsx2::wb_to_df()].
#' @inheritDotParams wb_add_data_ext -x
#' @inheritParams wb_new_workbook
#' @inheritParams rlang::args_error_context
#' @seealso
#' - [write_xlsx_ext()]
#' - [map_wb()]
#'
#' @examples
#' as_wb(mtcars[1:3, ])
#'
#' as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))
#'
#' @export
#' @importFrom fs file_exists
#' @importFrom openxlsx2 wb_to_df
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
                  call = caller_env()) {
  # If x is a wbWorkbook object, use wb_save_ext to save to file
  # All other arguments except file, path, and overwrite are ignored
  if (is_wb(x)) {
    return(x)
    # cli::cli_abort(
    #   "{.arg x} must be a data frame or a list of data frames,
    #   not a workbook.",
    #   call = call
    # )
  }

  type <- arg_match(type, error_call = call)

  # Validate data frame inputs
  if (!is.data.frame(x) && (type == "df")) {
    cli::cli_abort(
      "{.arg x} must be a data frame when {.code type = df}.",
      call = call
    )
  }

  if (is.character(x) && has_length(x, 1) && fs::file_exists(x)) {
    x <- openxlsx2::wb_to_df(x)
  }

  if (!is_bare_list(x)) {
    # Wrap data frame or other non-list object in a bare list
    x <- list(x)
  }

  # TODO: Check for data frames or coercibility to data frame
  # stopifnot(
  #   all(purrr::map_lgl(x, is.data.frame))
  # )

  # Set names for list (warns if x is named and sheet_names is supplied)
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
#' [map_wb()] takes a list and returns a list of `wbWorkbook` objects.
#'
#' @inheritParams as_wb
#' @inheritDotParams as_wb
#' @inheritParams purrr::map
#' @keywords internal
#' @returns A list of wbWorkbook objects.
#' @examples
#' map_wb(list(mtcars[1:3, ], mtcars[4:6, ]))
#'
#' @export
map_wb <- function(x, ..., .progress = FALSE) {
  wb_list <- purrr::map(
    x,
    \(x) {
      as_wb(x, ...)
    },
    .progress = .progress
  )

  wb_list
}
