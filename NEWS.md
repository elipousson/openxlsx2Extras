# openxlsx2Extras 0.0.0.9000

* Increase minimum required version of openxlsx2 to 1.23, which introduced the `na` argument used by `wb_add_data_ext()` and `write_xlsx_ext()`.
* `read_xlsx_ext()` now accepts vector `file` or `sheet` arguments to read multiple files or sheets, combined into a single data frame by default (controlled by the new `combine`, `names_from`, and `names_to` arguments). (2025-09-05)
* `read_xlsx_ext()` now accepts a `wbWorkbook` object for `file` when the workbook has an existing file path. (2025-12-24)
* `wb_add_data_ext()` gains a `labels = "comments"` option to add column labels as cell comments instead of an extra row. (2025-10-20)
* Fix `wb_add_data_ext()` `labels = "row_before"` handling, which referenced the wrong object and did not handle missing labels. (2025-10-20)
* `wb_add_data_ext()` and `write_xlsx_ext()` gain a `na` argument matching `openxlsx2::wb_add_data()`. The `na.strings` argument is soft-deprecated in favor of `na`.
* Add `wb_dims_ext()` helper extending `openxlsx2::wb_dims()` with workbook input and tidyselect support for the `cols` argument. (2025-08-04)
* `wb_cols_to_dims()`, `wb_cols_to_index()`, `wb_sheets_cols_to_dims()`, and `wb_dims_ext()` gain `start_row` and `start_col` arguments, and `wb_sheets_cols_to_dims()` now de-duplicates character `cols` input. (2025-10-21)
* Add `wb_protect_worksheets()` function to protect multiple worksheets at once. (2025-10-20)
* Add `wb_rename_data()` function to rename workbook columns using tidyselect syntax. (2025-10-20)
* Add `wb_rename_sheets()` and `wb_rename_sheets_with()` functions to rename workbook sheets using tidyselect syntax. (2025-10-20)
* Add `set_sheet_list_names()`, `as_sheet_names()`, and `as_sheet_list()` utility functions (based on existing openxlsx2 code). (2024-12-02)
* Add `prep_wb_data()` function (see #4, 2024-12-02).
* Add `read_xlsx_ext()`, `write_xlsx_ext()` (#3), and `wb_add_data_ext()` functions (2024-11-10).
* Add `set_excel_fmt_class()` function.
* Add `wb_add_marquee_text()` and `fmt_marquee_txt()` functions.
* Add `wb_add_styles()` function for passing multiple styles in a list. Provide `common_dxfs_styles` as a prepared named list of styles. (2025-01-25)
* Add `as_data_validation_value()` helper function. (2025-01-25)
* Publish package to GitHub (2024-10-21).
