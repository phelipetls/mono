library(tidyverse)
library(data.table)
library(lubridate)
library(ggthemes)
library(cowplot)

setwd("~/mono/dados")

# -----------------------------------------------
df <- fread("series.csv") %>% as_tibble %>% 
  mutate(date = ymd(date))

# -----------------------------------------------

intervalo <- c(min(df$date), NA)

plt <- ggplot(df) + labs(x = NULL, y = NULL) +
       scale_x_date(date_labels = "%Y",
                    date_breaks = "1 year") +
       theme(plot.caption = element_text(color = "black"),
             plot.title = element_text(hjust = 1/2))

plt + geom_line(aes(date, Spread)) +
      labs(title = "Spread",
           subtitle = "Spread médio das operações de crédito com recursos livres - Total",
           caption = "\nFonte: série 20786 do SGS")

plt + geom_line(aes(date, IHH)) +
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
