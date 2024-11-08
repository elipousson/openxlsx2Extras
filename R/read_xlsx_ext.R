#' Create a data frame from a Workbook (with extra features)
#'
#' @inheritParams vctrs::vec_as_names
#' @inheritDotParams openxlsx2::read_xlsx
read_xlsx_ext <- function(file,
                          ...,
                          repair = "unique") {
  xlsx_df <- openxlsx2::read_xlsx(file = file, ...)

  rlang::set_names(
    xlsx_df,
    vctrs::vec_as_names(
      names(xlsx_df),
      repair = repair
    )
  )
}
