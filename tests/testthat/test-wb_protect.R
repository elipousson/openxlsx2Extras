test_that("wb_protect_worksheets() protects all sheets by default", {
  wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))

  wb <- wb_protect_worksheets(wb)

  expect_match(wb$worksheets[[1]]$sheetProtection, "insertColumns=\"1\"")
  expect_match(wb$worksheets[[2]]$sheetProtection, "insertColumns=\"1\"")
})

test_that("wb_protect_worksheets() can target a single sheet", {
  wb <- as_wb(list(a = mtcars[1:2, ], b = mtcars[3:4, ]))

  wb <- wb_protect_worksheets(wb, sheet = "a")

  expect_true(nzchar(wb$worksheets[[1]]$sheetProtection))
  expect_equal(wb$worksheets[[2]]$sheetProtection, character(0))
})

test_that("wb_protect_worksheets() can limit protected properties", {
  wb <- as_wb(mtcars[1:2, ])

  wb <- wb_protect_worksheets(wb, properties = "insertRows")

  expect_match(wb$worksheets[[1]]$sheetProtection, "insertRows=\"1\"")
  expect_no_match(wb$worksheets[[1]]$sheetProtection, "insertColumns")
})
