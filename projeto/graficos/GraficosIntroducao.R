library(cowplot)
library(WDI)
library(countrycode)
library(tidyverse)

spread <- WDI(indicator = c("spread" = "FR.INR.LNDP"),
              start = 2017, end = 2017, extra = T) %>% as_tibble() %>%
          rename("code" = iso2c) %>%
          select(year, code, country, spread, everything()) %>%
          arrange(spread %>% desc)

ALnames <- c("Brasil", "Paraguai", "Guiana", "Jamaica", "Honduras", "Argentina", "Nicarágua", "Uruguai", "Costa Rica", "Barbados")

spread %>%
  filter(region == "Latin America & Caribbean") %>%
  top_n(10, wt = spread) %>%
  mutate(country = fct_recode(ALnames)) %>%
  ggplot(aes(x = country %>% fct_reorder(spread),
             y = spread / 100)) +
  geom_col() + 
  coord_flip() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
  labs(x = NULL, y = NULL) + 
  theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm")) +
  ggsave("spread_AL.pdf", height = 7, units = "cm")

