# -*- coding: utf-8 -*-
"""
Created on Tue Mar 17 03:08:14 2020

@author: ShuangZhao
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
from sklearn.linear_model import LinearRegression
import statsmodels.api as sm
from sklearn.metrics import r2_score
#%%
# import and processing data
############################################################
return1=pd.read_csv('Australian_return.csv')
factor1=pd.read_csv('Australian_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
Australian=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('Canada_return.csv')
factor1=pd.read_csv('Canada_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
Canada=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('China_return.csv')
factor1=pd.read_csv('China_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
China=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('France_return.csv')
factor1=pd.read_csv('France_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
France=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('German_return.csv')
factor1=pd.read_csv('German_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
German=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('Italy_return.csv')
factor1=pd.read_csv('Italy_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
Italy=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('Japan_return.csv')
factor1=pd.read_csv('Japan_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
Japan=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('South_korea_return.csv')
factor1=pd.read_csv('South_korea_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
South_korea=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('Spain_return.csv')
factor1=pd.read_csv('Spain_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
Spain=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('Swiss_return.csv')
factor1=pd.read_csv('Swiss_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
Swiss=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('UK_return.csv')
factor1=pd.read_csv('UK_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
UK=factor1.dropna(axis=0,how='any')
############################################################
return1=pd.read_csv('US_return.csv')
factor1=pd.read_csv('US_forward.csv')
return1['Dates']=return1['Dates'].astype('str')
factor1['Dates']=factor1['Dates'].astype('str')
for i in return1.index:
    return1['Dates'][i]=datetime.strptime(return1['Dates'][i],'%Y-%m-%d')
for i in factor1.index:
    factor1['Dates'][i]=datetime.strptime(factor1['Dates'][i],'%Y-%m-%d')
return1=return1.set_index('Dates')
factor1=factor1.set_index('Dates')
return1=return1.shift(-1,axis=0)
return1=return1.loc[factor1.index]
factor1['return']=return1['10Y']
US=factor1.dropna(axis=0,how='any')
############################################################

#%%
US=US.loc[US.index.year>=1995]
US=US.iloc[:-1,:]
US.index=German.index
Australian=Australian.loc[Australian.index.year>=1995]
country=[Australian,Canada,France,German,Italy,Japan, South_korea, Swiss,UK,US]
country_name=['Australian','Canada','France','German','Italy','Japan', 'South_korea', 'Swiss','UK','US']
# basic regression

#%%future returns
future_returns = pd.read_excel('future_monthly.xlsx')
future_returns['Dates'] = future_returns['Dates'].astype(str)
future_returns['Dates'] = future_returns['Dates'].apply(lambda x:datetime.strptime(x, '%Y%m%d'))
future_returns = future_returns.set_index('Dates')
future_returns = future_returns.shift(-1,axis=0)
future_returns = future_returns.iloc[:-2,:]
future_returns = future_returns.loc[future_returns.index.year>=1995]
future_returns.index = German.index

for i in range(len(country)):
    name = country_name[i]
    df = country[i]
    country[i]['future_return']= future_returns.loc[df.index][name]

France = France.dropna(axis=0,how='any')
Italy = Italy.dropna(axis=0,how='any')
South_korea = South_korea.dropna(axis=0,how='any')
#%% riskfree
rf=pd.read_csv('fama_french.csv')
rf['Dates']=rf['Dates'].astype(str)
rf['Dates']=rf['Dates'].apply(lambda x:datetime.strptime(x, '%Y%m'))
rf=rf.iloc[823:,:]
rf=rf.set_index('Dates')
rf.index=German.index
rf=(rf/100).astype(np.float64)

for df in country:
    df['total_return']=df['future_return']+rf.loc[df.index]['RF']

#%%
for df in country:
    #for out of sample, expanding window
    n=60
    pre1=np.zeros(len(df))
    pre2=np.zeros(len(df))
    for i in range(n,len(df)):
        Y=(df['future_return']).values[:i]
        X1=df.iloc[:i,:-4].values
        X2=df['spread'].values[:i].reshape(-1,1)
        lr1=LinearRegression().fit(X1,Y)
        lr2=LinearRegression().fit(X2,Y)
        #CP
        pre1[i]=lr1.predict(df.values[i,:-4].reshape(1,-1))[0]
        #fama-bliss
        pre2[i]=lr2.predict(df['spread'].values[i].reshape(1,-1))[0]
    df['pre_CP']=pre1
    df['pre_FB']=pre2
#%%
CP=pd.DataFrame()
CP['Dates']=German.index
FB=pd.DataFrame()
FB['Dates']=German.index
returns=pd.DataFrame()
returns['Dates']=German.index
for i in range(len(country)):
    df=country[i]
    cp1=pd.DataFrame()
    cp1['Dates']=df.index
    cp1[country_name[i]]=df['pre_CP'].values
    fb1=pd.DataFrame()
    fb1['Dates']=df.index
    fb1[country_name[i]]=df['pre_FB'].values
    return01=pd.DataFrame()
    return01['Dates']=df.index
    return01[country_name[i]]=df['total_return'].values
    CP=pd.merge(CP,cp1,on='Dates',how='outer')
    FB=pd.merge(FB,fb1,on='Dates',how='outer')
    returns=pd.merge(returns,return01,on='Dates',how='outer')
#%%    
returns=returns.set_index('Dates')
returns=returns.fillna(0)
FB=FB.set_index('Dates')
FB=FB.sort_index()
FB=FB.loc[FB.index.year>=2003]
FB=FB.fillna(-1)
returns_FB=returns.loc[FB.index]
holding1=(FB>np.dot(np.ones([np.shape(FB)[1],1]),FB.quantile(q=2/3,axis=1).values.reshape(1,-1)).T)
Portfolio_FB=returns_FB*holding1
Portfolio_FB=Portfolio_FB.sum(axis=1)/holding1.sum(axis=1)
#%%
CP=CP.set_index('Dates')
CP=CP.sort_index()
CP=CP.loc[CP.index.year>=2003]
CP=CP.fillna(-1)
b=CP
returns_CP=returns.loc[CP.index]
holding2=(CP>np.dot(np.ones([np.shape(FB)[1],1]),CP.quantile(q=2/3,axis=1).values.reshape(1,-1)).T)
Portfolio_CP=returns_CP*holding2
p2=returns_FB*holding2
Portfolio_CP=Portfolio_CP.sum(axis=1)/holding2.sum(axis=1)
p2=(1+Portfolio_CP).cumprod()
EW=returns_CP.sum(axis=1)/(returns_CP!=0).sum(axis=1)

r2=np.zeros([np.shape(CP)[1],1])
for i in range(np.shape(CP)[1]):
    r2[i]=r2_score(CP.iloc[:,i].values.reshape(-1,1),returns_CP.iloc[:,i].values.reshape(-1,1))
#%%
plt.figure()
plt.plot(EW.index,(1+EW.values).cumprod())
plt.plot(EW.index,(1+Portfolio_CP.values).cumprod())
plt.plot(EW.index,(1+Portfolio_FB.values).cumprod())
plt.legend(['EW','CP','FB'])
plt.show()
