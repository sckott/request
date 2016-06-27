context("api_error_handler")

test_that("api_error_handler works", {
  skip_on_cran()

  expect_error(
    api('http://httpbin.org/status/503') %>% api_error_handler(stop_for_status),
    "Service Unavailable"
  )

  expect_error(
    api('http://httpbin.org/status/404') %>% api_error_handler(stop_for_status),
    "Not Found"
  )

  expect_error(
    api("http://httpbin.org/status/501") %>% api_error_handler(stop_for_status),
    "Not Implemented"
  )

  expect_error(api_error_handler(), "argument \".data\" is missing")
})
