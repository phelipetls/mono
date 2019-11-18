import pandas as pd
from statsmodels.tsa.stattools import adfuller, kpss
from arch.unitroot import PhillipsPerron

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0])
    .set_index("date")
    .loc[:, ["spread", "selic", "pib_mensal", "inad", "igp", "ibc"]]
    .dropna()
)


def adf(serie, tipo, lag=False):
    results = adfuller(serie, maxlag=12, autolag="BIC", regression=tipo)
    if lag:
        return results[2]
    else:
        return results[1]


resultados = pd.concat(
    [
        series.apply(lambda x: adf(x, tipo="nc", lag=True), result_type="expand").T,
        series.apply(lambda x: adf(x, tipo="nc"), result_type="expand").T,
        series.apply(lambda x: adf(x, tipo="c"), result_type="expand").T,
        series.apply(lambda x: adf(x, tipo="ct"), result_type="expand").T,
    ],
    axis="columns",
)
resultados.columns = ["Defasagem"] + ["P-valor"] * 3

print(resultados.to_latex(float_format="{:0.2f}".format))


def pp(serie, tipo="nc", lag=False):
    results = PhillipsPerron(serie, trend=tipo)
    if lag:
        return results.lags
    else:
        return results.pvalue


resultados = pd.concat(
    [
        series.apply(lambda x: pp(x, tipo="nc", lag=True), result_type="expand").T,
        series.apply(lambda x: pp(x, tipo="nc"), result_type="expand").T,
        series.apply(lambda x: pp(x, tipo="c"), result_type="expand").T,
        series.apply(lambda x: pp(x, tipo="ct"), result_type="expand").T,
    ],
    axis="columns",
)
resultados.columns = ["Defasagem"] + ["P-valor"] * 3

print(resultados.to_latex(float_format="{:0.2f}".format))


def KPSS(serie, tipo, lag=False):
    results = kpss(serie, regression=tipo, lags="auto")
    if lag:
        return results[2]
    else:
        return results[1]


resultados = pd.concat(
    [
        series.apply(lambda x: KPSS(x, tipo="c", lag=True), result_type="expand").T,
        series.apply(lambda x: KPSS(x, tipo="c"), result_type="expand").T,
        series.apply(lambda x: KPSS(x, tipo="ct", lag=True), result_type="expand").T,
        series.apply(lambda x: KPSS(x, tipo="ct"), result_type="expand").T,
    ],
    axis="columns",
)
resultados.columns = ["Defasagem", "P-valor"] * 2

print(resultados.to_latex(float_format="{:0.2f}".format))
