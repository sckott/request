context("print.req")

test_that("print.req - character input", {
  expect_output(print(as.req("9200")), "<http request>")
  expect_output(print(as.req("9200")), "url: ")
  expect_output(print(as.req("9200")), "paths: ")
  expect_output(print(as.req("9200")), "query: ")
  expect_output(print(as.req("9200")), "body: ")
  expect_output(print(as.req("9200")), "paging: ")
  expect_output(print(as.req("9200")), "headers: ")
  expect_output(print(as.req("9200")), "rate limit: ")
  expect_output(print(as.req("9200")), "error handler: ")
  expect_output(print(as.req("9200")), "config: ")
})

test_that("print.req fails well", {
  expect_error(capture_output(print.req()), "argument \"x\" is missing")
})
