check_open_access <- function(page) {
  source_site <- attr(page, "source_site", exact = TRUE)
  switch(
    source_site,
    "Frontiers" = TRUE,
    "eLife" = is_oa_elife(page),
    "Elsevier" = ,
    "Academic Press" = is_oa_elsevier(page),
    "Journal of Biological Chemistry" = ,
    "Biophysical Journal" = is_oa_jbc(page),
    "Journal of Neuroscience" = is_oa_jneurosci(page),
    "MDPI" = is_oa_mdpi(page),
    "Nature" = ,
    "SpringerLink" = is_oa_nature(page),
    "PNAS" = is_oa_pnas(page),
    "Portland Press" = is_oa_portland(page),
    "Public Library of Science" = is_oa_plos(page),
    "The Royal Society of Chemistry" = is_oa_rsc(page),
    stop(glue("'{source_site}' is not supported as a source", call. = FALSE))
  )
}

#' @importFrom rvest html_element
is_oa_elife <- function(page) {
  html_element(page, "a.content-header__icon--oa") %>%
    Negate(is.na)()
}

#' @importFrom rvest html_element
is_oa_elsevier <- function(page) {
  html_element(page, "div.OpenAccessLabel") %>%
    Negate(is.na)()
}

#' @importFrom rvest html_element
is_oa_jbc <- function(page) {
  # TODO: should text be equal to "Open Archive"?
  html_element(page, "span.article-header__access") %>%
    Negate(is.na)()
}

#' @importFrom rvest html_element
is_oa_jneurosci <- function(page) {
  html_element(page, "span.highwire-foxycart-add-to-cart") %>%
    is.na()
}

#' @importFrom rvest html_element
is_oa_mdpi <- function(page) {
  html_element(page, "span.openaccess") %>%
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

#' @importFrom rvest html_element
is_oa_portland <- function(page) {
  html_element(page, "i.icon-availability_open") %>%
    Negate(is.na)()
}

#' @importFrom glue glue
#' @importFrom rvest html_element
is_oa_rsc <- function(page) {
  img_src <- "https://www.rsc-cdn.org/pubs-core/2022.0.86/content/NewImages/open-access-icon-orange.png"
  html_element(page, glue("img[src=\"{img_src}\"]")) %>%
    Negate(is.na)()
}
