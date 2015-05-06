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

request <- function(.data){
  x <- as.url(.data)
  structure(list(url = .data), class = "request")
}

#' @export
print.request <- function(x, ...){
  cat("<http request> ", sep = "\n")
  cat(paste0("  url: ", x$url), sep = "\n")
  cat("  config: ", sep = "\n")
  print(x$config, sep = "\n")
}
