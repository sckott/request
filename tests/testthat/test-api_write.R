context("api_write")

test_that("api_write works", {
  skip_on_cran()

  expect_is(api_write(api("http://api.plos.org/search"), tempfile()), "req")

  aa <- api("http://httpbin.org/get") %>%
    api_write(tempfile()) %>%
    peep

  bb <- api("http://httpbin.org/get") %>%
    api_write(tempfile(), overwrite = TRUE) %>%
    peep

  expect_is(aa, "req")
  expect_is(bb, "req")

  expect_is(aa$url, "url")
  expect_is(bb$write, "request")

  expect_is(aa %>% http, "character")
  expect_is(bb %>% http, "character")
})

test_that("api_write fails well", {
  skip_on_cran()

  expect_error(api_write(), "argument \".data\" is missing")
})
