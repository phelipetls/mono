import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.tsa.api import VECM
from statsmodels.tsa.vector_ar.vecm import select_coint_rank, coint_johansen, select_order

series = pd.read_csv("../dados/series_economicas_log.csv").drop("date", axis="columns")

series.columns

endog = ["spread", "selic", "inad", "ihh", "pib_mensal"]
endogenous_variables = series.loc[:, endog]

##### Order Selection #####

order_selection = select_order(, maxlags=3, deterministic="colo").summary()
print(order_selection)

##### Cointegration rank test #####

coint_rank = select_coint_rank(
    endog=endogenous_variables,
    k_ar_diff=1,
    det_order=1,
    signif=0.05,
    method="maxeig",
)
print(coint_rank)

##### VECM Estimation #####

vecm = VECM(endog=endogenous_variables, k_ar_diff=1, coint_rank=1, deterministic="colo")

vecm_results = vecm.fit()

vecm_irf = vecm_results.irf(12)
vecm_irf.plot()
plt.show()

vecm_results.summary()

vecm_results.var_rep[0]
