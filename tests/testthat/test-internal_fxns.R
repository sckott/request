context("internal fxns")

test_that("pluck", {
  mtcarsl <- apply(mtcars, 1, as.list)
  expect_is(pluck(mtcarsl, "mpg"), "list")
  expect_is(pluck(mtcarsl, "mpg", 1), "numeric")
})

test_that("dr_op", {
  lst <- list(a = 5, b = 6)
  expect_is(dr_op(lst, "a"), "list")
  expect_named(dr_op(lst, "a"), "b")
})

test_that("is_url", {
  expect_true(is_url("http://google.com"))
  expect_false(is_url("google.com"))
  expect_true(is_url("http://localhost"))
  expect_true(is_url("localhost:9000"))
  expect_false(is_url("9000"))
})

test_that("is_port", {
  expect_true(is_port("9000"))
  expect_false(is_port("900"))
  expect_true(is_port(":8000"))
  expect_true(is_port("/9000"))
  expect_false(is_port("/900"))
})

test_that("each_link", {
  str <- '<https://api.github.com/organizations/1200269/events?page=2>; rel="next", <https://api.github.com/organizations/1200269/events?page=10>; rel="last"'
  strs <- strtrim(strsplit(str, ",")[[1]])
  aa <- lapply(strs, each_link)

  expect_is(aa, "list")
  expect_named(aa[[1]], c('name', 'url'))
  expect_is(aa[[1]]$name, "character")
  expect_is(aa[[1]]$url, "character")
  expect_equal(aa[[1]]$name, "next")
  expect_match(aa[[1]]$url, "https")
})
