#### disaster_deaths.R 

require('broom')
require('tidyverse')
require('stringr')



emdat_data <- read.table("~/disaster_deaths/emdat_deaths.txt", sep = ",",skip = 2, nrows = 2537)  %>%
  rename(start_date = V1, end_date = V2, country = V3, iso = V4, location = V5, disaster_type = V6, disaster_subtype = V7,associated_disaster1 = V8, associated_disaster2 = V9, total_deaths = V10, total_affected = V11, total_damage = V12, total_insured_damage = V13, disaster_num =V14)  %>%
  mutate(start_day = as.numeric(str_split_fixed(start_date,"/",3)[,1]),
          start_month = as.numeric(str_split_fixed(start_date,"/",3)[,2]),
          start_year = as.numeric(str_split_fixed(start_date,"/",3)[,3]),
          end_day = as.numeric(str_split_fixed(end_date,"/",3)[,1]),
          end_month = as.numeric(str_split_fixed(end_date,"/",3)[,2]),
          end_year = as.numeric(str_split_fixed(end_date,"/",3)[,3])) %>%
  select(-start_date,-end_date)

