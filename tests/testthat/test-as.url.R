context("as.rurl")

test_that("as.rurl works", {
  aa <- as.rurl(5000)
  bb <- as.rurl("5000")
  cc <- as.rurl(':9200')
  dd <- as.rurl('9200')
  ee <- as.rurl('9200/stuff')
  ff <- as.rurl('api.crossreg.org')

  expect_is(aa, "rurl")
  expect_is(bb, "rurl")
  expect_is(cc, "rurl")
  expect_is(dd, "rurl")
  expect_is(ee, "rurl")
  expect_is(ff, "rurl")

  expect_true(grepl("localhost", aa))
  expect_true(grepl("localhost", bb))
  expect_true(grepl("localhost", cc))
  expect_true(grepl("localhost", dd))
  expect_true(grepl("localhost", ee))

  expect_true(grepl("http", ff))

  expect_true(grepl("5000", aa))
  expect_true(grepl("5000", bb))
  expect_true(grepl("9200", cc))
  expect_true(grepl("9200", dd))
  expect_true(grepl("9200", ee))
})

test_that("as.url fails well", {
  expect_error(as.rurl(), "no applicable method")
})
