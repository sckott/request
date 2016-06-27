context("as_df")

test_that("as_df works", {
  mtlist <- apply(iris, 1, as.list)
  aa <- as_df(mtlist)

  expect_is(aa, "data.frame")
  expect_named(iris, c('Sepal.Length','Sepal.Width','Petal.Length','Petal.Width','Species'))
  expect_named(aa, c('Sepal.Length','Sepal.Width','Petal.Length','Petal.Width','Species'))

  ## FIXME - should be identical
  # expect_identical(aa, iris)
})
