#' Get a url, with sensible defaults
#'
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

Get <- function(.data, ...)
{
  .data <- as.request(.data)
  hu <- httr:::handle_url(NULL, .data$url, query=.data$query)
  res <- httr:::make_request("get", hu$handle, hu$url, .data$config)
  stop_for_status(res)
  if(grepl("json", res$headers$`content-type`)){
    jsonlite::fromJSON(content(res, "text"))
  } else {
    content(res)
  }
}

Put <- function(.data, ...)
{
  .data <- as.request(.data)
  res <- PUT(.data$url, body = .data$body, ...)
  stop_for_status(res)
  if(grepl("json", res$headers$`content-type`)){
    jsonlite::fromJSON(content(res, "text"))
  } else {
    content(res)
  }
}

request <- function(.data){
  x <- as.url(.data)
  structure(list(url=.data), class="request")
}

#' @export
print.request <- function(x, ...){
  cat("<http request> ", sep = "\n")
  cat(paste0("  url: ", x$url), sep = "\n")
  cat("  config: ", sep = "\n")
  print(x$config, sep = "\n")
}

as.request <- function(x) UseMethod("as.request")
as.request.request <- function(x) x
# as.request.list <- function(x){
#
# }
as.request.character <- function(x){
  if( is_url(tryCatch(as.url(x), error=function(e) e)) ) request(x)  else stop("error ...")
}
