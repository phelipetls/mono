import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.tsa.api import VAR

series = pd.read_csv("../dados/series_log.csv")

# tratamento das séries
# extraindo os resíduos da reg. pib_mensal ~ 1 + trend
series["pib_mensal"] = sm.OLS(
    series.pib_mensal, pd.DataFrame({"const": 1, "trend": range(1, len(series) + 1)})
).fit().resid

# primeira diferença das variáveis não-estacionárias
for col in ["spread", "selic", "inad", "igp", "ihh"]:
    series[col] = series.loc[:, col].diff()

# selecionando as variáveis endógenas e exógenas
endog_vars = ["spread", "selic", "pib_mensal", "inad", "ihh"]
exog_vars = ["igp"]

# se usando ihh
series["date"] = pd.to_datetime(series.date)
if "ihh" in endog_vars:
    series = series.query('date.dt.year <= 2017')

# ignorar na
series = series.loc[:, endog_vars + exog_vars].dropna()

# estimando o VAR
model = VAR(endog=series.loc[:, endog_vars], exog=series.loc[:, exog_vars])

print(model.select_order(12))
print(model.select_order(12).summary())

number_of_lags = 1
results = model.fit(number_of_lags, trend="c")

results.summary()

# teste estabilidade
results.is_stable(True)

# teste autocorrelação residual
print(results.test_whiteness(nlags=number_of_lags + 1).summary())

results.plot_acorr(resid=True, nlags=12)
plt.show()

results.resid_corr

# função de impulso resposta
results.irf(12).plot()
plt.show()

results.irf(12).plot(orth=False)
plt.show()
