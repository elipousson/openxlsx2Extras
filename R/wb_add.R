#' Add data using `openxlsx2::wb_add_data()` with extra features
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [wb_add_data_ext()] extends [openxlsx2::wb_add_data()] to add data to a
#' workbook with special handling for sf input objects and labelled data.
#'
#' @inheritParams openxlsx2::wb_add_data
#' @inheritDotParams openxlsx2::wb_add_data
#' @param geometry String, one of "drop" (default), "coords", or "wkt".
#' @param labels Method for handling column labels. "drop" (default) or
#'   "row_before". If "row_before", insert column labels in the row before the
#'   column names.
#' @inheritParams rlang::args_error_context
#' @export
#' @importFrom openxlsx2 wb_add_data
wb_add_data_ext <- function(wb,
                            x,
                            ...,
                            start_row = 1,
                            geometry = c("drop", "coords", "wkt"),
                            labels = c("drop", "row_before"),
                            call = caller_env()) {
  is_sf_obj <- inherits(x, "sf")
  geometry <- rlang::arg_match(geometry, error_call = call)

  if (is_sf_obj && geometry == "drop") {
    check_installed("sf", call = call)
    x <- sf::st_drop_geometry(x)
  } else if (is_sf_obj && geometry == "coords") {
    check_installed("sf", call = call)
    pts <- suppressWarnings(sf::st_centroid(sf::st_transform(x, 4326)))
    coords <- sf::st_coordinates(pts)[,c("X", "Y")]
    coords <- set_names(as.data.frame(coords), c("lon", "lat"))
    x <- purrr::list_cbind(list(sf::st_drop_geometry(x), coords))
  } else if (is_sf_obj) {
    check_installed("sf", call = call)

    wkt <- as.data.frame(sf::st_as_text(sf::st_geometry(x)))
    wkt <- set_names(wkt, attr(x, "sf_column"))

    x <- purrr::list_cbind(
      list(
        sf::st_drop_geometry(x),
        wkt
      )
    )
  }

  labels <- rlang::arg_match(labels, error_call = call)

  if (labels == "row_before") {
    col_labels <- get_col_labels(x)

    if (!is.null(labels)) {
      labels <- as.data.frame(t(as.data.frame(labels)))
      wb <- openxlsx2::wb_add_data(wb, x = labels, start_row = start_row, col_names = FALSE)
      start_row <- start_row + 1
    }
  }

  wb <- openxlsx2::wb_add_data(wb, x = x, ..., start_row = start_row)

  wb
}

#' Get label attributes from each column in a data frame
#' @noRd
get_col_labels <- function(data) {
  unlist(lapply(data, \(x) attr(x, "label")))
}
