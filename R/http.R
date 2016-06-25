#' Make a HTTP request
#'
#' @export
#'
#' @param req A \code{req} class object
#' @param method (character) Pick which HTTP method to use. Only GET and
#' POST for now. Default: GET
#'
#' @details By default, a GET request is made. Will fix this soon to easily allow
#' a different HTTP verb.
#'
#' The \code{http} function makes the request and gives back the parsed result.
#' Whereas, the \code{http_client} function makes the request, but gives back
#' the raw R6 class object, which you can inspect all parts of, modify, etc.
#' @examples \dontrun{
#' # high level - http()
#' api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, commits) %>%
#'   http()
#'
#' # low level - http_client()
#' res <- api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, commits) %>%
#'   http_client()
#' res$count()
#' res$body()
#' res$status()
#' res$result
#' res$links
#' res$parse()
#'
#' # Specify HTTP verb
#' api("http://httpbin.org/post") %>%
#'    api_body(x = "A simple text string") %>%
#'    http("POST")
#' }
http <- function(req, method = "GET") {
  pipe_autoexec(toggle = FALSE)
  if (!method %in% c("GET", "POST")) stop("method must be one of GET or POST", call. = FALSE)
  if ('body' %in% names(req)) method <- "POST"
  #rr <- RequestIterator$new(paging = req$paging)
  rr <- RequestIterator$new()
  switch(method,
         GET = rr$GET(req),
         POST = rr$POST(req)
  )
  rr$parse()
}

http2 <- function(req, method = "GET") {
  pipe_autoexec(toggle = FALSE)
  if (!method %in% c("GET", "POST")) stop("method must be one of GET or POST", call. = FALSE)
  rr <- RequestIterator$new(paging = req$paging)
  switch(
    method,
    GET = {
      if (!is.null(req$paging)) {
        if (all(get_names(req$paging) %in% c('page', 'per_page'))) {
          # pattern: page/per_page
          rr$GET(req)
        } else {
          # pattern: limit
          tot <- 0
          while (tot <= get_req_size(req$paging)) {
            rr$GET(req)
            tot <- rr$count()
          }
        }
      }
    },
    POST = rr$POST(req)
  )
  rr$parse()
}

#' @export
#' @rdname http
http_client <- function(req) {
  pipe_autoexec(toggle = FALSE)
  rr <- RequestIterator$new(paging = req$paging)
  rr$GET(req)
  return(rr)
}

get_req_size <- function(x) {
  xx <- sapply(x, function(z) {
    as.list(setNames(z[[1]]$expr, names(z)))
  })
  xx[names(xx) %in% c('size', 'limit', 'max')][[1]]
}
