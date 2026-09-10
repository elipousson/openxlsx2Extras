test_that("wb_add_styles() adds a single named style", {
  wb <- openxlsx2::wb_workbook()
  wb <- openxlsx2::wb_add_worksheet(wb)

  style <- openxlsx2::create_dxfs_style(
    font_color = openxlsx2::wb_color(hex = "FF0000")
  )
  wb <- wb_add_styles(wb, styles = style, style_names = "myred")

  expect_equal(wb$styles_mgr$dxf$name, "myred")
})

test_that("wb_add_styles() adds a named list of styles", {
  wb <- openxlsx2::wb_workbook()
  wb <- openxlsx2::wb_add_worksheet(wb)

  wb <- wb_add_styles(wb, styles = common_dxfs_styles)

  expect_equal(wb$styles_mgr$dxf$name, c("bad", "good", "neutral"))
})

test_that("wb_add_styles() errors without style_names for unnamed styles", {
  wb <- openxlsx2::wb_workbook()
  wb <- openxlsx2::wb_add_worksheet(wb)

  style <- openxlsx2::create_dxfs_style()

  expect_error(wb_add_styles(wb, styles = style))
})

test_that("common_dxfs_styles has bad, good, and neutral styles", {
  expect_named(common_dxfs_styles, c("bad", "good", "neutral"))
})
