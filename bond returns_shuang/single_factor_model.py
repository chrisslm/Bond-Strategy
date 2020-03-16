# -*- coding: utf-8 -*-
"""
Created on Mon Mar  9 19:54:34 2020

@author: ShuangZhao
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import statsmodels.api as sm
from sklearn.metrics import r2_score
from datetime import datetime

#import data
return_quandl=pd.read_csv('Bond_return_quandl.csv')
return_FRB=pd.read_csv('Bond_return_FRB.csv')
Yield_quandl=pd.read_csv('Yield_quandl.csv')
Yield_FRB=pd.read_csv('Yield_FRB.csv')
return_FRB=return_FRB.iloc[1:-1,:]
return_quandl=return_quandl.iloc[8:,:]
Yield_FRB=Yield_FRB.iloc[1:-1,:]
Yield_quandl=Yield_quandl.iloc[8:,:]

# for quandl data
# on quandl return in the sample R2=0.03
# on FRB return, in the sample R2=0.046

########################
# try yearly data
# 1964-2003 R2=0.323
# 1962-2018 R2=0.216

data=Yield_quandl
for i in data.index:
    data['Date'][i]=datetime.strptime(data['Date'][i],'%Y-%m-%d')
data=data.set_index('Date')
data=data.iloc[:,0:5]
data=data.loc[data.index[data.index.month.values==12]]
log_data=np.log(data/100+1)

#calculate bond prices from yields
num=np.ones(np.shape(data.values)[0])
maturity=pd.DataFrame(np.vstack([num*1,num*2,num*3,num*4,num*5]).T,data.index,data.columns)
log_price=-(log_data*maturity)

#calculate yearly return from yields
log_returns=log_price.shift(1,axis=1).shift(-1,axis=0)-log_price
log_returns.iloc[:,0]=log_data.iloc[:,0]

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=log_returns.iloc[:,0]

#deleting the last row which is nan
log_returns=log_returns.iloc[:len(log_returns)-1,:]
forward=forward.iloc[:len(forward)-1,:]

# get excess return
excess_returns=pd.DataFrame()
for i in range(1,5):
    excess_returns[log_data.columns[i]]=log_returns.iloc[:,i]-log_returns.iloc[:,0]
    
#forward=forward[forward.index.year>=1964]
#forward=forward[forward.index.year<=2003]
excess_returns=excess_returns.loc[forward.index]
#forward['excess_return']=excess_returns.mean(axis=1)
#print(forward.corr())
model=sm.OLS(excess_returns.mean(axis=1),sm.add_constant(forward))
results=model.fit()
print(results.summary())

in_the_sample_predict=results.predict(sm.add_constant(forward))
'''
plt.figure()
plt.plot(excess_returns.index,excess_returns.mean(axis=1))
plt.plot(excess_returns.index,in_the_sample_predict.values)
plt.legend(['true','prediction'])
plt.show()
'''

#for out of sample
rx=excess_returns.mean(axis=1)
n=20
#prediction=pd.DataFrame(0,excess_returns.index,columns=['prediction'])
prediction=list()
for i in range(n,len(excess_returns)):
    Y=rx.values[0:i]
    X=forward.values[0:i,:]
    lr=sm.OLS(Y,X).fit()
    prediction.append(lr.predict(forward.values[i,:])[0])
    
r2=r2_score(np.array(prediction),rx.values[n:])
result=pd.DataFrame(np.hstack([np.array(prediction).reshape(-1,1),rx.values[n:].reshape(-1,1)]).astype(np.float64),
                    index=rx.index[n:],columns=['prediction','true'])
result['hold']=(result['prediction']>0)*result['true']
result['total_return']=np.exp(result['hold']+log_returns.iloc[n:,0]).cumprod()
'''
plt.figure()
#plt.plot(result.index,result['total_return'])
plt.plot(rx.index[n:],rx.values[n:])
plt.plot(rx.index[n:],prediction.values[n:])
plt.legend(['true','prediction'])
plt.show()
'''
#returns=return_FRB

'''
#change index to datetime
for i in data.index:
    data['Date'][i]=datetime.strptime(data['Date'][i],'%Y-%m-%d')
data=data.set_index('Date')
returns=returns.set_index(data.index)

#shift, let returns match yields data
returns=returns.shift(-1).iloc[:,1:6]
data=data.iloc[:,0:5]
returns=returns.iloc[:len(returns)-1,:]
data=data.iloc[:len(data)-1,:] 

# get log data
log_data=np.log(data/100+1)
log_returns=np.log(returns+1)

#calculate bond prices from yields
num=np.ones(np.shape(data.values)[0])
maturity=pd.DataFrame(np.vstack([num*1,num*2,num*3,num*4,num*5]).T,data.index,data.columns)
log_price=-(log_data*maturity)

#calculate forward rates from bond prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=log_data.iloc[:,0]
forward.index=returns.index

# get excess return
excess_returns=pd.DataFrame()
for i in range(1,5):
    excess_returns[log_data.columns[i]]=log_returns.iloc[:,i]-log_returns.iloc[:,0]     

# in the sample regression
    
forward=forward[forward.index.year>=1964]
forward=forward[forward.index.year<=2003]
excess_returns=excess_returns.loc[forward.index]
#forward['excess_return']=excess_returns.mean(axis=1)
#print(forward.corr())
model=sm.OLS(excess_returns.mean(axis=1),sm.add_constant(forward))
results=model.fit()
print(results.summary())
in_the_sample_predict=results.predict(sm.add_constant(forward))
'''
'''
# for FRB data
data=Yield_FRB
returns=return_FRB

#change index to datetime
#for i in data.index:
#    data['Date'][i]=datetime.strptime(data['Date'][i],'%Y-%m-%d')
data=data.set_index('Date')
returns=returns.set_index(data.index)

#shift, let returns match yields data
returns=returns.shift(-1).iloc[:,1:7]
data=data.iloc[:,0:6]
returns=returns.iloc[:len(returns)-1,:]
data=data.iloc[:len(data)-1,:] 
data=data.dropna(axis=0,how='any')
returns=returns.loc[data.index]

# get log data
log_data=np.log(data/100+1)
log_returns=np.log(returns+1)

#calculate bond prices from yields
maturity=pd.DataFrame(np.dot(np.ones([len(data),1]),(np. array([1,2,3,5,7,10])).reshape(1,-1)),index=data.index,columns=data.columns)
log_price=-(log_data*maturity)

#calculate forward rates from bond prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=log_data.iloc[:,0]

# get excess return
excess_returns=pd.DataFrame()
for i in range(1,6):
    excess_returns[log_data.columns[i]]=log_returns.iloc[:,i]-log_returns.iloc[:,0]     

# in the sample regression

model=sm.OLS(excess_returns.mean(axis=1),sm.add_constant(forward))
results=model.fit()
print(results.summary())
in_the_sample_predict=results.predict(sm.add_constant(forward))
'''

'''
#Fama-bliss
model=sm.OLS(excess_returns.values[:,-1],sm.add_constant(forward.values[:,-1].reshape(-1,1)))
results=model.fit()
print(results.summary())
#in_the_sample_predict=results.predict(sm.add_constant(forward))
'''

'''
plt.figure()
plt.scatter(forward.index,in_the_sample_predict)
plt.scatter(forward.index,excess_returns.mean(axis=1))
plt.show()
factor=np.dot(results.params.values,sm.add_constant(forward).T)
'''
'''
rx=excess_returns.mean(axis=1)
prediction=pd.DataFrame(index=excess_returns.index,columns=['Returns'])
#for out of sample
n=60
for i in range(n,len(excess_returns)):
    Y=rx.values[0:i]
    X=forward.values[0:i,:]
    lr=sm.OLS(Y,X).fit()
    prediction.values[i]=lr.predict(forward.values[i,:])[0]
    
r2=r2_score(prediction.values[n:],rx.values[n:])
result=pd.DataFrame(np.hstack([prediction.values[n:].reshape(-1,1),rx.values[n:].reshape(-1,1)]).astype(np.float64),
                    index=rx.index[n:],columns=['prediction','true'])
result['hold']=(result['prediction']>0)*result['true']
result['total_return']=np.exp(result['hold']+log_returns.iloc[n:,0]).cumprod()
plt.figure()
plt.plot(result.index,result['total_return'])
#plt.plot(rx.index[500:],rx.values[500:])
#plt.plot(rx.index[500:],prediction.values[500:])
#plt.legend(['true','prediction'])
plt.show()

# constructing sigle factor based on averaged return

# prediction of single factor

# prediction of fama-bliss


# plot prediction, compare sinlge factor and fama-bliss

# try lag for 1,2,3 month
'''
