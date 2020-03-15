% Data
SwissYields = xlsread("Swiss Yields.xls");
GermanYields = xlsread("German Yield.xls");
[USYields, Date] = xlsread("Yield_quandl.xls");
FrenchYields = xlsread("France Yields.xls");
SKYields = xlsread("south korea yields.xls");
JapanYields = xlsread("Japan Yields.xls");
ChinaYields = xlsread("china yield.xls");
ItalianYields = xlsread("Italy Yields.xls"); 
SpanishYields = xlsread("Spain Yields.xls");
AustralianYields = xlsread("Australian Yields.xls");
CanadaYields = xlsread("Canada yields.xls");
UKYields = xlsread("UK Yields.xls");

Date = Date(:,1);
dates4Fig = datetime(Date, 'InputFormat', 'dd.MM.yyyy');

%TTM
Swissmaturities = [1,2,3,4,5,6,7,8,9,10,15,20,30,0.083333,0.25,0.5,1];
Germanmaturities = [1,2,3,4,5,6,7,8,9,10,15,20,30];
USmaturities = (1:1:30);
Frenchmaturities = [0.083333,0.25,0.5,1,2,3,5,7,10, 15,20, 25, 30];
SKmaturities = [0.25,0.5,1,2,3,5,10,20,30];
Japanmaturities = [0.083333,0.25,0.5,1,2,3,4,5,6,7,8,9,10,15,20,30,40];
Chinamaturities = [0.25,0.5,1,2,3,4,5,6,7,8,9,10,15,20,30];
Italianmaturities = [0.25,0.5,1,2,3,4,5,7,8,10,15,20,30];
Spanishmaturities = [0.25,0.5,1,2,3,4,5,6,7,8,9,10,15,30];
Australianmaturities = [0.083333,0.25,0.5,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,30,0.08333,0.25,0.5];
Canadamaturities = [0.083333,0.25,0.5,1,2,3,4,5,7,10,20,30];
UKmaturities = [0.083333,0.25,0.5,1,2,3,4,5,6,7,8,10,15,20,30,40];

%Returns
Swiss_Returns = getbondreturns(SwissYields, Swissmaturities, 1);
German_Returns = getbondreturns(GermanYields, Germanmaturities, 1);
US_Returns = getbondreturns(USYields, USmaturities, 1);
French_Returns = getbondreturns(FrenchYields, Frenchmaturities, 1);
SK_Returns = getbondreturns(SKYields, SKmaturities, 1);
Japan_Returns = getbondreturns(JapanYields, Japanmaturities, 1);
China_Returns = getbondreturns(ChinaYields, Chinamaturities, 1);
Italian_Returns = getbondreturns(ItalianYields, Italianmaturities, 1);
Spanish_Returns = getbondreturns(SpanishYields, Spanishmaturities, 1);
Australian_Returns = getbondreturns(AustralianYields, Australianmaturities, 1);
Canada_Returns = getbondreturns(CanadaYields, Canadamaturities, 1);
UK_Returns = getbondreturns(UKYields, UKmaturities, 1);

% Swiss_Returns = [Swissmaturities ; zeros(1,size(Swiss_Returns,2)) ; Swiss_Returns];
% Swiss_Returns = [Date(end-length(Swiss_Returns)+1:end) Swiss_Returns];
xlswrite("UK_Returns.xls", UK_Returns);
% 
% %Choose Country%
% Country_Returns = Swiss_Returns;
% 
% Country_Returns(isnan(Country_Returns)) = 0;
% figure
% plot(cumprod(1+Country_Returns)), xlabel('Time')
% plot(dates4Fig, strategyNAV(:, 4), 'k--', dates4Fig, strategyNAV(:, 5), 'b--', dates4Fig, strategyNAV(:, 6), 'r--'),
%     xlabel('Year'), ylabel('Portfolio Value'), 
%     legend('Equally Weighted', 'Momentum Long Only', 'Momentum Long/Short', 'Equally Weighted, TC', 'Mom. Long Only, TC', 'Mom. Long/Short, TC', 'Location', 'NorthWest')
