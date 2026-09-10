test_that("vec_fmt_lgl() replaces TRUE/FALSE with default values", {
  skip_if_not_installed("dplyr")

  expect_equal(
    vec_fmt_lgl(c(TRUE, FALSE, NA)),
    c("Y", "N", NA)
  )
})

test_that("vec_fmt_lgl() supports custom replacement values", {
  skip_if_not_installed("dplyr")

  expect_equal(
    vec_fmt_lgl(c(TRUE, FALSE), c("Yes", "No")),
    c("Yes", "No")
  )
})

test_that("vec_fmt_lgl() errors if values is not length 2", {
  skip_if_not_installed("dplyr")

  expect_error(vec_fmt_lgl(c(TRUE, FALSE), c("Yes", "No", "Maybe")))
})

test_that("fmt_lgl_cols() formats all logical columns by default", {
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tidyselect")

  data <- data.frame(x = c(TRUE, FALSE), y = 1:2)

  expect_equal(
    fmt_lgl_cols(data),
    data.frame(x = c("Y", "N"), y = 1:2)
  )
})

test_that("fmt_lgl_cols() leaves non-logical columns untouched", {
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tidyselect")

  data <- data.frame(x = c(TRUE, FALSE), y = c("a", "b"))

  expect_equal(fmt_lgl_cols(data)[["y"]], c("a", "b"))
})
