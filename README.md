# Classprob

`Classprob` is an R package designed to calculate performance metrics for classification models. It provides the `calculate_model_metrics` function, which computes metrics such as AUC, sensitivity, specificity, PPV, NPV, and accuracy. Additionally, it supports calculating 95% confidence intervals for these metrics using the Bootstrap method. By inputting the predicted probabilities and true labels of a model, you can obtain model performance metrics under different cutoff values. The default cutoff is **0.5**, but you can specify any numerical value as your cutoff or use **"kappa"** to select the cutoff value corresponding to the optimal Kappa value. The 95% confidence intervals are calculated using Bootstrap, so the AUC confidence interval may differ from that calculated by `pROC`. This is worth noting.

---

## Installation

You can install `Classprob` from GitHub using the `devtools` package:

```R
# Install devtools if not already installed
install.packages("devtools")

# Install Classprob
devtools::install_github("Smallriver2024/Classprob")
```

---

## Usage

### Function: `calculate_model_metrics`

The `calculate_model_metrics` function is used to calculate performance metrics for classification models. Its input parameters are as follows:

| Parameter          | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| `predicted_probs`  | A numeric vector representing the predicted probabilities of the model (ranging from 0 to 1). |
| `true_labels`      | A numeric vector or factor representing the true labels (must be 0 and 1).  |
| `cutoff`           | The classification threshold, default is `0.5`. If set to `"kappa"`, the optimal threshold based on Kappa is used. |
| `n_bootstrap`      | The number of Bootstrap samples, default is `1000`.                         |

#### Return Value
The function returns a list containing the following:
- **`Metrics`**: Point estimates for AUC, sensitivity, specificity, PPV, NPV, and accuracy.
- **`ConfidenceIntervals`**: 95% confidence intervals for the above metrics.
- **`Cutoff`**: The classification threshold used.

---

### Example

Below is an example of how to use the `calculate_model_metrics` function:

```R
library(Classprob)

# Example data
set.seed(123)
predicted_probs <- runif(100, 0, 1)  # Generate 100 random predicted probabilities
true_labels <- rbinom(100, 1, 0.5)   # Generate 100 random true labels (0 and 1)

# Calculate model performance metrics
results <- calculate_model_metrics(predicted_probs, true_labels, cutoff = "kappa")

# View results
print(results)
```

---

### Input Data Preparation

#### 1. **`predicted_probs`**
- Must be a numeric vector representing the predicted probabilities of the model.
- Each value should be between 0 and 1.
- Example:
  ```R
  predicted_probs <- c(0.2, 0.8, 0.5, 0.9, 0.1)
  ```

#### 2. **`true_labels`**
- Must be a numeric vector or factor representing the true labels.
- Each value must be either 0 or 1, where:
  - `0` represents the negative class.
  - `1` represents the positive class.
- Example:
  ```R
  true_labels <- c(0, 1, 0, 1, 0)
  ```

#### 3. **`cutoff`**
- The default value is `0.5`, representing the classification threshold.
- If set to `"kappa"`, the optimal threshold based on Kappa is used.
- Example:
  ```R
  # Use the default threshold of 0.5
  results_default <- calculate_model_metrics(predicted_probs, true_labels, cutoff = 0.5)

  # Use the Kappa-optimized threshold
  results_kappa <- calculate_model_metrics(predicted_probs, true_labels, cutoff = "kappa")
  ```

#### 4. **`n_bootstrap`**
- The default value is `1000`, representing the number of Bootstrap samples.
- Example:
  ```R
  results <- calculate_model_metrics(predicted_probs, true_labels, n_bootstrap = 2000)
  ```

---

### Output Example

The return value of the `calculate_model_metrics` function is as follows:

```R
$`0.45`
$Metrics
       AUC Sensitivity Specificity        PPV        NPV  Accuracy 
     0.850       0.720       0.880      0.750      0.860      0.820 

$ConfidenceIntervals
$ConfidenceIntervals$AUC
[1] 0.800 0.900

$ConfidenceIntervals$Sensitivity
[1] 0.680 0.760

$ConfidenceIntervals$Specificity
[1] 0.850 0.910

$ConfidenceIntervals$PPV
[1] 0.720 0.780

$ConfidenceIntervals$NPV
[1] 0.840 0.880

$ConfidenceIntervals$Accuracy
[1] 0.800 0.840

$Cutoff
[1] 0.45
```

---

### Notes

1. **Input Data Length**: The lengths of `predicted_probs` and `true_labels` must be the same.
2. **True Labels**: `true_labels` must be numeric values of 0 and 1, where `1` represents the positive outcome. If the labels are factors, convert them using `as.numeric()` and ensure they are 0 and 1, not 1 and 2.
3. **Bootstrap Sampling**: The larger the `n_bootstrap`, the more precise the confidence interval calculation, but the longer the runtime. The default is 1000.

---

## Contact

For questions or suggestions, please contact:  
📧 Email: [573814880@qq.com](mailto:573814880@qq.com)  
🌐 GitHub: [Smallriver2024](https://github.com/Smallriver2024)

---
