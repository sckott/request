#' API base url and endpoint setup
#'
#' @export
#' @param x A URL
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
  structure(list(url = as.rurl(x)), class = "endpoint")
}

#' @export
print.endpoint <- function(x, ...) {
  cat(sprintf("URL: %s", x$url))
}
