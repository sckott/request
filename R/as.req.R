# as request functions and print method for request S3 class
as.req <- function(x) {
  UseMethod("as.req")
}

as.req.default <- function(x) {
  stop("no as.req method for ", class(x), call. = FALSE)
}

as.req.req <- function(x) {
  if (!"cache" %in% names(x)) x$cache <- FALSE
  x
}

as.req.endpoint <- function(x){
  x <- req(x$url)
  if (!"cache" %in% names(x)) x$cache <- FALSE
  x
}

as.req.rurl <- function(x){
  x <- req(x[[1]])
  if (!"cache" %in% names(x)) x$cache <- FALSE
  x
}

as.req.character <- function(x){
  if (is_url(tryCatch(as.rurl(x), error = function(e) e))) {
    x <- req(x)
    if (!"cache" %in% names(x)) x$cache <- FALSE
    x
  } else {
    stop("error ...")
  }
}

req <- function(x){
  structure(list(url = as.rurl(x)), class = "req")
}
