#' Check a paper for open access
#'
#' @description
#' Checks whether the full text of the paper is available without restrictions.
#' Throws error if no interpreter available for the journal.
#'
#' @param article `character(1) | xml_document(1)`\cr
#'  DOI of the paper; or the HTML site containing the paper acquired using
#'  [rvest::read_html()] or [httr2::resp_body_html()].
#'
#' @section Supported sources:
#' * Academic Press
#' * BioMed Central
#' * Biophysical Journal
#' * Cambridge Core
#' * Cell Reports
#' * eLife
#' * Elsevier
#' * Frontiers
#' * Hindawi
#' * Journal of Biological Chemistry
#' * Journal of Neuroscience
#' * MDPI
#' * Molecular Cell
#' * Nature
#' * OUP Academic
#' * PeerJ
#' * Pergamon
#' * PLOS ONE
#' * Portland Press
#' * The Royal Society of Chemistry
#' * SpringerLink
#' * Taylor & Francis
#'
#' @return `TRUE` or `FALSE` depending on check result.
#'
#' @examples
#' is_open_access("10.1093/nar/gkac882")
#'
#' @export
is_open_access <- function(article) {
  UseMethod("is_open_access")
}

#' @rdname is_open_access
#' @importFrom glue glue
#' @export
is_open_access.character <- function(article) {
  is_open_access(get_html(glue("https://doi.org/{article}")))
}

#' @rdname is_open_access
#' @importFrom rvest read_html
#' @export
is_open_access.xml_document <- function(article) {
  redirects <- is_redirect(article)
  while (redirects) {
    article <- get_html(attr(redirects, "url", exact = TRUE))
    redirects <- is_redirect(article)
  }
  is_open_access(determine_source(article))
}

#' @rdname is_open_access
#' @export
is_open_access.oa_remote_driver <- function(article) {
  is_open_access(determine_source(article))
}

#' @rdname is_open_access
#' @export
is_open_access.oa_html_document <- function(article) {
  check_open_access(article)
}

#' @importFrom rvest html_attr html_element
determine_source <- function(page) {
  source <- page %>%
    find_element("head>meta[property=\"og:site_name\"]") %>%
    element_attr("content")

  if (is.na(source) || source == "") {
    # If `og:site_name` property is missing
    source <- page %>%
      find_element("head>meta[name=citation_publisher]") %>%
      element_attr("content")
  }

  if (is.na(source) || source == "") {
    # If citation publisher is missing as well
    source <- page %>%
      find_element("head>meta[name=\"DC.publisher\"]") %>%
      element_attr("content")
  }

  structure(
    page,
    source_site = source,
    class = c("oa_html_document", class(page))
  )
}
