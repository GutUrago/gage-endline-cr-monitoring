################################################################################
# Automated GAGE AF Survey Monitoring Script
################################################################################



library(googlesheets4)
library(rsurveycto)
library(tidyverse)
library(rlang)
library(checkmate)
library(glue)

# Source external scripts
source("scripts/variables.R")
source("scripts/functions.R")

# Set local file paths for testing
form_id = "gage_endline_af_survey"
local_gs_token <- "secrets/monitoring-446409-c6231994c3cd.json"
local_scto_token <- "secrets/scto_auth.txt"
local_private_token <- "secrets/key.pem"
gsheet <- "https://docs.google.com/spreadsheets/d/19rA5DBCdfzNcLYMHEw7VRMF-CWX6Nf90kmI9OLED7IU"


# Replace credentials with github tokens
if(file.exists(local_gs_token)){
  GSHEET_TOKEN <- local_gs_token
  } else {
    GSHEET_TOKEN <- Sys.getenv('GSHEET_TOKEN')
    }


if(file.exists(local_private_token)){
  PRIVATE_TOKEN <- local_private_token
  } else {
    token_text <- Sys.getenv('PRIVATE_TOKEN')
    write_file(token_text, "PRIVATE_TOKEN.pem")
    Sys.sleep(3)
    PRIVATE_TOKEN <- "PRIVATE_TOKEN.pem"
  }


if(file.exists(local_scto_token)){
  SCTO_TOKEN <- local_scto_token
  } else {
    token_text <- Sys.getenv('SCTO_TOKEN')
    write_file(token_text, "SCTO_TOKEN.txt")
    Sys.sleep(3)
    SCTO_TOKEN <- "SCTO_TOKEN.txt"
  }
# Authorize google sheet API
gs4_auth(path = GSHEET_TOKEN)


if(!exists("raw_data")){
  raw_data <- scto_read(
    auth = scto_auth(SCTO_TOKEN),
    ids = form_id,
    private_key = PRIVATE_TOKEN,
    drop_empty_cols = FALSE
  )
}

# Convert variable types to numeric
df <- raw_data %>% 
  mutate(across(all_of(var_list), as.numeric),
         starttime = ymd_hms(starttime),
         starttime = with_tz(starttime, "Africa/Nairobi"))
  
# Check outdated form versions
form_defs <- df %>% 
  select(all_of(out_vars), formdef_version) %>% 
  mutate(sub_date = date(Date)) %>% 
  arrange(desc(sub_date)) %>% 
  mutate(latest_version = max(formdef_version), .by = sub_date) %>% 
  filter(formdef_version < latest_version) %>% 
  mutate(Issue_description = "Please download the latest form version") %>% 
  select(!sub_date) %>% 
  arrange(desc(Date)) %>% 
  mutate(Date = format(Date, "%b %d, %Y %I:%M:%S %p"))

# Write it to the google sheet
write_sheet(form_defs, ss = gsheet, sheet = "Form version")

# Check Duplicates
dups <- df %>% group_by(hhid) %>% 
  filter(n() > 1) %>% 
  select(all_of(out_vars)) %>% 
  mutate(Issue_description = "These are duplicates",
         sub_date = date(Date)) %>% 
  arrange(desc(sub_date), HHID) %>% 
  select(!sub_date) %>% 
  mutate(Date = format(Date, "%b %d, %Y %I:%M:%S %p"))

# Write to google sheet
write_sheet(dups, ss = gsheet, sheet = "Duplicates")

# Check missing gps
gps_missing <- filter(df, (ccl_gps == "" | is.na(ccl_gps)) &
                        list_region != "Amhara") %>% 
  select(all_of(out_vars)) %>% 
  mutate(Issue_description = "GPS Missing",
         sub_date = date(Date)) %>% 
  arrange(desc(sub_date), HHID) %>% 
  select(!sub_date) %>% 
  mutate(Date = format(Date, "%b %d, %Y %I:%M:%S %p"))

# Write to google sheet
write_sheet(gps_missing, ss = gsheet, sheet = "GPS Missing")

# Check for outliers
df_outliers <- check_outliers(df, var_list, out_vars)

# Write to google sheet
for(var_name in names(df_outliers)){
  df_out <- df_outliers[[var_name]] %>%
    arrange(desc(Date)) %>% 
    mutate(Date = format(Date, "%b %d, %Y %I:%M:%S %p"))
  write_sheet(df_out, ss = gsheet, sheet = var_name)
}
