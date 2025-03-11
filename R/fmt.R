#' Prepare a data frame with Excel style class values for formatting by
#' openxlsx2
#'
#' `r lifecycle::badge("experimental")`
#'
#' [set_excel_fmt_class()] applies a style to each specified column. See the
#' openxlsx2 documentation for more information on this feature:
#' <https://janmarvin.github.io/openxlsx2/articles/openxlsx2_style_manual.html#numfmts2>
#'
#' @param data A data frame with columns to format.
#' @param cols Column names or numbers to modify.
#' @param fmt_class Excel style class, one of: c("currency", "accounting",
#'   "hyperlink", "percentage", "scientific", "formula"). Length is recycled to
#'   match length of cols using [vctrs::vec_recycle()].
#' @inheritParams rlang::arg_match
#' @param strict If `TRUE`, error if any character values in cols are not
#' included in the names of `data`. Default `FALSE`.
#' @export
#' @importFrom vctrs vec_recycle
set_excel_fmt_class <- function(
  data,
  cols,
  fmt_class = "currency",
  multiple = TRUE,
  strict = FALSE
) {
  # Validate format class
  fmt_class <- arg_match(
    fmt_class,
    c(
      "currency",
      "accounting",
      "hyperlink",
      "percentage",
      "scientific",
      "formula"
    ),
    multiple = multiple
  )

  # Drop columns that don't appear in data frame (character input only)
  if (!strict && is.character(cols)) {
    cols <- intersect(cols, names(data))
  } else if (is.character(cols)) {
    stopifnot(
      all(has_name(data, cols))
    )
  }

  # Apply format class to each specified column
  fmt_class <- vctrs::vec_recycle(fmt_class, size = length(cols))

  for (i in seq_along(cols)) {
    col <- cols[[i]]
    class(data[[col]]) <- c(fmt_class[[i]], class(data[[col]]))
  }

  data
}
