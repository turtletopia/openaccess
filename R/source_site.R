determine_source <- function(page) {
  publisher <- page %>%
    find_element("head>meta[name=\"dc.publisher\"]") %>%
    element_attr("content")
  url <- switch (
    publisher,
    "BioMed Central" = "https://biomedcentral.com"
  )

  if (is.null(url)) {
    url <- page %>%
      find_element("head>link[rel=canonical]") %>%
      element_attr("href")
  }

  if (is.na(url)) {
    url <- page %>%
      find_element("head>meta[property=\"og:url\"]") %>%
      element_attr("content")
  }

  site <- page %>%
    find_element("head>meta[property=\"og:site_name\"]") %>%
    element_attr("content")

  structure(
    page,
    canonical_url = regmatches(url, regexec("://([^/]+)", url))[[1]][2],
    site_name = if (is.na(site) || site == "") NULL else site,
    class = c("oa_html_document", class(page))
  )
}
