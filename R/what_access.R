.CURRENT_DOI <- NULL

#' Check paper access type
#'
#' @description
#' Checks the access type under which a paper is available. It can be one of:
#' "Open Access", "Open Archive", "Free Access", "Closed Access".
#'
#' @param articles `character() | xml_document()`\cr
#'  DOIs of the papers; or the HTML sites containing the papers acquired using
#'  [rvest::read_html()] or [httr2::resp_body_html()].
#'
#' @details
#' # Supported sources
#'
#' * Academic Press
#' * ACS Publications
#' * Analytical Science Journals
#' * BioMed Central
#' * Biophysical Journal
#' * Cambridge Core
#' * Cell Reports
#' * Cell Reports Medicine
#' * eLife
#' * Elsevier
#' * FEBS Press
#' * Frontiers
#' * Hindawi
#' * Journal of Biological Chemistry
#' * Journal of Lipid Research
#' * Journal of Neuroscience
#' * MDPI
#' * Molecular & Cellular Proteomics
#' * Molecular Cell
#' * Nature
#' * OUP Academic
#' * PeerJ
#' * Pergamon
#' * PLOS ONE
#' * PNAS
#' * Portland Press
#' * The Royal Society of Chemistry
#' * Science
#' * SpringerLink
#' * Taylor & Francis
#' * Wiley Online Library
#'
#' @return Paper access type, one of `Open Access`, `Open Archive`,
#' `Free Access`, and `Closed Access`.
#'
#' @examples
#' what_access("10.1093/nar/gkac882")
#'
#' @export
what_access <- function(articles) {
  vapply(articles, what_access_intrnl, FUN.VALUE = character(1), USE.NAMES = FALSE)
}

what_access_intrnl <- function(object) {
  UseMethod("what_access_intrnl")
}

#' @importFrom glue glue
#' @importFrom utils assignInMyNamespace
what_access_intrnl.character <- function(object) {
  assignInMyNamespace(".CURRENT_DOI", object)
  what_access_intrnl(get_html(glue("https://doi.org/{object}")))
}
.S3method("what_access_intrnl", "character", what_access_intrnl.character)

#' @importFrom rvest read_html
what_access_intrnl.xml_document <- function(object) {
  redirects <- is_redirect(object)
  while (redirects) {
    object <- get_html(attr(redirects, "url", exact = TRUE))
    redirects <- is_redirect(object)
  }
  what_access_intrnl(determine_source(object))
}
.S3method("what_access_intrnl", "xml_document", what_access_intrnl.xml_document)

what_access_intrnl.oa_remote_driver <- function(object) {
  if (is_overloaded(object)) {
    do.call(start_remote_driver, .REMOTE_DRIVER_SETTINGS)
    what_access_intrnl(.CURRENT_DOI)
  }
  what_access_intrnl(determine_source(object))
}
.S3method(
  "what_access_intrnl", "oa_remote_driver", what_access_intrnl.oa_remote_driver
)

what_access_intrnl.oa_html_document <- function(object) {
  get_access_type(object)
}
.S3method(
  "what_access_intrnl", "oa_html_document", what_access_intrnl.oa_html_document
)

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
