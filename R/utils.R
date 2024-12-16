#' Set sheet names for input data
#'
#' [set_sheet_list_names()] and [as_sheet_names()] are adapted from the existing
#' functionality for handling sheet names in [openxlsx2::write_xlsx()].
#'
#' @param sheet_names One or more sheet names. Empty values ("" or " ") are
#'   replaced using the `default` parameter value and position in `sheet_names`
#'   vector.
#' @param n_sheets Number of sheet names to return.
#' @param default Default prefix to use for numbered sheets. Default values are
#'   used if `sheet_names = NULL` or if `n_sheets` is greater than the length of
#'   `sheet_names`. Defaults to "Sheet".
#' @param max_length Maximum allowed length in characters for sheet names. Must
#'   be 31 or less.
#' @param excess_length Handling for sheet names that exceed `max_length` in
#'   characters. "truncate" trims to length of `max_length` and "error" errors.
#' @source <https://github.com/JanMarvin/openxlsx2/blob/main/R/write_xlsx.R#L281-L301>
#' @keywords internal utils
#' @export
set_sheet_list_names <- function(x,
                                 sheet_names = NULL,
                                 ...,
                                 n_sheets = NULL,
                                 .prep_fn = prep_wb_data,
                                 repair = "unique",
                                 default = "Sheet",
                                 call = caller_env()) {
  if (is_named(x) && !is.null(sheet_names)) {
    cli::cli_warn(
      "{.arg x} names are ignored when {.arg sheet_names} is supplied."
    )
  }

  sheet_names <- as_sheet_names(
    sheet_names = sheet_names %||% names(x),
    n_sheets = length(x),
    default = default,
    repair = repair,
    call = call
  )

  set_names(x, sheet_names)
}

#' @rdname set_sheet_list_names
#' @keywords internal utils
#' @examples
#'
#' as_sheet_names()
#'
#' as_sheet_names("Workbook sheet")
#'
#' as_sheet_names(c("Workbook sheet", "Workbook sheet"), quiet = TRUE)
#'
#' as_sheet_names("Workbook sheet", n_sheets = 2)
#'
#' as_sheet_names("Sheet names longer than 31 characters are truncated")
#'
#' @export
as_sheet_names <- function(sheet_names = NULL,
                           n_sheets = 1,
                           default = "Sheet",
                           max_length = 31,
                           excess_length = c("truncate", "error"),
                           repair = "unique",
                           quiet = FALSE,
                           arg = caller_arg(sheet_names),
                           call = caller_env()) {
  sheet_names <- sheet_names %||% paste(default, seq_len(n_sheets))

  sheet_names <- as.character(sheet_names)

  sheet_names_len <- length(sheet_names)

  # TODO: Add an option to error or allow missing or empty sheet names
  if (sheet_names_len < n_sheets) {
    sheet_names <- c(sheet_names, rep("", n_sheets - sheet_names_len))
  } else {
    n_sheets <- max(n_sheets, sheet_names_len)
  }

  empty_sheet_names <- sheet_names %in% c("", " ")

  if (any(empty_sheet_names)) {
    replace_name <- paste("Sheet", seq_len(n_sheets)[empty_sheet_names])
    sheet_names[empty_sheet_names] <- replace_name
  }

  excess_length <- arg_match(excess_length, error_call = call)
  name_chars <- nchar(sheet_names)

  stopifnot(
    max_length <= 31
  )

  if (excess_length == "truncate" && any(name_chars > max_length)) {
    cli::cli_bullets(
      c("!" = "Truncating {.arg {arg}} values to {max_length} characters.")
    )
    sheet_names <- substr(sheet_names, 1, max_length)
    name_chars <- nchar(sheet_names)
  }

  if (any(name_chars > max_length)) {
    cli::cli_abort(
      "{.arg {arg}} too long! Max length is {max_length} characters.",
      call = call
    )
  }

  if (!is_installed("vctrs")) {
    return(make.unique(sheet_names))
  }

  vctrs::vec_as_names(
    names = sheet_names,
    repair = repair,
    quiet = quiet,
    call = call
  )
}

#' Prepare a data frame or list of data frames for inclusion in a workbook
#'
#' [as_sheet_list()] prepares a list of data frames for inclusion in a workbook.
#'
#' @inheritDotParams prep_wb_data
#' @inheritParams as_sheet_names
#' @param .prep_fn Function to use in preparing list of input objects. Defaults
#'   to [prep_wb_data()].
#' @param ... Additional parameters passed to `.prep_fn`
#' @keywords internal utils
#' @returns A named list of data frames.
#' @examples
#'
#' x <- head(mtcars, 1)
#' y <- tail(mtcars, 1)
#'
#' as_sheet_list(x)
#'
#' as_sheet_list(list(x, y))
#'
#' as_sheet_list(list(head = x, tail = y))
#'
#' as_sheet_list(list(head = x, y))
#'
#' @export
as_sheet_list <- function(x,
                          sheet_names = NULL,
                          ...,
                          n_sheets = NULL,
                          .prep_fn = prep_wb_data,
                          repair = "unique",
                          default = "Sheet",
                          call = caller_env()) {
  if (!is_bare_list(x)) {
    x <- list(x)
  }

  if (is_function(.prep_fn)) {
    x <- lapply(
      x,
      .prep_fn,
      ...
    )
  }

  set_sheet_list_names(
    x,
    sheet_names = sheet_names,
    n_sheets = n_sheets,
    default = default,
    repair = repair,
    call = call
  )
}

#' Test if object is a wbWorkbook class object
#' @noRd
is_wb <- function(x) {
  inherits(x, "wbWorkbook")
}
