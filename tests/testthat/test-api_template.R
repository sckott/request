context("api_template")

test_that("api_template works", {
  skip_on_cran()

  expect_is(api_template(api('https://api.github.com'), "", ""), "req")

  repo_info <- list(username = 'craigcitro', repo = 'r-travis')

  aa <- api('https://api.github.com') %>%
    api_template(template = 'repos/{{username}}/{{repo}}/issues', data = repo_info) %>%
    peep

  bb <- api("http://api.gbif.org/v1") %>%
    api_template("occurrence/{{id}}/verbatim", list(id = 1056251124)) %>%
    peep

  expect_is(aa, "req")
  expect_is(bb, "req")

  expect_is(aa$url, "url")
  expect_is(aa$template, "character")
  expect_match(aa$template, "craigcitro")
  expect_equal(length(aa$template), 1)
  expect_is(aa %>% http, "tbl_df")

  expect_is(bb$template, "character")
  expect_equal(length(bb$template), 1)
  expect_is(bb$template, "character")
})

test_that("api_template fails well", {
  skip_on_cran()

  expect_error(api_template(),
               "argument \".data\" is missing")
  expect_error(api_template(api('https://api.github.com')),
               "argument \"template\" is missing, with no default")
})
