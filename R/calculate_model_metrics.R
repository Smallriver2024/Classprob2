#' Calculate Classification Model Performance Metrics
#'
#' This function calculates various performance metrics for a classification model,
#' including AUC, sensitivity, specificity, NPV, PPV, and accuracy. It also computes
#' 95% confidence intervals for these metrics using bootstrap methods. The cutoff
#' for classification can be set manually or optimized based on Kappa.
#'
#' @param predicted_probs A numeric vector of predicted probabilities.
#' @param true_labels A factor or numeric vector of true labels (0 and 1).
#' @param cutoff A numeric value or "kappa" (default: 0.5). If "kappa", the optimal
#'               cutoff based on Kappa is used.
#' @param n_bootstrap Number of bootstrap samples (default: 1000).
#' @return A list containing the metrics, their 95% confidence intervals, and the cutoff value(s).
#' @importFrom pROC roc auc coords
#' @importFrom boot boot boot.ci
#' @importFrom caret confusionMatrix
#' @importFrom dplyr %>%
#' @export
calculate_model_metrics <- function(predicted_probs, true_labels, cutoff = 0.5, n_bootstrap = 1000) {
  # Check input
  if (length(predicted_probs) != length(true_labels)) {
    stop("The length of predicted probabilities and true labels must be the same.")
  }
  if (!all(true_labels %in% c(0, 1))) {
    stop("True labels must be 0 or 1.")
  }
  
  # If cutoff is "kappa", calculate the optimal cutoff
  if (cutoff == "kappa") {
    kappa_values <- sapply(seq(0, 1, by = 0.01), function(cut) {
      pred_classes <- ifelse(predicted_probs > cut, 1, 0)
      conf_matrix <- table(Predicted = pred_classes, Actual = true_labels)
      if (all(dim(conf_matrix) == c(2, 2))) {
        kappa <- caret::confusionMatrix(conf_matrix)$overall["Kappa"]
        return(kappa)
      } else {
        return(NA)
      }
    })
    optimal_cutoffs <- seq(0, 1, by = 0.01)[which(kappa_values == max(kappa_values, na.rm = TRUE))]
  } else {
    optimal_cutoffs <- cutoff
  }
  
  # Define a function to calculate metrics
  calculate_metrics <- function(data, indices, cutoff_value) {
    sample_data <- data[indices, ]
    preds <- sample_data$predicted_probs
    labels <- sample_data$true_labels
    
    # Classify based on the cutoff
    pred_classes <- ifelse(preds > cutoff_value, 1, 0)
    confusion_matrix <- table(Predicted = pred_classes, Actual = labels)
    
    # Calculate metrics
    TP <- confusion_matrix["1", "1"]
    TN <- confusion_matrix["0", "0"]
    FP <- confusion_matrix["1", "0"]
    FN <- confusion_matrix["0", "1"]
    
    sensitivity <- TP / (TP + FN)
    specificity <- TN / (TN + FP)
    ppv <- TP / (TP + FP)
    npv <- TN / (TN + FN)
    accuracy <- (TP + TN) / (TP + TN + FP + FN)
    
    return(c(
      AUC = pROC::auc(pROC::roc(labels, preds, quiet = TRUE)),
      Sensitivity = sensitivity,
      Specificity = specificity,
      PPV = ppv,
      NPV = npv,
      Accuracy = accuracy
    ))
  }
  
  # Prepare data for bootstrap
  bootstrap_data <- data.frame(predicted_probs = predicted_probs, true_labels = true_labels)
  
  # Initialize result storage
  results_list <- list()
  
  # Calculate metrics for each cutoff value
  for (cutoff_value in optimal_cutoffs) {
    # Run bootstrap
    bootstrap_results <- boot::boot(data = bootstrap_data, statistic = calculate_metrics, R = n_bootstrap, cutoff_value = cutoff_value)
    
    # Calculate 95% confidence intervals
    ci_auc <- boot::boot.ci(bootstrap_results, type = "bca", index = 1)
    ci_sensitivity <- boot::boot.ci(bootstrap_results, type = "bca", index = 2)
    ci_specificity <- boot::boot.ci(bootstrap_results, type = "bca", index = 3)
    ci_ppv <- boot::boot.ci(bootstrap_results, type = "bca", index = 4)
    ci_npv <- boot::boot.ci(bootstrap_results, type = "bca", index = 5)
    ci_accuracy <- boot::boot.ci(bootstrap_results, type = "bca", index = 6)
    
    # Store results
    results_list[[as.character(cutoff_value)]] <- list(
      Metrics = bootstrap_results$t0,
      ConfidenceIntervals = list(
        AUC = ci_auc$bca[4:5],
        Sensitivity = ci_sensitivity$bca[4:5],
        Specificity = ci_specificity$bca[4:5],
        PPV = ci_ppv$bca[4:5],
        NPV = ci_npv$bca[4:5],
        Accuracy = ci_accuracy$bca[4:5]
      ),
      Cutoff = cutoff_value
    )
  }
  
  return(results_list)
}