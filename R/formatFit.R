#' Format Logistic Regression Fit
#'
#' This function extracts and formats key statistics from a logistic regression model fit,
#' including coefficients (B), standard errors (SE), Wald statistics, odds ratios (OR),
#' 95% confidence intervals for OR, and p-values.
#'
#' @param fit1 A logistic regression model object (e.g., from `glm`).
#' @return A data frame with columns for B, SE, Wald, OR with 95% CI, and P-value.
#' @export
#' @examples
#' # Example usage
#' data(mtcars)
#' fit <- glm(am ~ wt + hp, data = mtcars, family = binomial)
#' formatFit(fit)
formatFit <- function(fit1) {
  # Extract p-values
  p <- summary(fit1)$coefficients[, 4]
  
  # Calculate Wald statistics
  wald <- summary(fit1)$coefficients[, 3]^2
  
  # Extract coefficients (B values)
  valueB <- coef(fit1)
  
  # Extract standard errors (SE)
  SE <- summary(fit1)$coefficients[, 2]
  
  # Calculate odds ratios (OR)
  valueOR <- exp(coef(fit1))
  
  # Calculate 95% confidence intervals for OR
  confitOR <- exp(confint(fit1))
  
  # Format the results into a data frame
  data.frame(
    B = round(valueB, 3),
    SE = round(SE, 3),
    Wald = round(wald, 3),
    OR_with_CI = paste(
      round(valueOR, 3), "(",
      round(confitOR[, 1], 3), "~", round(confitOR[, 2], 3), ")", sep = ""
    ),
    P = format.pval(p, digits = 3, eps = 0.001)
  )
}