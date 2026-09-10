test_that("wb_set_properties_ext() sets properties from named arguments", {
  wb <- openxlsx2::wb_workbook()
  wb <- wb_set_properties_ext(wb, title = "My title", creator = "Eli")

  props <- openxlsx2::wb_get_properties(wb)
  expect_equal(props[["title"]], "My title")
  expect_equal(props[["creator"]], "Eli")
})

test_that("wb_set_properties_ext() uses properties as fallback defaults", {
  wb <- openxlsx2::wb_workbook()
  wb <- wb_set_properties_ext(wb, properties = list(subject = "Sub"))

  props <- openxlsx2::wb_get_properties(wb)
  expect_equal(props[["subject"]], "Sub")
})

test_that("wb_set_properties_ext() lets explicit arguments override properties", {
  wb <- openxlsx2::wb_workbook()
  wb <- wb_set_properties_ext(
    wb,
    title = "Explicit title",
    properties = list(title = "Ignored title")
  )

  expect_equal(openxlsx2::wb_get_properties(wb)[["title"]], "Explicit title")
})

test_that("wb_set_properties_ext() accepts a named character vector for properties", {
  wb <- openxlsx2::wb_workbook()
  wb <- wb_set_properties_ext(wb, properties = c(subject = "Sub"))

  expect_equal(openxlsx2::wb_get_properties(wb)[["subject"]], "Sub")
})

test_that("wb_set_properties_ext() errors if dots are named", {
  wb <- openxlsx2::wb_workbook()

  expect_error(wb_set_properties_ext(wb, title2 = "x"))
})

test_that("wb_set_properties_ext() errors if properties is unnamed", {
  wb <- openxlsx2::wb_workbook()

  expect_error(wb_set_properties_ext(wb, properties = list("Sub")))
})
