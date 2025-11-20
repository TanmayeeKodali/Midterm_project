here::i_am("code/Pneumonia_Pttype.R")

#load library
library(labelled)
library(gtsummary)
library(here)
library(ggplot2)
library(dplyr)
library(readr)

#Read data
data_path <- here::here("data", "covid_sub.csv")
covid <- readr::read_csv(data_path, show_col_types = FALSE)

# Analyze relationship between age and pneumonia at presentation

# Create new dataset with age groups and pneumonia_bin
pneumonia_st <- covid %>%
  mutate(
    age_group = cut(
      AGE,
      breaks = c(0, 19, 39, 59, 79, Inf),
      labels = c("0-19", "20-39", "40-59", "60-79", "80+"),
      include.lowest = TRUE
    ),
    pneumonia_bin = ifelse(PNEUMONIA == "Yes", 1, 0)
  )

# Summarize counts
pneumonia_status <- pneumonia_st %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    pneumonia_cases = sum(pneumonia_bin, na.rm = TRUE)
  )

# Save table
saveRDS(
  pneumonia_status,
  file = here::here("output/tables/Pneumonia_status.rds")
)


# Obtaining plot Pneumonia vs Age groups

pneumonia_plot <- ggplot(pneumonia_status,
                         aes(x = age_group, y = pneumonia_cases)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Pneumonia Prevalence by Age Group",
    x = "Age Group",
    y = "Proportion with Pneumonia"
  ) 


ggsave(
  here::here("output/figures/Pneumonia_age.png"),
  plot = pneumonia_plot,
  device = "png"
)


# Examine age and hospitalization status among confirmed patients

covid <- covid %>%
  mutate(
    hospitalized = if_else(PATIENT_TYPE == "hospitalization", 1, 0)
  )


patient_type_tbl <- covid %>%
  mutate(
    age_group = cut(
      AGE,
      breaks = c(0, 19, 39, 59, 79, Inf),
      labels = c("0–19", "20–39", "40–59", "60–79", "80+"),
      include.lowest = TRUE
    )
  ) %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    hospitalized_cases = sum(hospitalized, na.rm = TRUE),
    rate = hospitalized_cases / n
  )


saveRDS(
  patient_type_tbl,
  file = here::here("output/tables/patient_type.rds")
)

# Obtaining plot

hosp_plot <- ggplot(patient_type_tbl,
                    aes(x = age_group, y = hospitalized_cases)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Hospitalization by Age Group",
    x = "Age Group",
    y = "Number Hospitalized"
  )

ggsave(
  here::here("output/figures/PatientType_age.png"),
  plot = hosp_plot,
  device = "png"
)




