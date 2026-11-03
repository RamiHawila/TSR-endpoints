# TSR endpoints in R

Calculate patient-level `RC\_H`, `RC\_L`, and `RC\_S` using imputation strategy `"a"` or `"b"`.

## Files

* `tsr\_endpoints.R` — endpoint calculation function.
* `toy\_tumor\_measurements.csv` — example patient-level tumor measurements.
* `example\_usage.R` — runnable example with results for strategies a and b.

## Run the example

Download the files into the same folder, set that folder as your R working directory, and run:

```r
source("example\_usage.R")
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
source("tsr\_endpoints.R")
my\_data <- read.csv("my\_tumor\_data.csv")

result <- calculate\_tsr\_endpoints(
  data = my\_data,
  endpoints = c("RC\_H", "RC\_L"),  # any of RC\_H, RC\_L, RC\_S
  imputation = "a"               # "a" or "b"
)
print(result)
```

Strategy **a** imputes −1 for new-lesion patients; strategy **b** imputes the minimum observed relative change. Early dropouts receive −1 under both strategies.

Reference: [Chakraborty et al. (2025)](https://doi.org/10.1007/s10928-024-09946-3).

