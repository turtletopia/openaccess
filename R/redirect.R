#' @importFrom stringr str_match
#' @importFrom rvest html_attr html_element
#' @importFrom utils URLdecode
is_redirect <- function(page) {
  url_to_follow <- page %>%
    html_element("head>meta[http-equiv=REFRESH]") %>%
    html_attr("content") %>%
    str_match("url='[^']*\\?.*Redirect=([^&']*).*'") %>%
    `[[`(1, 2)

  structure(
    !is.na(url_to_follow),
    url = URLdecode(url_to_follow)
  )
}
