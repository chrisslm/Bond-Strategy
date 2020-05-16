clear
clc
%% load data
futures_prices      = readtable('BloombergDataSheet.xlsx', 'Sheet', 'Futures');
futures_vol         = readtable('BloombergDataSheet.xlsx', 'Sheet', 'Futures Volume');
futures_tickers     = readtable('BloombergDataSheet.xlsx', 'Sheet', 'Futures Ticker');
yields              = readtable('BloombergDataSheet.xlsx', 'Sheet', 'Yields');
risk_free           = readtable('BloombergDataSheet.xlsx', 'Sheet', 'Risk Free');
fx_rates            = readtable('BloombergDataSheet.xlsx', 'Sheet', 'FX Rates');
forward_points      = readtable('BloombergDataSheet.xlsx', 'Sheet', 'Forward Points');
vix_data            = readtable('BloombergDataSheet.xlsx', 'Sheet', 'VIX Level');
dates               = datetime(table2array(futures_prices(6 : end, 1)));
rf_dates            = datetime(table2array(risk_free(3 : end, 1)));
monthly_dates       = datetime(table2array(yields(6 : end, 1)));
fx_dates            = datetime(table2array(fx_rates(3 : end, 1)));
fx_names            = fx_rates.Properties.VariableNames(2 : 9);
country_list        = ["Germany", "France", "Spain", "Italy", "UK", "Switzerland", "China", "Korea", "Australia", "Japan", "US", "Canada"];

%% data transformation
futures_prices      = str2double(table2cell(futures_prices(6 : end, 2 : end)));
futures_vol         = str2double(table2cell(futures_vol(3 : end, 2 : end)));
futures_tickers     = table2cell(futures_tickers(3 : end, 2 : end));    
yields              = (str2double(table2cell(yields(6 : end, 2 : end))));
risk_free           = (str2double(table2cell(risk_free(3 : end, 2 : end))) / 100);
fx_rates            = str2double(table2cell(fx_rates(3 : end, 2 : 9)));
forward_points      = str2double(table2cell(forward_points(3 : end, 2 : end)));
vix_prices          = str2double(table2cell(vix_data(3 : end, 2 : 5)));
vix_tickers         = str2double(table2cell(vix_data(3 : end, 6 : end)));

%% Get monthly bond returns 
maturs              = [1/12, 1/4, 1/2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30];
maturities          = repmat(maturs, 1, 12);
bondreturns         = getbondreturns(yields(:, 1 : length(maturities)), maturities, 1);
[tf, loc]           = ismember(fx_dates, monthly_dates);
fx_dates_monthly    = fx_dates(find(loc));
monthly_fx          = fx_rates(find(loc), 1 : 8);
monthly_fx_ret      = monthly_fx(1 : end - 1, :) ./ monthly_fx(2 : end, :);
fx_adjustment       = ones(length(bondreturns(:, 1)), length(bondreturns(1, :)));
adjustment          = [0, 0, 0, 0, 6, 2, 3, 8, 7, 5, 1, 4];

for j = 1 : length(adjustment)
    adj             = adjustment(j);
    if adj ~= 0
        fx_adjustment(:, (j - 1) * 16 + 1 : j * 16) = ones(length(bondreturns(:, 1)), 16) .* monthly_fx_ret(:, adj);
    end
end

monthly_fx_ret_eur  = (1 + bondreturns) .* fx_adjustment - 1;
monthly_fx_ret_eur  = [zeros(1, length(monthly_fx_ret_eur(1, :))); monthly_fx_ret_eur];

%% get monthly futures returns

cols_tickers        = linspace(1, length(futures_tickers(1, :)) - 1, length(futures_tickers(1, :)) / 2);
cols_front          = linspace(1, length(futures_tickers(1, :)) - 1, length(futures_tickers(1, :)) / 2);
cols_back           = linspace(2, length(futures_tickers(1, :)), length(futures_tickers(1, :)) / 2);
relevant_tickers    = futures_tickers(:, cols_tickers);
front_prices        = futures_prices(:, cols_front);
back_prices         = futures_prices(:, cols_back);
date_list           = yyyymmdd(dates);
fx_avail            = (fx_rates > 0);
fut_count           = [8, 4, 8, 6, 8, 4, 2, 6, 6, 6, 10, 8];
fut_cum             = cumsum(fut_count);
futures_prices_eur  = futures_prices;

for j = 1 : length(adjustment)
    adj             = adjustment(j);
    if adj ~= 0
        futures_prices_eur(:, fut_cum(j) - fut_count(j) + 1 : fut_cum(j)) = futures_prices(:, fut_cum(j) - fut_count(j) + 1 : fut_cum(j)) .* fx_rates(:, adj) .* fx_avail(:, adj);
    end
end

front_prices_eur    = futures_prices_eur(:, cols_front);
back_prices_eur     = futures_prices_eur(:, cols_back);

futures_xs          = rolloverFutures(front_prices, back_prices, relevant_tickers);
futures_eur_xs      = rolloverFutures(front_prices_eur, back_prices_eur, relevant_tickers);

%% calculate eur rf

eur_avail           = (risk_free(:, 1) > -1);
us_avail            = (risk_free(:, 2) > -1) - eur_avail;
risk_free(isnan(risk_free)) = 0;
eur_rf              = us_avail .* risk_free(:, 2) - (us_avail - 1) .* risk_free(:, 1);
[first, last]       = getFirstAndLastDayInPeriod(yyyymmdd(rf_dates), 2);
[tf, loc]           = ismember(dates, rf_dates);
eur_rf              = eur_rf(find(loc), :);
daycount            = diff(datenum(dates));
daycount            = [daycount; 1];
eur_rf              = eur_rf / 360 .* daycount;

%% Aggregate daily futures returns to monthly

[monthly_tr_eur, monthly_xs_eur, cumRf] = aggregateFutXsReturns(futures_eur_xs, eur_rf, yyyymmdd(dates), 2);

%% Vol screener

[first, last]       = getFirstAndLastDayInPeriod(yyyymmdd(dates), 2);
first_days          = dates(first);
last_days           = dates(last);
indicator           = (futures_vol(2 : end, :) == futures_vol(1 : end - 1, :));
indicator           = [zeros(1, length(futures_vol(1, :))); indicator];
futures_vol(find(indicator))        = 0;
futures_vol(isnan(futures_vol))     = 0;
cum_vol             = cumsum(futures_vol);
monthly_vol         = zeros(length(first), length(futures_vol(1, :)));

for i = 1 : length(first)
    monthly_vol(i, :)       = cum_vol(last(i), :) - cum_vol(first(i), :);
end

vol_dates           = last_days;

%% Replace NaN futures or where to little liquidity with Bondreturns

futures_to_replace  = repmat([2, 5, 10, 20, 30], 1, 12);
fut_count           = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
cum_fut             = cumsum(fut_count);
[tf, loc]           = ismember(vol_dates, fx_dates_monthly);
monthly_vol         = monthly_vol(find(loc), cols_tickers);
monthly_tr_eur      = monthly_tr_eur(find(loc), :);
monthly_xs_eur      = monthly_xs_eur(find(loc), :);
dummy1              = nan(length(monthly_vol(:, 1)), 1);
dummy2              = ones(length(monthly_vol(:, 1)), 1);
monthly_vol         = [monthly_vol(:, 1 : 4), dummy2, dummy2, monthly_vol(:, 5 : 6), dummy2, dummy2, ...
    monthly_vol(:, 7 : 10), dummy2, dummy2, monthly_vol(:, 11 : 13), dummy2, dummy2, monthly_vol(:, 14 : 16), ...
    dummy2, monthly_vol(:, 17), dummy2, monthly_vol(:, 18 : 19), dummy2, dummy2, dummy2, dummy2, monthly_vol(:, 20), dummy2, dummy2, monthly_vol(:, 21 : 23), ...
    dummy2, dummy2, monthly_vol(:, 24), dummy2, monthly_vol(:, 25 : 26), dummy2, dummy2, monthly_vol(:, 27 : 29), ...
    dummy2, monthly_vol(:, 30 : 37), dummy2, monthly_vol(:, 38)];
monthly_vol         = [monthly_vol(:, 1 : 12), monthly_vol(:, 14 : end)];
monthly_tr_eur         = [monthly_tr_eur(:, 1 : 4), dummy1, dummy1, monthly_tr_eur(:, 5 : 6), dummy1, dummy1, ...
    monthly_tr_eur(:, 7 : 10), dummy1, dummy1, monthly_tr_eur(:, 11 : 13), dummy1, dummy1, monthly_tr_eur(:, 14 : 16), ...
    dummy1, monthly_tr_eur(:, 17), dummy1, monthly_tr_eur(:, 18 : 19), dummy1, dummy1, dummy1, dummy1, monthly_tr_eur(:, 20), dummy1, dummy1, monthly_tr_eur(:, 21 : 23), ...
    dummy1, dummy1, monthly_tr_eur(:, 24), dummy1, monthly_tr_eur(:, 25 : 26), dummy1, dummy1, monthly_tr_eur(:, 27 : 29), ...
    dummy1, monthly_tr_eur(:, 30 : 37), dummy1, monthly_tr_eur(:, 38)];
monthly_tr_eur         = [monthly_tr_eur(:, 1 : 12), monthly_tr_eur(:, 14 : end)];
monthly_xs_eur         = [monthly_xs_eur(:, 1 : 4), dummy1, dummy1, monthly_xs_eur(:, 5 : 6), dummy1, dummy1, ...
    monthly_xs_eur(:, 7 : 10), dummy1, dummy1, monthly_xs_eur(:, 11 : 13), dummy1, dummy1, monthly_xs_eur(:, 14 : 16), ...
    dummy1, monthly_xs_eur(:, 17), dummy1, monthly_xs_eur(:, 18 : 19), dummy1, dummy1, dummy1, dummy1, monthly_xs_eur(:, 20), dummy1, dummy1, monthly_xs_eur(:, 21 : 23), ...
    dummy1, dummy1, monthly_xs_eur(:, 24), dummy1, monthly_xs_eur(:, 25 : 26), dummy1, dummy1, monthly_xs_eur(:, 27 : 29), ...
    dummy1, monthly_xs_eur(:, 30 : 37), dummy1, monthly_xs_eur(:, 38)];
monthly_xs_eur      = [monthly_xs_eur(:, 1 : 12), monthly_xs_eur(:, 14 : end)];
cumRf               = cumRf(find(loc));
threshold           = 500;
vol_indicator       = (monthly_vol > threshold);
monthly_bond_ret    = zeros(length(monthly_vol(:, 1)), length(monthly_vol(1, :)));

for j = 1 : length(fut_count)
    num_futs = fut_count(j);
    pos      = cum_fut(j);
    for k = pos - num_futs + 1 : pos
        years   = futures_to_replace(k);
        pos1    = find(maturs == years);
        monthly_bond_ret(:, k) = monthly_fx_ret_eur(:, (j - 1) * 16 + pos1);
    end
end

monthly_bond_ret(isnan(monthly_bond_ret)) = 0;
monthly_tr_eur(isnan(monthly_tr_eur)) = 0;
final_eur_tr_rets   = vol_indicator .* monthly_tr_eur - (1 - vol_indicator) .* monthly_bond_ret;
final_eur_xs_rets   = final_eur_tr_rets - cumRf;

% group futures into 2, 5, 10, 30 year futures
yields_mat          = [yields(:, 1 : length(maturities)), getbondduration(yields(:, 1 : length(maturities)), maturities)];
final_mat           = [yyyymmdd(monthly_dates), final_eur_tr_rets(:, linspace(1, 56, 12)), final_eur_tr_rets(:, linspace(2, 57, 12)), final_eur_tr_rets(:, linspace(3, 58, 12)),...
    final_eur_tr_rets(:, linspace(4, 59, 12)), final_eur_tr_rets(:, linspace(5, 60, 12)), yields_mat, cumRf];
