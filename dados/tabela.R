library(stargazer)
library(tidyverse)

df <- read_csv("./series_economicas.csv")

df %>% as.data.frame() %>%
  mutate(Compulsorio = Compulsorio / 1e+6) %>%
  select(Spread, Selic, Inadimplencia, IGP, ProducaoIndustrial_IPEADATA, Compulsorio, IHH) %>%
  rename("Atividade Econômica" = ProducaoIndustrial_IPEADATA,
         "IGP-DI" = IGP,
         "Inadimplência" = Inadimplencia,
         "Compulsório" = Compulsorio) %>%
  stargazer(decimal.mark = ",",
            digit.separate = 3,
            digits = 2, 
            nobs = F, 
            omit.summary.stat = c("p25", "p75"))
