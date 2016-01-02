request
=======



[![Build Status](https://travis-ci.org/sckott/request.svg)](https://travis-ci.org/sckott/request)
[![codecov.io](https://codecov.io/github/sckott/request/coverage.svg?branch=master)](https://codecov.io/github/sckott/request?branch=master)

`request` is DSL for http requests for R, and is inspired by the CLI tool [httpie](https://github.com/jakubroztocil/httpie).

`request` is built on `httr`, though may allow using the R packages `RCurl` or `curl` as optional backends at some point.

## Philosophy

* The web is increasingly a JSON world, so we set `content-type` and `accept` headers to `applications/json` by default
* The workflow follows logically, or at least should, from, _hey, I got this url_, to _i need to add some options_, to _execute request_
* Whenever possible, we transform output to data.frame's - facilitating downstream manipulation via `dplyr`, etc.
* We do `GET` requests by default. Specify a different type if you don't want `GET`
* You can use non-standard evaluation to easily pass in query parameters without worrying about `&`'s, URL escaping, etc. (see `api_query()`)
* Same for body params (see `api_body()`)

All of the defaults just mentioned can be changed.

## Auto execute http requests with pipes

When using pipes, we autodetect that a pipe is being used within the function calls, and automatically do the appropriate http request on the last piped function call. When you call a function without using pipes, you have to use the `http()` function explicitly to make the http request.

## low level http

Low level access is available with `http_client()`, which returns an `R6` class with various methods for inspecting http request results.

## Peek at a request

The function `peep()` let's you peek at a request without performing the http request.

## Install


```r
install.packages("devtools")
devtools::install_github("sckott/request")
```


```r
library("request")
```

## Building API routes

Works with full or partial URLs


```r
api('https://api.github.com/')
#> URL: https://api.github.com/
api('http://api.gbif.org/v1')
#> URL: http://api.gbif.org/v1
api('api.gbif.org/v1')
#> URL: api.gbif.org/v1
```

Works with ports, full or partial


```r
api('http://localhost:9200')
#> URL: http://localhost:9200
api('localhost:9200')
#> URL: http://localhost:9200
api(':9200')
#> URL: http://localhost:9200
api('9200')
#> URL: http://localhost:9200
api('9200/stuff')
#> URL: http://localhost:9200/stuff
```

The above are not passed through a pipe, so simply define a URL, but don't do a request. To make an http request, you can either pipe a url or partial url to e.g., `api()`, or call `http()`:


```r
'https://api.github.com/' %>% api()
#> $current_user_url
#> [1] "https://api.github.com/user"
#> 
#> $current_user_authorizations_html_url
#> [1] "https://github.com/settings/connections/applications{/client_id}"
#> 
#> $authorizations_url
#> [1] "https://api.github.com/authorizations"
#> 
#> $code_search_url
...
```

Or


```r
api('https://api.github.com/') %>% http()
#> $current_user_url
#> [1] "https://api.github.com/user"
#> 
#> $current_user_authorizations_html_url
#> [1] "https://github.com/settings/connections/applications{/client_id}"
#> 
#> $authorizations_url
#> [1] "https://api.github.com/authorizations"
#> 
#> $code_search_url
...
```

Set paths

NSE


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  peep
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

SE


```r
api('https://api.github.com/') %>%
  api_path_('repos', 'ropensci', 'rgbif', 'issues') %>%
  peep
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

Templating


```r
repo_info <- list(username = 'craigcitro', repo = 'r-travis')
api('https://api.github.com/') %>%
  api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info) %>%
  peep
#> <http request> 
#>   url: https://api.github.com/
#>   paths: 
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

## Features coming

These features are not in `request` yet, but are shown here just as examples

### Paging


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  api_paging(limit = 220, limit_max = 100)
```

### Retry


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  api_retry(n = 5) %>%
  peep
```

### Rate limit


```r
api('https://api.github.com/') %>% rate_limit(value = 5, period = "24 hrs") %>% peep
api('https://api.github.com/') %>% rate_limit(value = 5000, period = "24 hrs") %>% peep
api('https://api.github.com/') %>% rate_limit(value = 10, period = "5 min") %>% peep
```

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
