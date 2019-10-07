library(tidyverse)
library(data.table)
library(lubridate)
library(cowplot)
library(scales)

# -----------------------------------------------
df <- fread("../dados/series_economicas.csv") %>%
  as_tibble() %>%
  mutate(date = ymd(date))

# -----------------------------------------------

intervalo <- c(min(df$date), NA)

theme_set(theme_cowplot())

plt <- ggplot(df) + labs(x = NULL, y = NULL) +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  theme(
    plot.caption = element_text(color = "black"),
    plot.title = element_text(hjust = 1 / 2)
  )

plt + geom_line(aes(date, spread / 100)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ggsave("Spread.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, ihh)) +
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
