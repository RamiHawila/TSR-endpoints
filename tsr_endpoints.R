# Patient-level tumor-size relative-change endpoints (RC_H, RC_L, RC_S).

calculate_tsr_endpoints <- function(data,
                                    endpoints = c("RC_H", "RC_L", "RC_S"),
                                    imputation = "a") {
  required <- c("ID", "WEEK", "SLD", "DROPF", "NEWLF")
  if (!all(required %in% names(data))) stop("Missing columns: ",
    paste(setdiff(required, names(data)), collapse = ", "))
  if (!length(endpoints) || any(!endpoints %in% c("RC_H", "RC_L", "RC_S")))
    stop("Choose RC_H, RC_L, and/or RC_S")
  if (!imputation %in% c("a", "b")) stop("imputation must be 'a' or 'b'")

  endpoints <- unique(endpoints)
  patients <- split(data, factor(data$ID, levels = unique(data$ID)))

  results <- lapply(patients, function(p) {
    p <- p[order(p$WEEK), ]
    baseline <- p$SLD[p$WEEK == 0]
    if (length(baseline) != 1 || is.na(baseline) || baseline <= 0)
      stop("Each patient must have one positive baseline SLD at WEEK = 0")

    # Only observed post-baseline measurements contribute to the endpoints.
    post <- p[p$WEEK > 0 & !is.na(p$SLD), ]

    if (any(p$DROPF == 1, na.rm = TRUE) || nrow(post) == 0) {
      rc_values <- c(RC_H = -1, RC_L = -1, RC_S = -1)
    } else {
      # Relative change from baseline at each available post-baseline scan.
      RC <- 1 - post$SLD / baseline

      # Endpoints: highest, latest, and smallest observed relative change.
      rc_values <- c(RC_H = max(RC), RC_L = tail(RC, 1), RC_S = min(RC))

      # New-lesion imputation: (a) -1; (b) worst observed relative change.
      if (any(p$NEWLF == 1, na.rm = TRUE)) {
        rc_values[] <- if (imputation == "a") -1 else min(RC)
      }
    }

    result <- data.frame(ID = p$ID[1])
    for (name in endpoints) result[[name]] <- unname(rc_values[name])
    result
  })

  rownames_result <- do.call(rbind, results)
  rownames(rownames_result) <- NULL
  rownames_result
}
