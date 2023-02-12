check_open_access <- function(page) {
  source_site <- attr(page, "source_site", exact = TRUE)
  switch(
    source_site,
    "Frontiers" = TRUE,
    "eLife" = is_oa_elife(page),
    "Journal of Biological Chemistry" = is_oa_jbc(page),
    "Nature" = ,
    "SpringerLink" = is_oa_nature(page),
    "PNAS" = is_oa_pnas(page),
    "Public Library of Science" = is_oa_plos(page),
    stop(glue("'{source_site}' is not supported as a source", call. = FALSE))
  )
}

#' @importFrom rvest html_element
is_oa_elife <- function(page) {
  html_element(page, "a.content-header__icon--oa") %>%
    Negate(is.na)()
}

#' @importFrom rvest html_element
is_oa_jbc <- function(page) {
  html_element(page, "span.article-header__access") %>%
    Negate(is.na)()
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

#' @importFrom rvest html_element html_text
is_oa_plos <- function(page) {
  html_element(page, "p#licenseShort") %>%
    html_text() %>%
    `==`("Open Access")
}
