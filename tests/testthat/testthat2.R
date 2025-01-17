library(testthat)
library(Classprob)

test_that("min_max_scale works correctly", {
  # Test basic functionality
  x <- c(1, 2, 3, 4, 5)
  scaled_x <- min_max_scale(x)
  expect_equal(scaled_x, c(0, 0.25, 0.5, 0.75, 1))
  
  # Test with identical values
  x <- c(3, 3, 3)
  expect_warning(min_max_scale(x))
  expect_equal(min_max_scale(x), c(0, 0, 0))
  
  # Test with non-numeric input
  x <- c("a", "b", "c")
  expect_error(min_max_scale(x), "Input must be a numeric vector.")
  
  # Test with empty vector
  x <- numeric(0)
  expect_error(min_max_scale(x), "Input vector must have at least one element.")
})