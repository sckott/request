as.request <- function(x) {
  UseMethod("as.request")
}

as.request.request <- function(x) {
  x
}

# as.request.list <- function(x){
#
# }

as.request.character <- function(x){
  if (is_url(tryCatch(as.url(x), error = function(e) e))) {
    request(x)
  } else {
    stop("error ...")
  }
}
