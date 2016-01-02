#' Peek at a query
#'
#' @export
#' @param .data (list) input, using higher level interface
#' @examples
#' api('https://api.github.com/') %>% peep
#' api('https://api.github.com/') %>%
#'   api_path(repos, ropensci, rgbif, issues) %>%
#'   peep
#'
#' repo_info <- list(username = 'craigcitro', repo = 'r-travis')
#' api('https://api.github.com/') %>%
#'   api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info) %>%
#'   peep
#'
#' api("http://api.plos.org/search") %>%
#'   api_query(q = ecology, wt = json, fl = id, fl = journal) %>%
#'   peep
#'
#' api("http://api.plos.org/search") %>%
#'   api_query(q = ecology, wt = json, fl = id, fl = journal) %>%
#'   api_paging(limit = 220, limit_max = 100) %>%
#'   peep
peep <- function(.data) {
  pipe_autoexec(toggle = FALSE)
  structure(.data, class = "http_peep")
}

#' @export
print.http_peep <- function(x, ...) {
  cat("<http query>", sep = "\n")
  for (i in seq_along(x)) {
    cat(sprintf("  %s: %s", names(x[i]), paste0(combm(x[[i]]), collapse = " ")), sep = "\n")
  }
}

combm <- function(z) {
  if (is(z, "list")) {
    if (!is.null(names(z))) {
      paste(names(z), z, sep = ":")
    } else {
      pastec(z)
    }
  } else {
    pastec(z)
  }
}

pastec <- function(x) paste0(x, collapse = " ")
