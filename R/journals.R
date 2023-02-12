check_open_access <- function(page) {
  source_site <- attr(page, "source_site", exact = TRUE)
  switch(
    source_site,
    "SpringerLink" = ,
    "Nature" = is_oa_nature(page),
    "PNAS" = is_oa_pnas(page),
    "Journal of Biological Chemistry" = is_oa_jbc(page),
    stop(glue("'{source_site}' is not supported as a source", call. = FALSE))
  )
}

#' @importFrom rvest html_element
is_oa_nature <- function(page) {
  html_element(page, "span[data-test=open-access]") %>%
    Negate(is.na)()
}

#' @importFrom rvest html_element
is_oa_pnas <- function(page) {
  html_element(page, "i.icon-open_access") %>%
    Negate(is.na)()
}

#' @importFrom rvest html_element
is_oa_jbc <- function(page) {
  html_element(page, "span.article-header__access") %>%
    Negate(is.na)()
}
