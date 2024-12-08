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


#' Prepare data for adding to a workbook
#'
#' [prep_wb_data()] prepares a data frame for addition to a workbook by handling
#' list columns and geometry columns (for sf data frames).
#'
#' @param x Required. A data frame or an object coercible to a data frame with
#'   [base::as.data.frame()].
#' @param list_columns String, one of "collapse" (default), "drop", or "asis"
#' @param sep String to use in collapsing list columns. Ignored unless
#'   `list_columns = "collapse"`. Defaults to `"; "`.
#' @param geometry String, one of "drop" (default), "coords", or "wkt". "coords"
#'   uses [sf::st_centroid()] to convert input to POINT geometry, transforms
#'   geometry to EPSG:4326, converts geometry to coordinates, and adds new
#'   columns with names matching `coords`. "wkt" converts geometry to a Well
#'   Known Text (WKT) character vector using [sf::st_as_text()] and replaces the
#'   existing geometry column (keeping the existing sf column name).
#' @param coords Length 2 character vector with column names to add if `geometry
#'   = "coords"`. Must be length 2 in longitude, latitude order.
#' @inheritParams rlang::args_error_context
#' @keywords utils
#' @examples
#'
#' list_df <- vctrs::data_frame(
#'   num = 1,
#'   alpha = list(list("A", "B", "C"))
#' )
#'
#' prep_wb_data(list_df)
#'
#' prep_wb_data(list_df, list_columns = "drop")
#'
#' prep_wb_data(list_df, list_columns = "asis")
#'
#' if (rlang::is_installed("sf")) {
#'   nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))
#'
#'   prep_wb_data(nc, geometry = "coords")
#'
#'   prep_wb_data(nc, geometry = "wkt")
#' }
#'
#' @export
#' @importFrom purrr map_chr list_cbind
prep_wb_data <- function(x,
                         list_columns = c("collapse", "drop", "asis"),
                         sep = "; ",
                         geometry = c("drop", "coords", "wkt"),
                         coords = c("lon", "lat"),
                         call = caller_env()) {
  # TODO: Improve coercion for non-data frame objects
  # See https://github.com/elipousson/openxlsx2Extras/issues/4
  if (!is.data.frame(x)) {
    x <- as.data.frame(x)
  }

  # Check if x has list columns or is a sf class object
  is_sf_obj <- inherits(x, "sf")
  is_list_col <- purrr::map_chr(x, base::typeof) == "list"
  has_list_cols <- any(is_list_col)

  # Return if neither condition applies
  if (!has_list_cols && !is_sf_obj) {
    return(x)
  }

  # Transform sf data frame as specified by `geometry`
  if (is_sf_obj) {
    geometry <- arg_match(geometry, error_call = call)
    check_installed("sf", call = call)
    if (geometry == "drop") {
      # Drop geometry
      # FIXME: Dropping geometry does not require the sf package
      x <- sf::st_drop_geometry(x)
    } else if (geometry == "coords") {
      # Get centroid coordinates
      pts <- suppressWarnings(sf::st_transform(sf::st_centroid(x), 4326))
      pts <- sf::st_coordinates(pts)[, c("X", "Y")]
      coords <- set_names(as.data.frame(pts), coords)

      # Bind coordinate columns to feature data
      x <- purrr::list_cbind(list(sf::st_drop_geometry(x), coords))
    } else if (geometry == "wkt") {
      # Get well-known text for geometry
      wkt <- as.data.frame(sf::st_as_text(sf::st_geometry(x)))
      wkt <- set_names(wkt, attr(x, "sf_column"))

      # Bind wkt text column to feature data
      x <- purrr::list_cbind(list(sf::st_drop_geometry(x), wkt))
    }

    # Check again (since geometry column) is a list column
    is_list_col <- purrr::map_chr(x, base::typeof) == "list"
    has_list_cols <- any(is_list_col)
  }

  # Modify list columns data frame as specified by `list_columns`
  if (has_list_cols) {
    list_columns <- arg_match(list_columns, error_call = call)
    if (list_columns == "collapse") {
      for (nm in names(x)[is_list_col]) {
        x[[nm]] <- purrr::map_chr(
          x[[nm]],
          \(x) {
            paste(x, collapse = sep)
          }
        )
      }
    } else if (list_columns == "drop") {
      # Remove list columns
      x[is_list_col] <- NULL
    } else {
      for (nm in names(x)[is_list_col]) {
        x[[nm]] <- paste0(x[[nm]])
      }
    }
  }

  x
}

#' Test if object is a wbWorkbook class object
#' @noRd
is_wb <- function(x) {
  inherits(x, "wbWorkbook")
}
