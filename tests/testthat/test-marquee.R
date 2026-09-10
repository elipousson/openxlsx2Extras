test_that("fmt_marquee_txt() converts markdown text to fmt_txt objects", {
  skip_if_not_installed("marquee")

  result <- fmt_marquee_txt("# Heading\n\nSome text")

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true(all(vapply(result, inherits, logical(1), "fmt_txt")))
})

test_that("wb_add_marquee_text() adds markdown text to a workbook", {
  skip_if_not_installed("marquee")

  wb <- openxlsx2::wb_workbook()
  wb <- openxlsx2::wb_add_worksheet(wb)
  wb <- wb_add_marquee_text(wb, text = "# Heading\n\nSome text")

  values <- unlist(openxlsx2::wb_to_df(wb, col_names = FALSE))

  expect_true(any(grepl("Heading", values)))
  expect_true(any(grepl("Some text", values)))
})

test_that("wb_add_marquee_text() can skip setting column widths", {
  skip_if_not_installed("marquee")

  wb <- openxlsx2::wb_workbook()
  wb <- openxlsx2::wb_add_worksheet(wb)

  expect_no_error(
    wb_add_marquee_text(wb, text = "Some text", widths = NULL)
  )
})
