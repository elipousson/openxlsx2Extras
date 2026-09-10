test_that("wb_rename_sheets() renames sheets by tidyselect name", {
  skip_if_not_installed("tidyselect")

  wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
  wb <- wb_rename_sheets(wb, X = "a", Y = "b")

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c(X = "X", Y = "Y")
  )
})

test_that("wb_rename_sheets() returns wb unchanged when no renames given", {
  skip_if_not_installed("tidyselect")

  wb <- as_wb(mtcars[1:2, ])

  expect_equal(wb_rename_sheets(wb), wb)
})

test_that("wb_rename_sheets_with() applies a function to all sheet names", {
  skip_if_not_installed("tidyselect")

  wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
  wb <- wb_rename_sheets_with(wb, \(x) paste0("sheet_", x))

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c(sheet_a = "sheet_a", sheet_b = "sheet_b")
  )
})

test_that("wb_rename_sheets_with() can target a subset of sheets", {
  skip_if_not_installed("tidyselect")

  wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))
  wb <- wb_rename_sheets_with(wb, \(x) paste0("x_", x), .sheets = "a")

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c(x_a = "x_a", b = "b")
  )
})

test_that("wb_rename_data() renames columns using tidyselect", {
  skip_if_not_installed("tidyselect")

  wb <- as_wb(mtcars[1:3, c("mpg", "hp")])
  wb <- wb_rename_data(wb, MPG = mpg, HP = hp)

  expect_equal(names(openxlsx2::wb_to_df(wb)), c("MPG", "HP"))
})

test_that("wb_rename_data() returns wb unchanged when no renames given", {
  skip_if_not_installed("tidyselect")

  wb <- as_wb(mtcars[1:3, c("mpg", "hp")])

  expect_equal(wb_rename_data(wb), wb)
})
