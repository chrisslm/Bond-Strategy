
"""
Created on Mon Mar 16 15:53:52 2020

@author: ShuangZhao
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# For Australian, get yields
#calculate returns
# calc forward rates

# for Australian
'''
Australian=pd.read_excel('Australian Yields.xlsx')
Australian=Australian.iloc[5:,:21]
Australian.columns=['Dates','1M','3M','6M','1Y','2Y','3Y','4Y','5Y'
                    ,'6Y','7Y','8Y','9Y','10Y','11Y','12Y','13Y','14Y',
                    '15Y','20Y','30Y']
Australian=Australian.set_index('Dates')
#Australian.to_csv('Australian_yields.csv')
data=Australian.iloc[:,1:]
Y=data/100
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R['1M']=((1+Australian['1M']/100)**(1/12)-1).shift(1)
#R.to_csv('Australian_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,10,11]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,9,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('Australian_forward.csv')
'''
# for canada
'''
Canada=pd.read_excel('Canada yields.xlsx')
Canada=Canada.iloc[5:,:]
Canada.columns=['Dates','3M','6M','1Y','2Y','3Y','4Y','5Y','7Y','10Y','20Y','30Y','1M']
Canada=Canada.set_index('Dates')
Canada.to_csv('Canada_yields.csv')
data=Canada.iloc[:,:-1]
Y=data/100
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,7,10,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R['1M']=((1+Canada['1M']/100)**(1/12)-1).shift(1)
R.to_csv('Canada_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,7,8]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,7,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('7Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('Canada_forward.csv')
'''
#For China
'''
China=pd.read_excel('china yield.xlsx')
Country=China.iloc[5:,:]
Country.columns=['Dates','3M','6M','1Y','2Y','3Y','4Y','5Y','6Y','7Y','8Y','9Y','10Y','15Y','20Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('China_yields.csv')
data=Country.iloc[:,:]
Y=data/100
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,6,7,8,9,10,15,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
#R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('China_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,10,11]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,9,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('China_forward.csv')
'''
# for France
'''
France=pd.read_excel('France Yields.xlsx')
Country=France.iloc[5:,:]
Country.columns=['Dates','1M','3M','6M','1Y','2Y','3Y','5Y','7Y','10Y','15Y','20Y','25Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('France_yields.csv')
data=Country.iloc[:,1:]
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,5,7,10,15,20,25,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('France_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,7]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,5,7,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
#forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('France_forward.csv')
'''
# For German
'''
German=pd.read_excel('German Yield.xlsx')
Country=German.iloc[7:,1:]
Country.columns=['Dates','1Y','2Y','3Y','4Y','5Y','6Y','7Y','8Y','9Y','10Y','15Y','20Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('German_yields.csv')
data=Country.iloc[:,:]
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([1,2,3,4,5,6,7,8,9,10,15,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
#R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('German_return.csv')

forward_data=data.iloc[:,[0,1,2,3,4,8,9]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,9,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('German_forward.csv')
'''
# for Italy
'''
Italy=pd.read_excel('Italy Yields.xlsx')
Country=Italy.iloc[6:,:]
Country.columns=['Dates','3M','6M','1Y','2Y','3Y','4Y','5Y','7Y','8Y','10Y','15Y','20Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('Italy_yields.csv')
data=Country.iloc[:,:]
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,7,8,10,15,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
#R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('Italy_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,8,9]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,8,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('8Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('Italy_forward.csv')
'''
#for Japan
'''
Japan=pd.read_excel('Japan Yields.xlsx')
Country=Japan.iloc[5:,:]
Country.columns=['Dates','1M','3M','6M','1Y','2Y','3Y','4Y','5Y','6Y','7Y','8Y','9Y','10Y','15Y','20Y','30Y','40Y']
Country=Country.set_index('Dates')
Country.to_csv('Japan_yields.csv')
data=Country.iloc[:,1:]
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,6,7,8,9,10,15,20,30,40])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('Japan_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,10,11]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,9,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('Japan_forward.csv')
'''

# For South korea
'''
South_korea=pd.read_excel('south korea yields.xlsx')
Country=South_korea.iloc[5:,:]
Country.columns=['Dates','3M','6M','1Y','2Y','3Y','5Y','10Y','20Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('South_korea_yields.csv')
data=Country.iloc[:,:]
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,5,10,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
#R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('South_korea_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,5,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
#forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('South_korea_forward.csv')
'''
# For Spain
'''
Spain=pd.read_excel('Spain Yields.xlsx')
Country=Spain.iloc[5:,:]
Country.columns=['Dates','3M','6M','1Y','2Y','3Y','4Y','5Y','6Y','7Y','8Y','9Y','10Y','15Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('Spain_yields.csv')
data=Country.iloc[:,:]
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,6,7,8,9,10,15,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
#R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('Spain_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,10,11]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,9,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('Spain_forward.csv')
'''
#For Swiss
'''
Swiss=pd.read_excel('Swiss Yields.xlsx')
Country=Swiss.iloc[5:,:]
Country.columns=['Dates','1Y','2Y','3Y','4Y','5Y','6Y','7Y','8Y','9Y','10Y','15Y','20Y','30Y','1M','3M','6M','12M']
Country=Country.set_index('Dates')
Country.to_csv('Swiss_yields.csv')
#data=Country.iloc[:,:-1]
data=Country.drop('1M',axis=1)
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([1,2,3,4,5,6,7,8,9,10,15,20,30,3/12,6/12,1])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('Swiss_return.csv')

forward_data=data.iloc[:,[0,1,2,3,4,8,9]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,9,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('9Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('Swiss_forward.csv')
'''
# For UK
'''
UK=pd.read_excel('UK Yields.xlsx')
Country=UK.iloc[5:,:]
Country.columns=['Dates','1M','3M','6M','1Y','2Y','3Y','4Y','5Y','6Y','7Y','8Y','10Y','15Y','20Y','30Y','40Y']
Country=Country.set_index('Dates')
Country.to_csv('UK_yields.csv')
#data=Country.iloc[:,:-1]
data=Country.drop('1M',axis=1)
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([3/12,6/12,1,2,3,4,5,6,7,8,10,15,20,30,40])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('UK_return.csv')

forward_data=data.iloc[:,[2,3,4,5,6,9,10]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,4,5,8,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
forward=forward.drop('8Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('UK_forward.csv')
'''
# For US
US=pd.read_csv('Yield_FRB.csv')
Country=US
Country.columns=['Dates','1Y','2Y','3Y','5Y','7Y','10Y','20Y','30Y']
Country=Country.set_index('Dates')
Country.to_csv('US_yields.csv')
data=Country.iloc[:,:]
#data=Country.drop('1M',axis=1)
Y=data/100
Y=Y.replace(0,0.00001)
#remaining maturity
M=np.dot(np.ones([len(data),1]),(np. array([1,2,3,5,7,10,20,30])-1/12).reshape(1,-1))
M=pd.DataFrame(M,index=data.index,columns=data.columns)
Y_lastmonth=((1+Y)**(1/12)-1).shift(1)
D=(1/Y)*(1-1/((1+0.5*Y)**(2*M)))
C=(2/(Y**2))*(1-1/((1+0.5*Y)**(2*M)))-2*M/(Y*(1+0.5*Y)**(2*M+1))
R=Y_lastmonth-D*(Y-Y.shift(1))+0.5*C*((Y-Y.shift(1))**2)
#R['1M']=((1+Country['1M']/100)**(1/12)-1).shift(1)
R.to_csv('US_return.csv')

forward_data=data.iloc[:,[0,1,2,3,4,5]]
forward_data=(forward_data.dropna(axis=0,how='any')).astype(np.float64)
log_data=np.log(forward_data/100+1)
#calculate bond prices from yields
maturity=np.dot(np.ones([len(log_data),1]),(np. array([1,2,3,5,7,10])).reshape(1,-1))
log_price=-(log_data*maturity)

#calculate forward rates from prices
forward=log_price.shift(1,axis=1)-log_price
forward.iloc[:,0]=forward_data.iloc[:,0]/100
#forward=forward.drop('8Y',axis=1)
forward['spread']=forward['10Y']-forward['1Y']
forward.to_csv('US_forward.csv')
