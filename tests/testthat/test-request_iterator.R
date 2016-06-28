context("RequestIterator")

test_that("RequestIterator - pre initialization", {
  aa <- RequestIterator
  bb <- RequestIterator$new()

  expect_is(aa, "R6ClassGenerator")
})

test_that("RequestIterator - post initialization", {
  skip_on_cran()

  bb <- RequestIterator$new()

  expect_is(bb, "RequestIterator")
  expect_is(bb, "R6")
  expect_equal(bb$status(), list())
  expect_equal(bb$result, list())
  expect_equal(bb$links, list())
  expect_equal(bb$parse(), list())
  expect_equal(bb$limit_max, NA)
  expect_equal(bb$limit, NA)
  expect_is(bb$handle_errors, "function")
  expect_is(bb$GET, "function")
  expect_error(bb$GET(), "argument \".data\" is missing")
  expect_is(bb$count, "function")
  expect_error(bb$count(), "invalid")
  expect_is(bb$body, "function")
  expect_equal(bb$body(), list())
})

test_that("RequestIterator - post initialization w/ data", {
  skip_on_cran()

  bb <- RequestIterator$new()
  cc <- bb$GET(api("http://httpbin.org/get"))

  expect_is(cc, "response")
  expect_equal(bb$status(), 200)
  expect_equal(bb$result, cc)
  expect_null(bb$links)
  expect_is(bb$parse(), "list")
  expect_equal(bb$limit_max, NA)
  expect_equal(bb$limit, NA)
  expect_is(bb$handle_errors, "function")
  expect_is(bb$GET, "function")
  expect_error(bb$GET(), "argument \".data\" is missing")
  expect_is(bb$count, "function")
  expect_equal(bb$count(), 1)
  expect_is(bb$body, "function")
  expect_is(bb$body(), "response")
})

# test_that("RequestIterator fails well", {
#   skip_on_cran()
#
#   expect_error(http(), "argument \"req\" is missing")
#   expect_error(http(api("https://api.github.com"), method = "FART"),
#                "method must be one of GET or POST")
# })
