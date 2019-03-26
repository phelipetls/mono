library(tidyverse)
library(data.table)
library(lubridate)
library(ggplot2)
library(ggthemes)
library(cowplot)

setwd("~/mono/dados")

# -----------------------------------------------
df <- fread("series.csv")[, -1] %>% as_tibble %>% 
  mutate(date = ymd(date))

# -----------------------------------------------

date_limit <- c(min(df$date), max(df$date))

plt <- ggplot(df) + labs(x = NULL, y = NULL) +
       scale_x_date(limits = date_limit,
                    date_labels = "%Y",
                    date_breaks = "1 year")

plt + geom_line(aes(date, Spread)) +
      ggtitle("Spread",
              "Spread médio das operações de crédito com recursos livres - Total") +
      ggsave("Spread.png")

plt + geom_line(aes(date, ihh)) +
      ggtitle("Índice de Herfindahl-Hirschmann")

plt + geom_line(aes(date, Inflacao)) +
      ggtitle("Inflação",
              "Índice nacional de preços ao consumidor-amplo (IPCA)")

plt + geom_line(aes(date, Selic)) +
      ggtitle("Selic",
              "Taxa de juros - Selic acumulada no mês anualizada base 252")

plt + geom_line(aes(date, Inadimplencia)) +
      ggtitle("Inadimplência",
              "Inadimplência da carteira de crédito - Total")

plt + 
