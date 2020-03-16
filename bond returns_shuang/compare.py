# -*- coding: utf-8 -*-
"""
Created on Mon Mar  9 18:56:45 2020

@author: ShuangZhao
"""

# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

return_quandl=pd.read_csv('Bond_return_quandl.csv')
return_FRB=pd.read_csv('Bond_return_FRB.csv')

return_FRB=return_FRB.iloc[1:-1,:]
return_quandl=return_quandl.iloc[8:,:]
compare=pd.DataFrame()
compare['FRB']=return_FRB['10Y']
compare['quandl']=return_quandl['SVENY10']
compare=compare.set_index(return_FRB['Date'])
compare['date']=compare.index
for i in compare.index:
    compare['date'][i]=datetime.strptime(compare['date'][i],'%Y-%m-%d')
compare=compare.set_index('date')
compare=compare.dropna(axis=0,how='any')
compare=compare
plt.figure()
plt.plot(compare.index,compare['FRB']-compare['quandl'])
plt.savefig("returns.png",dpi=500,bbox_inches = 'tight')
#plt.plot(compare.index.values.year,compare['quandl'])
#plt.legend(['FRB','quandl'])
#plt.show()
#plt.savefig("returns.png",dpi=500,bbox_inches = 'tight')
