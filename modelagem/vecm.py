import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.api import VECM
from statsmodels.tsa.vector_ar.vecm import select_coint_rank, select_order

series = (pd.read_csv("../dados/series_log.csv", parse_dates=[0])
          .set_index("date")
          .dropna())

series.plot(subplots=True, layout=(3, 3))

endog = ["spread", "selic", "inad", "prod_ind"]
endog_vars = series.loc[:, endog]

if "ihh" in endog_vars:
    series = series.query('date.dt.year <= 2017')

##### Order Selection #####

order_selection = select_order(
    endog_vars,
    maxlags=12,
    deterministic="colo")
print(order_selection.summary())

##### Cointegration rank test #####

coint_rank = select_coint_rank(
    endog=endog_vars,
    k_ar_diff=12,
    det_order=1,
    signif=0.05,
    method="maxeig")
print(coint_rank)

##### VECM estimação  #####

vecm_results = VECM(endog=endog_vars,
                    k_ar_diff=2,
                    coint_rank=1,
                    deterministic="colo").fit()
for i in range(1, 13):
    print(vecm_results.test_whiteness(i).summary())

#### Resultados ####

# vecm_results.summary()

##### Impulso resposta #####

# vecm_irf = vecm_results.irf(12)
# vecm_irf.plot()
# plt.show()
