# Save a workboook object to file while filling file name from assigned workbook title

**\[experimental\]**

`wb_save_ext()` is a helper function extending
[`openxlsx2::wb_save()`](https://janmarvin.github.io/openxlsx2/reference/wb_save.html)
by filling a missing file name with the workbook title and validating
the file extension. This function is not stable and may change in the
future.

## Usage

``` r
wb_save_ext(wb, file = NULL, overwrite = TRUE, flush = FALSE)
```

## Arguments

- wb:

  A `wbWorkbook` object to write to file

- file:

  A path to save the workbook to

- overwrite:

  If `FALSE`, will not overwrite when `file` already exists.

- flush:

  Experimental, streams the worksheet file to disk

## Examples

``` r
withr::with_tempdir({
  wb <- wb_new_workbook(
    title = "Title used for output file",
    sheet_name = "Sheet 1"
  )

  wb_save_ext(wb)

  fs::dir_ls()
})
#> Title used for output file.xlsx
```
