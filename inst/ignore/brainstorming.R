# api_path('repos', 'ropensci', 'rgbif', 'issues')
api_path <- function(...) {
  list(...)
}

# api_endpoint('https://api.github.com/')
api_endpoint <- function(x) {
  structure(list(url = x), class = "endpoint")
}

print.endpoint <- function(x, ...) {
  cat(sprintf("URL: %s", x$url))
}

# repo_info <- list(username = 'craigcitro', repo = 'r-travis')
# 'https://api.github.com/' %>% api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info)
api_template <- function(.data, template, data) {
  .data <- as.request(.data)
  temp <- whisker::whisker.render(template, data)
  .data <- modifyList(.data, list(template = temp))
  .data
}

# api_oauth2(token = "<token>")
api_oauth2 <- function(.data, token = NULL, app_name = NULL, key = NULL,
                       secret = NULL, request = NULL, authorize = NULL,
                       access = NULL, base_url = NULL, ...) {
  .data <- as.request(.data)

  args <- comp(list(token = token, app_name = app_name, key = key, secret = secret))
  if (length(args) == 0) {
    stop("either token or app_name + key + secret must be provided", call. = FALSE)
  } else {
    if (!is.null(token)) {
      auth <- config(token = token)
    } else {
      app <- oauth_app(app_name, key, secret)
      endpts <- oauth_endpoint(request = request, authorize = authorize,
                               access = access, base_url = base_url)
      token <- oauth2.0_token(endpts, app)
      auth <- config(token = token)
    }
  }

  .data <- modifyList(.data, list(config = c(auth)))
  .data
}

# api_error_handler(func = stop_for_status)
api_error_handler <- function(func) {
  list(func = func)
}
