# as request functions and print method for request S3 class
as.req <- function(x) {
  UseMethod("as.req")
}

as.req.default <- function(x) {
  stop("no as.req method for ", class(x), call. = FALSE)
}

as.req.req <- function(x) {
  x
}

as.req.endpoint <- function(x){
  req(x$url)
}

as.req.url <- function(x){
  req(x[[1]])
}

as.req.character <- function(x){
  if (is_url(tryCatch(as.url(x), error = function(e) e))) {
    req(x)
  } else {
    stop("error ...")
  }
}

req <- function(x){
  structure(list(url = as.url(x)), class = "req")
}
