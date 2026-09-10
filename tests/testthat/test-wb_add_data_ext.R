test_that("wb_add_data_ext works", {
  wb <- openxlsx2::wb_workbook(title = "Placeholder title")
  nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))

  wb <- openxlsx2::wb_add_worksheet(wb, "drop_geom")
  wb <- wb_add_data_ext(wb, nc)

  wb <- openxlsx2::wb_add_worksheet(wb, "coords_geom")
  wb <- wb_add_data_ext(wb, nc, geometry = "coords")

  wb <- openxlsx2::wb_add_worksheet(wb, "wkt_geom")
  wb <- wb_add_data_ext(wb, nc, geometry = "wkt")

  expect_snapshot(wb)
})

test_that("wb_add_data_ext() creates a missing worksheet automatically", {
  wb <- wb_new_workbook("mtcars")
  wb <- wb_add_data_ext(wb, mtcars)

  expect_equal(openxlsx2::wb_to_df(wb), mtcars, ignore_attr = TRUE)
})

test_that("wb_add_data_ext() can write data as a table", {
  wb <- wb_new_workbook("mtcars")
  wb <- wb_add_data_ext(wb, mtcars, as_table = TRUE)

  expect_equal(wb$get_tables()$tab_name, "Table1")
})

test_that("wb_add_data_ext() can add column labels in the row before data", {
  df <- data.frame(x = 1:2, y = c("a", "b"))
  attr(df$x, "label") <- "X label"

  wb <- wb_new_workbook("Sheet 1")
  wb <- wb_add_data_ext(wb, df, labels = "row_before")

  result <- openxlsx2::wb_to_df(wb, col_names = FALSE)
  expect_equal(as.character(result[1, 1]), "X label")
  expect_equal(as.character(result[2, ]), c("x", "y"))
})

test_that("wb_add_data_ext() can add column labels as comments", {
  df <- data.frame(x = 1:2, y = c("a", "b"))
  attr(df$x, "label") <- "X label"

  wb <- wb_new_workbook("Sheet 1")
  wb <- wb_add_data_ext(wb, df, labels = "comments")

  comments <- openxlsx2::wb_get_comment(wb, sheet = "Sheet 1")
  expect_match(comments$comment, "X label")
})

test_that("wb_add_data_ext() warns when using the deprecated na.strings argument", {
  df <- data.frame(x = 1:2)

  wb <- wb_new_workbook("Sheet 1")

  expect_warning(
    wb_add_data_ext(wb, df, na.strings = "NA"),
    class = "lifecycle_warning_deprecated"
  )
})
