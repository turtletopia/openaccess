#' @importFrom rvest read_html
get_html <- function(url) {
  tryCatch({
    read_html(url)
  }, error = function(e) {
    if (is.null(.REMOTE_DRIVER)) {
      stop("Use `start_remote_driver()` to configure RSelenium scraper.", call. = FALSE)
    }
    .REMOTE_DRIVER$navigate(url)
    .REMOTE_DRIVER
  })
}
