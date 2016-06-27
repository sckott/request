context("as.req")

test_that("as.req - character input", {
  expect_is(as.req("9200"), "req")
  expect_is(as.req("9200")$url, "url")
  expect_is(as.req("9200")$url[[1]], "character")
  expect_match(as.req("9200")$url[[1]], "http")

  expect_is(as.req("http://api.gbif.org"), "req")
  expect_is(as.req("http://api.gbif.org")$url, "url")
  expect_is(as.req("http://api.gbif.org")$url[[1]], "character")
})

test_that("as.req - endpoint input", {
  expect_is(as.req(api("api.gbif.org")), "req")
  expect_is(as.req(api("9200")), "req")
})

test_that("as.req - req (aka: self) input", {
  expect_is(as.req(as.req("api.gbif.org")), "req")
  expect_is(as.req(as.req("9200")), "req")
})

test_that("as.req - url input", {
  expect_is(as.url("9200"), "url")
  expect_is(as.req(as.url("9200")), "req")
  expect_is(as.req(as.url("9200"))$url, "url")
})

test_that("as.req fails well", {
  skip_on_cran()

  expect_error(as.req(), "argument \"x\" is missing")
  expect_error(as.req(4), "no as.req method for numeric")
  expect_error(as.req(mtcars), "no as.req method for data.frame")
  expect_error(as.req(matrix(1:4)), "no as.req method for matrix")
})
