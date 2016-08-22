context("authentication")

test_that("authentication - basic auth works", {
  skip_on_cran()

  expect_is(
    api_simple_auth(api("http://api.plos.org/search"), user = "asd", pwd = "asdf"),
    "req"
  )

  aa <- api('https://httpbin.org/basic-auth/user/passwd') %>%
    api_simple_auth(user = "user", pwd = "passwd") %>%
    peep

  bb <- api('https://httpbin.org/basic-auth/user/passwd') %>%
    api_simple_auth(user = "user", pwd = "passwd", type = "gssnegotiate") %>%
    peep

  expect_is(aa, "req")
  expect_is(bb, "req")

  expect_is(aa$url, "rurl")
  expect_is(aa$config, "request")
  expect_is(bb$config, "request")

  aaa <- aa %>% http
  expect_is(aaa, "list")
  expect_named(aaa, c("authenticated", "user"))
})

test_that("authentication - basic auth with differnt auth type", {
  skip_on_travis()
  skip_on_cran()

  bb <- api('https://httpbin.org/basic-auth/user/passwd') %>%
    api_simple_auth(user = "user", pwd = "passwd", type = "gssnegotiate") %>%
    peep
  expect_error(bb %>% http, "Client error: \\(401\\) Unauthorized")
})

test_that("authentication - oauth2 works", {
  skip_on_cran()

  expect_is(
    api_oauth2(api("http://api.plos.org/search"), token = "asfdasfs"),
    "req"
  )

  aa <- api('https://api.github.com/') %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    peep

  expect_is(aa, "req")

  expect_is(aa$url, "rurl")
  expect_is(aa$config, "request")
  expect_is(aa$config, "request")
  expect_named(aa$config$headers, "Authorization")
})

test_that("authentication - oauth2 with differnt auth type", {
  skip_on_travis()
  skip_on_cran()

  aa <- api('https://httpbin.org/basic-auth/user/passwd') %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    peep
  expect_error(aa %>% http, "Client error: \\(401\\) Unauthorized")
})

test_that("authentication fails well", {
  skip_on_cran()

  expect_error(api_simple_auth(), "argument \".data\" is missing")
  expect_error(api_oauth1(), "argument \".data\" is missing")
  expect_error(api_oauth2(), "argument \".data\" is missing")
})
