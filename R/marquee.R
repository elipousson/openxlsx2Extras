#' Use `marquee::marquee_parse()` to format Markdown text
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [fmt_marquee_txt()] uses [marquee::marquee_parse()] and
#' [openxlsx2::fmt_txt()] to format Markdown text.
#'
#' @inheritParams marquee::marquee_parse
#' @param ... Ignored at this time. For future use.
#' @examples
#'
#' fmt_marquee_txt(
#'   "# ABC
#'
#'   abc"
#' )
#'
#' @export
fmt_marquee_txt <- function(text,
                            ...,
                            style = marquee::classic_style(),
                            ignore_html = TRUE) {
  check_installed("marquee")

  parsed_text <- marquee::marquee_parse(
    text,
    style = style,
    ignore_html = ignore_html
  )

  purrr::pmap(
    parsed_text,
    \(text, type, indentation, indent, size, ol_index, weight, bullets, ...) {
      before <- paste0(rep(" ", indent), collapse = "")

      if (type == "li") {
        bullet <- bullets[[indentation - 2]]
        before <- paste0(before, bullet, " ")
      } else if (ol_index > 0) {
        # FIXME: Ordered lists are not yet supported
        before <- paste0(before, ol_index, ". ")
      }

      openxlsx2::fmt_txt(
        x = paste0(before, text),
        bold = weight > 400,
        size = size
      )
    }
  )
}


#' Add Markdown formatted text to a Workbook
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [wb_add_marquee_text()] uses [fmt_marquee_txt()] to add Markdown formatted
#' text to a Workbook. [openxlsx2::wb_set_col_widths()] is applied to the
#' workbook to adjust widths for the specified columns. Set `widths = NULL` to
#' disable this functionality.
#'
#' @inheritParams openxlsx2::wb_add_data
#' @inheritParams fmt_marquee_txt
#' @inheritDotParams fmt_marquee_txt
#' @inheritParams openxlsx2::wb_set_col_widths
#' @examples
#'
#' library(openxlsx2)
#'
#' wb_workbook() |>
#'   wb_add_worksheet() |>
#'   wb_add_marquee_text(
#'     text = "
#' # Heading 1
#'
#' Example text.
#'
#' 1. Ordered list item 1
#' 2. Order list item 2
#'
#' ## Heading 2
#'
#' - Bulleted list item 1
#'   - Nested bullet
#' - Bulleted list item 2"
#'   )
#'
#' @export
wb_add_marquee_text <- function(wb = NULL,
                                text,
                                sheet = current_sheet(),
                                dims = NULL,
                                ...,
                                cols = 1,
                                widths = "auto") {
  text <- fmt_marquee_txt(text, ...)

  if (is.null(dims)) {
    # Add each line to a successive cell by default
    wb <- purrr::reduce(
      seq_along(text),
      \(x, y) {
        x |>
          openxlsx2::wb_add_data(
            x = text[y],
            sheet = sheet,
            dims = paste0("A", y)
          )
      },
      .init = wb
    )
  } else {
    # Add formatted text to a single cell
    # TODO: Implement this option
  }

  if (is.null(widths)) {
    return(wb)
  }

  openxlsx2::wb_set_col_widths(
    wb,
    cols = cols,
    widths = widths
  )
}
