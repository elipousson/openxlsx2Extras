test_that("wb_add_data_ext works", {
  wb <- openxlsx2::wb_workbook(title = "Placeholder title")
  nc <- sf::read_sf(system.file("shape/nc.shp", package="sf"))

  wb <- openxlsx2::wb_add_worksheet(wb, "drop_geom")
  wb <- wb_add_data_ext(wb, nc)

  wb <- openxlsx2::wb_add_worksheet(wb, "coords_geom")
  wb <- wb_add_data_ext(wb, nc, geometry = "coords")

  wb <- openxlsx2::wb_add_worksheet(wb, "wkt_geom")
  wb <- wb_add_data_ext(wb, nc, geometry = "wkt")

  expect_snapshot(wb)
})
