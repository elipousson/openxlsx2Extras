#' Format a logical vector to specified values
#'
#' @param x A logical vector.
#' @param values Default to `c("Y", "N")` Length 2 vector where first element
#'   replaces `TRUE` and the second element replaces `FALSE`.
#' @examples
#' vec_fmt_lgl(c(TRUE, FALSE))
#'
#' vec_fmt_lgl(c(TRUE, FALSE), c("Yes", "No"))
#' @export
vec_fmt_lgl <- function(x, values = c("Y", "N")) {
  stopifnot(rlang::has_length(values, 2))

  dplyr::if_else(
    x,
    values[[1]],
    values[[2]]
  )
}

#' Format logical vector columns to use replacement values
#'
#' [fmt_lgl_cols()] uses [vec_fmt_lgl()] to format all (or specified) logical
#' vector columns to use replacement values.
#'
#' @inheritParams dplyr::across
#' @inheritParams vec_fmt_lgl
#' @examples
#' fmt_lgl_cols(data.frame(x = c(TRUE, FALSE, TRUE)))
#' @export
fmt_lgl_cols <- function(.data,
                         .cols = tidyselect::where(is.logical),
                         values = c("Y", "N")) {
  .data |>
    dplyr::mutate(
      dplyr::across(
        .cols = {{ .cols }},
        \(x) {
          vec_fmt_lgl(x, values = values)
        }
      )
    )
}
