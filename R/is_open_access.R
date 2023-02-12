#' @export
is_open_access <- function(article) {
  UseMethod("is_open_access")
}

#' @rdname is_open_access
#' @export
is_open_access.character <- function(article) {
  is_open_access(get_page_content(article))
}

#' @rdname is_open_access
#' @importFrom rvest read_html
#' @export
is_open_access.xml_document <- function(article) {
  redirects <- is_redirect(article)
  while (redirects) {
    article <- read_html(attr(redirects, "url", exact = TRUE))
    redirects <- is_redirect(article)
  }
  is_open_access(determine_source(article))
}

#' @rdname is_open_access
#' @export
is_open_access.oa_html_document <- function(article) {
  check_open_access(article)
}

#' @importFrom glue glue
#' @importFrom rvest read_html
get_page_content <- function(doi) {
  read_html(glue("https://doi.org/{doi}"))
}

#' @importFrom rvest html_attr html_element
determine_source <- function(page) {
  source <- page %>%
    html_element("head>meta[property=\"og:site_name\"]") %>%
    html_attr("content")
  structure(
    page,
    source_site = source,
    class = c("oa_html_document", class(page))
  )
}
