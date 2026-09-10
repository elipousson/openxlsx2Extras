# Changelog

## openxlsx2Extras 0.0.0.9000

- Increase minimum required version of openxlsx2 to 1.23, which
  introduced the `na` argument used by
  [`wb_add_data_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)
  and
  [`write_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/write_xlsx_ext.md).
- [`read_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/read_xlsx_ext.md)
  now accepts vector `file` or `sheet` arguments to read multiple files
  or sheets, combined into a single data frame by default (controlled by
  the new `combine`, `names_from`, and `names_to` arguments).
  (2025-09-05)
- [`read_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/read_xlsx_ext.md)
  now accepts a `wbWorkbook` object for `file` when the workbook has an
  existing file path. (2025-12-24)
- [`wb_add_data_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)
  gains a `labels = "comments"` option to add column labels as cell
  comments instead of an extra row. (2025-10-20)
- Fix
  [`wb_add_data_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)
  `labels = "row_before"` handling, which referenced the wrong object
  and did not handle missing labels. (2025-10-20)
- [`wb_add_data_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)
  and
  [`write_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/write_xlsx_ext.md)
  gain a `na` argument matching
  [`openxlsx2::wb_add_data()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data.html).
  The `na.strings` argument is soft-deprecated in favor of `na`.
- Add
  [`wb_dims_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_dims_ext.md)
  helper extending
  [`openxlsx2::wb_dims()`](https://janmarvin.github.io/openxlsx2/reference/wb_dims.html)
  with workbook input and tidyselect support for the `cols` argument.
  (2025-08-04)
- [`wb_cols_to_dims()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_sheets_cols_to_dims.md),
  [`wb_cols_to_index()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_sheets_cols_to_dims.md),
  [`wb_sheets_cols_to_dims()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_sheets_cols_to_dims.md),
  and
  [`wb_dims_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_dims_ext.md)
  gain `start_row` and `start_col` arguments, and
  [`wb_sheets_cols_to_dims()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_sheets_cols_to_dims.md)
  now de-duplicates character `cols` input. (2025-10-21)
- Add
  [`wb_protect_worksheets()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_protect_worksheets.md)
  function to protect multiple worksheets at once. (2025-10-20)
- Add
  [`wb_rename_data()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_rename_data.md)
  function to rename workbook columns using tidyselect syntax.
  (2025-10-20)
- Add
  [`wb_rename_sheets()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_rename_sheets.md)
  and
  [`wb_rename_sheets_with()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_rename_sheets.md)
  functions to rename workbook sheets using tidyselect syntax.
  (2025-10-20)
- Add
  [`set_sheet_list_names()`](https://elipousson.github.io/openxlsx2Extras/reference/set_sheet_list_names.md),
  [`as_sheet_names()`](https://elipousson.github.io/openxlsx2Extras/reference/set_sheet_list_names.md),
  and
  [`as_sheet_list()`](https://elipousson.github.io/openxlsx2Extras/reference/as_sheet_list.md)
  utility functions (based on existing openxlsx2 code). (2024-12-02)
- Add
  [`prep_wb_data()`](https://elipousson.github.io/openxlsx2Extras/reference/prep_wb_data.md)
  function (see
  [\#4](https://github.com/elipousson/openxlsx2Extras/issues/4),
  2024-12-02).
- Add
  [`read_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/read_xlsx_ext.md),
  [`write_xlsx_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/write_xlsx_ext.md)
  ([\#3](https://github.com/elipousson/openxlsx2Extras/issues/3)), and
  [`wb_add_data_ext()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_data_ext.md)
  functions (2024-11-10).
- Add
  [`set_excel_fmt_class()`](https://elipousson.github.io/openxlsx2Extras/reference/set_excel_fmt_class.md)
  function.
- Add
  [`wb_add_marquee_text()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_marquee_text.md)
  and
  [`fmt_marquee_txt()`](https://elipousson.github.io/openxlsx2Extras/reference/fmt_marquee_txt.md)
  functions.
- Add
  [`wb_add_styles()`](https://elipousson.github.io/openxlsx2Extras/reference/wb_add_styles.md)
  function for passing multiple styles in a list. Provide
  `common_dxfs_styles` as a prepared named list of styles. (2025-01-25)
- Add
  [`as_data_validation_value()`](https://elipousson.github.io/openxlsx2Extras/reference/as_data_validation_value.md)
  helper function. (2025-01-25)
- Publish package to GitHub (2024-10-21).
