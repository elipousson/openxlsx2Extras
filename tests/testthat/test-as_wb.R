test_that("as_wb() converts a data frame to a workbook", {
  wb <- as_wb(mtcars[1:3, ])

  expect_s3_class(wb, "wbWorkbook")
  expect_equal(openxlsx2::wb_get_sheet_names(wb), c("Sheet 1" = "Sheet 1"))
  expect_equal(openxlsx2::wb_to_df(wb), mtcars[1:3, ], ignore_attr = TRUE)
})

test_that("as_wb() converts a list of data frames to a workbook", {
  wb <- as_wb(list(mtcars[1:2, ], mtcars[3:4, ]))

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c("Sheet 1" = "Sheet 1", "Sheet 2" = "Sheet 2")
  )
})

test_that("as_wb() uses names of a named list as sheet names", {
  wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c(a = "a", b = "b")
  )
})

test_that("as_wb() warns when sheet_names overrides list names", {
  expect_warning(
    wb <- as_wb(
      list(a = mtcars[1:2, ], b = mtcars[3:4, ]),
      sheet_names = c("X", "Y")
    ),
    "names are ignored"
  )

  expect_equal(
    openxlsx2::wb_get_sheet_names(wb),
    c(X = "X", Y = "Y")
  )
})

test_that("as_wb() messages when list contains non-data frame elements", {
  expect_message(
    as_wb(list(1:3)),
    "non data frame elements|non-data frame elements"
  )
})

test_that("as_wb() returns a wbWorkbook input unchanged", {
  wb <- as_wb(mtcars[1:2, ])
  expect_identical(as_wb(wb), wb)
})

test_that("as_wb() loads a file path input", {
  tmp <- withr::local_tempfile(fileext = ".xlsx")
  openxlsx2::write_xlsx(mtcars[1:3, ], tmp)

  wb <- as_wb(tmp)

  expect_equal(openxlsx2::wb_to_df(wb), mtcars[1:3, ], ignore_attr = TRUE)
})

test_that("as_wb() sets workbook properties", {
  wb <- as_wb(mtcars[1:2, ], title = "mtcars data", creator = "Eli")

  props <- openxlsx2::wb_get_properties(wb)
  expect_equal(props[["title"]], "mtcars data")
  expect_equal(props[["creator"]], "Eli")
})

test_that("map_wb() converts a list to a list of workbooks", {
  wb_list <- map_wb(list(mtcars[1:2, ], mtcars[3:4, ]))

  expect_length(wb_list, 2)
  expect_true(all(vapply(wb_list, is_wb, logical(1))))
})

test_that("map_wb() preserves names of a named list", {
  wb_list <- map_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))

  expect_equal(names(wb_list), c("a", "b"))
})
