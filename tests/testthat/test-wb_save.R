test_that("wb_save_ext() uses workbook title to build a file name", {
  withr::local_dir(withr::local_tempdir())

  wb <- wb_new_workbook(title = "Title used for output file", sheet_names = "Sheet 1")
  wb_save_ext(wb)

  expect_true(file.exists("Title used for output file.xlsx"))
})

test_that("wb_save_ext() uses the supplied file path", {
  withr::local_dir(withr::local_tempdir())

  wb <- wb_new_workbook(sheet_names = "Sheet 1")
  wb_save_ext(wb, file = "custom-name.xlsx")

  expect_true(file.exists("custom-name.xlsx"))
})

test_that("wb_save_ext() errors on a non-xlsx file extension", {
  withr::local_dir(withr::local_tempdir())

  wb <- wb_new_workbook(sheet_names = "Sheet 1")

  expect_error(wb_save_ext(wb, file = "custom-name.csv"))
})

test_that("wb_save_ext() errors without a file or workbook title", {
  wb <- openxlsx2::wb_workbook()

  expect_error(wb_save_ext(wb))
})

test_that("write_xlsx_ext() writes a data frame to an xlsx file", {
  withr::local_dir(withr::local_tempdir())

  write_xlsx_ext(mtcars, "mtcars.xlsx")

  expect_true(file.exists("mtcars.xlsx"))
  expect_equal(
    openxlsx2::wb_to_df("mtcars.xlsx"),
    mtcars,
    ignore_attr = TRUE
  )
})

test_that("write_xlsx_ext() writes a list of data frames to named sheets", {
  withr::local_dir(withr::local_tempdir())

  write_xlsx_ext(
    list(mtcars = mtcars, anscombe = anscombe),
    "datasets-list.xlsx"
  )

  expect_equal(
    openxlsx2::wb_get_sheet_names(openxlsx2::wb_load("datasets-list.xlsx")),
    c(mtcars = "mtcars", anscombe = "anscombe")
  )
})

test_that("write_xlsx_ext() saves an existing workbook input", {
  withr::local_dir(withr::local_tempdir())

  wb <- wb_new_workbook(title = "wb input", sheet_names = "Sheet 1")
  write_xlsx_ext(wb)

  expect_true(file.exists("wb input.xlsx"))
})

test_that("write_xlsx_ext() invisibly returns a data frame input unmodified", {
  withr::local_dir(withr::local_tempdir())

  result <- withVisible(write_xlsx_ext(mtcars, "mtcars.xlsx"))

  expect_false(result$visible)
  expect_identical(result$value, mtcars)
})
