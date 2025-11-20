# ==============================================================================
# 05_make_figure7.R
# Coder 5: Tanmayee Kodali
# Purpose: Generate a histogram of age distribution
# Output: output/figures/age_distribution.png
# ==============================================================================

# Load required libraries
library(tidyverse)
library(here)

# Read the data
covid_data <- read.csv(here("data/covid_sub.csv"))

# Create age distribution histogram
age_histogram <- ggplot(covid_data, aes(x = AGE)) +
  geom_histogram(
    bins = 30, 
    fill = "steelblue", 
    color = "white",
    alpha = 0.8
  ) +
  labs(
    title = "Age Distribution of COVID-19 Cases",
    x = "Age (years)",
    y = "Number of Cases"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  ) +
  # Add a vertical line for mean age
  geom_vline(
    aes(xintercept = mean(AGE, na.rm = TRUE)),
    color = "red",
    linetype = "dashed",
    linewidth = 1
  ) +
  # Add annotation for mean
  annotate(
    "text",
    x = mean(covid_data$AGE, na.rm = TRUE) + 5,
    y = Inf,
    label = paste0("Mean = ", round(mean(covid_data$AGE, na.rm = TRUE), 1)),
    vjust = 2,
    color = "red",
    size = 4
  )

# Display the plot
print(age_histogram)

# Save the plot
ggsave(
  filename = here("output/figures/age_distribution.png"),
  plot = age_histogram,
  width = 10,
  height = 6,
  dpi = 300
)

cat("\nFigure saved successfully to: output/figures/age_distribution.png\n")

# Print summary statistics
cat("\nAge Distribution Summary:\n")
summary(covid_data$AGE)