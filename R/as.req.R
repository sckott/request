as.req <- function(x) {
  UseMethod("as.req")
}

as.req.req <- function(x) {
  x
}

as.req.endpoint <- function(x){
  req(x$url)
#   if (is_url(tryCatch(as.url(x$url), error = function(e) e))) {
#     req(x$url)
#   } else {
#     stop("error ...")
#   }
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

#' @export
print.req <- function(x, ...){
  cat("<http request> ", sep = "\n")
  cat(paste0("  url: ", x$url), sep = "\n")
  cat(paste0("  paths: ", paste(unlist(x$paths), collapse = "/")), sep = "\n")
  cat(paste0("  query: ", paste(names(x$query), unname(unlist(x$query)), sep = "=", collapse = ", ")), sep = "\n")
  cat(paste0("  body: ", paste(unlist(x$body), collapse = "/")), sep = "\n")
  cat(paste0("  error handler: ", names(x$error)), sep = "\n")
  cat("  config: ", sep = "\n")
  if (!is.null(x$config)) print(x$config, sep = "\n")
}
