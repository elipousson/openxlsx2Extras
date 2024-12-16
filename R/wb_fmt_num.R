get_currency_numfmt <- function(currency = NULL,
                                use_subunits = TRUE,
                                decimals = NULL,
                                locale = NULL,
                                accounting = FALSE,
                                force_sign = FALSE,
                                sep_mark = ",") {
  rlang::check_installed("gt")

  currency <- currency %||% gt:::get_locale_currency_code(currency)

  gt:::validate_currency(currency = currency)

  decimals <- gt:::get_currency_decimals(
    currency = currency,
    decimals = decimals,
    use_subunits = use_subunits
  )

  numfmt <- paste0("#", sep_mark, "##0")

  if (decimals > 0) {
    numfmt <- paste0(numfmt, ".", paste0(rep(0, decimals), collapse = ""))
  }

  if (accounting) {
    currency_sym <- paste0(
      "[$",
      gt:::currencies[gt:::currencies[["curr_code"]] == currency, ][["symbol"]],
      "]"
    )

    numfmt <- paste0(currency_sym, numfmt, ";(", currency_sym, numfmt, ")")
  }

  numfmt
}

wb_add_currencyfmt <- function(wb,
                               sheet = openxlsx2::current_sheet(),
                               dims = "A1",
                               numfmt = NULL,
                               currency = NULL,
                               use_subunits = TRUE,
                               decimals = NULL,
                               locale = NULL,
                               accounting = FALSE,
                               force_sign = FALSE,
                               sep_mark = ",",
                               ...) {
  numfmt <- numfmt %||% get_currency_numfmt(
    currency = currency,
    use_subunits = use_subunits,
    decimals = decimals,
    locale = locale,
    accounting = accounting,
    force_sign = force_sign,
    sep_mark = sep_mark
  )

  openxlsx2::wb_add_numfmt(
    wb,
    sheet = sheet,
    dims = dims,
    numfmt = numfmt
  )
}
