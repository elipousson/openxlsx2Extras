test_that("wb_cols_to_index() returns column positions by name", {
  wb <- as_wb(mtcars[1:5, ])

  expect_equal(
    wb_cols_to_index(wb, cols = c("mpg", "hp"), sheet = "Sheet 1"),
    c(1, 4)
  )
})

test_that("wb_cols_to_dims() returns dims for named columns", {
  wb <- as_wb(mtcars[1:5, ])

  expect_equal(
    wb_cols_to_dims(wb, cols = c("mpg", "hp"), sheet = "Sheet 1"),
    "A2:A6,D2:D6"
  )
})

test_that("wb_sheets_cols_to_dims() returns a list of dims per sheet", {
  wb <- as_wb(list(mtcars[1:2, ], mtcars[3:4, ]))

  dims <- wb_sheets_cols_to_dims(
    wb,
    cols = list("mpg", "hp"),
    sheets = c("Sheet 1", "Sheet 2")
  )

  expect_equal(
    dims,
    list("A2:A3", "D2:D3")
  )
})

test_that("wb_dims_ext() supports tidyselect for cols", {
  skip_if_not_installed("tidyselect")
  wb <- as_wb(mtcars[1:3, ])

  expect_equal(
    wb_dims_ext(wb, sheet = "Sheet 1", cols = c(mpg, hp)),
    "A2:A4,D2:D4"
  )
})

test_that("wb_dims_ext() can return only the selected column positions", {
  skip_if_not_installed("tidyselect")
  wb <- as_wb(mtcars[1:3, ])

  cols <- wb_dims_ext(
    wb,
    sheet = "Sheet 1",
    cols = c(mpg, hp),
    select = "cols"
  )

  expect_equal(unname(cols), c(1, 4))
})

test_that("wb_dims_ext() errors when no columns are selected", {
  skip_if_not_installed("tidyselect")
  wb <- as_wb(mtcars[1:3, ])

  expect_error(
    wb_dims_ext(wb, sheet = "Sheet 1", cols = tidyselect::starts_with("zzz"))
  )
})
