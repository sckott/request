#' GET iterator
#'
#' @import R6
GetIter <- R6::R6Class("GetIter",
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
      .data <- as.req(.data)
      .data$config <- c(httr::user_agent(make_ua()), .data$config)
      .data$url <- gather_paths(.data)
      res <- suppressWarnings(httr::GET(.data$url[1], .data$config, query = .data$query, ...))

      if (is.null(.data$error)) {
        httr::stop_for_status(res)
      } else {
        .data$error[[1]](res)
      }
      self$links <- get_links(res$headers)
      self$result <- empty(list(self$result, res))
    },
    parse = function(x, parse = TRUE) {
      if (grepl("json", x$headers$`content-type`)) {
        txt <- httr::content(x, "text")
        jsonlite::fromJSON(txt, parse, flatten = TRUE)
      } else {
        content(x)
      }
    }
  )
)

# dd <- api('https://api.github.com/') %>%
#   api_path(repos, ropensci, rgbif, commits) %>%
#   api_paging(limit = 220, limit_max = 100)
# # dd <- api('https://api.github.com/') %>%
# #   api_path(repos, ropensci, rplos, commits) %>%
# #   api_paging(limit = 220, limit_max = 100)
# rr <- GetIter$new(limit = dd$paging$limit, limit_max = dd$paging$limit_max)
# rr$GET(dd)
# rr$result
# rr$links
# rr$parse(rr$result)
