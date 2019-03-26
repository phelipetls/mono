library(tidyverse)
library(data.table)
library(lubridate)
library(rbcb)
library(ipeadatar)
library(plyr)

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
  dplyr::rename(IHH = ativos)


# -----------------------------------------------
# Dados do IPEADATA

intervalo <- c(as.Date(min(df$date)), as.Date(max(df$date)))

inad_alt <- ipeadata("BM12_CRLIN12") %>%
            filter(date >= as.Date(min(df$date)),
                 date <= as.Date(max(df$date))) %>% 
            select(value) %>% 
            dplyr::rename(InadimplenciaIPEADATA = value)

prod_ind <- ipeadata("PAN12_QIIGG12") %>% 
            filter(date >= as.Date(min(df$date)),
                   date <= as.Date(max(df$date))) %>%
            select(value) %>% 
            dplyr::rename(ProducaoIndustrialIPEADATA = value)
                     

# -----------------------------------------------
# Agregar dados

# ----------------------------------------------
# Juntar tudo num data.frame

series_df <- plyr::join_all(series)

df <- right_join(ihh, series_df, by = "date") %>%
      filter(date <= as.Date("2017-12-01")) %>% 
      as_tibble %>%
      fill(IHH) %>% bind_cols(inad_alt, prod_ind)

write.csv(cbind(df, inad_alt, prod_ind),
          file = "series_economicas.csv",
          row.names = F)
