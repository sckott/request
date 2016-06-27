#' API base url and endpoint setup
#'
#' @export
#' @param x A URL
#' @param .data Result of a call to \code{api}
#' @param ...	Comma separated list of unquoted variable names
#' @param .dots	Used to work around non-standard evaluation
#' @param template Template to contstruct API route
#' @param data Data to pass to the template parameter
#' @family dsl
#' @examples \dontrun{
#' # Set base url
#' ## works with full or partial URLs
#' api('https://api.github.com/')
#' api('http://api.gbif.org/v1')
#' api('api.gbif.org/v1')
#'
#' ## works with ports, full or partial
#' api('http://localhost:9200')
#' api('localhost:9200')
#' api(':9200')
#' api('9200')
#' api('9200/stuff')
#'
#' # set paths
#' ## NSE
#' api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, issues)
#' ## SE
#' api('https://api.github.com/') %>%
#'   api_path_('repos', 'ropensci', 'rgbif', 'issues')
#'
#' # template
#' repo_info <- list(username = 'craigcitro', repo = 'r-travis')
#' api('https://api.github.com/') %>%
#'   api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info)
#' }
api <- function(x) {
  pipe_autoexec(toggle = TRUE)
  structure(list(url = as.url(x)), class = "endpoint")
}

#' @export
print.endpoint <- function(x, ...) {
  cat(sprintf("URL: %s", x$url))
}
