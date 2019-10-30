import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.tsa.api import VECM
from statsmodels.tsa.vector_ar.vecm import select_coint_rank, coint_johansen, select_order

series = pd.read_csv("../dados/series_log.csv", parse_dates=[0]).set_index("date")

series.plot(subplots=True, layout=(3, 3))

endog = ["spread", "selic", "inad", "prod_ind"]
endogenous_variables = series.loc[:, endog].dropna()

##### Order Selection #####

order_selection = select_order(
    endogenous_variables,
    maxlags=12,
    deterministic="colo")
print(order_selection.summary())

##### Cointegration rank test #####

coint_rank = select_coint_rank(
    endog=endogenous_variables,
    k_ar_diff=2,
    det_order=1,
    signif=0.05,
    method="maxeig")
print(coint_rank)

##### VECM estimação  #####

vecm_results = VECM(endog=endogenous_variables,
                    k_ar_diff=2,
                    exog=series.igp[:-1],
                    coint_rank=1,
                    deterministic="colo").fit()
for i in range(1, 13):
    print(vecm_results.test_whiteness(i).summary())

#### Resultados ####

vecm_results.summary()

##### Diagnósticos #####


##### Impulso resposta #####

vecm_irf = vecm_results.irf(12)
vecm_irf.plot()
plt.show()
