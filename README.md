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
* You can use non-standard evaluation to easily pass in query parameters without worrying about `&`'s, URL escaping, etc. (see `query()`)
* Same for body params (see `body()`)

All of the default just mentioned can be changed.

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
  api_path(repos, ropensci, rgbif, commits) %>%
  http()
#> [[1]]
#> [[1]]$sha
#> [1] "6b9e09397d7682a500576796cf14c96e3c8b3570"
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

Set paths

NSE


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues)
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
  api_path_('repos', 'ropensci', 'rgbif', 'issues')
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
  api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info)
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

## Paging

This may not work in all scenarios, still a work in progress.

Here, set `limit` (no. records you want) with a known `limit_max` so we know how to do paging for you. Most well documented APIs tell you what the max limit is per request, so that info should be easy to get.


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  api_query(state = open) %>%
  api_paging(limit = 220, limit_max = 100)
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: state=open
#>   body: 
#>   paging: limit=220, limit_max=100, offset=0, by=100
#>   headers: 
#>   rate limit: 
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

## Retry

`curl` has a option `--retry` that lets you retry a request X times. This isn't available in `httr`, but I'm working on a helper.


```r
api('https://api.github.com/') %>%
  api_path(repos, ropensci, rgbif, issues) %>%
  api_retry(n = 5)
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 
#>   retry (n/delay (s)): 5/1
#>   error handler: 
#>   config:
```

Note that this doesn't work in the http request yet.

## Rate limit

Some APIs have rate limiting. That is, they may limit you to X number of requests per some time period, e.g., 1 hr or 24 hrs. Some APIs have multile rate limits for different time periods, e.g., 100 request per hr __and__ 5000 requests per 24 hrs.

In addition, you may want to set a rate limit below that the API defines, and we hope to support that use case too. 

The `rate_limit()` function helps you deal with these rate limits. 


```r
qr <- api('https://api.github.com/') %>%
 api_path(repos, ropensci, rgbif, issues)

qr %>% rate_limit(value = 5, period = "24 hrs")
```

```
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 5 @ 24 hrs - on_limit: Rate limit reached
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

```r
qr %>% rate_limit(value = 5000, period = "24 hrs")
```

```
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 5000 @ 24 hrs - on_limit: Rate limit reached
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

```r
qr %>% rate_limit(value = 10, period = "5 min")
```

```
#> <http request> 
#>   url: https://api.github.com/
#>   paths: repos/ropensci/rgbif/issues
#>   query: 
#>   body: 
#>   paging: 
#>   headers: 
#>   rate limit: 10 @ 5 min - on_limit: Rate limit reached
#>   retry (n/delay (s)): /
#>   error handler: 
#>   config:
```

Note that this doesn't work in the http request yet.

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
