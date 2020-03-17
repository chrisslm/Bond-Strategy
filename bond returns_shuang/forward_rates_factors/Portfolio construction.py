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
country=[Australian,Canada,China,France,German,Italy,Japan, South_korea,Spain, Swiss,UK,US]

# basic regression



for df in country:
    #for out of sample, expanding window
    n=60
    pre1=np.zeros(len(df))
    pre2=np.zeros(len(df))
    for i in range(n,len(df)):
        Y=df['return'].values[:i]
        X1=df.iloc[:i,:-3].values
        X2=df['spread'].values[:i].reshape(-1,1)
        lr1=LinearRegression().fit(X1,Y)
        lr2=LinearRegression().fit(X2,Y)
        #CP
        pre1[i]=lr1.predict(df.iloc[i,:-3].values.reshape(1,-1))[0]
        #fama-bliss
        pre2[i]=lr2.predict(df['spread'].values[i].reshape(1,-1))[0]
    df['pre_CP']=pre1
    df['pre_FB']=pre2



