#' Min-Max Scaling
#'
#' This function performs min-max scaling on a numeric vector, transforming the values to a range between 0 and 1.
#'
#' @param x A numeric vector.
#' @return A numeric vector with values scaled between 0 and 1.
#' @export
#' @examples
#' x <- c(1, 2, 3, 4, 5)
#' min_max_scale(x)
min_max_scale <- function(x) {
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.")
  }
  if (length(x) == 0) {
    stop("Input vector must have at least one element.")
  }
  if (min(x) == max(x)) {
    warning("All values in the input vector are identical. Returning a vector of 0s.")
    return(rep(0, length(x)))
  }
  (x - min(x)) / (max(x) - min(x))
}