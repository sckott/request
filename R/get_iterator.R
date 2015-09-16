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
#'
#' # with paging
#' api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, commits) %>%
#'   api_paging(limit = 220, limit_max = 100) %>%
#'   http()
#'
#' # Specify HTTP verb - not working yet.
#' # api("http://httpbin.org/post") %>%
#' #   api_body(x = "A simple text string") %>%
#' #   http("POST")
#' }
http <- function(req, method = "GET") {
  if (!method %in% c("GET", "POST")) stop("method must be one of GET or POST", call. = FALSE)
  rr <- RequestIterator$new(limit = req$paging$limit, limit_max = req$paging$limit_max)
  switch(method,
    GET = rr$GET(req),
    POST = rr$POST(req)
  )
  rr$parse()
}

#' @export
#' @rdname http
http_client <- function(req) {
  rr <- RequestIterator$new(limit = req$paging$limit, limit_max = req$paging$limit_max)
  rr$GET(req)
  return(rr)
}

RequestIterator <- R6::R6Class("RequestIterator",
  public = list(
  result = list(),
  limit = NA,
  limit_max = NA,
  links = list(),
  initialize = function(result, limit, limit_max, links) {
    if (!missing(result)) self$result <- result
    if (!missing(limit)) self$limit <- limit
    if (!missing(limit_max)) self$limit_max <- limit_max
    if (!missing(links)) self$links <- links
  },
  GET = function(.data, ...) {
    if (length(self$links) == 0) {
      .data <- as.req(.data)
      .data$config <- c(httr::user_agent(make_ua()), .data$config)
      .data$url <- gather_paths(.data)
      res <- suppressWarnings(httr::GET(.data$url[1], .data$config, query = .data$query, ...))
    } else {
      .data <- as.req(self$links[[1]]$url)
      res <- suppressWarnings(httr::GET(.data$url[1], .data$config, ...))
    }
    # error catching
    self$handle_errors(.data, res)
    # cache links
    self$links <- get_links(res$headers)
    # give back result
    self$result <- empty(list(self$result, res))
  },
  POST = function(.data, ...) {
    if (length(self$links) == 0) {
      .data <- as.req(.data)
      .data$config <- c(httr::user_agent(make_ua()), .data$config)
      .data$url <- gather_paths(.data)
      res <- suppressWarnings(httr::POST(.data$url[1], .data$config, body = .data$body, ...))
    } else {
      .data <- as.req(self$links[[1]]$url)
      res <- suppressWarnings(httr::POST(.data$url[1], .data$config, ...))
    }
    # error catching
    self$handle_errors(.data, res)
    # cache links
    self$links <- get_links(res$headers)
    # give back result
    self$result <- empty(list(self$result, res))
  },
  body = function() {
    self$result
  },
  status = function() {
    if (is(self$result, "response")) {
      self$result$status_code
    } else {
      lapply(self$result, function(z) {
        if (is(z, "response")) {
          z$status_code
        } else {
          NULL
        }
      })
    }
  },
  parse = function(parse = TRUE) {
    x <- self$result
    if (is(x, "response")) {
      httr_parse(x)
    } else {
      lapply(x, httr_parse)
    }
  },
  count = function() {
    if (is(self$result, "response")) {
      length(httr::content(self$result))
    } else {
      sum(sapply(self$result, function(x) length(httr::content(x))))
    }
  },
  handle_errors = function(.data, x) {
    if (is.null(.data$error)) {
      httr::stop_for_status(x)
    } else {
      .data$error[[1]](x)
    }
  }
))

httr_parse <- function(x) {
  if (grepl("json", x$headers$`content-type`)) {
    txt <- httr::content(x, "text")
    jsonlite::fromJSON(txt, parse, flatten = TRUE)
  } else {
    content(x)
  }
}

# dd <- api('https://api.github.com/') %>%
#   api_path(repos, ropensci, rgbif, commits) %>%
#   api_paging(limit = 220, limit_max = 100)
# # dd <- api('https://api.github.com/') %>%
# #   api_path(repos, ropensci, rplos, commits) %>%
# #   api_paging(limit = 220, limit_max = 100)
# rr <- GetIter$new(limit = dd$paging$limit, limit_max = dd$paging$limit_max)
# rr$GET(dd)
# rr$count()
# rr$result
# rr$links
# rr$parse()
