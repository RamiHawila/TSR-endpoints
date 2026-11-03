# Tumor size ratio (TSR) endpoints in R

Calculate patient-level `RC_H`, `RC_L`, and `RC_S` using imputation strategy `"a"` or `"b"`.

## Files

* `tsr_endpoints.R` — endpoint calculation function.
* `example_tumor_measurements.csv` — example patient-level tumor measurements.
* `example_usage.R` — runnable example with results for strategies a and b.

## Run the example

Download the files into the same folder, set that folder as your R working directory, and run:

```r
source("example_usage.R")
```

The example prints the first six patients' endpoint values for each strategy.

## Use your own dataset

Provide one row per tumor assessment with these columns:

| Variable | Description |
|---|---|
| `ID` | Unique patient identifier |
| `WEEK` | Week of tumor scan/assessment (= 0 for baseline) |
| `SLD` | Sum of longest diameters of target lesions |
| `DROPF` | 1 if a patient is an early dropout (without any post-baseline scans); 0 otherwise |
| `NEWLF` | 1 if a patient develops a new lesion at any post-baseline scan; 0 otherwise |
  

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

Strategy "a" imputes the endpoint value for patients developing new lesions at any follow-up scan by −1; strategy "b" imputes the endpoint value by the minimum observed relative change. Endpoint values of early dropouts (patients without post-baseline scans) are imputed by −1 under both strategies.

Reference: [Chakraborty et al. (2025)](https://doi.org/10.1007/s10928-024-09946-3).

