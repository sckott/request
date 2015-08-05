context("Get")

test_that("Get works", {
  skip_on_cran()

  aa <- "https://api.github.com/" %>% Get()
  bb <- "https://api.github.com/" %>% Progress() %>% Verbose()
  bb_get <- bb %>% Get()
  cc <- "https://api.github.com/" %>% Timeout(3)
  cc_get <- cc %>% Get()
  dd <- "http://api.crossref.org/works/10.3897/zookeys.515.9459" %>% User_agent("howdydoodie")
  dd_get <- dd %>% Get()

  expect_is(aa, "list")
  expect_is(bb, "req")
  expect_is(bb_get, "list")
  expect_is(cc, "req")
  expect_is(cc_get, "list")
  expect_is(dd, "req")
  expect_is(dd_get, "list")

  expect_equal(bb$url[1], "https://api.github.com/")
  expect_is(bb$config, "request")
  expect_is(bb$config$options, "list")
  expect_true(bb$config$options$verbose)
  expect_false(bb$config$options$noprogress)

  expect_equal(cc$url[1], "https://api.github.com/")
  expect_is(cc$config, "request")
  expect_named(cc$config$options, "timeout_ms")
  expect_is(cc$config$options, "list")
  expect_equal(cc$config$options$timeout_ms, 3000)

  expect_equal(dd$url[1], "http://api.crossref.org/works/10.3897/zookeys.515.9459")
  expect_is(dd$config, "request")
  expect_named(dd$config$options, "useragent")
  expect_is(dd$config$options, "list")
  expect_equal(dd$config$options$useragent, "howdydoodie")
})

test_that("Get fails well", {
  skip_on_cran()

  expect_error(Get(), "argument \".data\" is missing")
  expect_error(Get("http://google.com", config = timeout(0.001)), "Timeout")
})
