as.url <- function(x) {
  UseMethod("as.url")
}

as.url.url <- function(x) {
  x
}

as.url.character <- function(x) {
  if (is_url(x)) {
    x <- add_http(x)
  } else if ( is_port(x) ) {
    x <- paste0("http://localhost:", x)
  } else {
    stop("url or port not detected", call. = FALSE)
  }
  structure(x, class = "url")
}

as.url.numeric <- function(x) {
  as.url(as.character(x))
}
