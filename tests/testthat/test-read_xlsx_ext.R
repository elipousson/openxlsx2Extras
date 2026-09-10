test_that("read_xlsx_ext() reads a single xlsx file", {
  tmp <- withr::local_tempfile(fileext = ".xlsx")
  openxlsx2::write_xlsx(mtcars[1:3, ], tmp)

  result <- read_xlsx_ext(tmp)

  expect_equal(result, mtcars[1:3, ], ignore_attr = TRUE)
})

test_that("read_xlsx_ext() can return a list of data frames without combining", {
  tmp1 <- withr::local_tempfile(fileext = ".xlsx")
  tmp2 <- withr::local_tempfile(fileext = ".xlsx")
  openxlsx2::write_xlsx(mtcars[1:2, ], tmp1)
  openxlsx2::write_xlsx(mtcars[3:4, ], tmp2)

  result <- read_xlsx_ext(c(tmp1, tmp2), combine = FALSE)

  expect_type(result, "list")
  expect_length(result, 2)
  expect_equal(names(result), basename(c(tmp1, tmp2)))
})

test_that("read_xlsx_ext() combines multiple files into one data frame", {
  tmp1 <- withr::local_tempfile(fileext = ".xlsx")
  tmp2 <- withr::local_tempfile(fileext = ".xlsx")
  openxlsx2::write_xlsx(mtcars[1:2, ], tmp1)
  openxlsx2::write_xlsx(mtcars[3:4, ], tmp2)

  result <- read_xlsx_ext(c(tmp1, tmp2))

  expect_equal(result, mtcars[1:4, ], ignore_attr = TRUE)
})

test_that("read_xlsx_ext() repairs duplicate or blank column names", {
  tmp <- withr::local_tempfile(fileext = ".xlsx")
  wb <- openxlsx2::wb_workbook()
  wb <- openxlsx2::wb_add_worksheet(wb)
  wb <- openxlsx2::wb_add_data(
    wb,
    x = data.frame(a = 1, a = 2, check.names = FALSE),
    col_names = TRUE
  )
  openxlsx2::wb_save(wb, tmp)

  result <- read_xlsx_ext(tmp)

  expect_equal(names(result), c("a...1", "a...2"))
})
