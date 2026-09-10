wb_get_all_comments <- function(wb) {
  sheet_names <- openxlsx2::wb_get_sheet_names(wb, escape = TRUE)

  comment_list <- purrr::map(
    rlang::set_names(
      sheet_names,
      sheet_names
    ),
    \(nm) {
      out <- openxlsx2::wb_get_comment(
        wb,
        sheet = nm
      )

      if (rlang::is_empty(out)) {
        return(data.frame())
      }

      out
    }
  )

  purrr::list_rbind(
    comment_list,
    names_to = "sheet"
  )
}
