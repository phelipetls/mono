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
  pib_mensal = 4380
), data_inicial, as = "tibble")

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

df <- plyr::join_all(series) %>%
  left_join(inad_ipea) %>%
  left_join(igp)

write.csv(df,
  file = "series_economicas.csv",
  row.names = F
)
