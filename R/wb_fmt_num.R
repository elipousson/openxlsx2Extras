get_currency_numfmt <- function(
  currency = NULL,
  use_subunits = TRUE,
  decimals = NULL,
  locale = NULL,
  accounting = FALSE,
  force_sign = FALSE,
  sep_mark = ","
) {
  rlang::check_installed("gt")

  currency <- currency %||% get_locale_currency_code(currency)

  validate_currency(currency = currency)

  decimals <- get_currency_decimals(
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
      currencies()[currencies()[["curr_code"]] == currency, ][["symbol"]],
      "]"
    )

    numfmt <- paste0(currency_sym, numfmt, ";(", currency_sym, numfmt, ")")
  }

  numfmt
}

wb_add_currencyfmt <- function(
  wb,
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
  ...
) {
  numfmt <- numfmt %||%
    get_currency_numfmt(
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

#' @noRd
currencies <- function(...) {
  check_installed("gt")
  utils::getFromNamespace("currencies", "gt")
}

#' @noRd
get_currency_decimals <- function(...) {
  check_installed("gt")
  .f <- utils::getFromNamespace("get_currency_decimals", "gt")
  .f(...)
}


#' @noRd
get_locale_currency_code <- function(...) {
  check_installed("gt")
  .f <- utils::getFromNamespace("get_locale_currency_code", "gt")
  .f(...)
}

#' @noRd
validate_currency <- function(...) {
  check_installed("gt")
  .f <- utils::getFromNamespace("validate_currency", "gt")
  .f(...)
}
