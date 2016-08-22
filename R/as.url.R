as.rurl <- function(x) {
  UseMethod("as.rurl")
}

as.rurl.rurl <- function(x) x

as.rurl.character <- function(x) {
  if (is_url(x)) {
    x <- add_scheme(x)
  } else if ( is_port(x) ) {
    x <- paste0("http://localhost:", sub("^:", "", x))
  } else {
    x
  }
  if (!has_scheme(x)) {
    x <- add_scheme(x)
  }
  structure(x, class = "rurl")
}

as.rurl.numeric <- function(x) {
  as.rurl(as.character(x))
}
