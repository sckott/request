httsnap
=======



[![Build Status](https://travis-ci.org/sckott/httsnap.svg)](https://travis-ci.org/sckott/httsnap)

`httsnap` is an attempt to replicate the awesomeness of [httpie](https://github.com/jakubroztocil/httpie)

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

![](http://media.giphy.com/media/QpebwL6Jr6snu/giphy.gif)

## Install


```r
install.packages("devtools")
devtools::install_github("sckott/httsnap")
```

And load `dplyr` for parsing data.frame's


```r
library("dplyr")
library("httsnap")
```

## Even simpler verbs

Playing around with this idea. `httr` is already easy, but `Get()`:

* Allows use of an intuitive chaining workflow
* Parses data for you using `httr` built in format guesser, which should work in most cases

A simple GET request


```r
"http://httpbin.org/get" %>%
  Get()
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1 httsnap/0.0.1.99"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
```

You can buid up options by calling functions


```r
"http://httpbin.org/get" %>%
  Progress() %>%
  Verbose()
#> <http request> 
#>   url: http://httpbin.org/get
#>   config: 
#> Config: 
#> List of 4
#>  $ noprogress      :FALSE
#>  $ progressfunction:function (...)  
#>  $ debugfunction   :function (...)  
#>  $ verbose         :TRUE
```

Then eventually execute the GET request


```r
"http://httpbin.org/get" %>%
  Progress() %>%
  Verbose() %>%
  Get()
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1 httsnap/0.0.1.99"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
```

## The new setup

Default 


```r
tmp <- "http://api.crossref.org/works" %>%
  Get() %>% 
  .$message %>% 
  .$items
sapply(tmp, "[[", "DOI")
#>  [1] "10.1111/j.1742-4658.2011.08468.x" "10.1007/bf01282823"              
#>  [3] "10.1007/bf01282809"               "10.1007/bf01282850"              
#>  [5] "10.1007/bf01282844"               "10.1007/bf01282851"              
#>  [7] "10.1007/bf01282852"               "10.1007/bf01282853"              
#>  [9] "10.1007/bf01282832"               "10.1007/bf01282828"              
#> [11] "10.1007/bf01282829"               "10.1007/bf01282818"              
#> [13] "10.1007/bf01282822"               "10.1007/bf01282806"              
#> [15] "10.1007/bf01282839"               "10.1007/bf01282826"              
#> [17] "10.1007/bf01282825"               "10.1007/bf01282813"              
#> [19] "10.1007/bf01282820"               "10.1007/bf01282843"
```

Use query parameters


```r
"http://api.plos.org/search" %>%
  query(q="*:*", wt="json", fl="id,journal,counter_total_all")
#> $response
#> $response$numFound
#> [1] 1274217
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#>                                                                    id
#> 1             10.1371/annotation/98908e14-e9fd-458f-9cea-ba4bec139f20
#> 2             10.1371/annotation/98d7baf8-0e73-42d0-adbc-2eeb6a3c1b3c
#> 3       10.1371/annotation/98d7baf8-0e73-42d0-adbc-2eeb6a3c1b3c/title
#> 4    10.1371/annotation/98d7baf8-0e73-42d0-adbc-2eeb6a3c1b3c/abstract
#> 5  10.1371/annotation/98d7baf8-0e73-42d0-adbc-2eeb6a3c1b3c/references
#> 6        10.1371/annotation/98d7baf8-0e73-42d0-adbc-2eeb6a3c1b3c/body
#> 7       10.1371/annotation/834e21b0-6acb-40ae-8735-f7ad120c989a/title
#> 8    10.1371/annotation/834e21b0-6acb-40ae-8735-f7ad120c989a/abstract
#> 9  10.1371/annotation/834e21b0-6acb-40ae-8735-f7ad120c989a/references
#> 10       10.1371/annotation/834e21b0-6acb-40ae-8735-f7ad120c989a/body
#>    counter_total_all  journal
#> 1                  0 PLoS ONE
#> 2                  0 PLoS ONE
#> 3                  0 PLoS ONE
#> 4                  0 PLoS ONE
#> 5                  0 PLoS ONE
#> 6                  0 PLoS ONE
#> 7                  0 PLoS ONE
#> 8                  0 PLoS ONE
#> 9                  0 PLoS ONE
#> 10                 0 PLoS ONE
```

Use body parameters


```r
"http://httpbin.org/put" %>%
  body(x = "hello world!")
#> $args
#> named list()
#> 
#> $data
#> [1] ""
#> 
#> $files
#> named list()
#> 
#> $form
#> $form$x
#> [1] "hello world!"
#> 
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$`Content-Length`
#> [1] "148"
#> 
#> $headers$`Content-Type`
#> [1] "multipart/form-data; boundary=------------------------83534311b2d1a3ff"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1"
#> 
#> 
#> $json
#> NULL
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/put"
```
