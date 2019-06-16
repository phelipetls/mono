library(plyr)
library(tidyverse)
library(data.table)
library(lubridate)
library(rbcb)
library(ipeadatar)

setwd("~/Documentos/mono/dados")

# -----------------------------------------------
# Coletar dados do rbcb

data_inicial <- "2011-01-01"

series <- get_series(c(
  Spread = 20786,
  Selic = 4189,
  Inflacao = 433,
  Compulsorio = 1849,
  Inadimplencia = 21085,
  ProducaoIndustrial = 21859
), data_inicial, as = "tibble")

# -----------------------------------------------
# Ler dados de Herfindahl-Hirschmann

ihh <- read_csv2("ihh.csv") %>%
  arrange(date) %>%
  select(date, credito) %>%
  dplyr::rename(IHH = credito)

# -----------------------------------------------
# Dados do IPEADATA

inad_ipea <- ipeadata("BM12_CRLIN12") %>%
  select(date, value) %>%
  dplyr::rename(Inadimplencia_IPEADATA = value)

prodind_ipea <- ipeadata("PAN12_QIIGG12") %>%
  select(date, value) %>%
  dplyr::rename(ProducaoIndustrial_IPEADATA = value)

igp <- ipeadata("PAN12_IGPDIG12") %>%
  select(date, value) %>%
  dplyr::rename(IGP = value)

# ----------------------------------------------
# Juntar tudo num data.frame

series_df <- plyr::join_all(series)

df <- right_join(ihh, series_df, by = "date") %>%
  filter(date <= as.Date("2017-12-01")) %>%
  fill(IHH) %>%
  left_join(inad_ipea) %>%
  left_join(prodind_ipea) %>%
  left_join(igp)

# write.csv(df,
#   file = "series_economicas.csv",
#   row.names = F
# )
