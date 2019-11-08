import pandas as pd
from statsmodels.tsa.stattools import adfuller
from arch.unitroot import PhillipsPerron

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0])
    .set_index("date")
    .loc[:, ["spread", "selic", "pib_mensal", "igp"]]
)


def adf(serie, tipo, lag=False):
    results = adfuller(serie, maxlag=12, autolag="BIC", regression=tipo)
    if lag:
        return results[2]
    else:
        return results[0], results[4]["5%"]


resultados = pd.concat(
    [
        series.apply(lambda x: adf(x, tipo="nc", lag=True), result_type="expand").T,
        series.apply(lambda x: adf(x, tipo="nc"), result_type="expand").T,
        series.apply(lambda x: adf(x, tipo="c"), result_type="expand").T,
        series.apply(lambda x: adf(x, tipo="ct"), result_type="expand").T,
    ],
    axis="columns",
)
resultados.columns = ["Defasagem"] + ["Estatística", "Vl. Crítico"] * 3

print(resultados.to_latex(float_format="{:0.2f}".format))


def pp(serie, tipo="nc", lag=False):
    results = PhillipsPerron(serie, trend=tipo)
    if lag:
        return results.lags
    else:
        return results.stat, results.critical_values["5%"]


resultados = pd.concat(
    [
        series.apply(lambda x: pp(x, tipo="nc", lag=True), result_type="expand").T,
        series.apply(lambda x: pp(x, tipo="nc"), result_type="expand").T,
        series.apply(lambda x: pp(x, tipo="c"), result_type="expand").T,
        series.apply(lambda x: pp(x, tipo="ct"), result_type="expand").T,
    ],
    axis="columns",
)
resultados.columns = ["Defasagem"] + ["Estatística", "Vl. Crítico"] * 3


print(resultados.to_latex(float_format="{:0.2f}".format))
