#' Attempt to convert list to a data.frame
#'
#' @export
#' @param x input, a list
#' @param clean (logical) clean 0 length elements. Default: \code{TRUE}
#' @examples
#' mtlist <- apply(mtcars, 1, as.list)
#' as_df(mtlist)
#'
#' mtlist <- apply(mtcars, 1, as.list)
#' mtlist[[1]]$mpg <- list()
#' as_df(mtlist)
as_df <- function(x, clean = TRUE) {
  if (!requireNamespace("data.table")) {
    stop("please install data.table", call. = FALSE)
  }

  if (clean) {
    # top level
    len1 <- vapply(x, length, 1)
    x[len1 == 0] <- NULL

    # lower levels
    x <- lapply(x, function(z) {
      len2 <- vapply(z, length, 1)
      z[len2 == 0] <- NULL
      z
    })
  }

  (xxx <- data.table::setDF(data.table::rbindlist(x, fill = TRUE, use.names = TRUE)))
}
