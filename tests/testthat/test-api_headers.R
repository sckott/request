context("api_headers")

test_that("api_headers works", {
  skip_on_cran()

  x <- api('https://api.github.com/') %>%
    api_headers(`X-FARGO-SEASON` = 3) %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    peep

  y <- api('https://api.github.com/') %>%
    api_headers(`X-FARGO-SEASON` = three, `Accept Token` = yellow) %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    peep

  yy <- api('https://api.github.com/') %>%
    api_headers_(`X-FARGO-SEASON` = "three", `Accept Token` = "yellow") %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    peep

  expect_is(x, "req")
  expect_is(y, "req")

  expect_is(x$url, "url")
  expect_is(y$url, "url")

  expect_is(x$config, "request")
  expect_named(x$config$headers, c("X-FARGO-SEASON", "Authorization"))

  expect_is(y$config, "request")
  expect_named(y$config$headers, c("X-FARGO-SEASON", "Accept Token", "Authorization"))

  expect_identical(y, yy)
})

test_that("api_headers fails well", {
  skip_on_cran()

  expect_error(api_headers(), "argument \".data\" is missing")
})
