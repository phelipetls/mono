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
# Concentração bancária (IHH)

IHH <- read_csv2("ihh.csv") %>%
  arrange(date) %>%
  select(date, credito) %>%
  dplyr::rename(ihh = credito)

# -----------------------------------------------
# Dados do IPEADATA

igp <- ipeadata("PAN12_IGPDIG12") %>%
  select(date, value) %>%
  dplyr::rename(igp_di = value)

inad <- ipeadata("BM12_CRLIN12") %>%
  select(date, value) %>%
  dplyr::rename(inad_ipea = value)

# ----------------------------------------------
# Juntar tudo num data.frame

df <- plyr::join_all(series) %>%
  left_join(inad) %>% left_join(igp) %>%
  left_join(IHH) %>% fill(ihh) %>%
  filter(date <= max(IHH$date))

# ----------------------------------------------
# Salvar em um csv

write.csv(df, file = "series_economicas.csv", row.names = F)

write.csv(df %>% mutate_at(vars(-date, -ihh, -igp_di), log),
          file = "series_economicas_log.csv", row.names = F)
