# TSR endpoints in R

Calculate patient-level `RC_H`, `RC_L`, and `RC_S` using imputation strategy `"a"` or `"b"`.

## Files

* `tsr_endpoints.R` — endpoint calculation function.
* `toy_tumor_measurements.csv` — example patient-level tumor measurements.
* `example_usage.R` — runnable example with results for strategies a and b.

## Run the example

Download the files into the same folder, set that folder as your R working directory, and run:

```r
source("example_usage.R")
```

The example prints the first six patients' endpoint values for each strategy.

## Use your own dataset

Provide one row per tumor assessment with these columns:

|Column|Description|
|-|-|
|`ID`|Patient identifier|
|`WEEK`|Assessment time; baseline at 0|
|`SLD`|Tumor-size measurement (sum of longest diameters)|
|`DROPF`|1 for early dropout; otherwise 0|
|`NEWLF`|1 if a new lesion developed; otherwise 0|

Each patient must have one baseline row with a positive `SLD`. Set `DROPF` and `NEWLF` consistently across that patient's rows. The function uses the assessment rows you provide.

```r
source("tsr_endpoints.R")
my_data <- read.csv("my_tumor_data.csv")

result <- calculate_tsr_endpoints(
  data = my_data,
  endpoints = c("RC_H", "RC_L"),  # any of RC_H, RC_L, RC_S
  imputation = "a"               # "a" or "b"
)
print(result)
```

Strategy **a** imputes −1 for new-lesion patients; strategy **b** imputes the minimum observed relative change. Early dropouts receive −1 under both strategies.

Reference: [Chakraborty et al. (2025)](https://doi.org/10.1007/s10928-024-09946-3).

