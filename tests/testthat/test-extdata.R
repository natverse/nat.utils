context("test-extdata.R")

test_that("can make a neuronlist from parts", {
  delayedAssign('wurgle', make_nl_from_parts('sample.rds', package='nat.utils'))
  expect_is(wurgle, 'neuronlist')
})
