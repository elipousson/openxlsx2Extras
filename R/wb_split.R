#' Convert a workbook to a list of data frames
#'
#' [wb_to_df_list()] uses [openxlsx2::wb_to_df()] to extract each sheet of a
#' workbook object into a data frame. Additional parameters `...` are recycled
#' to match the length of sheet names.
#'
#' @inheritParams openxlsx2::wb_to_df
#' @param sheet_names Character vector of sheet names. If not supplied, all
#'   sheet names from the supplied workbook are used.
#' @inheritDotParams openxlsx2::wb_to_df
#' @returns A list of data frame lists.
#' @examples
#' wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))
#'
#' wb_to_df_list(wb)
#'
#' wb_to_df_list(wb, "Sheet 1")
#'
#' @export
wb_to_df_list <- function(file, sheet_names = NULL, ...) {
  # Allow file inputs for consistency w/ `openxlsx2::wb_to_df`
  wb <- file
  if (!is_wb(wb)) {
    wb <- openxlsx2::wb_load(wb)
  }

  # Get sheet names
  sheet_names <- sheet_names %||%
    openxlsx2::wb_get_sheet_names(wb)

  # Initialize data frame list
  df_list <- set_names(
    vctrs::vec_init_along(list(), sheet_names),
    sheet_names
  )

  # Recycle parameters to match length of sheet_names
  params <- vctrs::vec_recycle_common(
    ...,
    .size = length(sheet_names),
    .call = call
  )

  # Use `openxlsx2::wb_to_df` to extract data frames from workbook
  # FIXME: Replace with map
  for (i in seq_along(sheet_names)) {
    # TODO: Consider submitting a GH issue for wb_to_df to return an empty data
    # frame
    sheet_name <- sheet_names[[i]]
    df_params <- purrr::map(params, \(x) {
      x[i]
    })

    df_list[[sheet_name]] <- suppressMessages(exec(
      .fn = openxlsx2::wb_to_df,
      file = wb,
      sheet = sheet_name,
      !!!df_params
    )) %||% data.frame()
  }

  df_list
}

#' Use `dplyr::group_split` to split a workbook into a list of workbooks
#'
#' [wb_split()] uses [wb_to_df_list()] to extract the data frames from each
#' sheet of a workbook and then split the data frames by a `.key` argument then
#' convert each new list of data frames back into a wbWorkbook object.
#'
#' @inheritParams wb_to_df_list
#' @param .by Passed to [dplyr::group_split()].
#' @param properties If "inherit" (default) and `file` is a workbook, inherit
#'   the workbook list element properties from the existing workbook. properties
#'   can also be `NULL` or a named character vector, a named list, or a bare
#'   list of the same length as the number of groups defined using the `.by`
#'   argument.
#' @inheritParams dplyr::group_split
#' @inheritDotParams wb_to_df_list
#' @returns A list of wbWorkbook objects.
#' @examples
#'
#' wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))
#'
#' wb_split(wb, .by = carb)
#'
#' @export
wb_split <- function(file, .by, ..., .keep = TRUE, properties = "inherit") {
  if (is_wb(file) && (properties == "inherit")) {
    properties <- as.list(openxlsx2::wb_get_properties(file))
  }

  df_list <- wb_to_df_list(file, ...)

  # TODO: Implement w/ vctrs to avoid dplyr dependency
  check_installed("dplyr")

  df_list <- purrr::map(
    df_list,
    \(x) {
      x_grouped <- dplyr::group_by( x, {{.by}})

      keys <- dplyr::group_keys(x_grouped)

      # FIXME: Avoid dependency on experimental function
      x_split <- dplyr::group_split(x_grouped, .keep = .keep)

      if (ncol(keys) > 1) {
        return(x_split)
      }

      set_names(x_split, keys[[1]])
    })

  if (!is_named(df_list[1])) {
    cli::cli_warn(
      "Output list is only named when a single grouping variable is supplied."
    )
  }

  df_list <- purrr::list_transpose(df_list, simplify = FALSE)

  # df_list <- vctrs::list_drop_empty(df_list)
  map_wb(df_list, properties = properties)
}


#' Write a data frame list to a series of Excel files
#' @noRd
write_xlsx_split <- function(x,
                             file = NULL,
                             ...,
                             path = getwd(),
                             ext = "xlsx") {
  # FIXME: Allow workbook and workbook list inputs
  wb_list <- map_wb(x, ...)

  file <- file %||% purrr::map_chr(
    seq_along(wb_list),
    \(x) {
      fs::file_temp(paste0("file", x), tmp_dir = path, ext = ext)
    }
  )

  purrr::walk2(
    wb_list,
    file,
    \(x, y) {
      write_xlsx_ext(
        x = x,
        file = y,
        ...
      )
    }
  )
}
