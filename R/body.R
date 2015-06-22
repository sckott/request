#' Query construction
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param ...	Comma separated list of unquoted variable names
#' @param .dots	Used to work around non-standard evaluation
#' @family dsl
#' @examples
#' ## NSE
#' dd <- api("http://httpbin.org/post")
#' dd %>% api_body(body_value = FALSE)
#' dd %>% api_body(body_value = "NULL")
#' dd %>% api_body(body_value = "")
#'
#' # upload a file
#' file <- "~/httsnap_test.txt"
#' cat("hello, world", file = file)
#' dd %>% api_body(body_value = upload_file("~/httsnap_test.txt"))
#'
#' # A named list
#' dd %>% api_body(x = "A simple text string", y = "stuff")
#'
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
api_body <- function(.data, ..., body_value = NULL){
  api_body_(.data, .dots = lazyeval::lazy_dots(...), body_value = body_value)
}

#' @export
#' @rdname api_body
api_body_ <- function(.data, ..., .dots, body_value){
  .data <- as.req(.data)
  if (is.null(body_value)) {
    dots <- lazyeval::all_dots(.dots, ...)
    args <- sapply(dots, "[[", "expr")
    modifyList(.data, list(body = as.list(args)))
  } else {
    modifyList(.data, list(body = body_value))
  }
}
