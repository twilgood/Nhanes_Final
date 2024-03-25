library(pacman)
p_load(tidyverse, rio, janitor, haven, here)

here::i_am("Code/00_make_data_clean.R")

xptdirect <- here::here("Raw_Data/")

xptfiles <- list.files(path = xptdirect, full.names = T)

dataframes_list <- list()

# Loop through each file and import it into a separate dataframe
for (file in xptfiles) {
  # Print the file name for reference
  cat("Importing file:", file, "\n")
  # Reading in the .xpt files
  data <- read_xpt(file) %>% clean_names()
  # Creating a unique dataframe name based on the file name
  dataframe_name <- sub(".xpt$", "", basename(file))
  # Assigning data to a dataframe with the unique name
  assign(dataframe_name, data)
  # Storing the dataframe in the list
  dataframes_list[[dataframe_name]] <- data
}
# Removing excess dataframes
rm(data, dataframes_list)

# Merging data togther by SEQN
nhanes <- Reduce(full_join, list(DEMO_I.XPT,BMX_I.XPT,BPX_I.XPT,
                                 DIQ_I.XPT,TRIGLY_I.XPT,GHB_I.XPT))
# Key Variables:
# BMXBMI	  Body Mass Index (kg/m**2)
# BPXDI2	  Diastolic: Blood pres (2rd rdg) mm Hg
# BPXDI3	  Diastolic: Blood pres (3rd rdg) mm Hg
# BPXDI4    Diastolic: Blood pres (4th rdg) mm Hg
# BPXSY2	  Systolic: Blood pres (2nd rdg) mm Hg
# BPXSY3	  Systolic: Blood pres (3rd rdg) mm Hg
# BPXSY4	  Systolic: Blood pres (4th rdg) mm Hg
# DIQ010	  Doctor told you have diabetes
# DIQ070	  Take diabetic pills to lower blood sugar
# DMDEDUC2	Education level - Adults 20+
# DMQMILIZ	Served active duty in US Armed Forces
# LBXGH	    Glycohemoglobin (%)
# RIAGENDR  Gender
# RIDAGEYR  Age in years at screening
# RIDRETH3	Race/Hispanic origin w/ NH Asian
# WTMEC2YR  MEC Weight
# SDMVPSU   Cluster
# SDMVSTRA  Strata 

# Selecting only neccessary data and removing excess
nhanes1 <- nhanes %>% dplyr::select(seqn,riagendr,ridageyr,ridreth3,dmdeduc2,bmxbmi,bpxdi2,bpxdi3,bpxdi4,bpxsy2,bpxsy3,
                                    bpxsy4,diq010,diq070,diq050,dmqmiliz,lbxgh,
                                    wtmec2yr,sdmvpsu,sdmvstra)

# New Key Variables:
# ridageyr	Age
# highBP	  Blood Pressure 	Average blood pressure is high if average systolic () => 130 mm Hg or average diastolic (2nd and 3rd readings) => 80 mm Hg or higher. 
# college	  College Educated	College Educated
# diabetes	Diabetes Diagnosis	Have been told they are diabetic or had a1c levels of 7% or higher
# pills	    Diabetic Pills	Taking diabetic pills to lower blood sugar
# RIAGENDR  Gender	Gender of respondent
# bmxbmi  	High  BMI	BMI is high if Body Mass Index (kg/m**2) is >= 25
# managed	  Ideal Diabetes Management	Glycohemoglobin (%) is managed if < 7%
# insulin	  Insulin Use	Taking insulin now
# WTINT2YR	Interview Weight	Full sample 2 year interview weight
# WTMEC2YR	MEC Exam Weight	Full sample 2 year MEC exam weight
# miltary	  Military Service	Served active duty in US Armed Forces
# medtx     Diabetic Medications  Diabetic pills or insulin use
# SDMVPSU   PSU/Cluster	Masked variance pseudo-PSU
# racecat	  Race / Ethnicity	Race / Ethnicity
# SEQN	    Respondent sequence number	Respondent ID
# SDMVSTRA	Stratum	Masked variance pseudo-stratum

# Average Systolic and Diastolic vars and then high BP var where:
#   1 = high blood pressure avg sys => 130 mm Hg or avg dia => 80 mm Hg or higher
#   2 = Not high
nhanes2 <- nhanes1 %>% group_by(seqn) %>% 
  mutate(dbpavg = mean(c(bpxdi2,bpxdi3,bpxdi4), na.rm = T),
         sbpavg = mean(c(bpxsy2,bpxdi3,bpxdi4), na.rm = T),
         highbp = ifelse(sbpavg >= 130 | dbpavg >= 80, 1, 2))


# College var where:
#   1 = College Graduate
#   2 = Less than a college education
#   NA = Refused, can't remember, or missing
nhanes2 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(college = case_when(dmdeduc2 %in% c(7,9, NA) ~ NA,
                             dmdeduc2 == 5 ~ 1,
                             TRUE ~ 2))

# Diabetes Diagnosis:
#   1 = have been told they are diabetic or had a1c levels of 7% or higher
#   2 = No diagnosis and lower than 7%
#   NA = Missing or refused
nhanes2 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(diabetes = case_when(diq010 %in% c(9, NA) & lbxgh < 7 ~ NA,
                              diq010 == 1 | lbxgh >= 7 ~ 1,
                              TRUE ~ 2))
# Diabetic Medication Usage:
#   1 = Using pills or insulin
#   2 = No medication use
#   NA = Refused both, unknown, or missing both

nhanes2 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(pills = case_when(diq070 == 2 ~ 2,
                           diq070 == 1 ~ 1,
                           TRUE ~ NA),
         insulin = case_when(diq050 == 2 ~ 2,
                             diq050 == 1 ~ 1,
                             TRUE ~ NA),
         medtx = ifelse(pills == 1 | insulin == 1, 1, 2))

# Ideal Diabetes Management:
#   1 = Glycohemoglobin (%) is managed if < 7%
#   2 = HbA1c >= 7%

nhanes2 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(managed = ifelse(lbxgh < 7, 1, 2))

# Military Service:
#   1 = Active duty military experience
#   2 = No active duty military experience
#   NA = Missing, unknown, or refused

nhanes2 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(military = case_when(dmqmiliz == 1 ~ 1,
                              dmqmiliz == 2 ~ 2,
                              T ~ NA))

# Race / Ethnicity:
#   1 = Mexican American 
#   2 = NH Black
#   3 = NH White
#   4 = NH Asian, other race (including multiracial), and other Hispanic

nhanes2 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(racecat = case_when(ridreth3 == 1 ~ 1,
                             ridreth3 == 4 ~ 2,
                             ridreth3 == 3 ~ 3,
                             TRUE ~ 4))

# Creating Eligiblity:
#   1 = Age >= 20 and diabetic
#   2 = Not eligible

nhanes3 <- nhanes2 %>% group_by(seqn) %>% 
  mutate(eligible = ifelse(ridageyr >= 20 & diabetes == 1, 1, 2))

# Creating Analytic Sample:
nhanes4 <- nhanes3 %>% ungroup() %>% 
  mutate(analytic = case_when(eligible == 1 & !is.na(highbp & racecat & medtx & college 
                                                     & managed & military & ridageyr & bmxbmi & riagendr) ~ 1,
                              TRUE ~ 2))

# Saving cleaned and merged data into Clean_data folder
saveRDS(nhanes4, file = here("Clean_Data/nhanes.rds"))
