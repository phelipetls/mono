import pandas as pd
from statsmodels.tsa.api import VAR
from itertools import combinations

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=["date"], index_col=["date"])
    .loc[:, ["spread", "selic", "inad", "ibc"]]
    .dropna()
)

var_model = VAR(endog=series).fit(maxlags=3, ic=None)

for C in combinations(series.columns, 2):
    print(
        f"{C[0]} -> {C[1]}",
        var_model.test_inst_causality(
            causing=C[0], caused=C[1]).test_statistic,
        var_model.test_inst_causality(causing=C[0], caused=C[1]).pvalue
    )
