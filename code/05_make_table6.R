# ==============================================================================
# 05_make_table6.R
# Coder 5: Tanmayee Kodali
# Purpose: Generate a table comparing CFR between males and females
# Output: output/tables/cfr_by_sex.rds
# ==============================================================================

# Load required libraries
library(tidyverse)
library(here)

# Read the data
covid_data <- read.csv(here("data/covid_sub.csv"))

# Calculate CFR by sex
cfr_by_sex <- covid_data %>%
  # Filter out missing sex data if any
  filter(!is.na(SEX) & SEX != "") %>%
  # Group by sex
  group_by(SEX) %>%
  # Calculate statistics
  summarise(
    total_cases = n(),
    deaths = sum(!is.na(DATE_DIED) & DATE_DIED != "", na.rm = TRUE),
    survivors = sum(is.na(DATE_DIED) | DATE_DIED == "", na.rm = TRUE),
    cfr_percent = round((deaths / total_cases) * 100, 2),
    .groups = "drop"
  ) %>%
  # Arrange by sex for consistent ordering
  arrange(SEX)

# Display the table
print("Case Fatality Rate by Sex:")
print(cfr_by_sex)

# Save the table
saveRDS(cfr_by_sex, here("output/tables/cfr_by_sex.rds"))

cat("\nTable saved successfully to: output/tables/cfr_by_sex.rds\n")