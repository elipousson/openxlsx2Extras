# Use `marquee::marquee_parse()` to format Markdown text

**\[experimental\]**

`fmt_marquee_txt()` uses
[`marquee::marquee_parse()`](https://marquee.r-lib.org/reference/marquee_parse.html)
and
[`openxlsx2::fmt_txt()`](https://janmarvin.github.io/openxlsx2/reference/fmt_txt.html)
to format Markdown text.

## Usage

``` r
fmt_marquee_txt(
  text,
  ...,
  style = marquee::classic_style(),
  ignore_html = TRUE
)
```

## Arguments

- text:

  A character string. The core quality of markdown is that any text is
  valid markdown so there is no restrictions on the content

- ...:

  Ignored at this time. For future use.

- style:

  A style set such as
  [`classic_style()`](https://marquee.r-lib.org/reference/classic_style.html)
  that defines how the text should be rendered

- ignore_html:

  Should HTML code be removed from the output

## Examples

``` r
fmt_marquee_txt(
  "# ABC

  abc"
)
#> [[1]]
#> fmt_txt string: 
#> [1] ""
#> 
#> [[2]]
#> fmt_txt string: 
#> [1] "ABC"
#> 
#> [[3]]
#> fmt_txt string: 
#> [1] "abc"
#> 
```
