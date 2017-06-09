#### disaster_deaths.R 

require('broom')
require('tidyverse')
require('stringr')
require('zoo')
require('data.table')

emdat_data <- read.table("~/disaster_deaths/emdat_deaths.txt", sep = ",",skip = 2, nrows = 2537)  %>%
  rename(start_date = V1, end_date = V2, country = V3, iso = V4, location = V5, disaster_type = V6, disaster_subtype = V7,associated_disaster1 = V8, associated_disaster2 = V9, total_deaths = V10, total_affected = V11, total_damage = V12, total_insured_damage = V13, disaster_num =V14)  %>%
  mutate(start_day = as.numeric(str_split_fixed(start_date,"/",3)[,1]),
          start_month = as.numeric(str_split_fixed(start_date,"/",3)[,2]),
          start_year = as.numeric(str_split_fixed(start_date,"/",3)[,3]),
          end_day = as.numeric(str_split_fixed(end_date,"/",3)[,1]),
          end_month = as.numeric(str_split_fixed(end_date,"/",3)[,2]),
          end_year = as.numeric(str_split_fixed(end_date,"/",3)[,3]),
         start_yrmo = as.yearmon(paste(start_year,start_month,sep = "-")),
         end_yrmo = as.yearmon(paste(end_year,end_month, sep = "-"))
         ) %>%
  arrange(country, start_yrmo) %>% 
  select(-start_date,-end_date) 

setDT(emdat_data)[,ID2:=.GRP,by=c("country")]
Ref <- emdat_data[,list(Compare_Value=list(I(total_deaths)),Compare_Date=list(I(start_yrmo))), by=c("ID2")]
emdat_data[,Roll.Val := mapply(RD = start_yrmo,NUM=ID2, function(RD, NUM) {
  d <- as.numeric(Ref$Compare_Date[[NUM]] - RD)
  sum((d <= -1 & d >= -365*10)*Ref$Compare_Value[[NUM]])})]

