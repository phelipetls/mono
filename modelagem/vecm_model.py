import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.api import VECM
from statsmodels.tsa.vector_ar.vecm import select_coint_rank, select_order
from statsmodels.stats.diagnostic import acorr_ljungbox

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0])
    .set_index("date")
    .drop(["icc"], axis="columns")
    .dropna()
)

endogenas = series.loc[:, ["spread", "selic", "inad", "pib_mensal"]]

series.loc["2011":"2014", "dummy"] = 1
exogenas = series.loc[:, ["igp"]].fillna(0)

print(
    select_order(endogenas, exog=exogenas, deterministic="colo", maxlags=12, seasons=12)
    .summary()
    .as_latex_tabular()
)

print(
    select_coint_rank(
        endog=endogenas, det_order=1, k_ar_diff=2, method="maxeig"
    ).summary()
)

model = VECM(
    endog=endogenas,
    exog=exogenas,
    deterministic="colo",
    k_ar_diff=2,
    coint_rank=1,
    dates=series.index,
    freq="MS",
    seasons=12,
    first_season=3
)
vecm = model.fit()
anos = np.datetime_as_string(endogenas.index.values[::12], unit="Y")
fig, axes = plt.subplots(
    endogenas.shape[1], 3,
    sharex="col",
    subplot_kw={"xticks": range(0, len(endogenas), 12), "xticklabels": anos},
    gridspec_kw={"hspace": 0.5}
)
for i in range(len(axes)):
    axes[i, 0].plot(endogenas.values[vecm.k_ar:, i])
    axes[i, 0].plot(vecm.fittedvalues[:, i], linestyle="--")
    axes[i, 1].plot(vecm.resid[:, i])
    plot_acf(vecm.resid[:, i], ax=axes[i, 2],
             title="Autocorrelação", lags=12)
plt.suptitle("Resíduos das equações do sistema")
fig.autofmt_xdate()
[axes[i, 0].title.set_text(endogenas.columns[i]) for i in range(len(axes))]
[axes[i, 1].title.set_text("Resíduos") for i in range(len(axes))]
[axes[i, 2].set_xticks(range(1, 13))]
[axes[i, 2].set_xticklabels(range(1, 13), rotation=0)]
vecm.summary()

print("lags, p-value")
for i in range(vecm.k_ar, 13):
    test = vecm.test_whiteness(i, adjusted=False)
    print(f'{i: 4}, {test.pvalue:.4f}')

acorr_ljungbox(vecm.resid[:, 0], lags=range(1, 13))
acorr_ljungbox(vecm.resid[:, 1], lags=range(1, 13))
acorr_ljungbox(vecm.resid[:, 2], lags=range(1, 13))
acorr_ljungbox(vecm.resid[:, 3], lags=range(1, 13))

vecm.irf(periods=36).plot()

print(vecm.test_normality().summary().as_latex_tabular())
