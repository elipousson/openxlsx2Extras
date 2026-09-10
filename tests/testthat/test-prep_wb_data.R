test_that("prep_wb_data() returns non-list-column data frames unchanged", {
  data <- data.frame(x = 1:2, y = c("a", "b"))

  expect_equal(prep_wb_data(data), data)
})

test_that("prep_wb_data() collapses list columns by default", {
  list_df <- vctrs::data_frame(
    num = 1,
    alpha = list(list("A", "B", "C"))
  )

  result <- prep_wb_data(list_df)

  expect_equal(result[["alpha"]], "A; B; C")
})

test_that("prep_wb_data() can drop list columns", {
  list_df <- vctrs::data_frame(
    num = 1,
    alpha = list(list("A", "B", "C"))
  )

  result <- prep_wb_data(list_df, list_columns = "drop")

  expect_false("alpha" %in% names(result))
})

test_that("prep_wb_data() can leave list columns as-is (coerced to character)", {
  list_df <- vctrs::data_frame(
    num = 1,
    alpha = list(list("A", "B", "C"))
  )

  result <- prep_wb_data(list_df, list_columns = "asis")

  expect_type(result[["alpha"]], "character")
})

test_that("prep_wb_data() drops sf geometry by default", {
  skip_if_not_installed("sf")

  nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))
  result <- prep_wb_data(nc)

  expect_false(inherits(result, "sf"))
  expect_false(attr(nc, "sf_column") %in% names(result))
})

test_that("prep_wb_data() can convert sf geometry to coordinates", {
  skip_if_not_installed("sf")

  nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))
  result <- prep_wb_data(nc, geometry = "coords")

  expect_true(all(c("lon", "lat") %in% names(result)))
  expect_type(result[["lon"]], "double")
})

test_that("prep_wb_data() can convert sf geometry to WKT text", {
  skip_if_not_installed("sf")

  nc <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))
  result <- prep_wb_data(nc, geometry = "wkt")

  sf_col <- attr(nc, "sf_column")
  expect_type(result[[sf_col]], "character")
  expect_match(result[[sf_col]][[1]], "^MULTIPOLYGON")
})
