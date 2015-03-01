pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

as.url <- function(x) UseMethod("as.url")
as.url.url <- function(x) x
as.url.character <- function(x){
  if( is_url(x) )
    x <- add_http(x)
  else if( is_port(x) )
    x <- paste0("http://localhost:", x)
  else
    stop("url or port not detected", call. = FALSE)
  structure(x, class="url")
}
as.url.numeric <- function(x) as.url(as.character(x))

is_url <- function(x){
  grepl("https?://", x, ignore.case = TRUE) || grepl("localhost:[0-9]{4}", x, ignore.case = TRUE)
}

is_port <- function(x) grepl("[[:digit:]]", x) && nchar(x) == 4

add_http <- function(x){
  if( !grepl("http://", x, ignore.case = TRUE) ) paste0("http://", x) else x
}
