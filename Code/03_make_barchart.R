library(pacman)
p_load(tidyverse, rio, janitor, haven, epiDisplay, gtsummary, table1, here)

here::i_am("Code/03_make_barchart.R")

nhanes <- readRDS(here::here("Clean_Data/labeledNhanes.rds"))

barchart <- nhanes %>% filter(analytic == 1) %>%
  ggplot(aes(x = managed, fill = military)) +
  geom_bar() +
  labs(title = "Figure 1: Glycemic Control by Military Service",
       y = "Frequency",
       x = "Optimal Glycemic Control (HbA1c \u2265 7%)") +
  scale_fill_manual(values = c("No" = "#af8dc3", "Yes" = "#7fbf7b"))+
  theme(plot.title = element_text(hjust = .5))+
  guides(fill = guide_legend(title = "Military Service Experience"))

saveRDS(barchart, file = here("Output/barchart.rds"))