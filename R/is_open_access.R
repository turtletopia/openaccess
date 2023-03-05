#' Check a paper for open access
#'
#' @description
#' Checks whether the full text of the paper is available without restrictions.
#' Throws error if no interpreter available for the journal.
#'
#' @inheritParams what_access
#'
#' @inheritSection what_access Supported sources
#'
#' @return `TRUE` or `FALSE` depending on check result.
#'
#' @examples
#' is_open_access("10.1093/nar/gkac882")
#'
#' @export
is_open_access <- function(articles) {
  what_access(articles) == "Open Access"
}
