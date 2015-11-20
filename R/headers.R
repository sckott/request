#' Headers
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param ...	Key value pairs of headers
#' @param .dots	Used to work around non-standard evaluation
#' @examples \dontrun{
#' api('https://api.github.com/') %>%
#'    api_headers(`X-FARGO-SEASON` = 3)
#'
#' api('https://api.github.com/') %>%
#'    api_headers(`X-FARGO-SEASON` = 3, `Accept Token` = 5)
#' }
api_headers <- function(.data, ..., .dots) {
  api_headers_(.data, .dots = lazyeval::lazy_dots(...))
}

#' @export
#' @rdname api_headers
api_headers_ <- function(.data, ..., .dots) {
  tmp <- lazyeval::all_dots(.dots, ...)
  .data <- as.req(.data)
  modifyList(.data, list(headers = getheads(tmp)))
}

getheads <- function(x) {
  as.list(sapply(x, function(z) as.character(z$expr)))
}
