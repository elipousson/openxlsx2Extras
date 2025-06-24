#' Create a data frame from a Workbook (with extra features)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [read_xlsx_ext()] uses [openxlsx2::read_xlsx()] but allows use of a name
#' repair argument (`"unique"` by default) to avoid blank `""` or `NA` values
#' for column names.
#'
#' @inheritParams openxlsx2::read_xlsx
#' @inheritParams vctrs::vec_as_names
#' @inheritDotParams openxlsx2::read_xlsx
#' @export
read_xlsx_ext <- function(file, ..., repair = "unique") {
  xlsx_df <- openxlsx2::read_xlsx(file = file, ...)

  rlang::set_names(
    xlsx_df,
    vctrs::vec_as_names(
      names(xlsx_df),
      repair = repair
    )
  )
}
