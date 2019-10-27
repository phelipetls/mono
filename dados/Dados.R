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
  select(date, credito) %>%
  dplyr::rename(ihh = credito)

# ----------------------------------------------
# Dados do IPEADATA

igp <-
  ipeadata("PAN12_IGPDIG12") %>%
  select(date, value) %>%
  dplyr::rename(igp = value)

inad <-
  ipeadata("BM12_CRLIN12") %>%
  select(date, value) %>%
  dplyr::rename(inad = value)

prod_ind <-
  ipeadata("PAN12_QIIGG12") %>%
  select(date, value) %>%
  dplyr::rename(prod_ind = value)

# ----------------------------------------------
# Juntar tudo em um data.frame

series_df <-
  plyr::join_all(series) %>%
  left_join(inad) %>%
  left_join(igp) %>%
  left_join(prod_ind) %>%
  left_join(IHH) %>% fill(ihh)

# ----------------------------------------------
# Salvar em um csv

series_df %>%
  write.csv(file = "series.csv", row.names = F)

series_df %>%
  mutate_if(function(x) all(x > 0) && !is.Date(x), log) %>%
  write.csv(file = "series_log.csv", row.names = F)
