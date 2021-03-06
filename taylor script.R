library(tidyverse)
library(readxl)
# install.packages("devtools")
# devtools::install_github("UrbanInstitute/urbnmapr")
library(urbnmapr)
library(sf)
library(units)

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

all_data <-
popul_data %>% 
  left_join(popul_cattle) %>% 
  left_join(popul_wolves) %>% 
  print()

counties_sf <- get_urbn_map(map = "counties", sf = TRUE)


counties_sf %>% 
  filter(state_name == "Minnesota") %>%
  mutate(
    county = str_remove(county_name, " County"),
    area = as.numeric(st_area(geometry) / 1000000)
  ) %>% 
  left_join(all_data, by = "county") %>% 
  mutate(
    population_density = population / area,
    wolf_density = n_wolves / area,
    human_wolf_ratio = wolf_density/population_density
  ) %>% 
  ggplot() +
  geom_sf(mapping = aes(fill = human_wolf_ratio),
          color = "#D1E5F0", size = 0.05) +
  coord_sf(datum = NA) +
  labs(fill = "Ratio",
       subtitle = "Ratio of Wolf Density to Human Density",
       title = "Prediction of Human-Wolf Conflict")

counties_sf %>% 
  filter(state_name == "Minnesota") %>%
  mutate(
    county = str_remove(county_name, " County"),
    area = as.numeric(st_area(geometry) / 1000000)
  ) %>% 
  left_join(all_data, by = "county") %>% 
  mutate(
    cattle_density = n_cattle_calves / area,
    wolf_density = n_wolves / area,
    cattle_wolf_ratio = wolf_density/cattle_density
  ) %>% 
  ggplot() +
  geom_sf(mapping = aes(fill = cattle_wolf_ratio),
          color = "#D1E5F0", size = 0.05) +
  coord_sf(datum = NA) +
  labs(fill = "Ratio",
       subtitle = "Ratio of Wolf Density to Cattle Density", 
       title = "Prediction of Wolf Predation on Cattle")


