#' API path template
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param template Template to contstruct API route
#' @param data Data to pass to the template parameter
#' @family dsl
#' @examples \dontrun{
#' repo_info <- list(username = 'craigcitro', repo = 'r-travis')
#' api('https://api.github.com/') %>%
#'   api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info)
#' }
api_template <- function(.data, template, data) {
  pipe_autoexec(toggle = TRUE)
  .data <- as.req(.data)
  temp <- whisker::whisker.render(template, data)
  modifyList(.data, list(template = temp))
}
