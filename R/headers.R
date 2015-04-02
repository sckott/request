#' Headers
#'
#' @export
#' @param ... Named \code{key:value} pairs.
h <- function(...) {
  args <- list(...)
  lapply(args, function(y) strsplit(y, ":")[[1]])
}
