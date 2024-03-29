suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(rbcb))
suppressPackageStartupMessages(library(ipeadatar))

setwd("~/Documentos/mono/dados")

# ----------------------------------------------
# Coletar dados do rbcb

data_inicial <- "2011-01-01"

series <- get_series(c(
  spread = 20786,
  selic = 4189,
  pib_mensal = 4380
), data_inicial, as = "tibble")

# ----------------------------------------------
# Concentração bancária (IHH)

IHH <- read_csv2("ihh.csv") %>%
  arrange(date) %>%
  dplyr::select(date, credito) %>%
  dplyr::rename(ihh = credito)

get_series(c(selic = 4189)) %>% write_csv("selic.csv")

# ----------------------------------------------
# Dados do IPEADATA

igp <-
  ipeadata("PAN12_IGPDIG12") %>%
  dplyr::select(date, value) %>%
  dplyr::rename(igp = value)

inad <-
  ipeadata("BM12_CRLIN12") %>%
  dplyr::select(date, value) %>%
  dplyr::rename(inad = value)

ibc <-
  ipeadata("SGS12_IBCBRDESSAZ12") %>%
  dplyr::select(date, value) %>%
  dplyr::rename(ibc = value)

# ----------------------------------------------
# Juntar tudo em um data.frame

series_df <-
  plyr::join_all(series) %>%
  left_join(inad) %>%
  left_join(igp) %>%
  left_join(ibc) %>%
  left_join(IHH) %>%
  fill(ihh)

# ----------------------------------------------
# Salvar em um csv

series_df %>%
  write.csv(file = "series.csv", row.names = F)

series_df %>%
  mutate_at(vars(spread, selic, inad, pib_mensal, ibc), log) %>%
  write.csv(file = "series_log.csv", row.names = F)
