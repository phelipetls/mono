import pandas as pd
import numpy as np
import statsmodels.tsa.vector_ar.vecm as VECM

series = pd.read_csv("../dados/series_economicas_log.csv").drop('date', axis = 'columns')

var = VECM.VAR(series)
