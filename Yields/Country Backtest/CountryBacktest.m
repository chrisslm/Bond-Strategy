clear
clc
%% Control Relevant Variables

% For long-short factor construction, either integer or fraction. That
% means if one wants to long three securities and short three, set both to
% 3. However, if one wants to long the upper tercile and short the lower
% tercile, set both to 1 / 3. If one gives an integer, set flag to 1, other
% wise to 0.
nLongs  = 1 / 3;
nShorts = 1 / 3;

% Set other backtest relevant variables. The variable lag lags the series
% that is used for any factor construction. Its unit is always equivalent
% to one time step in each dates vector, that means if the data is monthly
% data, then a lag of 1 means that the data is lagged by one month.
lag = 1;

% The time variable is used to distinguish between different types of data.
% If the data is daily, set time to 0, if monthly to 1 and if yearly to 2.
time = 1;

% Option to plot the return series to check whether there are issues with
% the data. If one wants to plot the data, set plot_var to 1, otherwise to
% 0.
plot_var = 0;

%% Load Bond Return Data

% get the yields for every country
country_yields    = readtable('Country10yields.xlsx');
country_dates = table2array(country_yields(:, 1));
country_yields = table2array(country_yields(:, 2 : end));

short_yields = readtable('3 month rates.xlsx');
short_yields = table2array(short_yields(:, 2 : end));

maturities = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10];

% Set important variables per series
% counts number of different maturities per country
nBonds = length(country_yields(1, :));

% counts the number of dates / observations per country
country_obs       = length(country_dates);

% Use the functions to calculate the returns and durations
country_duration = getbondduration(country_yields, maturities);
country_returns = getbondreturns(country_yields, maturities, 1);
country_returns = [zeros(1, nBonds); country_returns];

%% Load Futures Data

futures_prices = readtable('Country Futures.xlsx');
futures_dates = table2array(futures_prices(:, 1));
futures_dates = yyyymmdd(futures_dates);
futures_prices = table2array(futures_prices(:, 2 : end));

rf = xlsread('FFDaily.xlsx');
rf = rf(:, 2) / 100;
futures_returns = futures_prices(2 : end, :) ./ futures_prices(1 : end - 1, :) - 1;

[firstDayList, lastDayList] = getFirstAndLastDayInPeriod(futures_dates, 2);
month_dates = futures_dates(lastDayList);
month_dates = month_dates(1 : end - 2);
[cumTR, cumXsR, cumRf] = aggregateFutXsReturns(futures_returns, rf(1 : end - 1), futures_dates(2 : end), 2);
cumXsR = cumXsR(1 : end - 3, :);
cumXsR = [zeros(1, nBonds); cumXsR];
cumTR = cumTR(1 : end - 3, :);
cumTR = [zeros(1, nBonds); cumTR];
cumRf = cumRf(1 : end - 3);
cumRf = [0; cumRf];
%%
cumXsR(110, 1) = 0;
%%
country_returns = cumXsR;
%% Check Return Availability

% check when the individual series start
country_avail = (country_yields > -1);
country_count_avail = sum(country_avail, 2);

% check when the individual series start
country_avail = ([cumXsR(2 : end, :) ; ones(1, nBonds)] > -1);
country_count_avail = sum(country_avail, 2);

%% Compute Dollar Evolution

% This section computes for all return series the evolution of an
% investment of 1 unit of currency in each of the return series.
country_returns(isnan(country_returns)) = 0;
country_nav = cumprod(1 + country_returns .* country_avail);

%% Optional Plots

% If plot_var is set to 1, one can see plots of the returns series.

if plot_var == 1
    figure(1)
    semilogy(country_dates, country_nav);
end

%% Factor Setup

if time == 0
    year_frac = 252;
elseif time == 1 
    year_frac = 12;
else
    year_frac = 1;
end

% adapt the longs and shorts for each country depending on how the nLongs
% and nShorts are defined above

if nLongs < 1
    country_nLongs    = floor(nLongs * nBonds);
    country_nShorts   = floor(nShorts * nBonds);
else
    country_nLongs    = nLongs;
    country_nShorts   = nShorts;
end

%% Check Availability for Longs and Shorts

% create a series of available count for longs and shorts and slice these
% for the other factors
country_strat_count = floor(country_count_avail / 2);
country_nShorts = country_nShorts .* (country_nShorts <= country_strat_count) + country_strat_count .* (country_nShorts > country_strat_count);
country_nLongs = country_nLongs .* (country_nLongs <= country_strat_count) + country_strat_count .* (country_nLongs > country_strat_count);


%% Momentum Factor Construction

% check for availability of the momentum factor, meaning which maturity was
% available 1 year ago.
country_mom_avail = country_avail(1 : end - year_frac + 1, :);

% calculate yearly returns with country NAVs
country_mom_dates = country_dates(year_frac : end);
country_yearly    = (country_nav(year_frac : end, :) ./ country_nav(1 : end - year_frac + 1, :) - 1) .* country_mom_avail;

% compare number of longs and shorts with actual available securities and
% calculate the maximum number of securities on could go long or short at
% each time point. country_mom_count is the maximum number of either longs or
% shorts one could invest into as it reflects half of the assets.
country_mom_nShorts = country_nShorts(1 : end - year_frac + 1);
country_mom_nLongs = country_nLongs(1 : end - year_frac + 1);

% Calculate the nth largest and smallest return
country_min_ret = zeros(length(country_yearly), 1);
country_max_ret = zeros(length(country_yearly), 1);

for i = 1 : length(country_yearly)
    relevant_ret = nonzeros(country_yearly(i, :) .* country_mom_avail(i, :));
    min_el = mink(relevant_ret, country_mom_nShorts(i));
    max_el = maxk(relevant_ret, country_mom_nLongs(i));
    country_min_ret(i) = min_el(end);
    country_max_ret(i) = max_el(end);
end

% Generate the indicator matrices per country
country_long_mom  = (country_yearly >= country_max_ret) .* country_mom_avail ./ country_mom_nLongs;
country_short_mom = -1 * (country_yearly <= country_min_ret) .* country_mom_avail ./ country_mom_nShorts;
country_ls_mom    = country_long_mom + country_short_mom;

%% Low Volatility Factor Construction 

% Calculate the low volatility factor
country_lvol_factor = country_duration .* country_yields;


% Calculate the nth largest and smallest vol
country_min_vol = zeros(length(country_lvol_factor), 1);
country_max_vol = zeros(length(country_lvol_factor), 1);

for i = 1 : length(country_lvol_factor)
    relevant_vol = nonzeros(country_lvol_factor(i, :) .* country_avail(i, :));
    min_el = mink(relevant_vol, country_nShorts(i));
    max_el = maxk(relevant_vol, country_nLongs(i));
    country_min_vol(i) = min_el(end);
    country_max_vol(i) = max_el(end);
end

% Generate the indicator matrices per country
country_long_vol  = (country_lvol_factor <= country_min_vol) ./ country_nLongs;
country_short_vol = -1 * (country_lvol_factor >= country_max_vol) ./ country_nShorts;
country_ls_vol    = country_long_vol + country_short_vol;

%% Value Factor Construction

% check for availability of the momentum factor, meaning which maturity was
% available 1 year ago.
country_val_avail = country_avail(1 : end - year_frac * 5 + 1, :);

% calculate the yield difference

country_yielddiff = country_yields(year_frac * 5 : end, :) - country_yields(1 : end - year_frac * 5 + 1, :);

% compare number of longs and shorts with actual available securities and
% calculate the maximum number of securities on could go long or short at
% each time point. country_mom_count is the maximum number of either longs or
% shorts one could invest into as it reflects half of the assets.
country_val_nShorts = country_nShorts(1 : end - year_frac * 5 + 1);
country_val_nLongs = country_nLongs(1 : end - year_frac * 5 + 1);

% Calculate the nth largest and smallest value
country_min_val = zeros(length(country_yielddiff), 1);
country_max_val = zeros(length(country_yielddiff), 1);

for i = 1 : length(country_yielddiff)
    relevant_val = nonzeros(country_yielddiff(i, :) .* country_val_avail(i, :));
    min_el = mink(relevant_val, country_val_nShorts(i));
    max_el = maxk(relevant_val, country_val_nLongs(i));
    country_min_val(i) = min_el(end);
    country_max_val(i) = max_el(end);
end

% Generate the indicator matrices per country
country_long_val  = (country_yielddiff >= country_max_val) ./ country_val_nLongs;
country_short_val = -1 * (country_yielddiff <= country_min_val) ./ country_val_nShorts;
country_ls_val    = country_long_val + country_short_val;

%% Carry Factor

% Calculate the low volatility factor
country_carry = country_yields - short_yields;


% Calculate the nth largest and smallest vol
country_min_car = zeros(length(country_carry), 1);
country_max_car = zeros(length(country_carry), 1);

for i = 1 : length(country_carry)
    relevant_car = nonzeros(country_carry(i, :) .* country_avail(i, :));
    min_el = mink(relevant_car, country_nShorts(i));
    max_el = maxk(relevant_car, country_nLongs(i));
    country_min_car(i) = min_el(end);
    country_max_car(i) = max_el(end);
end

% Generate the indicator matrices per country
country_long_car  = (country_carry >= country_max_car) ./ country_nLongs;
country_short_car = -1 * (country_carry <= country_min_car) ./ country_nShorts;
country_ls_car    = country_long_car + country_short_car;

%% Test Factor

% get all factors to the same length. As value is the shortest, all
% timelines will be amended

country_lvol_factor_l = sum(country_long_vol(1 : end - 1, :) .* country_returns(2 : end, :), 2);
country_lvol_factor_l = cumprod(1 + country_lvol_factor_l);
country_lvol_factor_l = [1; country_lvol_factor_l];


country_mom_factor_l = sum(country_long_mom(1 : end - 1, :) .* country_returns(year_frac + 1 : end, :), 2);
country_mom_factor_l = cumprod(1 + country_mom_factor_l);
country_mom_factor_l = [1; country_mom_factor_l];


country_val_factor_l = sum(country_long_val(1 : end - 1, :) .* country_returns(year_frac * 5 + 1 : end, :), 2);
country_val_factor_l = cumprod(1 + country_val_factor_l);
country_val_factor_l = [1; country_val_factor_l];


country_car_factor_l = sum(country_long_car(1 : end - 1, :) .* country_returns(2 : end, :), 2);
country_car_factor_l = cumprod(1 + country_car_factor_l);
country_car_factor_l = [1; country_car_factor_l];


factor_matrix = [country_val_factor_l country_car_factor_l(5 * year_frac : end) country_lvol_factor_l(5 * year_frac : end) country_mom_factor_l(4 * year_frac + 1 : end)];
factor_returns = factor_matrix(2 : end, :) ./ factor_matrix(1 : end - 1, :) - 1;
factor_nav = cumprod(1 + sum(factor_returns, 2) / 4);
factor_nav = [1; factor_nav];
factor_returns = [zeros(1, 4); factor_returns];
factor_matrix = cumprod(1 + factor_returns);


factor_matrix = [factor_matrix factor_nav];

country_dates = country_dates(5 * year_frac : end);
plot(country_dates, factor_matrix(:, 1), '-.g', country_dates, factor_matrix(:, 2), '-.r', country_dates, factor_matrix(:, 3), '-.b', country_dates, factor_matrix(:, 4), '-.m', country_dates, factor_matrix(:, 5), '-k','LineWidth',1) 
legend('Low Volatility', 'Momentum', 'Value', 'Carry', 'Combo','Location','northwest')
%% Performance Calc

factor_returns = factor_matrix(2 : end, :) ./ factor_matrix(1 : end - 1, :) - 1;

summarizePerformance(factor_returns, cumRf(5 * year_frac + 1 : end),factor_returns(:, end),12,'Low Vola, Mom, Value, Carry, Combo')


