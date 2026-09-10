test_that("wb_new_workbook() returns a workbook with no sheets by default", {
  wb <- wb_new_workbook()

  expect_s3_class(wb, "wbWorkbook")
  expect_length(openxlsx2::wb_get_sheet_names(wb), 0)
})

test_that("wb_new_workbook() adds a single named sheet", {
  wb <- wb_new_workbook("Sheet 1")

  expect_equal(openxlsx2::wb_get_sheet_names(wb), c("Sheet 1" = "Sheet 1"))
})

test_that("wb_new_workbook() adds multiple named sheets", {
  wb <- wb_new_workbook(c("Data", "Analysis"))

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c(Data = "Data", Analysis = "Analysis")
  )
})

test_that("wb_new_workbook() sets workbook properties", {
  wb <- wb_new_workbook(title = "My workbook", creator = "Eli")

  props <- openxlsx2::wb_get_properties(wb)
  expect_equal(props[["title"]], "My workbook")
  expect_equal(props[["creator"]], "Eli")
})
