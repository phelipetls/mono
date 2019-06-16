library(tidyverse)
library(data.table)
library(lubridate)
library(cowplot)
library(scales)

# -----------------------------------------------
df = fread("../dados/series_economicas.csv") %>%
  as_tibble() %>%
  mutate(date = ymd(date))

# -----------------------------------------------

intervalo <- c(min(df$date), NA)

plt <- ggplot(df) + labs(x = NULL, y = NULL) +
  scale_x_date(
    date_labels = "%Y",
    date_breaks = "1 year"
  ) +
  theme(
    plot.caption = element_text(color = "black"),
    plot.title = element_text(hjust = 1 / 2)
  )

plt + geom_line(aes(date, Spread / 100)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ggsave("Spread.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, IHH)) +
  ggsave("IHH.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, Inflacao)) +
  ggsave("Inflacao.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, Selic / 100)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ggsave("Selic.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, Inadimplencia)) +
  ggsave("Inadimplencia.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, Compulsorio/1e+6)) + 
  scale_y_continuous(labels = scales::comma_format(prefix = "R$", big.mark = ".", decimal.mark = ",")) +
  ggsave("Compulsorio.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, ProducaoIndustrial_IPEADATA)) +
  ggsave("ProducaoIndustrial_IPEADATA.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")

plt + geom_line(aes(date, IGP)) +
  ggsave("IGP.pdf", device = cairo_pdf, dpi = 300, height = 7, units = "cm")
