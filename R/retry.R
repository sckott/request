#' Retry
#'
#' FIXME: still need to implement doing this in the request
#'
#' @export
#'
#' @param .data Result of a call to \code{api}
#' @param times (integer) Number of times to retry the request
#'
#' @details This doesn't use the retry option within curl itself,
#' as it's not available via the \code{curl} R client. Instead, we
#' retry X times you specify, if the previous call failed.
#'
#' @examples \dontrun{
#' api('https://api.github.com/') %>%
#'  api_path(repos, ropensci, rgbif, issues) %>%
#'  retry(times = 5)
#' }
retry <- function(.data, times) {
  .data <- as.req(.data)
  modifyList(.data, list(retry_times = times))
}
