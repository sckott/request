#' Get a url, with sensible defaults
#'
#' @import httr
#' @export
#' @param .data A request object
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @details Attempts to simplify the http request process by using sensible defaults:
#' \itemize{
#'  \item GET by default: you most likely want to use \code{\link[httr]{GET}}
#'  \item You most likely want a data.frame back, so we attempt to coerce to a data.frame
#' }
#' @examples \dontrun{
#' "https://api.github.com/" %>%
#'    Get()
#'
#' "https://api.github.com/" %>%
#'    Progress() %>%
#'    Verbose() %>%
#'    Get()
#'
#' "https://api.github.com/" %>%
#'    Timeout(3) %>%
#'    Get()
#'
#' "http://api.crossref.org/works/" %>%
#'    User_agent("howdydoodie") %>%
#'    Get()
#'
#' "http://api.plos.org/search?q=*:*&wt=json" %>%
#'    Get() %>%
#'    .$response %>%
#'    .$docs
#' }

Get <- function(.data, ...) {
  .data <- as.request(.data)
  .data$config <- c(user_agent(make_ua()), verbose())
  hu <- httr:::handle_url(NULL, .data$url, query = .data$query)
  res <- httr:::make_request(method = "get", handle = hu$handle, url = hu$url, config = .data$config)
  stop_for_status(res)
  if (grepl("json", res$headers$`content-type`)) {
    txt <- content(res, "text")
    jsonlite::fromJSON(txt, .data$parse)
  } else {
    content(res)
  }
}

make_ua <- function() {
  versions <- c(curl = RCurl::curlVersion()$version,
                Rcurl = as.character(packageVersion("RCurl")),
                httr = as.character(packageVersion("httr")),
                httsnap = as.character(packageVersion("httsnap")))
  paste0(names(versions), "/", versions, collapse = " ")
}

Put <- function(.data, ...) {
  .data <- as.request(.data)
  res <- PUT(.data$url, body = .data$body, ...)
  stop_for_status(res)
  if (grepl("json", res$headers$`content-type`)) {
    jsonlite::fromJSON(content(res, "text"))
  } else {
    content(res)
  }
}
