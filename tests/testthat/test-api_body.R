context("api_body")

test_that("api_body works", {
  skip_on_cran()

  expect_is(api_body(api("http://api.plos.org/search"), a = 5), "req")

  aa <- api("https://httpbin.org/post") %>%
    api_body(a = 5, b = "Adfafasd") %>%
    peep

  bb <- api("https://httpbin.org/post") %>%
    api_body(a = 5, b = "Adfafasd") %>%
    peep

  cc <- api("https://httpbin.org/post") %>%
    api_body_(q = "ecology", wt = "json", fl = 'id', fl = 'journal') %>%
    peep

  expect_is(aa, "req")
  expect_is(bb, "req")
  expect_is(cc, "req")

  expect_is(aa$url, "rurl")
  expect_is(bb$body, "list")

  expect_is(aa %>% http("POST"), "list")
  expect_is(bb %>% http("POST"), "list")
  expect_is(cc %>% http("POST"), "list")
})

test_that("api_body fails well", {
  skip_on_cran()

  expect_error(api_body(), "argument \".data\" is missing")
})
