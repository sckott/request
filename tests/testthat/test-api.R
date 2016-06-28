context("api")

test_that("api works", {
  skip_on_cran()

  aa <- "https://api.github.com/" %>% api() %>% api_oauth2(token = Sys.getenv("GITHUB_PAT"))
  bb <- api("https://api.github.com/")
  bb_get <- bb %>% api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>% http()
  cc <- api("https://api.github.com/") %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    api_config(verbose()) %>%
    peep()

  expect_is(aa, "list")
  expect_is(bb, "endpoint")
  expect_is(bb_get, "list")

  expect_equal(cc$url[1], "https://api.github.com/")
  expect_is(cc$config, "request")
  expect_is(cc$config$options, "list")
  expect_true(cc$config$options$verbose)
})

test_that("print.endpoint works", {
  bb <- api("https://api.github.com/")

  expect_output(print(bb), "URL: ")
})

test_that("api fails well", {
  skip_on_cran()

  expect_error(api(), "argument \"x\" is missing")
  expect_error(api(NULL), "no applicable method")
  expect_error(5 %>% api())
})
