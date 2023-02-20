check_open_access <- function(page) {
  source_site <- attr(page, "source_site", exact = TRUE)
  switch(
    source_site,
    "Frontiers" = ,
    "PeerJ" = TRUE,
    "OUP Academic" = ,
    "Portland Press" = is_oa_icon(page),
    "Cambridge Core" = is_oa_cambridge(page),
    "Cell Reports" = ,
    "Biophysical Journal" = ,
    "Journal of Biological Chemistry" = ,
    "Molecular Cell" = is_oa_cell(page),
    "eLife" = is_oa_elife(page),
    "Elsevier" = ,
    "Academic Press" = ,
    "Pergamon" = is_oa_elsevier(page),
    "Hindawi" = is_oa_hindawi(page),
    "Journal of Neuroscience" = is_oa_jneurosci(page),
    "MDPI" = is_oa_mdpi(page),
    "Nature" = ,
    "BioMed Central" = ,
    "SpringerLink" = is_oa_nature(page),
    "PNAS" = is_oa_pnas(page),
    "Public Library of Science" = is_oa_plos(page),
    "The Royal Society of Chemistry" = is_oa_rsc(page),
    "Taylor & Francis" = is_oa_taylor_francis(page),
    stop(glue("'{source_site}' is not supported as a source", call. = FALSE))
  )
}

is_oa_icon <- function(page) {
  find_element(page, "i.icon-availability_open") %>%
    is_found()
}

is_oa_cambridge <- function(page) {
  find_element(page, "span.open-access>img.open-access") %>%
    is_found()
}

#' @importFrom stringr str_detect
is_oa_cell <- function(page) {
  find_element(page, "span.article-header__access") %>%
    element_text() %>%
    str_detect("^Open (?:Archive|Access)$")
}

is_oa_elife <- function(page) {
  find_element(page, "a.content-header__icon--oa") %>%
    is_found()
}

is_oa_elsevier <- function(page) {
  find_element(page, "div.OpenAccessLabel") %>%
    is_found()
}

#' @importFrom stringr str_detect
is_oa_hindawi <- function(page) {
  find_element(page, "div.articleHeader>strong") %>%
    element_text() %>%
    str_detect("Open Access")
}

is_oa_jneurosci <- function(page) {
  find_element(page, "span.highwire-foxycart-add-to-cart") %>%
    Negate(is_found)()
}

is_oa_mdpi <- function(page) {
  find_element(page, "span.openaccess") %>%
    is_found()
}

is_oa_nature <- function(page) {
  find_element(page, "span[data-test=open-access]") %>%
    is_found()
}

is_oa_pnas <- function(page) {
  find_element(page, "i.icon-open_access") %>%
    is_found()
}

is_oa_plos <- function(page) {
  find_element(page, "p#licenseShort") %>%
    element_text() %>%
    identical("Open Access")
}

#' @importFrom glue glue
is_oa_rsc <- function(page) {
  img_src <- "https://www.rsc-cdn.org/pubs-core/2022.0.86/content/NewImages/open-access-icon-orange.png"
  find_element(page, glue("img[src=\"{img_src}\"]")) %>%
    is_found()
}

is_oa_taylor_francis <- function(page) {
  find_element(page, "div.accessLogo>p#logo-text") %>%
    element_text() %>%
    identical("Open access")
}
