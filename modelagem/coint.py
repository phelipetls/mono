import pandas as pd
from statsmodels.tsa.stattools import coint
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.tsa.stattools import adfuller
from arch.unitroot import PhillipsPerron

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0]).set_index("date").dropna()
)

results = coint(
    series.spread,
    series.loc[:, ["selic", "inad", "ibc"]],
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

d_series = series.diff().dropna()

reg = smf.ols("spread ~ selic + inad + ibc", data=series).fit()
print(reg.summary())

adfuller(reg.resid)

reg_resid = reg.resid.shift(1).dropna()
reg_resid.name = "equilibrio"

sm.OLS(
    endog=d_series.spread,
    exog=pd.concat(
        [reg_resid, d_series.selic, d_series.inad, d_series.ibc], axis="columns"
    ),
).fit().summary()
