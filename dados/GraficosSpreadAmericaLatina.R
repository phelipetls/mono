library(cowplot)
library(tidyverse)
library(lubridate)
library(data.table)
library(janitor)

setwd("~/mono/dados/")

raw <- read_csv("spreads_paises.csv") %>%
  clean_names %>%
  select(-c(x64, x2018))

latin_america <- read_csv("countries.csv") %>%
  clean_names() %>%
  filter(sub_region_name == "Latin America and the Caribbean") %>%
  pull(official_name_en)

spreads <- raw %>% gather("year", "spread", x1960:x2017) %>%
  na.omit() %>% 
  select(country_name, year, spread) %>%
  mutate(year = str_remove(year, "x")) %>%
  filter(year >= 2015) %>% 
  filter(country_name %in% latin_america)


spreads %>% na.omit() %>% 
  ggplot(aes(reorder(country_name, spread), spread)) +
  geom_col() +
  facet_grid(.~year) + coord_flip() +
  guides(fill = F) + labs(x = NULL, y = NULL)
