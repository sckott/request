httsnap
=======



[![Build Status](https://travis-ci.org/sckott/httsnap.svg)](https://travis-ci.org/sckott/httsnap)
[![codecov.io](https://codecov.io/github/sckott/httsnap/coverage.svg?branch=master)](https://codecov.io/github/sckott/httsnap?branch=master)

`httsnap` is DSL for http requests for R, and is inspired by the CLI tool  [httpie](https://github.com/jakubroztocil/httpie). 

`httsnap` is built on `httr`, though may allow using the R packages `RCurl` or `curl` as optional backends at some point.

## Philosophy

* The web is increasingly a JSON world, so we set `content-type` and `accept` headers to `applications/json` by default
* The workflow follows logically, or at least should, from, _hey, I got this url_, to _i need to add some options_, to _execute request_
* Whenever possible, we transform output to data.frame's - facilitating downstream manipulation via `dplyr`, etc.
* We do `GET` requests by default. Specify a different type if you don't want `GET`
* You can use non-standard evaluation to easily pass in query parameters without worrying about `&`'s, URL escaping, etc. (see `api_query()`)
* Same for body params (see `api_body()`)

All of the default just mentioned can be changed.

## Auto execute http requests with pipes

When using pipes, we autodetect that a pipe is being used within the function calls, and automatically do the appropriate http request on the last piped function call. When you call a function without using pipes, you have to use the `http()` function explicitly to make the http request.

## Peek at a request

The function `peep()` let's you peek at a request without performing the http request.

## Philosophy in gif

> the new way

![thenewway](http://media.giphy.com/media/QpebwL6Jr6snu/giphy.gif)

## Install


```r
install.packages("devtools")
devtools::install_github("sckott/httsnap")
```


```r
library("httsnap")
```

## Get request


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, commits)
#> [[1]]
#> [[1]]$sha
#> [1] "a71ec4080b5832600fb7704f84369260ea8bf663"
#> 
#> [[1]]$commit
#> [[1]]$commit$author
#> [[1]]$commit$author$name
#> [1] "Scott Chamberlain"
#> 
#> [[1]]$commit$author$email
...
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
#> <http query>
#>   url: https://api.github.com/
#>   paths: repos ropensci rgbif issues
```

SE


```r
api('https://api.github.com/') %>%
  api_path_('repos', 'ropensci', 'rgbif', 'issues') %>% 
  peep
#> <http query>
#>   url: https://api.github.com/
#>   paths: repos ropensci rgbif issues
```

Templating


```r
repo_info <- list(username = 'craigcitro', repo = 'r-travis')
api('https://api.github.com/') %>%
  api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info) %>% 
  peep
#> <http query>
#>   url: https://api.github.com/
#>   template: repos/craigcitro/r-travis/issues
```

## Paging

This may not work in all scenarios, still a work in progress.

Here, set `limit` (no. records you want) with a known `limit_max` so we know how to do paging for you. Most well documented APIs tell you what the max limit is per request, so that info should be easy to get.


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  api_query(state = open) %>%
  api_paging(limit = 220, limit_max = 100) %>% 
  peep
#> <http query>
#>   url: https://api.github.com/
#>   paths: repos ropensci rgbif issues
#>   query: state:open
#>   paging: limit:220 limit_max:100 offset:0 by:100
```

## Retry

`curl` has a option `--retry` that lets you retry a request X times. This isn't available in `httr`, but I'm working on a helper.


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  api_retry(n = 5) %>% 
  peep
#> <http query>
#>   url: https://api.github.com/
#>   paths: repos ropensci rgbif issues
#>   retry: n:5 time:1
```

Note that this doesn't work in the http request yet.

## Rate limit

Some APIs have rate limiting. That is, they may limit you to X number of requests per some time period, e.g., 1 hr or 24 hrs. Some APIs have multile rate limits for different time periods, e.g., 100 request per hr __and__ 5000 requests per 24 hrs.

In addition, you may want to set a rate limit below that the API defines, and we hope to support that use case too. 

The `rate_limit()` function helps you deal with these rate limits. 


```r
api('https://api.github.com/') %>% rate_limit(value = 5, period = "24 hrs") %>% peep
```

```
#> <http query>
#>   url: https://api.github.com/
#>   rate_limit: value:5 period:24 hrs on_limit:list(x = "Rate limit reached", fxn = function (x) 
#> stop(x, call. = FALSE))
```

```r
api('https://api.github.com/') %>% rate_limit(value = 5000, period = "24 hrs") %>% peep
```

```
#> <http query>
#>   url: https://api.github.com/
#>   rate_limit: value:5000 period:24 hrs on_limit:list(x = "Rate limit reached", fxn = function (x) 
#> stop(x, call. = FALSE))
```

```r
api('https://api.github.com/') %>% rate_limit(value = 10, period = "5 min") %>% peep
```

```
#> <http query>
#>   url: https://api.github.com/
#>   rate_limit: value:10 period:5 min on_limit:list(x = "Rate limit reached", fxn = function (x) 
#> stop(x, call. = FALSE))
```

Note that this doesn't work in the http request yet.

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
