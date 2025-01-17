library(testthat)
library(Classprob)  # Replace with your package name

test_that("calculate_model_metrics works correctly", {
  # Example data
  set.seed(123)
  predicted_probs <- runif(100, 0, 1)
  true_labels <- rbinom(100, 1, 0.5)
  
  # Test default cutoff
  results_default <- calculate_model_metrics(predicted_probs, true_labels)
  
  # Check the structure of results_default
  expect_type(results_default, "list")
  expect_true(is.list(results_default[[1]]))  # Check if the first element is a list
  expect_true("Metrics" %in% names(results_default[[1]]))  # Check if "Metrics" is in the nested list
  expect_true("ConfidenceIntervals" %in% names(results_default[[1]]))  # Check if "ConfidenceIntervals" is in the nested list
  
  # Test Kappa-optimized cutoff
  results_kappa <- calculate_model_metrics(predicted_probs, true_labels, cutoff = "kappa")
  expect_type(results_kappa, "list")
  expect_true(is.list(results_kappa[[1]]))  # Check if the first element is a list
  expect_true("Cutoff" %in% names(results_kappa[[1]]))  # Check if "Cutoff" is in the nested list
})