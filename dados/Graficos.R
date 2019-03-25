library(rbcb)
library(ggplot2)

setwd("~/mono/dados")

# -----------------------------------------------
# Coletar séries

data_inicial = "2011-01-01"

series = get_series(c(
  Spread = 20786,
  Selic = 4189,
  Inflacao = 433,
  Compulsorio = 1849,
  Inadimplencia = 21082), data_inicial, as = "tibble")


# -----------------------------------------------
# Criando uma função para plotar todos de uma vez
par(mfrow = c(2, 3))

plot_all <- function(SERIES) {
  for (i in 1:length(SERIES)) {

    serie = SERIES[[i]]

        plot(serie,
        type = "l",
        main = names(SERIES)[i],
        xlab = "", ylab = "")

  }
}

plot_all(series)



# ----------------------------------------------
# Criando uma função para salvar cada um por vez

plot_and_save <- function(SERIES) {
  for (i in 1:length(SERIES)) {

    serie = SERIES[[i]]

    ggplot(serie, aes(serie[[1]], serie[[2]])) +
    geom_line() +
    labs(x = NULL, y = NULL,
         title = names(SERIES)[i]) +
    theme_bw()

    ggsave(paste0(names(SERIES)[i], ".png"),
           device = "png",
           path = getwd(),
           dpi = 300)

    }
}

plot_and_save(series)
