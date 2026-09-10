test_that("as_sheet_names() returns default sheet names", {
  expect_equal(as_sheet_names(), "Sheet 1")
  expect_equal(as_sheet_names("Workbook sheet"), "Workbook sheet")
})

test_that("as_sheet_names() repairs duplicate names", {
  expect_equal(
    as_sheet_names(c("Workbook sheet", "Workbook sheet"), quiet = TRUE),
    c("Workbook sheet...1", "Workbook sheet...2")
  )
})

test_that("as_sheet_names() fills missing names using default prefix", {
  expect_equal(
    as_sheet_names("Workbook sheet", n_sheets = 2),
    c("Workbook sheet", "Sheet 2")
  )
})

test_that("as_sheet_names() truncates names over max_length by default", {
  expect_message(
    result <- as_sheet_names(
      "Sheet names longer than 31 characters are truncated"
    ),
    "Truncating"
  )

  expect_true(nchar(result) <= 31)
})

test_that("as_sheet_names() errors on excess length when excess_length = 'error'", {
  expect_error(
    as_sheet_names(
      "Sheet names longer than 31 characters are truncated",
      excess_length = "error"
    )
  )
})

test_that("as_sheet_names() errors if max_length is greater than 31", {
  expect_error(as_sheet_names("Sheet", max_length = 32))
})

test_that("as_sheet_list() wraps a single data frame in a named list", {
  x <- head(mtcars, 1)

  result <- as_sheet_list(x)

  expect_equal(names(result), "Sheet 1")
  expect_equal(result[[1]], x)
})

test_that("as_sheet_list() names an unnamed list of data frames", {
  x <- head(mtcars, 1)
  y <- tail(mtcars, 1)

  result <- as_sheet_list(list(x, y))

  expect_equal(names(result), c("Sheet 1", "Sheet 2"))
})

test_that("as_sheet_list() preserves existing names", {
  x <- head(mtcars, 1)
  y <- tail(mtcars, 1)

  result <- as_sheet_list(list(head = x, tail = y))

  expect_equal(names(result), c("head", "tail"))
})

test_that("as_sheet_list() fills in missing names for partially named lists", {
  x <- head(mtcars, 1)
  y <- tail(mtcars, 1)

  result <- as_sheet_list(list(head = x, y))

  expect_equal(names(result), c("head", "Sheet 2"))
})

test_that("set_sheet_list_names() warns when x names are overridden", {
  x <- list(a = 1, b = 2)

  expect_warning(
    result <- set_sheet_list_names(x, sheet_names = c("X", "Y"), .prep_fn = NULL),
    "names are ignored"
  )

  expect_equal(names(result), c("X", "Y"))
})
