# Example: calculate TSR endpoints from the accompanying example dataset.

source("tsr_endpoints.R")
tumor_data <- read.csv("example_tumor_measurements.csv")

# Calculate all three endpoints using imputation strategy a.
results_a <- calculate_tsr_endpoints(
  data = tumor_data,
  endpoints = c("RC_H", "RC_L", "RC_S"),
  imputation = "a"
)

cat("Strategy a: first six patients\n")
print(head(results_a))

# Calculate the three endpoints using imputation strategy b.
results_b <- calculate_tsr_endpoints(
  data = tumor_data,
  endpoints = c("RC_H", "RC_L", "RC_S"),
  imputation = "b"
)

cat("\nStrategy b: first six patients\n")
print(head(results_b))


# For your own data, replace tumor_data with a dataset containing
# ID, WEEK, SLD, DROPF, NEWLF, and choose endpoints/imputation above.
