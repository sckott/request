#' Curl settings
#'
#' @export
#' @family dsl
#' @param .data Result of a call to \code{api}
#' @param ...	Comma separated list of unquoted variable names
#' @examples
#' # Config handler
#' api('https://api.github.com/') %>%
#'  api_config(verbose())
#'
#' \dontrun{
#' # Full examples
#' api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, issues) %>%
#'   api_config(verbose()) %>%
#'   Get()
#' }
api_config <- function(.data, ...) {
  pipe_autoexec(toggle = TRUE)
  .data <- as.req(.data)
  tmp <- list(...)
  tmp <- if (length(tmp) == 1) tmp[[1]] else tmp
  modifyList(.data, list(config = tmp))
}
