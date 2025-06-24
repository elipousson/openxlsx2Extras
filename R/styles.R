#' Add a named list of styles to a workbook
#'
#' [wb_add_styles()] extends [openxlsx2::wb_add_style()] by allowing the
#' addition of multiple styles as a named list.
#'
#' @inheritParams openxlsx2::wb_add_style
#' @param styles Required. List or style xml character, created by a
#'   ⁠create_*()⁠ function. Passed to `style` argument of
#'   [openxlsx2::wb_add_style()].
#' @param style_names Optional if styles is a named list.
#' @export
#' @importFrom openxlsx2 wb_add_style
wb_add_styles <- function(wb, styles, style_names = NULL) {
  if (!is_bare_list(styles)) {
    styles <- list(styles)
  }

  if (!is_named(styles)) {
    stopifnot(is.character(style_names))
    styles <- set_names(styles, style_names)
  }

  for (nm in names(styles)) {
    wb <- openxlsx2::wb_add_style(
      wb = wb,
      style = styles[[nm]],
      style_name = nm
    )
  }

  wb
}

#' Common dxfs styles
#'
#' `common_dxfs_styles` is a named list of dxfs styles created with
#' [openxlsx2::create_dxfs_style()] with bad, good, and neutral values.
#'
#' @seealso [wb_add_styles()]
#' @source https://stackoverflow.com/questions/27611260/what-are-the-rgb-codes-for-the-conditional-formatting-styles-in-excel#comment78058968_27611522
#' @export
#' @importFrom openxlsx2 create_dxfs_style wb_color
common_dxfs_styles <- list(
  "bad" = openxlsx2::create_dxfs_style(
    font_color = openxlsx2::wb_color(hex = "9C0006"),
    bg_fill = openxlsx2::wb_color(hex = "FFC7CE")
  ),
  "good" = openxlsx2::create_dxfs_style(
    font_color = openxlsx2::wb_color(hex = "006100"),
    bg_fill = openxlsx2::wb_color(hex = "C6EFCE")
  ),
  "neutral" = openxlsx2::create_dxfs_style(
    font_color = openxlsx2::wb_color(hex = "9C6500"),
    bg_fill = openxlsx2::wb_color(hex = "FFEB9C")
  )
)
