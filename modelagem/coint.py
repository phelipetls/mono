import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.tsa.stattools import coint
from statsmodels.stats.stattools import durbin_watson, jarque_bera
from statsmodels.iolib.summary2 import summary_col, summary_model
from statsmodels.tsa.stattools import adfuller, kpss
from statsmodels.stats.diagnostic import het_white
from arch.unitroot import PhillipsPerron as pp
from stargazer.stargazer import Stargazer

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0]).set_index("date").dropna()
)

series["tendencia"] = range(1, len(series)+1)

results = coint(
    series.spread,
    series.loc[:, ["selic", "inad", "pib_mensal"]],
    trend="c",
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

reg_info = {
    "Observações": lambda x: x.nobs,
    "R^2": lambda x: x.rsquared,
    "R^2 Ajustado": lambda x: x.rsquared_adj,
    "Estatística F": lambda x: f"{x.fvalue:.3f} ({x.f_pvalue:.3f})",
    "Jarque-Bera": lambda x: f"{jarque_bera(x.resid)[0]:.3f} ({jarque_bera(x.resid)[1]:.3f})",
    "Dickey-Fuller": lambda x: f"{adfuller(x.resid, maxlag=1, autolag=None)[0]:.3f} ({adfuller(x.resid, maxlag=1, autolag=None)[1]:.3f})",
    "Durbin-Watson": lambda x: f"{durbin_watson(x.resid):.3f}"
}

print(summary_col([reg], stars=True, info_dict=reg_info).as_latex())

print(Stargazer([reg]).render_latex())

reg_resid = reg.resid.shift(1).dropna()
reg_resid.name = "equilibrio"

y = d_series.spread,
X = pd.concat([reg_resid, d_series.selic, d_series.inad, d_series.ibc], axis="columns")

ecm = sm.OLS(
    endog=d_series.spread,
    exog=pd.concat(
        [reg_resid, d_series.selic, d_series.inad, d_series.ibc], axis="columns"
    ),
).fit()

print(summary_col([ecm], stars=True, info_dict=reg_info).as_latex())
