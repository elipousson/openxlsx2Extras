test_that("magic conversion functions work", {

  ## temporary files
  csv  <- tempfile(fileext = ".csv")
  xlsx <- openxlsx2::temp_xlsx()

  ## create example csv
  utils::write.csv(x = mtcars, file = csv, row.names = FALSE)

  ## works even with other packages
  wb <- csv_to_wb(csv = csv)
  expect_equal(openxlsx2::wb_to_df(wb), mtcars, ignore_attr = TRUE)

  csv_to_xlsx(csv = csv, xlsx = xlsx)
  expect_equal(openxlsx2::wb_to_df(xlsx), mtcars, ignore_attr = TRUE)

  csv_to_xlsx(csv = list(foo = csv), xlsx = xlsx)
  expect_equal(
    openxlsx2::wb_get_sheet_names(openxlsx2::wb_load(xlsx)),
    c(foo = "foo")
  )

  ## use other arguments frequently passed to openxlsx2::write_xlsx()
  csv_to_xlsx(csv = csv, xlsx = xlsx, as_table = TRUE)

  expect_equal(openxlsx2::wb_load(xlsx)$get_tables()$tab_name, "Table1")

  ## go the other way around from spreadsheet to csv
  xlsx_to_csv(xlsx = xlsx, csv = csv, row.names = FALSE)

  expect_equal(read.csv(csv), mtcars, ignore_attr = TRUE)

})
