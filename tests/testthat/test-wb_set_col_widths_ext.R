test_that("wb_set_col_widths_ext() sets width for a named column", {
  wb <- as_wb(mtcars[1:3, ])

  wb <- wb_set_col_widths_ext(wb, cols = "drat")

  expect_match(wb$worksheets[[1]]$cols_attr, 'min="5" max="5"')
})

test_that("wb_set_col_widths_ext() defaults to all columns", {
  wb <- as_wb(mtcars[1:3, ])

  expect_no_error(wb_set_col_widths_ext(wb))
})

test_that("wb_set_col_widths_ext() accepts numeric column indices", {
  wb <- as_wb(mtcars[1:3, ])

  expect_no_error(wb_set_col_widths_ext(wb, cols = 1))
})
