[US, date] = xlsread("US_Returns_Final.xls");
date = datetime(date(2:end,1), "InputFormat", "dd.MM.yyyy");
UK = xlsread("UK_Returns_Final.xls");
SW = xlsread("Swiss_Return_Final.xls");
SP = xlsread("Spain_Returns_Final.xls");
SK = xlsread("SK_Returns_Final.xls");
JA = xlsread("Japan_Returns_Final.xls");
IT = xlsread("Italian_Returns_Final.xls");
GE = xlsread("German_Returns_Final.xls");
FR = xlsread("France_Returns_Final.xls");
CH = xlsread("China_Returns_Final.xls");
CA = xlsread("Canada_Returns_Final.xls");
AU = xlsread("Australian_Returns_Final.xls");
Quality = xlsread("Quality_Score.xls");
Size = xlsread("Size_GDP.xls");


US(isnan(US)) = 0;
UK(isnan(UK)) = 0;
SW(isnan(SW)) = 0;
SP(isnan(SP)) = 0;
SK(isnan(SK)) = 0;
JA(isnan(JA)) = 0;
IT(isnan(IT)) = 0;
GE(isnan(GE)) = 0;
FR(isnan(FR)) = 0;
CH(isnan(CH)) = 0;
CA(isnan(CA)) = 0;
AU(isnan(AU)) = 0;


locUS = (US ~=0);
locUK = (UK ~=0);
locSW = (SW ~=0);
locSP = (SP ~=0);
locSK = (SK ~=0);
locJA = (JA ~=0);
locIT = (IT ~=0);
locGE = (GE ~=0);
locFR = (FR ~=0);
locCH = (CH ~=0);
locCA = (CA ~=0);
locAU = (AU ~=0);

US = sum(US,2)./sum(locUS,2);
UK = sum(UK,2)./sum(locUK,2);
SW = sum(SW,2)./sum(locSW,2);
SP = sum(SP,2)./sum(locSP,2);
SK = sum(SK,2)./sum(locSK,2);
JA = sum(JA,2)./sum(locJA,2);
IT = sum(IT,2)./sum(locIT,2);
GE = sum(GE,2)./sum(locGE,2);
FR = sum(FR,2)./sum(locFR,2);
CH = sum(CH,2)./sum(locCH,2);
CA = sum(CA,2)./sum(locCA,2);
AU = sum(AU,2)./sum(locAU,2);

US(isnan(US)) = 0;
UK(isnan(UK)) = 0;
SW(isnan(SW)) = 0;
SP(isnan(SP)) = 0;
SK(isnan(SK)) = 0;
JA(isnan(JA)) = 0;
IT(isnan(IT)) = 0;
GE(isnan(GE)) = 0;
FR(isnan(FR)) = 0;
CH(isnan(CH)) = 0;
CA(isnan(CA)) = 0;
AU(isnan(AU)) = 0;

Returns = zeros(704,12);
Returns(end-length(SW)+1:end,1) = SW;
Returns(end-length(FR)+1:end,2) = FR;
Returns(end-length(US)+1:end,3) = US;
Returns(end-length(CH)+1:end,4) = CH;
Returns(end-length(IT)+1:end,5) = IT;
Returns(end-length(UK)+1:end,6) = UK;
Returns(end-length(AU)+1:end,7) = AU;
Returns(end-length(GE)+1:end,8) = GE;
Returns(end-length(JA)+1:end,9) = JA;
Returns(end-length(SP)+1:end,10) = SP;
Returns(end-length(CA)+1:end,11) = CA;
Returns(end-length(SK)+1:end,12) = SK;
% Returns=Returns(400:end,:);
% date = date(400:end,1);
% plot(date,cumprod(1+Returns)), 
% legend("SW", "FR", "US", "CH", "IT", "UK", "AU", "GE", "JA", "SP", "CA", "SK")
Size(isnan(Size))=0;
Quality(isnan(Quality))=0;
Returns(isnan(Returns))=0;


for i = 1:length(Size);
    Size(i,:) = Size(i,:)/sum(Size(i,:),2);
end

Size_Returns = sum(Returns(end-400+1:end,:).*Size(end-400:end-1,:),2);
locReturns = (Returns ~=0);
EWReturnWeights = locReturns./sum(locReturns,2);
locQuality = (Quality > 0);
QualityWeights = locQuality./sum(locQuality,2);
Quality_Returns = sum(Returns(end-351+2:end,:).*QualityWeights(end-351+1:end-1,:),2);
Returns = sum(Returns,2)./sum(locReturns,2);

Returns=Returns(end-350+1:end,:);
Size_Returns=Size_Returns(end-400+1:end,:);
date = date(end-350+1:end,1);

plot(date, cumprod(1+Quality_Returns), date, cumprod(1+Returns)),
legend("Quality Returns", "EW Returns")




