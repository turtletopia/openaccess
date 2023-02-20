find_element <- function(page, selector) {
  UseMethod("find_element")
}

find_element.oa_remote_driver <- function(page, selector) {
  suppressMessages({
    tryCatch({
      value <- .REMOTE_DRIVER$findElement(using = "css selector", value = selector)
      structure(list(element = value, is_found = TRUE), class = "oa_optional")
    }, error = function(e) {
      structure(list(element = NULL, is_found = FALSE), class = "oa_optional")
    })
  })
}

#' @importFrom rvest html_element
find_element.xml_document <- function(page, selector) {
  value <- html_element(page, css = selector)
  if (is.na(value)) {
    value <- NULL
  }
  structure(
    list(element = value, is_found = !is.null(value)),
    class = "oa_optional"
  )
}

element_attr <- function(element, attribute, ...) {
  UseMethod("element_attr")
}

element_attr.oa_optional <- function(element, attribute, ...) {
  if (!is_found(element)) {
    return(NA_character_)
  }
  element_attr(element[["element"]], attribute, ...)
}

element_attr.webElement <- function(element, attribute, ...) {
  element$getElementAttribute(attribute)[[1]]
}

#' @importFrom rvest html_attr
element_attr.xml_node <- function(element, attribute, ...) {
  html_attr(element, attribute)
}

element_text <- function(element, ...) {
  UseMethod("element_text")
}

element_text.oa_optional <- function(element, ...) {
  if (!is_found(element)) {
    return(NA_character_)
  }
  element_text(element[["element"]], ...)
}

element_text.webElement <- function(element, ...) {
  element$getElementText()
}

#' @importFrom rvest html_text
element_text.xml_node <- function(element, ...) {
  html_text(element)
}
