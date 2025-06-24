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
prep_wb_data <- function(
  x,
  list_columns = c("collapse", "drop", "asis"),
  sep = "; ",
  geometry = c("drop", "coords", "wkt"),
  coords = c("lon", "lat"),
  call = caller_env()
) {
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
