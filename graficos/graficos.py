import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0])
    .set_index("date")
    .loc[:, ["spread", "selic", "inad", "pib_mensal", "ibc", "igp"]]
    .dropna()
)

fig, axes = plt.subplots(3, 2)
for ax, serie in zip(axes.flat, series):
    ax.plot(series[serie], color="black", label=serie)
    ax.set_xlabel("")
    ax.legend(loc="upper left", fontsize="small")
    ax.xaxis.set_minor_locator(mdates.MonthLocator())
    ax.set_xlim(min(series.index), max(series.index))
fig.autofmt_xdate()
fig.tight_layout()
plt.savefig("series_modelo.pdf", figsize=(8, 8))

series_nivel = (
    pd.read_csv("../dados/series.csv", parse_dates=[0])
    .set_index("date")
    .loc[:, ["spread", "selic", "inad", "pib_mensal", "ibc", "igp"]]
    .dropna()
)

for serie in series_nivel:
    fig, ax = plt.subplots()
    ax.plot(series[serie], label=serie, color="black")
    ax.xaxis.set_minor_locator(mdates.MonthLocator())
    ax.set_xlim(min(series.index), max(series.index))
    if serie == "spread":
        ax.set_yticklabels(["{:.1%}".format(value / 10) for value in ax.get_yticks()])
    elif serie == "selic":
        ax.set_yticklabels(["{:.0%}".format(value) for value in ax.get_yticks()])
    fig.autofmt_xdate()
    fig.tight_layout()
    plt.savefig(serie + ".pdf", figsize=(8, 3))


