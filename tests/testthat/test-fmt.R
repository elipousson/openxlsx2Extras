test_that("set_excel_fmt_class() adds fmt_class to column class", {
  data <- data.frame(price = c(1, 2), pct = c(0.1, 0.2))

  data <- set_excel_fmt_class(
    data,
    cols = c("price", "pct"),
    fmt_class = c("currency", "percentage")
  )

  expect_equal(class(data[["price"]]), c("currency", "numeric"))
  expect_equal(class(data[["pct"]]), c("percentage", "numeric"))
})

test_that("set_excel_fmt_class() recycles fmt_class to length of cols", {
  data <- data.frame(price = c(1, 2), cost = c(3, 4))

  data <- set_excel_fmt_class(data, cols = c("price", "cost"))

  expect_equal(class(data[["price"]]), c("currency", "numeric"))
  expect_equal(class(data[["cost"]]), c("currency", "numeric"))
})

test_that("set_excel_fmt_class() ignores unknown columns by default", {
  data <- data.frame(a = 1)

  result <- set_excel_fmt_class(data, cols = "nonexistent")

  expect_equal(class(result[["a"]]), "numeric")
})

test_that("set_excel_fmt_class() errors on unknown columns when strict", {
  data <- data.frame(a = 1)

  expect_error(
    set_excel_fmt_class(data, cols = "nonexistent", strict = TRUE)
  )
})

test_that("set_excel_fmt_class() errors on an invalid fmt_class", {
  data <- data.frame(a = 1)

  expect_error(
    set_excel_fmt_class(data, cols = "a", fmt_class = "bogus")
  )
})
