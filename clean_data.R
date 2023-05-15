### swine flu
library(tsibble)
library(dplyr)
library(car)
library(caret)
library(readxl)

### data
vars <- read.csv("/Users/jackconnors/Downloads/training_set_features.csv")
dep <- read.csv("/Users/jackconnors/Downloads/training_set_labels.csv")
sub <- read.csv("/Users/jackconnors/Downloads/submission_format.csv")

### clean data
### create master data frame
master <- vars %>%
  left_join(dep, by="respondent_id")

### impute 0 for missing values
master_impute <- master %>%
  mutate_if(is.numeric, ~if_else(is.na(.), 0, .))

### visualize data ###
### seasonal vaccine
seas_vax <- ggplot(master_impute, aes(factor(seasonal_vaccine))) +
  geom_bar(aes(y=..prop.., group=1)) +
  scale_y_continuous(labels=scales::percent_format()) +
  coord_flip() +
  labs(title="Proportion of Seasonal Vaccination",
       x="Whether Vaccine was Taken") +
  theme_bw()

### h1n1_vaccine
h1n1_vax <- ggplot(master_impute, aes(factor(h1n1_vaccine))) +
  geom_bar(aes(y=..prop.., group=1)) +
  scale_y_continuous(labels=scales::percent_format()) +
  coord_flip() +
  labs(title="Proportion of H1N1 Vaccination",
       x="Whether Vaccine was Taken") +
  theme_bw()

h1n1_concern <- ggplot(master_impute, aes(factor(h1n1_concern))) +
  geom_bar(aes(y=..prop.., group=1)) +
  coord_flip() +
  labs(title="Concern for H1N1",
       x="Levels of Concern") +
  theme_bw()

library(cowplot)
plot_grid(h1n1_vax, seas_vax, h1n1_concern)

#### H1N1 Vaccine Status ####
h1 <- master_impute %>%
  select(-respondent_id, -seasonal_vaccine)

### turn factors into factors
h1 <- h1 %>%
  mutate_if(is.integer, as.factor) %>%
  mutate_if(is.numeric, as.factor)