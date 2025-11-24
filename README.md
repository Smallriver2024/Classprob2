# Classprob2

---

`Classprob2` is an R package for calculating classification model performance metrics and formatting logistic regression results. 说人话就是脚本太长了，把要实现的function封到一个R包里面方便我自己使用。主要用于二分类预测问题模型的相关计算，补充了一些已有的大佬的包里面缺少的函数

---

## Installation

You can install `Classprob` from GitHub using the `devtools` package:

```R
install.packages("devtools")  # Install devtools if not already installed
devtools::install_github("Smallriver2024/Classprob2")
```

---

## Key Features

### 1. **`calculate_model_metrics`**
Calculates classification model performance metrics, including AUC, sensitivity, specificity, PPV, NPV, and accuracy, with 95% confidence intervals using the Bootstrap method. `Classprob` is an R package designed to calculate performance metrics for classification models. It provides the `calculate_model_metrics` function, which computes metrics such as AUC, sensitivity, specificity, PPV, NPV, and accuracy. Additionally, it supports calculating 95% confidence intervals for these metrics using the Bootstrap method. By inputting the predicted probabilities and true labels of a model, you can obtain model performance metrics under different cutoff values. The default cutoff is **0.5**, but you can specify any numerical value as your cutoff or use **"youden"** to select the cutoff value corresponding to the optimal Kappa value. The 95% confidence intervals are calculated using Bootstrap, so the AUC confidence interval may differ from that calculated by `pROC`. This is worth noting.
#### Example
```R
library(Classprob)

# Example data
set.seed(123)
predicted_probs <- runif(100, 0, 1)
true_labels <- rbinom(100, 1, 0.5)

# Calculate model performance metrics
results <- calculate_model_metrics(predicted_probs, true_labels, cutoff = "kappa")
print(results)
```

---

### 2. **`min_max_scale`**
Performs min-max scaling on a numeric vector, transforming values to a range between 0 and 1.

#### Example
```R
x <- c(1, 2, 3, 4, 5)
scaled_x <- min_max_scale(x)
print(scaled_x)
```

---

### 3. **`formatFit`**
Formats logistic regression model results, extracting coefficients (B), standard errors (SE), Wald statistics, odds ratios (OR) with 95% confidence intervals, and p-values.

#### Example
```R
data(mtcars)
fit <- glm(am ~ wt + hp, data = mtcars, family = binomial)
formatted_results <- formatFit(fit)
print(formatted_results)
```


---

## Contact

For questions or suggestions, please contact:  
📧 Email: [573814880@qq.com](mailto:573814880@qq.com)  
🌐 GitHub: [Smallriver2024](https://github.com/Smallriver2024)

---
