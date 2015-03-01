httsnap
=======



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
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
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
#>   |                                                                         |                                                                 |   0%  |                                                                         |=================================================================| 100%
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
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
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
"http://api.crossref.org/works" %>%
  Get() %>% 
  .$message %>% 
  .$items %>% 
  select(DOI, page)
#>                                 DOI    page
#> 1  10.1111/j.1742-4658.2011.08468.x   no-no
#> 2                10.1007/bf01282823 290-293
#> 3                10.1007/bf01282809 255-257
#> 4                10.1007/bf01282850 378-381
#> 5                10.1007/bf01282844 358-360
#> 6                10.1007/bf01282851 381-386
#> 7                10.1007/bf01282852 386-387
#> 8                10.1007/bf01282853 387-388
#> 9                10.1007/bf01282832 317-320
#> 10               10.1007/bf01282828 303-305
#> 11               10.1007/bf01282829 307-308
#> 12               10.1007/bf01282818 274-279
#> 13               10.1007/bf01282822 287-290
#> 14               10.1007/bf01282806 241-247
#> 15               10.1007/bf01282839 343-344
#> 16               10.1007/bf01282826 297-302
#> 17               10.1007/bf01282825 295-297
#> 18               10.1007/bf01282813 268-269
#> 19               10.1007/bf01282820 282-284
#> 20               10.1007/bf01282843 353-358
```

Use query parameters


```r
"http://api.plos.org/search" %>%
  query(q="*:*", wt="json", fl="id,journal,counter_total_all")
#> $response
#> $response$numFound
#> [1] 1219309
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#>                                                     id counter_total_all
#> 1                         10.1371/journal.pone.0074638               784
#> 2                   10.1371/journal.pone.0074638/title               784
#> 3                10.1371/journal.pone.0074638/abstract               784
#> 4              10.1371/journal.pone.0074638/references               784
#> 5                    10.1371/journal.pone.0074638/body               784
#> 6            10.1371/journal.pone.0074638/introduction               784
#> 7  10.1371/journal.pone.0074638/results_and_discussion               784
#> 8   10.1371/journal.pone.0074638/materials_and_methods               784
#> 9                         10.1371/journal.pone.0074637               631
#> 10                  10.1371/journal.pone.0074637/title               631
#>     journal
#> 1  PLoS ONE
#> 2  PLoS ONE
#> 3  PLoS ONE
#> 4  PLoS ONE
#> 5  PLoS ONE
#> 6  PLoS ONE
#> 7  PLoS ONE
#> 8  PLoS ONE
#> 9  PLoS ONE
#> 10 PLoS ONE
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
#> [1] "multipart/form-data; boundary=------------------------b76173d892c55e3f"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
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
