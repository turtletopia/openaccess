get_access_type <- function(page) {
  source_site <- attr(page, "source_site", exact = TRUE)
  switch(
    source_site,
    # ASBMB
    "Journal of Biological Chemistry" = ,
    "Journal of Lipid Research" = ,
    "Molecular & Cellular Proteomics" = "Open Access",
    # Cell Press
    "Cell Reports" = ,
    "Cell Reports Medicine" = "Open Access",
    "Biophysical Journal" = ,
    "Molecular Cell" = is_oa_pb_page(page),
    # Other publishers
    "Frontiers" = ,
    "PeerJ" = "Open Access",
    "OUP Academic" = ,
    "Portland Press" = is_oa_icon(page),
    "ACS Publications" = is_oa_acs(page),
    "Cambridge Core" = is_oa_cambridge(page),
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
    "Science" = is_oa_science(page),
    "Taylor & Francis" = is_oa_taylor_francis(page),
    "Wiley Online Library" = ,
    "Analytical Science Journals" = ,
    "FEBS Press" = is_oa_wiley(page),
    stop(glue(
      "'{source_site}' is not supported as a source (for {.CURRENT_DOI})"
    ), call. = FALSE)
  )
}

is_oa_pb_page <- function(page) {
  # Full support
  access_type <- find_element(page, "span.article-header__access")
  if (is_found(access_type)) {
    standardize_access(element_text(access_type))
  } else {
    purchase <- find_element(page, "a.article-tools__item__purchase")
    if (is_found(purchase)) "Closed Access" else "Free Access"
  }
}

is_oa_icon <- function(page) {
  find_element(page, "i.icon-availability_open") %>%
    is_found() %>%
    open_closed()
}

is_oa_acs <- function(page) {
  find_element(page, "div.article_header-open-access img[alt=\"ACS AuthorChoice\"]") %>%
    is_found() %>%
    open_closed()
}

is_oa_cambridge <- function(page) {
  find_element(page, "span.open-access>img.open-access") %>%
    is_found() %>%
    open_closed()
}

is_oa_elife <- function(page) {
  find_element(page, "a.content-header__icon--oa") %>%
    is_found() %>%
    open_closed()
}

is_oa_elsevier <- function(page) {
  find_element(page, "div.OpenAccessLabel") %>%
    is_found() %>%
    open_closed()
}

#' @importFrom stringr str_detect
is_oa_hindawi <- function(page) {
  find_element(page, "div.articleHeader>strong") %>%
    element_text() %>%
    str_detect("Open Access")
}

is_oa_jneurosci <- function(page) {
  find_element(page, "span.highwire-foxycart-add-to-cart") %>%
    Negate(is_found)() %>%
    open_closed()
}

is_oa_mdpi <- function(page) {
  find_element(page, "span.openaccess") %>%
    is_found() %>%
    open_closed()
}

is_oa_nature <- function(page) {
  find_element(page, "span[data-test=open-access]") %>%
    is_found() %>%
    open_closed()
}

is_oa_pnas <- function(page) {
  find_element(page, "i.icon-open_access") %>%
    is_found() %>%
    open_closed()
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
    is_found() %>%
    open_closed()
}

is_oa_science <- function(page) {
  find_element(page, "i.icon-access-open") %>%
    is_found() %>%
    open_closed()
}

is_oa_taylor_francis <- function(page) {
  find_element(page, "div.accessLogo>p#logo-text") %>%
    element_text() %>%
    identical("Open access")
}

is_oa_wiley <- function(page) {
  ret <- find_element(page, "div.doi-access")
  is_found(ret) %>%
    open_closed()
  # structure(
  #   is_found(ret),
  #   type = element_text(ret)
  # )
}
