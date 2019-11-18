import pandas as pd
from statsmodels.tsa.api import VAR
from  statsmodels.tsa.vector_ar.vecm import select_order

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=["date"], index_col=["date"])
    .loc[:, ["spread", "selic", "inad", "ibc"]]
    .dropna()
)

var = VAR(endog=series)
var_model = var.fit(maxlags=4, verbose=True)
print(var_model.test_whiteness(nlags=12).summary())

print(var.select_order(12).summary())

print(" & ".join(series.columns))
for linha in series.columns:
    resultados = []
    for coluna in series.columns:
        test = var_model.test_causality(caused=linha, causing=coluna, kind="wald")
        if coluna == linha:
            resultados.append(" - & - ")
        else:
            resultados.append(f"{test.test_statistic:.3f} & {test.pvalue:.3f}")
    print(linha + " & " + " & ".join(resultados))

total = []
for linha in series.columns:
    resultados_total = var_model.test_causality(
        causing=[serie for serie in series.columns if serie != linha],
        caused=linha,
        kind="wald"
    )
    total.append(f"{resultados_total.test_statistic:.3f} & {resultados_total.pvalue:.3f}")
print("total & " + " & ".join(total))
