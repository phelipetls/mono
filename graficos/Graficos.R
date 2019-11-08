suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(cowplot))
suppressPackageStartupMessages(library(scales))

# -----------------------------------------------
df <- fread("../dados/series.csv") %>%
  as_tibble() %>%
  mutate(date = ymd(date)) %>%
  select(date, spread, selic, inad, igp, pib_mensal, ibc) %>%
  na.omit()

# -----------------------------------------------

intervalo <- c(min(df$date), NA)

theme_set(theme_cowplot())

plt <- ggplot(df) + labs(x = NULL, y = NULL) +
  scale_x_date(date_labels = "%Y",
               date_breaks = "1 year",
               minor_breaks = "1 month",
               limits = c(df$date %>% min, NA))

plt + geom_line(aes(date, spread / 100)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ggsave("Spread.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, igp)) +
  ggsave("IGP.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, igp)) +
  ggsave("Inflacao.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, selic / 100)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ggsave("Selic.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, inad)) +
  ggsave("Inadimplencia.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, pib_mensal)) +
  ggsave("PIB_Mensal.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, ibc)) +
  ggsave("IBC.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")
