request
=======


[![cran checks](https://cranchecks.info/badges/worst/request)](https://cranchecks.info/pkgs/request)
[![Build Status](https://travis-ci.org/sckott/request.svg)](https://travis-ci.org/sckott/request)
[![codecov.io](https://codecov.io/github/sckott/request/coverage.svg?branch=master)](https://codecov.io/github/sckott/request?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/request?color=F3B1FF)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/request)](https://cran.r-project.org/package=request)

`request` is DSL for http requests for R, and is inspired by the CLI tool [httpie](https://github.com/jakubroztocil/httpie).

`request` is built on `httr`, though may allow using the R packages `RCurl` or `curl` as optional backends at some point.

I gave a poster at User2016, its in my [talks repo](https://github.com/sckott/talks/blob/gh-pages/user2016/request.pdf)

## Philosophy

* The web is increasingly a JSON world, so we assume `applications/json` by default, but give back other types if not
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

From CRAN


```r
install.packages("request")
```

Development version from GitHub


```r
devtools::install_github("sckott/request")
```


```r
library("request")
```

## NSE and SE

NSE is supported


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues)
```

as well as SE


```r
api('https://api.github.com/') %>%
  api_path_('repos', 'ropensci', 'rgbif', 'issues')
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

## Make HTTP requests

The above examples with `api()` are not passed through a pipe, so only define a URL, but don't do an HTTP request. To make an HTTP request, you can either pipe a url or partial url to e.g., `api()`, or call `http()` at the end of a string of function calls:


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

`http()` is called at the end of a chain of piped commands, so no need to invoke it. However, you can if you like.

## Templating


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

## Set paths

`api_path()` adds paths to the base URL (see `api_query()`) for query parameters


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

## Query


```r
api("http://api.plos.org/search") %>%
  api_query(q = ecology, wt = json, fl = 'id,journal') %>%
  peep
#> <http request>
#>   url: http://api.plos.org/search
#>   paths:
#>   query: q=ecology, wt=json, fl=id,journal
#>   body:
#>   paging:
#>   headers:
#>   rate limit:
#>   retry (n/delay (s)): /
#>   error handler:
#>   config:
```

## ToDo

See [the issues](https://github.com/sckott/request/issues) for discussion of these

* Paging
* Retry
* Rate limit

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
