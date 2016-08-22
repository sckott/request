context("api_path")

test_that("api_path works", {
  skip_on_cran()

  expect_is(api_path(api('https://api.github.com'), repos, ropensci, rgbif, issues), "req")

  aa <- api('https://api.github.com') %>%
    api_path(repos, ropensci, rgbif, issues) %>%
    api_oauth2(token = Sys.getenv("GITHUB_PAT")) %>%
    peep

  bb <- api("http://httpbin.org") %>%
    api_path(get) %>%
    peep

  cc <- api("http://api.crossref.org") %>%
    api_path(works, '10.1101/045526') %>%
    peep

  expect_is(aa, "req")
  expect_is(bb, "req")
  expect_is(cc, "req")

  expect_is(aa$url, "rurl")
  expect_is(bb$paths, "character")
  expect_equal(length(bb$paths), 1)
  expect_equal(length(cc$paths), 2)
  expect_is(cc$paths, "character")

  expect_is(aa %>% http, "tbl_df")
  expect_is(bb %>% http, "list")
  expect_is(cc %>% http, "list")

  # NSE and SE give same result
  ## FIXME - not sure why but this keeps failing on travis, but not locally
  # expect_identical(aa %>% http,
  #   api("https://api.github.com") %>%
  #     api_path_('repos', 'ropensci', 'rgbif', 'issues')
  # )
})

test_that("api_path fails well", {
  skip_on_cran()

  expect_error(api_path(), "argument \".data\" is missing")
})
