#' Query construction
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param ...	Comma separated list of unquoted variable names
#' @param .dots	Used to work around non-standard evaluation
#' @family dsl
#' @examples
#' ## NSE
#' api("http://api.plos.org/search") %>%
#'   api_query(q = ecology, wt = json, fl = 'id,journal')
#' ### Or
#' api("http://api.plos.org/search") %>%
#'   api_query(q = ecology, wt = json, fl = id, fl = journal)
#' ## SE
#' api("http://api.plos.org/search") %>%
#'   api_query_(q = "ecology", wt = "json", fl = 'id', fl = 'journal')
#'
#' \dontrun{
#' ## NSE
#' api("http://api.plos.org/search") %>%
#'   api_query(q = ecology, wt = json, fl = 'id,journal') %>%
#'   Get()
#' ## SE
#' api("http://api.plos.org/search") %>%
#'   api_query_(q = "ecology", wt = "json", fl = 'id', fl = 'journal') %>%
#'   Get()
#' }
api_query <- function(.data, ...){
  api_query_(.data, .dots = lazyeval::lazy_dots(...))
}

#' @export
#' @rdname api_query
api_query_ <- function(.data, ..., .dots){
  dots <- lazyeval::all_dots(.dots, ...)
  args <- sapply(dots, "[[", "expr")
  .data <- as.req(.data)
  modifyList(.data, list(query = args))
}
