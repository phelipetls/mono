library(tidyverse)
library(data.table)
library(lubridate)
library(rbcb)
library(ipeadatar)

setwd("~/mono/dados/")

# -----------------------------------------------
# Coletar dados do rbcb

data_inicial <- "2011-01-01"

series <- get_series(c(
  Spread = 20786,
  Selic = 4189,
  Inflacao = 433,
  Compulsorio = 1849,
  Inadimplencia = 21082,
  ProducaoIndustrial = 21859), data_inicial, as = "tibble")

# -----------------------------------------------
# Ler dados de Herfindahl-Hirschmann

ihh <- fread("ihh.csv") %>%
  as_tibble %>%
  mutate(date = as.Date(date)) %>%
  arrange(date) %>%
  select(date, ativos) %>%
  rename(IHH = ativos)

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


# -----------------------------------------------

# -----------------------------------------------
# Dados do IPEADATA

intervalo <- c(as.Date(min(df$date)), as.Date(max(df$date)))

inad_alt <- ipeadata("BM12_CRLIN12") %>%
            filter(date >= as.Date(min(df$date)),
                 date <= as.Date(max(df$date))) %>% 
            select(value) %>% 
            rename(InadimplenciaIPEADATA = value)

prod_ind <- ipeadata("PAN12_QIIGG12") %>% 
            filter(date >= as.Date(min(df$date)),
                   date <= as.Date(max(df$date))) %>%
            select(value) %>% 
            rename(ProducaoIndustrialIPEADATA = value)
                     

write.csv(cbind(df, inad_alt, prod_ind),
          file = "series_economicas.csv",
          row.names = F)
