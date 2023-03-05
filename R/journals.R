get_access_type <- function(page) {
  canonical_url <- attr(page, "canonical_url", exact = TRUE)
  switch(
    canonical_url,
    # ASBMB
    "www.jbc.org" = ,
    "www.jlr.org" = ,
    "www.mcponline.org" = "Open Access",
    # Cell Press
    "www.cell.com" = is_oa_cell(page),
    # Science Direct
    "www.sciencedirect.com" = is_oa_elsevier(page),
    # Springer Nature
    "link.springer.com" = ,
    "www.nature.com" = ,
    "biomedcentral.com" = is_oa_springer(page),
    # Other publishers
    "peerj.com" = "Open Access",
    "www.cambridge.org" = is_oa_cambridge(page),
    "www.hindawi.com" = is_oa_hindawi(page),
    "www.tandfonline.com" = is_oa_taylor_francis(page),


    # Other publishers
    "Frontiers" = ,
    "PeerJ" = "Open Access",
    "OUP Academic" = ,
    "Portland Press" = is_oa_icon(page),
    "ACS Publications" = is_oa_acs(page),
    "eLife" = is_oa_elife(page),
    "Journal of Neuroscience" = is_oa_jneurosci(page),
    "MDPI" = is_oa_mdpi(page),
    "Nature" = ,
    "BioMed Central" = ,
    "SpringerLink" = is_oa_nature(page),
    "PNAS" = is_oa_pnas(page),
    "Public Library of Science" = is_oa_plos(page),
    "The Royal Society of Chemistry" = is_oa_rsc(page),
    "Science" = is_oa_science(page),
    "Wiley Online Library" = ,
    "Analytical Science Journals" = ,
    "FEBS Press" = is_oa_wiley(page),
    stop(glue(
      "'{canonical_url}' is not supported as a source (for {.CURRENT_DOI})"
    ), call. = FALSE)
  )
}

is_oa_cambridge <- function(page) {
  open_access <- find_element(page, "span.open-access")
  if (is_found(open_access)) {
    open_access %>%
      element_text() %>%
      standardize_access()
  } else {
    access <- find_element(page, "span.has-access")
    if (is_found(access)) "Free Access" else "Closed Access"
  }
}

is_oa_cell <- function(page) {
  access_type <- find_element(page, "span.article-header__access")
  if (is_found(access_type)) {
    access_type %>%
      element_text() %>%
      standardize_access()
  } else {
    purchase <- find_element(page, "a.article-tools__item__purchase")
    if (is_found(purchase)) "Closed Access" else "Free Access"
  }
}

is_oa_elsevier <- function(page) {
  open_access <- find_element(page, "div.OpenAccessLabel")
  if (is_found(open_access)) {
    open_access %>%
      element_text() %>%
      standardize_access()
  } else {
    purchase <- find_element(page, "li.PurchasePDF")
    if (is_found(purchase)) "Closed Access" else "Free Access"
  }
}

is_oa_hindawi <- function(page) {
  find_element(page, "div.articleHeader>strong") %>%
    element_text() %>%
    string_match("\\|(.*)") %>%
    standardize_access()
}

is_oa_springer <- function(page) {
  open_access <- find_element(page, "span[data-test=open-access]")
  if (is_found(open_access)) {
    open_access %>%
      element_text() %>%
      standardize_access()
  } else {
    download <- find_element(page, "span.c-pdf-download__text")
    if (is_found(download)) "Free Access" else "Closed Access"
  }
}

is_oa_taylor_francis <- function(page) {
  find_element(page, "div.accessLogo>p#logo-text") %>%
    element_text() %>%
    standardize_access() %>%
    closed_if_null()
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

is_oa_elife <- function(page) {
  find_element(page, "a.content-header__icon--oa") %>%
    is_found() %>%
    open_closed()
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

is_oa_wiley <- function(page) {
  ret <- find_element(page, "div.doi-access")
  is_found(ret) %>%
    open_closed()
  # structure(
  #   is_found(ret),
  #   type = element_text(ret)
  # )
}
