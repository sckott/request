context("config fxns")

test_that("all config fxns work as expected", {
  skip_on_cran()

  aa <- api("localhost:9000/get") %>%
    api_headers(a = 5) %>%
    api_simple_auth(user = "adf", pwd = "af") %>%
    api_config(verbose()) %>%
    api_write(tempfile()) %>%
    peep

  expect_is(aa, "req")
  expect_is(aa$url, "rurl")
  expect_is(aa$config, "request")
  expect_named(aa$config$headers, "a")
  expect_equal(aa$config$options$userpwd, "adf:af")
  expect_true(aa$config$options$verbose)
  expect_is(aa$config$output$path, "character")

  # bb <- api("localhost:9000/get") %>%
  #   api_config(verbose()) %>%
  #   api_simple_auth(user = "adf", pwd = "af") %>%
  #   api_headers(a = 5) %>%
  #   api_write(tempfile()) %>%
  #   peep
})

test_that("config fxn combinations fail well", {
  skip_on_cran()

  expect_error(api_query(), "argument \".data\" is missing")
})
