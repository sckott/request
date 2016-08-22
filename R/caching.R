#' Caching helper
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param dir (character) Directory to cache in. Uses
#' \code{rappdirs::user_cache_dir()} by default
#' @param ... ignored
#' @examples \dontrun{
#' # cache
#' ## first call is slower
#' api('http://localhost:5000') %>%
#'   api_path(get) %>%
#'   api_query(foo = "bar") %>%
#'   api_cache()
#'
#' ## second call is faster, pulling from cache
#' api('http://localhost:5000') %>%
#'   api_path(get) %>%
#'   api_query(foo = "bar") %>%
#'   api_cache()
#'
#' # other egs
#' x <- api('api.crossref.org') %>%
#'   api_path(works) %>%
#'   api_query(rows = 1000) %>%
#'   api_cache()
#' }
api_cache <- function(.data, dir = NULL, ...) {
  pipe_autoexec(toggle = TRUE)
  .data <- as.req(.data)
  .data <- modifyList(
    .data,
    list(
      cache = TRUE,
      cache_path = dir %||% cache_path()
    )
  )
  return(.data)
}

cache_path <- function() rappdirs::user_cache_dir("request-cache")

cache_make <- function(x) {
  if (!file.exists(x)) {
    dir.create(x, recursive = TRUE, showWarnings = FALSE)
  }
}

# caculate hash based on
# - url
# - path
# - query parameters
cache_sha <- function(x) {
  # x <- as.req(x)
  # x$config <- c(httr::user_agent(make_ua()), x$config, x$headers)
  # x$url <- gather_paths(x)
  # x$query <- if (is.null(x$query)) NULL else as.list(x$query)
  # x$cache <- NULL
  # x$cache_path <- NULL
  url <- httr::parse_url(x$url)
  url$path <- gather_path(x)
  url$query <- if (is.null(x$query)) NULL else as.list(x$query)
  url <- httr::build_url(url)
  file.path(cache_path(), paste0(digest(url), ".rds"))
}

cache_response <- function(x, file) {
  saveRDS(x, file = file)
}

gather_path <- function(x) {
  if (!is.null(x$paths) && !is.null(x$template)) {
    stop("Cannot pass use both api_template and api_path", call. = FALSE)
  }
  if (!is.null(x$paths)) {
    paste(unlist(x$paths), collapse = "/")
  } else if (!is.null(x$template)) {
    x$template
  }
}
