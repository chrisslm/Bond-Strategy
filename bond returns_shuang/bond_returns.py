# -*- coding: utf-8 -*-
"""
Created on Mon Mar  9 15:40:50 2020

@author: ShuangZhao
"""
import numpy as np
import pandas as pd
from datetime import datetime

# import data
# for quandl data, counpounded zero cupon bonds

data=pd.read_csv('FED-SVENY -monthly.csv')
data['Date']=data['Date'].astype('str')
for i in data.index:
    data['Date'][i]=datetime.strptime(data['Date'][i],'%Y-%m-%d')
data=data.set_index('Date')
data=data.sort_index()
Y=data/100

#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array(range(1,31))-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R.to_csv('Bond_return_quandl.csv')
data.to_csv('Yield_quandl.csv')
'''
# for US treasury bond yields
data=pd.read_csv('FRB_H15.csv')
data=data.set_index('Series Description')
data=data.iloc[5:,3:]
data.columns=['1Y','2Y','3Y','5Y','7Y','10Y','20Y','30Y']
data['Date']=data.index
for i in data.index:
    data['Date'][i]=datetime.strptime(data['Date'][i],'%Y/%m/%d')
data=data.set_index('Date')
data[data.isin(['ND'])]=np.nan
data=data.astype(np.float64)
data=data.dropna(axis=0,how='all')
data=data.loc[data.index[data.index.month.values!=np.hstack([data.index.month.values[1:],[12]])]]
Y=data/100
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([1,2,3,5,7,10,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R.to_csv('Bond_return_FRB.csv')
data.to_csv('Yield_FRB.csv')
'''