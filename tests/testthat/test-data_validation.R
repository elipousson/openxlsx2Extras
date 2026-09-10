test_that("as_data_validation_value() collapses a character vector", {
  expect_equal(
    as_data_validation_value(c("a", "b", "c"), allow_blank = FALSE),
    '"a,b,c"'
  )
})

test_that("as_data_validation_value() adds a blank option by default", {
  expect_equal(
    as_data_validation_value(c("a", "b", "c")),
    '" ,a,b,c"'
  )
})

test_that("as_data_validation_value() errors for non-character input", {
  expect_error(as_data_validation_value(1:3))
})
