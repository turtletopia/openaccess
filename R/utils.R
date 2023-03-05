#' @importFrom rvest read_html
get_html <- function(url) {
  tryCatch({
    read_html(url)
  }, error = function(e) {
    if (is.null(.REMOTE_DRIVER)) {
      stop("Use `start_remote_driver()` to configure RSelenium scraper.", call. = FALSE)
    }
    .REMOTE_DRIVER$navigate(url)
    structure(list(), class = "oa_remote_driver")
  })
}

is_found <- function(optional) {
  optional[["is_found"]]
}

open_closed <- function(is_open) {
  if (is_open) "Open Access" else "Closed Access"
}

standardize_access <- function(access_type) {
  if (grepl("(?i)open.?access", access_type)) {
    "Open Access"
  } else if (grepl("(?i)open.?archive", access_type)) {
    "Open Archive"
  } else if (grepl("(?i)free.?access", access_type)) {
    "Free Access"
  } else if (grepl("(?i)closed.?access", access_type)) {
    "Closed Access"
  }
}
