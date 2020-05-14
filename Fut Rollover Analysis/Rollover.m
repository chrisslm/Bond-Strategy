clear
clc
%% Load data
% load front- and backprices and ticker names separately
data            = readtable('CountryFuts.xlsx');
ticker_data     = readtable('CountryFuts.xlsx','Sheet','Sheet2');

% make necessary adjustments
front_prices    = str2double(table2cell(data(6 : end, 2 : 13)));
back_prices     = str2double(table2cell(data(6 : end, 14 : end)));
dates           = yyyymmdd(datetime(table2cell(data(6 : end, 1))));
ticker_names    = table2cell(ticker_data(6 : end, 2 : end));

% load risk-free rate
rf_data         = readtable('FutPrices in Eur.xlsx');
eur_rf          = str2double(table2cell(rf_data(6 : end, 2))) / 100;
us_rf           = str2double(table2cell(rf_data(6 : end, 3))) / 100;
rf_dates        = yyyymmdd(datetime(table2cell(rf_data(6 : end, 1))));

% get BBG adjusted prices
bbg_series      = str2double(table2cell(rf_data(6 : end, 4 : end)));
bbg_returns     = [zeros(1, 12); bbg_series(2 : end, :) ./ bbg_series(1 : end - 1 , :) - 1];

%% Adjust rf

for i = 1 : length(eur_rf)
    if isnan(eur_rf(i))
        eur_rf(i) = us_rf(i);
    end
end

daycount    = diff(datenum(datetime(rf_dates, "ConvertFrom", "yyyymmdd")));
daycount    = [daycount; 1];
eur_rf      = eur_rf / 360 .* daycount;

%% Get first and last days of the month
[first, last]   = getFirstAndLastDayInPeriod(dates, 2);

%% Futures rollover
futXsRets       = rolloverFutures(front_prices, back_prices, ticker_names);

%% Aggregate daily futures returns to monthly
[cumTR, cumXsR, cumRf] = aggregateFutXsReturns(futXsRets, eur_rf, dates, 2);
[cumTR_bbg, cumXsR_bbg, cumRf_bbg] = aggregateFutXsReturns(bbg_returns, eur_rf, dates, 2);

%% Plot graphs
cumTR(isnan(cumTR)) = 0;
cumTR_bbg(isnan(cumTR_bbg)) = 0;
cumXsR(isnan(cumXsR)) = 0;
cumXsR_bbg(isnan(cumXsR_bbg)) = 0;

figure(1)
plot(cumprod(1 + cumTR))

figure(2)
plot(cumprod(1 + cumTR_bbg))

figure(3)
plot(cumprod(1 + cumXsR))

figure(4)
plot(cumprod(1 + cumXsR_bbg))



