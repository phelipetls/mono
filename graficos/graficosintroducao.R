suppressPackageStartupMessages(library(cowplot))
suppressPackageStartupMessages(library(WDI))
suppressPackageStartupMessages(library(countrycode))
suppressPackageStartupMessages(library(tidyverse))

spread <- WDI(indicator = c("spread" = "FR.INR.LNDP"),
              start = 2018, end = 2018, extra = T) %>% as_tibble() %>%
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
  geom_text(aes(label = paste0(round(spread, 1), "%")), nudge_y = .015) +
  coord_flip() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     expand = expand_scale(mult = c(0, 0.05))) +
  labs(x = NULL, y = NULL) + 
  theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm")) +
  theme_minimal_vgrid() +
  ggsave("spread_AL.pdf", height = 7, units = "cm")
