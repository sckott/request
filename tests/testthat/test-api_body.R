context("api_body")

test_that("api_body works", {
  skip_on_cran()

  expect_is(api_body(api("http://api.plos.org/search"), a = 5), "req")

  aa <- api("http://httpbin.org/post") %>%
    api_body(a = 5, b = "Adfafasd") %>%
    peep

  bb <- api("http://httpbin.org/post") %>%
    api_body(a = 5, b = "Adfafasd") %>%
    peep

  cc <- api("http://httpbin.org/post") %>%
    api_body_(q = "ecology", wt = "json", fl = 'id', fl = 'journal') %>%
    peep

  expect_is(aa, "req")
  expect_is(bb, "req")
  expect_is(cc, "req")

  expect_is(aa$url, "url")
  expect_is(bb$body, "list")

  expect_is(aa %>% http, "list")
  expect_is(bb %>% http, "list")
  expect_is(cc %>% http, "list")
})

test_that("api_body fails well", {
  skip_on_cran()

  expect_error(api_body(), "argument \".data\" is missing")
})
