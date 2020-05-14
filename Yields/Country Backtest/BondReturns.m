clear
clc
% Loading Yields
Germany_yields = xlsread('German Yield.xls');
Italy_yields = xlsread('Italy Yields.xls');
France_yields = xlsread('France Yields.xls');
Spain_yields = xlsread('Spain Yields.xls');
Switzerland_yields = xlsread('Swiss Yields.xls');
UK_yields = xlsread('UK Yields.xls');
China_yields = xlsread('china yield.xls');
Japan_yields = xlsread('Japan Yields.xls');
SK_yields = xlsread('south korea yields.xls');
Australia_yields = xlsread('Australian Yields.xls');
US_yields = readtable('Yield_quandl.xls');
country_dates = table2array(US_yields(:,1));
US_yields = table2array(US_yields(:,2:end));
Canada_yields = xlsread('Canada yields.xls');
Real_yields = xlsread('real_yields_10y.xlsx');

% Loading FX Rates
FXrates = readtable('Exchange_rates_to_Euro.xlsx');
FXrates = table2array(FXrates(:, 2 : end));

%Yields per Maturity
nBonds = 12;
maturities = size(Australia_yields,2);
nMonths = 722;
yield_matrix = nan(nMonths,maturities*nBonds);
for i = 1:20
        yield_matrix(end-length(Germany_yields)+1:end,(i-1)*nBonds+1) = Germany_yields(:,i);
        yield_matrix(end-length(Italy_yields)+1:end,(i-1)*nBonds+2) = Italy_yields(:,i);
        yield_matrix(end-length(France_yields)+1:end,(i-1)*nBonds+3) = France_yields(:,i);
        yield_matrix(end-length(Spain_yields)+1:end,(i-1)*nBonds+4) = Spain_yields(:,i);
        yield_matrix(end-length(Switzerland_yields)+1:end,(i-1)*nBonds+5) = Switzerland_yields(:,i);
        yield_matrix(end-length(UK_yields)+1:end,(i-1)*nBonds+6) = UK_yields(:,i);
        yield_matrix(end-length(China_yields)+1:end,(i-1)*nBonds+7) = China_yields(:,i);
        yield_matrix(end-length(Japan_yields)+1:end,(i-1)*nBonds+8) = Japan_yields(:,i);
        yield_matrix(end-length(SK_yields)+1:end,(i-1)*nBonds+9) = SK_yields(:,i);
        yield_matrix(end-length(Australia_yields)+1:end,(i-1)*nBonds+10) = Australia_yields(:,i);
        yield_matrix(end-length(US_yields)+1:end,(i-1)*nBonds+11) = US_yields(:,i);
        yield_matrix(end-length(Canada_yields)+1:end,(i-1)*nBonds+12) = Canada_yields(:,i);
end

%% Get Bond Return Data

% get the yields for every maturity
% choose maturity 0 = 1m, 1 = 3m, 2 = 6m, 3 = 1y, 4 = 2y, 5 = 3y, 6 = 4y
% 7 = 5y, 8 = 6y, 9 = 7y, 10 = 8y, 11 = 9y, 12 = 10y, 13 = 11y, 14 = 12y,
% 15 = 13y, 16 = 14y, 17 = 15y, 18 = 20y, 19 = 30y
maturity_number = 3;
maturities_possible = [1/12, 1/4, 1/2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20, 30];
maturity_chosen = maturities_possible(maturity_number+1);
desired_years = 30;
maturities_vector = maturity_chosen.*ones(1,nBonds);
country_yields = yield_matrix(:,nBonds*maturity_number+1:nBonds*maturity_number+nBonds);
short_yields = yield_matrix(:,13:24);

%% Use the functions to calculate the returns and durations
bond_duration = getbondduration(country_yields, maturities_vector);
bond_returns = getbondreturns(country_yields, maturities_vector, 1);
bond_returns = bond_returns(end-desired_years*12+1:end,:);
bond_returns_avail = 1-(isnan(bond_returns));
bond_returns_avail(bond_returns_avail == 0) = NaN;
bond_returns(isnan(bond_returns)) = 0;

%% Real returns
real_duration = getbondduration(Real_yields, 10*ones(1,12));
real_returns = getbondreturns(Real_yields, 10*ones(1,12),1);

%% Prices in Euro or home currency
bond_returns = [zeros(1, nBonds) ; bond_returns];
bond_prices_euro = cumprod(1+bond_returns)./FXrates(end-length(bond_returns):end-1,:);
bond_returns_euro = (bond_prices_euro(2:end,:)./bond_prices_euro(1:end-1,:))-1;
bond_returns_euro = bond_returns_avail .* bond_returns_euro;
bond_returns = bond_returns(2:end,:) .* bond_returns_avail;
country_dates = country_dates(end-length(bond_returns)+1:end);

xlswrite("bond_returns.xls", bond_returns);
xlswrite("bond_returns_euro.xls", bond_returns_euro);
xlswrite("bond_duration.xls", bond_duration);
xlswrite("bond_yields.xls", country_yields);
xlswrite("short_yields.xls", short_yields);
xlswrite("Real_bond_returns.xls", real_returns(1:end-1,:));
%% plot return
bond_returns(isnan(bond_returns)) = 0;
bond_returns_euro(isnan(bond_returns_euro)) = 0;
figure(1)
plot(country_dates,cumprod(1+bond_returns_euro)),
legend("GER", "ITA", "FRA", "ESP", "SWI", "UK", "CHN", "JAP", "SK", "AUS", "US", "CAN", "location", "northwest")
figure(2)
plot(country_dates,cumprod(1+bond_returns)),
legend("GER", "ITA", "FRA", "ESP", "SWI", "UK", "CHN", "JAP", "SK", "AUS", "US", "CAN", "location", "northwest")
