

# Function to check outliers 
check_outliers <- function(df, var_list, out_vars = NULL, p = c(0.05, 0.95), 
                           exclude = c(NA, -95, -97, -99, -77, -78)) {
  # Validate arguments
  assert_data_frame(df, min.rows = 1, min.cols = 1)
  assert_character(var_list, any.missing = FALSE, min.len = 1)
  assert_numeric(p, lower = 0, upper = 1, len = 2, sorted = TRUE)
  assert_vector(exclude)
  
  # Ensure variables in `var_list` exist in `df`
  missing_vars <- setdiff(var_list, colnames(df))
  if (length(missing_vars) > 0) {
    abort(paste("The following variables are missing from the dataframe:", 
                paste(missing_vars, collapse = ", ")))
  }
  
  # Ensure `out_vars` is valid if provided
  if (!is.null(out_vars)) {
    assert_character(out_vars)
    missing_out_vars <- setdiff(out_vars, colnames(df))
    if (length(missing_out_vars) > 0) {
      abort(paste("The following output variables are missing from the dataframe:", 
                  paste(missing_out_vars, collapse = ", ")))
    }
  }
  
  # Convert specified columns to numeric
  df <- df %>% mutate(across(all_of(var_list), as.numeric, .names = "num_{col}"))
  list_out <- list()
  
  for (var_name in var_list) {
    num_var_name <- paste0("num_", var_name)  # Numeric column name
    var_value <- df[[num_var_name]]
    
    # Filter out excluded values
    df_filtered <- df %>% filter(!(var_value %in% exclude))
    if (nrow(df_filtered) == 0) {
      warn(paste("No valid rows remain after filtering for variable:", var_name))
      list_out[[var_name]] <- tibble()
      next
    }
    
    # Recalculate var_value after filtering
    var_value <- df_filtered[[num_var_name]]
    
    # Calculate quantiles
    p5 <- quantile(var_value, probs = p[1], na.rm = TRUE)
    p95 <- quantile(var_value, probs = p[2], na.rm = TRUE)
    
    # Identify outliers
    outliers_df <- df_filtered %>%
      filter(var_value <= p5 | var_value >= p95) %>%
      select(any_of(out_vars), all_of(var_name)) %>% 
      mutate("Variable" = var_name)
    
    # Recalculate var_value for outlier rows
    if (nrow(outliers_df) > 0) {
      outliers_df <- outliers_df %>%
        mutate(Issue_description = glue::glue("Responded {.data[[var_name]]} to '{var_labels[var_name]}'. It's an outlier. Please confirm")) %>% 
        select(!all_of(var_name))
    }
    
    # Store result
    list_out[[var_name]] <- outliers_df
  }
  
  return(list_out)
}




add_totals <- function(data, min = NULL, max = NULL, avg = NULL, pct = NULL) {
  # Validate inputs
  assert_data_frame(data, min.rows = 1, min.cols = 1)
  assert_character(min, null.ok = TRUE)
  assert_character(max, null.ok = TRUE)
  assert_character(avg, null.ok = TRUE)
  assert_list(pct, null.ok = TRUE, types = "character", any.missing = FALSE)
  
  # Check that columns specified in min, max, avg, and pct exist in the data
  all_columns <- names(data)
  if (!is.null(min)) assert_subset(min, all_columns, empty.ok = TRUE)
  if (!is.null(max)) assert_subset(max, all_columns, empty.ok = TRUE)
  if (!is.null(avg)) assert_subset(avg, all_columns, empty.ok = TRUE)
  if (!is.null(pct)) {
    for (pair in pct) {
      assert_character(pair, len = 2)
      assert_subset(pair, all_columns)
    }
  }
  
  # Generate totals
  totals <- data %>% adorn_totals()
  row_n <- nrow(totals)
  
  # Process min
  if (!is.null(min)) {
    for (i in min) {
      totals[[i]][row_n] <- NA
      totals[[i]][row_n] <- round(min(totals[[i]], na.rm = TRUE))
    }
  }
  
  # Process max
  if (!is.null(max)) {
    for (i in max) {
      totals[[i]][row_n] <- NA
      totals[[i]][row_n] <- round(max(totals[[i]], na.rm = TRUE))
    }
  }
  
  # Process avg
  if (!is.null(avg)) {
    for (i in avg) {
      totals[[i]][row_n] <- NA
      totals[[i]][row_n] <- round(mean(totals[[i]], na.rm = TRUE))
    }
  }
  
  # Process pct
  if (!is.null(pct)) {
    for (i in names(pct)) {
      enum <- pct[[i]][1]
      denum <- pct[[i]][2]
      totals[[i]][row_n] <- NA
      totals[[i]][row_n] <- totals[[enum]][row_n] / totals[[denum]][row_n]
    }
  }
  
  return(totals)
}






gt_table <- function(
    data,
    title = NULL,
    subtitle = NULL,
    ...) {
  
  gt_table <- gt(data)
  
  rows <- nrow(gt_table[["_data"]])
  
  my_table <- gt_table |> 
    tab_header(
      title = title,
      subtitle = subtitle
    ) |> 
    tab_style(
      style = cell_text(color = "black", 
                        weight = "bold"),
      locations = cells_title(groups = "title")
    ) |> 
    tab_style(
      style = cell_fill(color = "grey90"),
      locations = cells_body(rows = seq(1, rows, 2))
    ) |> 
    tab_options(
      table.width = pct(100),
      column_labels.background.color = "steelblue",
      heading.align = "left") |> 
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()
    ) |> 
    tab_style(
      style = cell_text(weight = "bold",
                        size = "medium"),
      locations = cells_column_spanners()
    )
  
  if((gt_table[["_data"]][rows, 1] == "Total")[1]){
    my_table <- my_table |> 
      tab_style(
        style = cell_text(color = "black", 
                          weight = "bold"),
        locations = cells_body(rows = rows)
      )
  }
  
  return(my_table)
  
}







