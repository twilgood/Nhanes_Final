library(pacman)
p_load(tidyverse, rio, janitor, haven, epiDisplay, gtsummary, table1)

here::i_am("Code/02_table1.R")

nhanes <- readRDS(here::here("Clean_Data/labeledNhanes.rds"))

table1 <- nhanes %>% 
  tbl_summary(include = c(ridageyr, riagendr, college, racecat, highbp, medtx),
              by = military,
              type = list(c(college, medtx) ~ "categorical")) %>% 
  modify_spanning_header(c("stat_1", "stat_2") ~ "**Military Service Experience**") %>% 
  modify_caption("**Table 1: Sample Characteristics**") %>% 
  bold_labels()

saveRDS(table1, file = here::here("Output/table1.rds"))
