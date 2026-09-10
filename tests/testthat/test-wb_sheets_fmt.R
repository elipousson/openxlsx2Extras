test_that("wb_sheets_fmt() applies a formatting function to selected columns", {
  wb <- as_wb(mtcars[1:3, ])

  wb <- wb_sheets_fmt(
    wb,
    cols = c("mpg", "hp"),
    sheets = "Sheet 1",
    numfmt = "0.00"
  )

  expect_match(wb$styles_mgr$numfmt$name, 'formatCode="0.00"')
})

test_that("wb_sheets_fmt() applies formatting across explicit dims", {
  wb <- as_wb(mtcars[1:3, ])

  expect_no_error(
    wb_sheets_fmt(wb, dims = "A1:A4", sheets = "Sheet 1", numfmt = "0.0")
  )
})
