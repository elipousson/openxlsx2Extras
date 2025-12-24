# Add Markdown formatted text to a Workbook

**\[experimental\]**

`wb_add_marquee_text()` uses
[`fmt_marquee_txt()`](https://elipousson.github.io/openxlsx2Extras/reference/fmt_marquee_txt.md)
to add Markdown formatted text to a Workbook.
[`openxlsx2::wb_set_col_widths()`](https://janmarvin.github.io/openxlsx2/reference/col_widths-wb.html)
is applied to the workbook to adjust widths for the specified columns.
Set `widths = NULL` to disable this functionality.

## Usage

``` r
wb_add_marquee_text(
  wb = NULL,
  text,
  sheet = current_sheet(),
  dims = NULL,
  ...,
  cols = 1,
  widths = "auto"
)
```

## Arguments

- wb:

  A Workbook object containing a worksheet.

- text:

  A character string. The core quality of markdown is that any text is
  valid markdown so there is no restrictions on the content

- sheet:

  The worksheet to write to. Can be the worksheet index or name.

- dims:

  Spreadsheet cell range that will determine `start_col` and
  `start_row`: "A1", "A1:B2", "A:B"

- ...:

  Arguments passed on to
  [`fmt_marquee_txt`](https://elipousson.github.io/openxlsx2Extras/reference/fmt_marquee_txt.md)

  `style`

  :   A style set such as
      [`classic_style()`](https://marquee.r-lib.org/reference/classic_style.html)
      that defines how the text should be rendered

  `ignore_html`

  :   Should HTML code be removed from the output

- cols:

  Indices of cols to set/remove column widths.

- widths:

  Width to set `cols` to specified column width or `"auto"` for
  automatic sizing. `widths` is recycled to the length of `cols`.
  openxlsx2 sets the default width is 8.43, as this is the standard in
  some spreadsheet software. See **Details** for general information on
  column widths.

## Examples

``` r
library(openxlsx2)

wb <- wb_workbook()
wb <- wb_add_worksheet(wb)

wb <- wb_add_marquee_text(
  wb,
  text = "
# Heading 1

Example text.

~~Strikethrough text~~

## Heading 2

- Bulleted list item 1
  - Nested bullet
- Bulleted list item 2"
)
```
