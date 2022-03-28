library(tidyverse)
library(readxl)

popul_data <-
  read_excel("data/mn_county_estimates_sdc_2019_tcm36-442553.xlsx") %>% 
  transmute(
    county = `County Name`,
    population = `Total Population, 2019`
  ) %>% 
  print()

popul_cattle <-
 read_excel("data/cattle data 2020.xlsx") %>% 
  print()

popul_wolves <-
  read_excel("data/Wolf pop per county all MN Counties.xlsx") %>% 
  print()

