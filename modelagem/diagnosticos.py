# Diagnósticos

# print(vecm.test_whiteness(12, adjusted=False).summary().as_latex_tabular())

# print(vecm.test_normality().summary().as_latex_tabular())

# VAR(endog=endogenas, exog=exogenas, dates=series.index, freq="MS").fit(
#     maxlags=3, ic=None, trend="c"
# ).resid_acorr()


# anos = np.datetime_as_string(endogenas.index.values[::12], unit="Y")
# fig, axes = plt.subplots(
#     endogenas.shape[1], 3,
#     sharex="col",
#     figsize=(15, 5),
#     subplot_kw={"xticks": range(0, len(endogenas), 12), "xticklabels": anos},
#     gridspec_kw={"hspace": 0.5}
# )
# for i in range(len(axes)):
#     axes[i, 0].plot(endogenas.values[vecm.k_ar:, i])
#     axes[i, 0].plot(vecm.fittedvalues[:, i], linestyle="--")
#     axes[i, 1].plot(vecm.resid[:, i])
#     plot_acf(vecm.resid[:, i], ax=axes[i, 2],
#              title="Autocorrelação", lags=12)
# # plt.suptitle("Resíduos das equações do sistema")
# fig.autofmt_xdate()
# [axes[i, 0].title.set_text(endogenas.columns[i]) for i in range(len(axes))]
# [axes[i, 1].title.set_text("Resíduos") for i in range(len(axes))]
# [axes[i, 2].set_xticks(range(1, 13))]
# [axes[i, 2].set_xticklabels(range(1, 13), rotation=0)]
# fig.savefig("../graficos/plot_residuos.pdf")
