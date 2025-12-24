# Set workbook properties

`wb_set_properties_ext()` extends
[`openxlsx2::wb_set_properties()`](https://janmarvin.github.io/openxlsx2/reference/properties-wb.html)
by adding a properties argument that uses a named list to default
default values for existing properties.

## Usage

``` r
wb_set_properties_ext(
  wb,
  ...,
  creator = NULL,
  title = NULL,
  subject = NULL,
  category = NULL,
  datetime_created = NULL,
  datetime_modified = NULL,
  modifier = NULL,
  keywords = NULL,
  comments = NULL,
  manager = NULL,
  company = NULL,
  custom = NULL,
  properties = NULL
)
```

## Arguments

- wb:

  A Workbook object

- ...:

  Must be empty.

- creator:

  Creator of the workbook (your name). Defaults to login username or
  `options("openxlsx2.creator")` if set.

- title, subject, category, keywords, comments, manager, company:

  Workbook property, a string.

- datetime_created:

  The time of the workbook is created

- datetime_modified:

  The time of the workbook was last modified

- modifier:

  A character string indicating who was the last person to modify the
  workbook

- custom:

  A named vector of custom properties added to the workbook

- properties:

  A named character vector or named list of properties used as default
  values for any other parameter that is not explicitly set.

## Value

A workbook with modified properties.
