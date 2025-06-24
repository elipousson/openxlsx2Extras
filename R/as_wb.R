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
as_wb <- function(
  x,
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
  call = caller_env()
) {
  # If x is a wbWorkbook object, use wb_save_ext to save to file
  # All other arguments except file, path, and overwrite are ignored
  if (is_wb(x)) {
    return(x)
  }

  if (is.character(x) && has_length(x, 1) && fs::file_exists(x)) {
    x <- openxlsx2::wb_to_df(x)
  }

  if (!is_bare_list(x)) {
    warn_coercion <- !is.data.frame(x)
    message <- c("!" = "{.arg x} is not a data frame.")

    # Wrap data frame or other non-list object in a bare list
    x <- list(x)
  } else {
    # TODO: Decide if NULL elements should be dropped
    warn_coercion <- !all(purrr::map_lgl(x, \(x) {
      is.null(x) || is.data.frame(x)
    }))
    message <- c("!" = "{.arg x} is a list containing non-data frame elements.")
  }

  if (warn_coercion) {
    cli::cli_bullets(message)
  }

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
    properties = properties,
    call = call
  )

  # TODO: Add support for .params argument to pass list of options for each
  # sheet
  params <- vctrs::vec_recycle_common(
    ...,
    .size = length(sheet_names),
    .call = call
  )

  # Add data for each named sheet
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
      wb_add_data_ext,
      wb = wb,
      x = sheet_data[[i]],
      sheet = sheet_names[[i]],
      !!!sheet_params,
      call = call
    )
  }

  wb
}

#' Convert an object to a list of workbooks
#'
#' [map_wb()] takes a list and returns a list of `wbWorkbook` objects.
#' `properties` is recycled to match the length of the input x.
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
map_wb <- function(x, ..., properties = NULL, .progress = FALSE) {
  if (is_named(properties)) {
    properties <- vctrs::vec_recycle(
      list(properties),
      size = length(x)
    )
  }

  if (!is.null(properties)) {
    # TODO: Improve validation messages
    vctrs::obj_check_list(properties)
    vctrs::vec_check_size(properties, size = length(x))

    if (is_named(x)) {
      properties <- set_names(properties, names(x))
    }
  }

  purrr::imap(
    x,
    \(x, i) {
      as_wb(x, ..., properties = properties[[i]])
    },
    .progress = .progress
  )
}
