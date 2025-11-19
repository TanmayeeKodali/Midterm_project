# ---- Coder 2: Akanshya Dash ---------------------------------------------
# Deliverables:
#   output/tables/cfr_by_comorbidity.csv
#   output/figures/comorbidity_prevalence.png

suppressPackageStartupMessages({
  library(readr); library(dplyr); library(ggplot2); library(scales); library(tibble)
})

# Optional sex filter read from config.R (if present)
sex_filter <- "ALL"
if (file.exists("config.R")) {
  try(source("config.R"), silent = TRUE)
}

# small helpers -------------------------------------------------------------
yn_to_logical <- function(x){
  z <- trimws(tolower(as.character(x)))
  out <- ifelse(z %in% c("1","yes","si","sí","true","t","y","s"), TRUE,
                ifelse(z %in% c("2","0","no","false","f","n"), FALSE, NA))
  if (all(is.na(out))) {
    num <- suppressWarnings(as.numeric(z))
    out <- ifelse(num == 1, TRUE,
                  ifelse(num %in% c(0,2), FALSE,
                         ifelse(num %in% c(97,98,99), NA, NA)))
  }
  out
}
ensure_dirs <- function(){
  dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
  dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
}

# read data (we’ll use column positions from your inspection) --------------
read_covid_sub_bypos <- function(){
  f <- "data/covid_sub.csv"
  if (!file.exists(f)) stop("data/covid_sub.csv not found.")
  readr::read_csv(f, show_col_types = FALSE, locale = readr::locale(encoding = "UTF-8"))
}

# main ----------------------------------------------------------------------
ensure_dirs()
raw <- read_covid_sub_bypos()

# Positions from your column check:
COL_SEX  <- 4
COL_AGE  <- 9
COL_DIED <- 6
COL_CLAS <- 21
COL_DIAB <- 11
COL_COPD <- 12
COL_HYP  <- 15
COL_CARD <- 17
COL_OBES <- 18

# Build clean analysis frame
dat <- tibble(
  sex            = raw[[COL_SEX]],              # "male"/"female"
  age            = raw[[COL_AGE]],
  date_died      = raw[[COL_DIED]],
  classification = raw[[COL_CLAS]],
  diabetes       = raw[[COL_DIAB]],
  copd           = raw[[COL_COPD]],
  hypertension   = raw[[COL_HYP]],
  cardiovascular = raw[[COL_CARD]],
  obesity        = raw[[COL_OBES]]
)

# keep confirmed cases only (1–3)
dat <- dat %>%
  mutate(classification = suppressWarnings(as.numeric(classification))) %>%
  filter(!is.na(classification) & classification %in% 1:3)

# death flag; treat blank/NA/"NA"/9999-99-99 as alive
dat <- dat %>%
  mutate(date_died = trimws(as.character(date_died))) %>%
  mutate(death = !is.na(date_died) &
           date_died != "" &
           !grepl("^NA$", date_died, ignore.case = TRUE) &
           !grepl("^9{4}[-/]?9{2}[-/]?9{2}$", date_died))

# optional sex filter from config.R
if (toupper(sex_filter) %in% c("MALE","FEMALE")){
  keep <- if (toupper(sex_filter) == "MALE") "male" else "female"
  dat <- dat %>% filter(tolower(sex) == keep)
}

# recode comorbidity columns to logical
comorb_vars <- c("diabetes","hypertension","obesity","copd","cardiovascular")
for (v in comorb_vars) dat[[v]] <- yn_to_logical(dat[[v]])

# ---- Output 1: CFR by comorbidity ----------------------------------------
# --- replace your compute_cfr() with this ---
compute_cfr <- function(df, v){
  # Only keep rows where the comorbidity is TRUE
  sub <- df %>% filter(.data[[v]] %in% TRUE)
  
  n_cases  <- nrow(sub)
  n_deaths <- if (n_cases > 0) sum(sub$death, na.rm = TRUE) else 0
  cfr      <- if (n_cases > 0) n_deaths / n_cases else NA_real_
  
  tibble(comorbidity = v, n_cases = n_cases, n_deaths = n_deaths, cfr = cfr)
}

# keep these lines as-is
cfr_tbl <- bind_rows(lapply(comorb_vars, function(v) compute_cfr(dat, v))) %>%
  arrange(desc(cfr))
write_csv(cfr_tbl, "output/tables/cfr_by_comorbidity.csv")

# ---- Output 2: Prevalence bar chart --------------------------------------
prev_tbl <- comorb_vars %>%
  lapply(function(v) tibble(comorbidity = v,
                            prevalence = mean(dat[[v]], na.rm = TRUE))) %>%
  bind_rows() %>% arrange(desc(prevalence))
prev_top5 <- head(prev_tbl, 5)

label_map <- c(
  diabetes = "Diabetes",
  hypertension = "Hypertension",
  obesity = "Obesity",
  copd = "COPD",
  cardiovascular = "Cardiovascular Dz"
)

p <- ggplot(prev_top5, aes(x = reorder(comorbidity, prevalence), y = prevalence)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(labels = function(x) unname(label_map[x])) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Prevalence of Top Comorbidities (Confirmed Cases)",
    x = NULL, y = "Prevalence",
    caption = if (exists("sex_filter") && sex_filter != "ALL")
      paste("Filtered:", sex_filter) else NULL
  ) +
  theme_minimal(base_size = 12)

ggsave("output/figures/comorbidity_prevalence.png", p, width = 7, height = 4.5, dpi = 300)

message("✅ Done. Files written to output/tables and output/figures.")
