context("api_headers")

test_that("api_headers works", {
  skip_on_cran()

  x <- api('https://api.github.com/') %>%
    api_headers(`X-FARGO-SEASON` = 3) %>%
    peep

  y <- api('https://api.github.com/') %>%
    api_headers(`X-FARGO-SEASON` = three, `Accept Token` = yellow) %>%
    peep

  yy <- api('https://api.github.com/') %>%
    api_headers_(`X-FARGO-SEASON` = "three", `Accept Token` = "yellow") %>%
    peep

  expect_is(x, "req")
  expect_is(y, "req")

  expect_is(x$url, "url")
  expect_is(y$url, "url")

  expect_is(x$headers, "list")
  expect_equal(x$headers$`X-FARGO-SEASON`, "3")

  expect_is(y$headers, "list")
  expect_named(y$headers, c("X-FARGO-SEASON", "Accept Token"))

  expect_identical(y, yy)
})

test_that("api_headers fails well", {
  skip_on_cran()

  expect_error(api_headers(), "argument \".data\" is missing")
})
