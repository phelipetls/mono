library(tidyverse)
library(data.table)
library(lubridate)
library(ecoseries)
library(rbcb)

setwd("~/mono/dados")


# -----------------------------------------------
# Coletar dados do rbcb

data_inicial = "2011-01-01"

series = get_series(c(
  Spread = 20786,
  Selic = 4189,
  `Inflação` = 433,
  `Compulsório` = 1849,
  `Inadimplência` = 21082,
  `Produção Industrial` = 21859), data_inicial, as = "tibble")

# -----------------------------------------------
# Ler dados Herfindahl-Hirschmann

ihh <- fread("ihh.csv") %>%
  as_tibble %>%
  mutate(date = as.Date(date)) %>%
  arrange(date) %>%
  select(date, ativos) %>%
  rename(ihh = ativos)

# ----------------------------------------------
# Juntar tudo num data.frame

concat <- function(series) {
  merged <- merge(series[[1]], series[[2]])

  for (i in 3:length(series)) {
    merged <- merge(merged, series[[i]])
  }
  return(merged)
}

df <- right_join(ihh, concat(series), by = "date") %>%
      filter(date <= as.Date("2017-12-01")) %>%
      as_tibble %>%
      fill(ihh)

write.csv(df, file = "series_economicas.csv")
