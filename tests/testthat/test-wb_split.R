test_that("wb_to_df_list() extracts each sheet as a data frame", {
  wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))

  result <- wb_to_df_list(wb)

  expect_equal(names(result), c("Sheet 1", "Sheet 2"))
  expect_equal(result[["Sheet 1"]], mtcars[1:3, ], ignore_attr = TRUE)
  expect_equal(result[["Sheet 2"]], mtcars[4:6, ], ignore_attr = TRUE)
})

test_that("wb_to_df_list() can extract a subset of sheets", {
  wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))

  result <- wb_to_df_list(wb, "Sheet 1")

  expect_equal(names(result), "Sheet 1")
})

test_that("wb_to_df_list() accepts a file path input", {
  tmp <- withr::local_tempfile(fileext = ".xlsx")
  wb <- as_wb(mtcars[1:3, ])
  openxlsx2::wb_save(wb, tmp)

  result <- wb_to_df_list(tmp)

  expect_equal(result[["Sheet 1"]], mtcars[1:3, ], ignore_attr = TRUE)
})

test_that("wb_split() splits a workbook by a grouping variable", {
  skip_if_not_installed("dplyr")

  wb <- as_wb(list(mtcars[1:3, ], mtcars[4:6, ]))

  split_wbs <- wb_split(wb, .by = carb)

  expect_true(all(vapply(split_wbs, is_wb, logical(1))))
  expect_true(length(split_wbs) > 0)
})
