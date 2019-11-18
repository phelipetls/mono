import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.api import VECM
from statsmodels.tsa.vector_ar.vecm import select_coint_rank
from matplotlib.ticker import FuncFormatter

series = (
    pd.read_csv("../dados/series_log.csv", parse_dates=[0])
    .set_index("date")
    .dropna()
)

# endogenas = series.loc[:, ["spread", "selic", "ibc", "inad"]]
endogenas = series.loc[:, ["selic", "inad", "ibc", "spread"]]
exogenas = series.loc[:, ["igp"]].fillna(0)

print(
    select_coint_rank(endog=endogenas, det_order=1, k_ar_diff=2, method="trace")
    .summary()
    .as_latex_tabular()
)

model = VECM(
    endog=endogenas,
    exog=exogenas,
    deterministic="co",
    k_ar_diff=2,
    coint_rank=1,
    dates=series.index,
    freq="MS",
    seasons=12,
    first_season=3
)

vecm = model.fit()

print(vecm.summary())

print(vecm.summary().as_latex())


def impulso_resposta(ortogonal=True):
    for resposta in vecm.names:
        for impulso in vecm.names:
            fig = vecm.irf(periods=24).plot(
                response=resposta,
                impulse=impulso,
                orth=ortogonal
            )
            plt.gca().set_title("")
            plt.gca().set_xticklabels(plt.gca().get_xticks(), {"size": 16})
            plt.gca().set_yticklabels(plt.gca().get_yticks(), {"size": 16})
            plt.gca().xaxis.set_major_formatter(FuncFormatter(lambda x, _: '{:.0f}'.format(x)))
            plt.gca().yaxis.set_major_formatter(FuncFormatter(lambda y, _: '{:.1f}'.format(y)))
            fig.suptitle("")
            fig.set_figheight(3)
            fig.set_figwidth(6)
            plt.tight_layout()
            plt.savefig(
                "../graficos/irf/orth_" + resposta + "_" + impulso + ".pdf"
                if ortogonal
                else "../graficos/irf/" + resposta + "_" + impulso + ".pdf",
                dpi=300
            )


impulso_resposta()
impulso_resposta(False)
plt.close("all")

vecm.irf(periods=24).plot(orth=True)
plt.gcf().tight_layout()
plt.gcf().suptitle("")
plt.gcf().savefig("../graficos/irf/irf_orth_completo.pdf")

vecm.irf(periods=24).plot(orth=False)
plt.gcf().suptitle("")
plt.gcf().tight_layout()
plt.gcf().savefig("../graficos/irf/irf_completo.pdf")
