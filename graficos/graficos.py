import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.ticker import FuncFormatter

# subplots de todas as séries como usadas no modelo
series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0])
    .set_index("date")
    .loc[:, ["spread", "selic", "inad", "ibc", "igp"]]
    .dropna()
)

axes = series.plot(subplots=True, layout=(3, 2), figsize=(9, 7), color="black", linewidth=1)
for ax in axes.flat:
    ax.legend(loc="upper left", fontsize="small")
    ax.set_xlabel("")
plt.gcf().tight_layout()
plt.gcf().savefig("../graficos/series_modelo.pdf", dpi=300)

# graficos diferente para cada serie em nível
series_nivel = (
    pd.read_csv("../dados/series.csv", parse_dates=[0])
    .set_index("date")
    .loc[:, ["spread", "selic", "inad", "pib_mensal", "ibc", "igp", "ihh"]]
    .dropna()
)

for serie in series_nivel:
    fig, ax = plt.subplots(figsize=(7, 3))
    ax.plot(series_nivel[serie], label=serie, color="black", linewidth=1)
    ax.xaxis.set_minor_locator(mdates.MonthLocator())
    ax.set_xlim(min(series_nivel.index), max(series_nivel.index))
    if serie in ["spread", "selic"]:
        ax.yaxis.set_major_formatter(FuncFormatter(lambda y, _: '{:.0%}'.format(y / 100)))
    if serie in ["inad"]:
        ax.yaxis.set_major_formatter(FuncFormatter(lambda y, _: '{:.1%}'.format(y / 100)))
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    fig.autofmt_xdate()
    fig.tight_layout()
    fig.savefig(serie + ".pdf", clear=True, dpi=300)
