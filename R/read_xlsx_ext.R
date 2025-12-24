#' Create a data frame from a Workbook (with extra features)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [read_xlsx_ext()] uses [openxlsx2::read_xlsx()] with a few added features:
#'
#' - allows use of a name repair argument (`"unique_quite"` by default) to avoid
#'   blank `""` or `NA` values for column names.
#' - allows vector inputs for the file or sheet argument. These parameters are
#'   recycled to a common length and result in the return of a data frame list
#' unless the `combine = TRUE` is set. If `combine = TRUE`, set `names_to`
#' (passed to `purrr::list_rbind`) to combined the file basename values
#' (default) or full path values as a column (depending on the `names_from`
#' argument). `names_from` can also be a length > 1 character vector that can be
#'  recycled to match the length of file.
#'
#' @param sheet Defaults to 1.
#' @param combine If `TRUE`, always return a data frames. If `FALSE`, return a
#' list of data frames.
#' @inheritParams purrr::list_rbind
#' @inheritParams openxlsx2::read_xlsx
#' @inheritParams vctrs::vec_as_names
#' @inheritDotParams openxlsx2::read_xlsx
#' @export
read_xlsx_ext <- function(
  file,
  sheet = 1,
  ...,
  names_from = "basename",
  names_to = rlang::zap(),
  combine = TRUE,
  repair = "unique_quiet"
) {
  # Only workbooks with path values are supported
  if (
    inherits(file, "wbWorkbook") &&
      (length(file[["path"]]) > 0) &&
      file.exists(file[["path"]])
  ) {
    file <- file[["path"]]
  }

  if (length(file) > 1 || length(sheet) > 1) {
    read_args <- vctrs::vec_recycle_common(file = file, sheet = sheet)
    file <- read_args[["file"]]
    sheet <- read_args[["sheet"]]
  }

  if (is_string(names_from)) {
    nm <- switch(names_from, "basename" = basename(file), "path" = file)
  } else {
    vctrs::vec_check_size(names_from, size = length(file))
    nm <- names_from
  }

  file <- set_names(file, nm)

  xlsx_list <- purrr::map2(
    file,
    sheet,
    function(x, y, ...) {
      xlsx_df <- openxlsx2::read_xlsx(file = x, sheet = y, ...)

      rlang::set_names(
        xlsx_df,
        vctrs::vec_as_names(
          names(xlsx_df),
          repair = repair
        )
      )
    }
  )

  if (is_false(combine)) {
    return(xlsx_list)
  }

  purrr::list_rbind(
    xlsx_list,
    names_to = names_to
  )
}
