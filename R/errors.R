#' Error handler
#'
#' @export
#' @family dsl
#' @param .data Result of a call to \code{api}
#' @param fun A function, either defined in the session, or a function available in loaded
#' or name-spaced packges
#' @examples
#' # Use functions from httr
#' api('https://api.github.com/') %>%
#'  api_error_handler(stop_for_status)
#'
#' api('https://api.github.com/') %>%
#'  api_error_handler(warn_for_status)
#'
#' # Custom error handling functions
#' my_stop <- function(x) {
#'   if (x$status > 200) {
#'      warning("nope, try again", call. = FALSE)
#'   }
#' }
#' api("http://httpbin.org/status/404") %>%
#'  api_error_handler(my_stop)
#'
#' # not working yet
#' # Error handler
#' # api("http://httpbin.org/status/404") %>%
#' #  api_error_handler(stop_for_status) %>%
#' #  Get()
#'
#' # Custom error handling function
#' # api("http://httpbin.org/status/404") %>%
#' #   api_error_handler(my_stop) %>%
#' #   Get()
api_error_handler <- function(.data, fun) {
  pipe_autoexec(toggle = TRUE)
  .data <- as.req(.data)
  fn_name <- deparse(substitute(fun))
  tmp <- setNames(list(fun), fn_name)
  modifyList(.data, list(error = tmp))
}
