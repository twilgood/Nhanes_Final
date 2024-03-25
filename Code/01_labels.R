library(pacman)
p_load(tidyverse, rio, janitor, haven, epiDisplay, gtsummary, table1, here)

here::i_am("Code/01_labels.R")

nhanes <- readRDS(here::here("Clean_Data/nhanes.rds"))

nhanes$military <- factor(nhanes$military, levels = 1:2, labels = c("Yes", "No"))
nhanes$riagendr <- factor(nhanes$riagendr, levels = 1:2, labels = c("Male", "Female"))
nhanes$racecat <- factor(nhanes$racecat, levels = c(1,2,3,4), labels = c("Mexican American",
                                                                         "Non-Hispanic Black",
                                                                         "Non-Hispanic White",
                                                                         "Non-Hispanic Asian/Other"))

nhanes$college <- factor(nhanes$college, levels = 1:2, labels = c("Yes", "No"))
nhanes$highbp <- factor(nhanes$highbp, levels = 1:2, labels = c("High", "Normal"))
nhanes$medtx <- factor(nhanes$medtx, levels = 1:2, labels = c("Yes", "No"))
nhanes$managed <- factor(nhanes$managed, levels = 1:2, labels = c("Managed", "Not Managed"))

# Formatting Variable Labels
label(nhanes$military) <- "Military Experience"
label(nhanes$riagendr) <- "Gender" 
label(nhanes$racecat) <- "Race / Ethnicity"
label(nhanes$ridageyr) <- "Age, yrs"
label(nhanes$college) <- "College Educated"
label(nhanes$highbp) <- "Blood Pressure"
label(nhanes$medtx) <- "Taking Diabetic Medication"
label(nhanes$managed) <- "Ideal Diabetes Management"

saveRDS(nhanes, file = here("Clean_Data/labeledNhanes.rds"))