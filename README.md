Midterm Project 2: GitHub - COVID-19 Analysis Report

Overview
This project analyzes COVID-19 case data, examining mortality patterns, comorbidities, demographics, pneumonia prevalence, and hospitalization rates.
Setup Instructions
Package Installation
This project uses renv for package management. To install all required packages:
bashmake install
This will restore all packages from the renv.lock file.
Building the Report
To generate the full report:
bashmake report
This will:

Execute all analysis scripts in the code/ folder
Generate tables in output/tables/
Generate figures in output/figures/
Render report.Rmd to report.html


Project Structure
project/
├── code/               # Analysis scripts
├── data/               # Raw data (covid_sub.csv)
├── output/
│   ├── tables/        # Generated .rds and .csv tables
│   └── figures/       # Generated .png figures
├── report.Rmd         # Main report template
├── Makefile           # Build automation
└── renv.lock          # Package dependencies

Analysis Components
Coder 1: Samridhi Purohit
code/01_make_table1.R

Generates classification summary table
Output: output/tables/classification_summary.csv

code/01_make_figure1.R

Generates bar chart of case classification distribution
Output: output/figures/classification_distribution.png


Coder 2: Akanshya Dash
code/comorbidities_analysis.R

Generates CFR comparison table with/without comorbidities
Output: output/tables/cfr_by_comorbidity.csv
Generates bar chart of top five comorbidities prevalence
Output: output/figures/comorbidity_prevalence.png


Coder 3: Deepanshu Goel
code/03_make_table3.R

Generates mortality distribution table
Output: output/tables/mortality.rds

code/03_make_figure3.R

Generates stacked bar charts showing:

Mortality by ICU admission status
Mortality by intubation status


Outputs:

output/figures/sbs_bar_admit.png
output/figures/sbs_bar_intub.png




Coder 4: Abha Namjoshi
code/Pneumonia_Pttype.R

Generates pneumonia prevalence table by age group
Output: output/tables/Pneumonia_status.rds
Generates hospitalization rates table by age group
Output: output/tables/patient_type.rds
Generates bar chart of pneumonia cases by age group
Output: output/figures/Pneumonia_age.png
Generates bar chart of hospitalization by age group
Output: output/figures/PatientType_age.png


Coder 5: Tanmayee Kodali
code/05_make_table6.R

Generates CFR comparison table between males and females
Output: output/tables/cfr_by_sex.rds

code/05_make_figure7.R

Generates histogram of age distribution
Output: output/figures/age_distribution.png


Team Lead
code/06_render_report.R

Renders the main report from report.Rmd
Output: report.html

report.Rmd

Master report template that integrates all tables and figures
Generates comprehensive HTML report


Output Summary
Tables (6 total)

classification_summary.csv - Case classification distribution
cfr_by_comorbidity.csv - CFR by comorbidity status
mortality.rds - Mortality distribution with ICU/intubation
Pneumonia_status.rds - Pneumonia prevalence by age
patient_type.rds - Hospitalization rates by age
cfr_by_sex.rds - CFR comparison by sex

Figures (7 total)

classification_distribution.png - Case classification bar chart
comorbidity_prevalence.png - Top 5 comorbidities prevalence
sbs_bar_admit.png - Mortality by ICU admission
sbs_bar_intub.png - Mortality by intubation
Pneumonia_age.png - Pneumonia cases by age group
PatientType_age.png - Hospitalization by age group
age_distribution.png - Age distribution histogram


Makefile Commands

make install - Install/restore R packages from renv.lock
make report - Generate the full report
make clean - Remove all generated outputs


Package Management with renv
This project uses renv to ensure reproducibility:

First time setup: Run make install to install all dependencies
Adding new packages: After installing new packages, run renv::snapshot() in R
Updating packages: Run renv::update() in R

Required R Packages

here - Path management
dplyr - Data manipulation
ggplot2 - Visualization
readr - Data reading
tidyverse - Data science ecosystem
gtsummary - Summary tables
rmarkdown - Report generation
knitr - Report rendering
scales - Plot scaling
labelled - Variable labels


Testing
The report is designed to work with updated datasets. To test:

Replace data/covid_sub.csv with updated data (must have same column structure)
Run make report
Verify that report compiles successfully with new data


Team Members

Samridhi Purohit (Coder 1)
Akanshya Dash (Coder 2)
Deepanshu Goel (Coder 3)
Abha Namjoshi (Coder 4)
Tanmayee Kodali (Coder 5)