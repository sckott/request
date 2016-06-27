#' API paths
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param ...	Comma separated list of unquoted variable names
#' @param .dots	Used to work around non-standard evaluation
#' @family dsl
#' @examples \dontrun{
#' # set paths
#' ## NSE
#' api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, issues)
#' ## SE
#' api('https://api.github.com/') %>%
#'   api_path_('repos', 'ropensci', 'rgbif', 'issues')
#' }
api_path <- function(.data, ..., .dots) {
  api_path_(.data, .dots = lazyeval::lazy_dots(...))
}

#' @export
#' @rdname api_path
api_path_ <- function(.data, ..., .dots) {
  pipe_autoexec(toggle = TRUE)
  tmp <- lazyeval::all_dots(.dots, ...)
  .data <- as.req(.data)
  modifyList(.data, list(paths = getpaths(tmp)))
}

getpaths <- function(x) {
  unname(sapply(x, function(z) as.character(z$expr)))
}
