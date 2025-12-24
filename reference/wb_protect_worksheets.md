# Protect one or more sheets in a workbook

Protect one or more sheets in a workbook

## Usage

``` r
wb_protect_worksheets(
  wb,
  sheet = NULL,
  protect = TRUE,
  password = NULL,
  properties = c("insertColumns", "insertRows", "deleteColumns", "deleteRows")
)
```

## Arguments

- wb:

  A workbook object

- sheet:

  A name or index of a worksheet

- protect:

  Whether to protect or unprotect the sheet (default=TRUE)

- password:

  (optional) password required to unprotect the worksheet

- properties:

  Defaults to
  `c("insertColumns", "insertRows", "deleteColumns", "deleteRows")`
