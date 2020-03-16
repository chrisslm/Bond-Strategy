# -*- coding: utf-8 -*-
"""
Created on Sat Mar 14 16:03:09 2020

@author: pc
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import datetime
import matplotlib.ticker as ticker

#%% read data
inflation = pd.read_csv('inflation(1).csv')
oggdp = pd.read_csv('fredgraph.csv')


#%%  synchronize
oggdp['DATE'] = oggdp['DATE'].apply(lambda x: datetime.datetime.strptime(x, '%Y/%m/%d'))
inflation['DATE'] = inflation['DATE'].apply(lambda x: datetime.datetime.strptime(x, '%Y/%m/%d'))

inflation.set_index('DATE', inplace = True)
oggdp.set_index('DATE', inplace = True)

data = oggdp.merge(inflation, right_index = True, left_index = True, how = 'outer')
data = data.loc['1960-01-01':,:]
data.fillna(method = 'ffill', inplace = True)


#%% judge phases
# 1 means upward, -1 means downward
data['Growth'] = 1
data['Inflation'] = 1

# for growth
#plt.plot(data.iloc[:,0])

data.loc['1960-03-01':'1961-03-01', 'Growth'] = -1
data.loc['1966-06-01':'1970-12-01', 'Growth'] = -1
data.loc['1973-06-01':'1975-06-01', 'Growth'] = -1
data.loc['1978-12-01':'1982-12-01', 'Growth'] = -1
data.loc['1989-03-01':'1991-12-01', 'Growth'] = -1
data.loc['2000-06-01':'2003-03-01', 'Growth'] = -1
data.loc['2006-03-01':'2009-09-01', 'Growth'] = -1
data.loc['2000-06-01':'2003-03-01', 'Growth'] = -1


# for inflation
plt.plot(data.iloc[:,1]) 

data.loc['1960-04-01':'1962-01-01', 'Inflation'] = -1
data.loc['1970-02-01':'1972-08-01', 'Inflation'] = -1
data.loc['1974-11-01':'1976-12-01', 'Inflation'] = -1
data.loc['1980-03-01':'1983-02-01', 'Inflation'] = -1
data.loc['1984-03-01':'1986-12-01', 'Inflation'] = -1
data.loc['1990-12-01':'1993-11-01', 'Inflation'] = -1
data.loc['1996-03-01':'1998-11-01', 'Inflation'] = -1
data.loc['2000-06-01':'2002-02-01', 'Inflation'] = -1
data.loc['2003-02-01':'2004-02-01', 'Inflation'] = -1
data.loc['2005-09-01':'2006-10-01', 'Inflation'] = -1
data.loc['2008-07-01':'2009-07-01', 'Inflation'] = -1
data.loc['2009-12-01':'2010-11-01', 'Inflation'] = -1
data.loc['2011-09-01':'2013-10-01', 'Inflation'] = -1
data.loc['2014-05-01':'2015-04-01', 'Inflation'] = -1
data.loc['2017-02-01':'2017-06-01', 'Inflation'] = -1
data.loc['2018-07-01':'2019-02-01', 'Inflation'] = -1



#%% plot growth

dates = data.index
df = pd.DataFrame(index=dates)
df['A'] = data['GDPC1_GDPPOT'] 
df['Growth'] = data['Growth']
df['i'] = range(len(data))
 
# getting the row where those values are true wit the 'i' value

pos_0 = df[df['Growth']==1]['i']
neg_0 = df[df['Growth']==-1]['i']
 
ax = df.A.plot()
'''    
for x in pos_0:
  ax.axvline(df.index[x], color='b',linewidth=5,alpha=0.03)
for x in neg_0:
  ax.axvline(df.index[x], color='w',linewidth=5,alpha=0.03)
plt.title('Growth*') 
'''

#%% plot inflation
df['B'] = data['CPIAUCSL_PC1'] 
df['Inflation'] = data['Inflation']
 
# getting the row where those values are true wit the 'i' value

pos_1 = df[df['Inflation']==1]['i']
neg_1 = df[df['Inflation']==-1]['i']
 
ax = df.B.plot()
'''
for x in pos_1:
  ax.axvline(df.index[x], color='b',linewidth=5,alpha=0.03)
for x in neg_1:
  ax.axvline(df.index[x], color='w',linewidth=5,alpha=0.03)
plt.title('Inflation') 
'''



Reflation= pd.merge(neg_0,neg_1,how='inner')
Recovery= pd.merge(pos_0,neg_1,how='inner')
Overheat=pd.merge(pos_0,pos_1,how='inner')
Stagflation=pd.merge(neg_0,pos_1,how='inner')
for x in Reflation['i']:
  ax.axvline(df.index[x], color='b',linewidth=5,alpha=0.03)
for x in Recovery['i']:
  ax.axvline(df.index[x], color='darkorange',linewidth=5,alpha=0.03)
for x in Overheat['i']:
  ax.axvline(df.index[x], color='g',linewidth=5,alpha=0.03)
for x in Stagflation['i']:
  ax.axvline(df.index[x], color='r',linewidth=5,alpha=0.03)
plt.title('Phases')
plt.legend(['Reflation','Recovery','Overheat','Stagflation']) 
plt.savefig("Phases.png",dpi=500,bbox_inches = 'tight')
#%% construct the cycle

cycle_set = ['Reflation', 'Recovery', 'Overheat', 'Stagflation']
cycle = pd.DataFrame(index=dates)
cycle['period']=0
for i in range(len(cycle)):
    if (data.iloc[i, 2] == -1) & (data.iloc[i, 3] == -1):
        cycle.iloc[i, 0] = cycle_set[0]
    elif (data.iloc[i, 2] == 1) & (data.iloc[i, 3] == -1):
        cycle.iloc[i, 0] = cycle_set[1]
    elif (data.iloc[i, 2] == 1) & (data.iloc[i, 3] == 1):
        cycle.iloc[i, 0] = cycle_set[2]
    elif (data.iloc[i, 2] == -1) & (data.iloc[i, 3] == 1):
        cycle.iloc[i, 0] = cycle_set[3]


#cycle.to_csv('Business Cycle.csv')







