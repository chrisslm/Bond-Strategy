datetime = SwissYields(:,1);
Swiss_Yields = SwissYields(:,3:end);
Swissmaturities = [2,3,4,5,6,7,8,9,10,15,20,30,0.83333,0.25,0.5,1];
Swiss_Returns = getbondreturns(Swiss_Yields, Swissmaturities, 1);