.REMOTE_DRIVER <- NULL
.REMOTE_DRIVER_SETTINGS <- list()

#' Create browser connection for RSelenium
#'
#' @description
#' Connects to a browser for RSelenium. RSelenium is needed for some cases where
#' rvest package doesn't suffice, usually due to 403 or 503 status codes
#' received. However, RSelenium setup is much more complicated, this is why
#' rvest is preferred unless there is no choice.
#'
#' @param ... `ANY`\cr
#'  Parameters passed to [RSelenium::remoteDriver()].
#'
#' @return Nothing, function called for its side effects.
#'
#' @examples
#' \dontrun{
#' start_remote_driver(port = 4567L, browserName = "firefox")
#' }
#'
#' @importFrom RSelenium remoteDriver
#' @importFrom utils assignInMyNamespace
#' @export
start_remote_driver <- function(...) {
  message("Starting a new remote driver...")
  assignInMyNamespace(".REMOTE_DRIVER", remoteDriver(...))
  assignInMyNamespace(".REMOTE_DRIVER_SETTINGS", list(...))
  # Silence RSelenium output
  sink(nullfile())
  .REMOTE_DRIVER$open()
  on.exit(sink())
}
