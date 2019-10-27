library(stargazer)
library(tidyverse)

setwd("~/Documentos/mono/dados/")
df <- read_csv("series.csv")

df %>% as.data.frame() %>%
  stargazer(decimal.mark = ",",
            digit.separate = 3,
            digits = 2,
            nobs = F,
            omit.summary.stat = c("p25", "p75"))
