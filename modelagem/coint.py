import pandas as pd
from statsmodels.tsa.stattools import coint

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0]).set_index("date")
)

coint_vars = (
    series.loc[:, ["spread", "selic", "inad", "ibc"]]
    .dropna()
)

results = coint(
    coint_vars.spread,
    coint_vars.iloc[:, 1:],
    trend="ct",
    maxlag=12,
    autolag="BIC",
)

print(results)


def join_numbers(L):
    rounded = []
    for item in L:
        try:
            rounded.append(round(item, 2))
        except TypeError:
            rounded.extend([round(value, 2) for value in item])
    return " & ".join(map(str, rounded))


print(join_numbers(results))
