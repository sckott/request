#' Paging helpers
#'
#' @export
#' @param .data Result of a call to \code{api}
#' @param limit	Maximum number results desired.
#' @param limit_max Maximum number results allowed in each request.
#' @param offset Record to start at
#' @param by Chunk size, if chunking desired. Default:
#' @family dsl
#' @section Special Functions:
#' \itemize{
#'  \item \code{limit(x)}: \code{x = N}, where x is the name of the API
#'  variable for determing how many results to return,
#'  \item \code{limit_max(x)}: xx
#'  \item \code{offset(x)}: \code{x = N}, where x is the name of the API
#'  variable for determing what record to start at
#'  \item \code{page(x)}: what page to return
#' }
#' @examples
#' url <- 'http://localhost:9200'
#' quer <-
#' api(url) %>%
#'   api_path(shakespeare, `_search`) %>%
#'   api_paging(limit(size = 10))
#'
#' api(url) %>%
#'   api_path(shakespeare, act, `_search`) %>%
#'   api_paging(size = 5)
#'
#' url <- 'https://api.github.com/'
#' quer <- api(url) %>%
#'   api_path(repos, ropensci, rgbif, issues) %>%
#'   api_query(state = open)
#'
#' # per_page & page, w/ known max_limit
#' api('https://api.github.com/') %>%
#'   api_paging(limit = 220, limit_max = 100)
#'
#' ##### Not working yet
#' # per_page & page
#' # quer %>%
#' #   api_paging(per_page = 10, page = 2)
#'
#' # limit & offset
#' # quer %>%
#' #   api_paging(limit = 10, offset = 20)
#'
#' # rows & start
#' # quer %>%
#' #   api_paging(rows = 10, start = 5)
#'
#' # or could it look like this:
#' ## YES, this!
#' api('https://api.github.com/') %>% api_paging(limit(size = 10))
#'
#' #### pattern: page/per_page
#' api('https://api.github.com/') %>%
#'   api_path(orgs, ropensci, events) %>%
#'   api_paging(chunk(per_page = 4), page(page = 2)) %>%
#'   peep
#'
#' #### pattern: limit/offset
#' api('http://api.gbif.org/v1') %>%
#'   api_path(occurrence, search) %>%
#'   api_query(scientificName = Accipiter) %>%
#'   api_paging(limit(limit = 4), offset(offset = 2)) %>%
#'   peep

api_paging <- function(.data, ..., by = NULL) {
  .data <- as.req(.data)
  # stopifnot(is.numeric(limit), is.numeric(limit_max), is.numeric(offset))
  # by <- get_by(by, limit, limit_max)
  # args <- list(limit = limit, size = size, rows = rows, page = page,
  #              per_page = per_page, limit_max = limit_max,
  #              start = start, offset = offset, by = by)

  # modifyList(.data, list(paging = list(size = 0, ...)))
  modifyList(.data, list(paging = list(...)))
}

limit <- function(...) {
  lazyeval::all_dots(lazyeval::lazy_dots(...))
}

offset <- function(...) {
  lazyeval::all_dots(lazyeval::lazy_dots(...))
}

page <- function(...) {
  lazyeval::all_dots(lazyeval::lazy_dots(...))
}

chunk <- function(...) {
  lazyeval::all_dots(lazyeval::lazy_dots(...))
}
  # vals <- unname(Map(function(x, y) {
  #   if (nchar(x) == 0) {
  #     as.character(y$expr)
  #   }
  #   else {
  #     sprintf("%s: %s", x, as.character(y$expr))
  #   }
  # }, names(tmp), tmp))
  # z <- paste0("{", paste0(vals, collapse = ", "), "}")
  # dots <- comb(tryargs(.data), structure(z, type = "select"))
  # structure(list(data = getdata(.data), args = dots), class = "jqr")
#}

get_by <- function(by, limit, limit_max) {
  if (!is.null(by)) {
    stopifnot(is.numeric(by))
    stopifnot(by < limit_max)
    return(by)
  } else {
    if (limit > limit_max) {
      return(limit_max)
    } else {
      return(limit)
    }
  }
}

rename_vars <- function(limit, size, rows) {

}

# ## four headers
# x=HEAD("https://api.github.com/repos/ropensci/taxize/issues?state=open&per_page=5&page=4")
# get_links(x$headers)
# ## two headers
# x=HEAD("https://api.github.com/repos/ropensci/taxize/issues")
# get_links(x$headers)
# ## no headers
# x=HEAD("https://api.github.com/repos/ropensci/pangaear/issues")
# get_links(x$headers)
get_links <- function(w) {
  lk <- w$link
  if (is.null(lk)) {
    NULL
  } else {
    if (is(lk, "character")) {
      links <- strtrim(strsplit(lk, ",")[[1]])
      lapply(links, each_link)
    } else {
      nms <- sapply(w, "[[", "name")
      tmp <- unlist(w[nms %in% "next"])
      grep("http", tmp, value = TRUE)
    }
  }
}
# get_links <- function(w) {
#   lk <- w$link
#   urls <- comp(sapply(w, "[[", "url"))
#   if (is.null(lk) && length(urls) == 0) {
#     NULL
#   } else {
#     if (is(w, "character")) {
#       links <- strtrim(strsplit(lk, ",")[[1]])
#       lapply(links, each_link)
#     } else {
#       nms <- sapply(w, "[[", "name")
#       tmp <- unlist(w[nms %in% "next"])
#       grep("http", tmp, value = TRUE)
#     }
#   }
# }

each_link <- function(z) {
  tmp <- strtrim(strsplit(z, ";")[[1]])
  nm <- gsub("\"|(rel)|=", "", tmp[2])
  url <- gsub("^<|>$", "", tmp[1])
  list(name = nm, url = url)
}
