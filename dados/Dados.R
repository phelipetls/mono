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
  spread = 20786,
  selic = 4189,
  inflacao = 433,
  compuls = 1849,
  inad = 21085,
  pib_mensal = 4380
), data_inicial, as = "tibble")

# -----------------------------------------------
# Ler dados de Herfindahl-Hirschmann

ihh <- read_csv2("ihh.csv") %>%
  arrange(date) %>%
  select(date, credito) %>%
  dplyr::rename(ihh = credito)

# -----------------------------------------------
# Dados do IPEADATA

igp <- ipeadata("PAN12_IGPDIG12") %>%
  select(date, value) %>%
  dplyr::rename(igp_di = value)

inad_ipea <- ipeadata("BM12_CRLIN12") %>%
  select(date, value) %>%
  dplyr::rename(inad_ipea = value)


# ----------------------------------------------
# Juntar tudo num data.frame

series_df <- plyr::join_all(series)

df <- right_join(ihh, series_df, by = "date") %>%
  filter(date <= as.Date("2017-12-01")) %>%
  fill(ihh) %>%
  left_join(inad_ipea) %>%
  left_join(igp)

write.csv(df,
  file = "series_economicas.csv",
  row.names = F
)
