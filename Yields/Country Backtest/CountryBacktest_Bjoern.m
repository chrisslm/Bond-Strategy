clear
clc
%% Loading country returns
bond_returns = xlsread("bond_returns.xls");
bond_returns_euro = xlsread("bond_returns_euro.xls");
real_bond_returns = xlsread("Real_bond_returns.xls");
real_bond_returns = real_bond_returns(1:end-1,:);
%short = 1, medium = 2, long = 3, ultra = 4
term = 1;
if term == 1;
    futures_returns = xlsread("short_futures.xls");
elseif term == 2;
    futures_returns = xlsread("medium_futures.xls");
elseif term == 3;
futures_returns = xlsread("long_futures.xls");
elseif term == 4;
futures_returns = xlsread("ultra_futures.xls");
futures_returns = [nan(length(bond_returns)-length(futures_returns),12) ; futures_returns];
end

%% killing march2020 return
futures_returns = futures_returns(end-length(bond_returns):end-1,:);
cumRf = xlsread("cumRf.xls");
cumRf = cumRf(end-length(bond_returns):end-1,:);

rf = readtable('3 month rates.xlsx');
rf = table2array(rf(:, 2 : end));

nBonds = size(futures_returns,2);
rf_duration = getbondduration(rf, 1/4 * ones(1,nBonds));
rf = getbondreturns(rf, 1/4 * ones(1,nBonds), 1);

bond_xs_returns = bond_returns - cumRf*ones(1,nBonds);
bond_xs_returns_euro = bond_returns_euro - cumRf*ones(1,nBonds);
real_bond_xs_returns = real_bond_returns - cumRf*ones(1,nBonds);
%% replace missing futures returns with bond returns
% load("VolScreener.mat");
in_euro = 1;
if in_euro == 0;
    futures_notavailable = (isnan(futures_returns));
    futures_returns(isnan(futures_returns)) = 0;
    country_returns = bond_xs_returns .* futures_notavailable + futures_returns;
elseif in_euro ==1;
    futures_notavailable = (isnan(futures_returns));
    futures_returns(isnan(futures_returns)) = 0;
    country_returns = bond_xs_returns_euro .* futures_notavailable + futures_returns;
end
%country_returns = bond_xs_returns_euro;
%country_returns = real_bond_xs_returns;
%% Loading Factor Size and Quality data

country_size = readtable('Size_Factor_New_PPP.xlsx');
country_size = table2array(country_size(:,2:end));

country_quality = readtable('Quality_Score.xlsx');
country_quality = table2array(country_quality(:,2:end));

%% Control Relevant Variables
% For long-short factor construction, either integer or fraction. That
% means if one wants to long three securities and short three, set both to
% 3. However, if one wants to long the upper tercile and short the lower
% tercile, set both to 1 / 3. If one gives an integer, set flag to 1, other
% wise to 0.
nLongs  = 3;
nShorts = 3;
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

%% Equally Weights
% check when the individual series start
country_avail = (1-(isnan(country_returns(1:end,:))));
country_count_avail = sum(country_avail,2);
equal_strategy = (1./country_count_avail.*ones(length(country_returns),nBonds)).*country_avail;

%% Compute Dollar Evolution

% This section computes for all return series the evolution of an
% investment of 1 unit of currency in each of the return series.
country_returns(isnan(country_returns)) = 0;
country_nav = cumprod(1 + country_returns .* country_avail);

%% Optional Plots
% If plot_var is set to 1, one can see plots of the returns series.

if plot_var == 1
    figure(1)
    semilogy(country_nav);
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
%country_mom_dates = country_dates(year_frac : end);
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
country_duration = xlsread("bond_duration.xls");
% Calculate the low volatility factor
% Taking past 12 month volatility of yields * duration
hist_vol_yields = zeros(length(country_returns), nBonds);
for m = 1:length(hist_vol_yields)
    hist_vol_yields(m,:) = var(country_returns(m:11+m));
end
country_lvol_factor = country_duration(end-length(hist_vol_yields)+1:end,:) .* hist_vol_yields;

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

country_long_vol  = (country_lvol_factor <= country_min_vol) .* country_avail ./ country_nLongs;
country_short_vol = -1 * (country_lvol_factor >= country_max_vol) .* country_avail ./ country_nShorts;

country_ls_vol    = country_long_vol + country_short_vol;
%% Value Factor Construction
country_yields = xlsread("bond_yields");
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
country_yielddiff = country_yielddiff(end-length(country_val_avail)+1:end,:);
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
country_long_val  = (country_yielddiff >= country_max_val) .* country_val_avail ./ country_val_nLongs;
country_short_val = -1 * (country_yielddiff <= country_min_val) .* country_val_avail ./ country_val_nShorts;
country_ls_val    = country_long_val + country_short_val;

%% Carry Factor
short_yields = xlsread("short_yields.xls");
% Calculate the carry factor
country_carry = country_yields - short_yields(end-length(country_yields)+1:end,:);
country_carry = country_carry(end-length(country_avail)+1:end,:);

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
country_long_car  = (country_carry >= country_max_car) .* country_avail ./ country_nLongs;
country_short_car = -1 * (country_carry <= country_min_car) .* country_avail ./ country_nShorts;
country_ls_car    = country_long_car + country_short_car;

%% Size Factor
country_size(isnan(country_size)) = 0;
country_size_dummy = country_size;
%look if returns are available
logical_returns = (country_returns ~= 0);
country_size = country_size.*logical_returns(end-length(country_size)+1:end,:);
country_size_weights = country_size./sum(country_size,2);
country_size_weights(isnan(country_size_weights))=0;

% Calculate the nth largest and smallest vol
country_min_size = zeros(length(country_size_dummy), 1);
country_max_size = zeros(length(country_size_dummy), 1);

for i = 1 : length(country_size_dummy)
    relevant_car = nonzeros(country_size_dummy(i, :) .* country_avail(i, :));
    min_el = mink(relevant_car, country_nShorts(i));
    max_el = maxk(relevant_car, country_nLongs(i));
    country_min_size(i) = min_el(end);
    country_max_size(i) = max_el(end);
end

% Generate the indicator matrices per country
country_long_size  = (country_size_dummy >= country_max_size) .* country_avail(end-length(country_max_size)+1:end,:) ./ country_nLongs(end-length(country_max_size)+1:end,:);
country_short_size = -1 * (country_size_dummy <= country_min_size) .* country_avail(end-length(country_max_size)+1:end,:) ./ country_nShorts(end-length(country_max_size)+1:end,:);
country_ls_size    = country_long_size + country_short_size;

%% Quality Factor
quality_avail = (country_quality > -10);
country_quality(isnan(country_quality)) = 0;
%look if returns are available
country_quality = country_quality.*logical_returns(end-length(country_quality)+1:end,:);
%look if quality is positive
logical_quality_long = (country_quality > 0);
logical_quality_short = (country_quality < 0);
%country_quality_long = country_quality.*logical_quality_long;
%country_quality_short = country_quality.*logical_quality_short;
country_quality_long = logical_quality_long;
country_quality_short = logical_quality_short;
%weights
country_long_qual = country_quality_long./sum(country_quality_long,2);
country_short_qual = country_quality_short./sum(country_quality_short,2);
country_ls_qual = country_long_qual - country_short_qual;

%% Test Factor Long

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

equal_weighted = sum(equal_strategy(1 : end - 1, :) .* country_returns(2 : end, :), 2);
equal_weighted = cumprod(1 + equal_weighted);
equal_weighted = [1; equal_weighted];
equal_weighted = equal_weighted(5 * year_frac : end);
equal_returns = equal_weighted(2 : end) ./ equal_weighted(1 : end - 1) - 1;
equal_nav = cumprod(1 + equal_returns);
equal_nav = [1; equal_nav];

country_size_factor_l = sum(country_long_size .* country_returns(end-length(country_long_size)+1:end, :), 2);
country_size_factor_l = cumprod(1 + country_size_factor_l);

country_quality_factor_l = sum(country_long_qual .* country_returns(end - length(country_long_qual) + 1 : end, :), 2);
country_quality_factor_l = cumprod(1 + country_quality_factor_l);

factor_matrix = [country_val_factor_l country_car_factor_l(5 * year_frac : end) country_lvol_factor_l(5 * year_frac : end) country_mom_factor_l(4 * year_frac + 1 : end) country_size_factor_l(end - 301 + 1:end) country_quality_factor_l(end - 301 + 1:end)];

factor_returns = factor_matrix(2 : end, :) ./ factor_matrix(1 : end - 1, :) - 1;
factor_nav = cumprod(1 + sum(factor_returns, 2) / 6);
factor_nav = [1; factor_nav];
factor_returns = [zeros(1, 6); factor_returns];

factor_matrix = cumprod(1 + factor_returns);
factor_matrix = [factor_matrix factor_nav];

US_yields = readtable('Yield_quandl.xls');
country_dates = table2array(US_yields(:,1));

country_dates = country_dates(end-length(factor_matrix)+1 : end);
figure(1)
plot(country_dates, factor_matrix(:, 1), '-r', country_dates, factor_matrix(:, 2), '-k', country_dates, factor_matrix(:, 3), '-g',country_dates, factor_matrix(:, 4), '-b', country_dates, factor_matrix(:, 5), '-magenta',country_dates, factor_matrix(:, 6), '-cyan',country_dates, factor_matrix(:, 7), '-.r', country_dates, equal_nav,'-.k','LineWidth',1) 
legend('Value', 'Carry', 'Low Volatility', 'Momentum', 'Size', 'Quality', 'Combo', 'Equal', 'Location','northwest')
saveas(gcf, 'Long Strategies.png');
figure(2)
plot(country_dates, factor_matrix(:, 7), '-.r', country_dates, equal_nav,'-.k','LineWidth',1)
legend('Combo', 'Equal', 'Location','northwest')
saveas(gcf, 'Long Combo.png');

%% Test Factor Long-Short

% get all factors to the same length. As value is the shortest, all
% timelines will be amended

country_lvol_factor_ls = sum(country_ls_vol(1 : end - 1, :) .* country_returns(2 : end, :), 2);
country_lvol_factor_ls = cumprod(1 + country_lvol_factor_ls);
country_lvol_factor_ls = [1; country_lvol_factor_ls];


country_mom_factor_ls = sum(country_ls_mom(1 : end - 1, :) .* country_returns(year_frac + 1 : end, :), 2);
country_mom_factor_ls = cumprod(1 + country_mom_factor_ls);
country_mom_factor_ls = [1; country_mom_factor_ls];


country_val_factor_ls = sum(country_ls_val(1 : end - 1, :) .* country_returns(year_frac * 5 + 1 : end, :), 2);
country_val_factor_ls = cumprod(1 + country_val_factor_ls);
country_val_factor_ls = [1; country_val_factor_ls];


country_car_factor_ls = sum(country_ls_car(1 : end - 1, :) .* country_returns(2 : end, :), 2);
country_car_factor_ls = cumprod(1 + country_car_factor_ls);
country_car_factor_ls = [1; country_car_factor_ls];

country_size_factor_ls = sum(country_ls_size .* country_returns(end - length(country_long_size) + 1 : end, :), 2);
country_size_factor_ls = cumprod(1 + country_size_factor_ls);

country_quality_factor_ls = sum(country_ls_qual .* country_returns(end - length(country_long_qual) + 1 : end, :), 2);
country_quality_factor_ls = cumprod(1 + country_quality_factor_ls);

factor_matrix_ls = [country_val_factor_ls country_car_factor_ls(5 * year_frac : end) country_lvol_factor_ls(5 * year_frac : end) country_mom_factor_ls(4 * year_frac + 1 : end) country_size_factor_ls(end - 301 + 1:end) country_quality_factor_ls(end - 301 + 1:end)];
factor_returns_ls = factor_matrix_ls(2 : end, :) ./ factor_matrix_ls(1 : end - 1, :) +  cumRf(end-length(factor_matrix_ls)+2 : end) - 1;
factor_nav_ls = cumprod(1 + sum(factor_returns_ls, 2) / 6);
factor_nav_ls = [1; factor_nav_ls];
factor_returns_ls = [zeros(1, 6); factor_returns_ls];

factor_matrix_ls = cumprod(1 + factor_returns_ls);
factor_matrix_ls = [factor_matrix_ls factor_nav_ls];

figure(3)
plot(country_dates, factor_matrix_ls(:, 1), '-r', country_dates, factor_matrix_ls(:, 2), '-k', country_dates, factor_matrix_ls(:, 3), '-g',country_dates, factor_matrix_ls(:, 4), '-b', country_dates, factor_matrix_ls(:, 5), '-magenta',country_dates, factor_matrix_ls(:, 6), '-cyan',country_dates, factor_matrix_ls(:, 7), '-.r', country_dates, equal_nav,'-.k', 'LineWidth',1) 
legend('Value', 'Carry', 'Low Volatility', 'Momentum', 'Size', 'Quality', 'Combo', 'Equal', 'Location','northwest')
%saveas(gcf, 'LS Strategies.png');
figure(4)
plot(country_dates, factor_matrix_ls(:, 7), '-.r',  country_dates, equal_nav,'-.k', 'LineWidth',1)
legend('Combo', 'Equal', 'Location','northwest')
%saveas(gcf, 'LS Combo.png');
%% Performance Calc Long

factor_returns = factor_matrix(2 : end, :) ./ factor_matrix(1 : end - 1, :) - 1;
equal_returns = equal_nav(2 : end) ./ equal_nav(1 : end - 1) - 1;
factor_returns = [factor_returns equal_returns];

% summarizePerformance(factor_returns - cumRf(5 * year_frac + 2 : end), cumRf(5 * year_frac + 2 : end),factor_returns(:, end),12,'Value, Carry, Low Vola, Mom, Size, Quality, Combo, Equal')

%% Performance Calc Long Short

factor_returns_ls = factor_matrix_ls(2 : end, :) ./ factor_matrix_ls(1 : end - 1, :) - 1;
factor_returns_ls = [factor_returns_ls equal_returns];

% summarizePerformance(factor_returns_ls - cumRf(5 * year_frac + 2: end), cumRf(5 * year_frac + 2 : end),factor_returns_ls(:, end),12,'Value, Carry, Low Vola, Mom, Size, Quality, Combo, Equal')

%% Save Returns

%save returns
%writetable(array2table(factor_returns), 'factor_returns_long.xls');
%writetable(array2table(factor_returns_ls), 'factor_returns_ls.xls');

%% Factor Rotation based on Momentum
Factor_Returns = factor_returns(:,1:6);
EWLong = factor_returns(:,8);

% Calculate past 12month average return
Factor_rot_ret = zeros(length(Factor_Returns)-12,6);
for i = 1:length(Factor_rot_ret)
     Factor_rot_ret(i,:) = mean(Factor_Returns(i:i+11,:));
end

% Taking only best return
logicalRotation = zeros(length(Factor_rot_ret),6);
for j = 1:length(Factor_rot_ret)
    maxL = max(Factor_rot_ret(j,:));
    logicalRotation(j,:) = (Factor_rot_ret(j,:) == maxL);
end

Factor_rot_ret = sum(logicalRotation(1:end-1,:).*Factor_Returns(end-length(logicalRotation)+2:end,:),2);
date = country_dates(end-length(Factor_rot_ret)+1:end);
EWLong = EWLong(end-length(Factor_rot_ret)+1:end);
figure(5)
plot(date,cumprod(1+Factor_rot_ret),'-.b',date,cumprod(1+EWLong),'-.k','LineWidth', 1)
legend('Factor Momentum Rotation', 'Equal', 'Location', 'northwest')

%% Factor Rotation timed on VIX
VIX = readtable("VIX.xlsx");
VIX_date = table2array(VIX(:,1));
VIX = table2array(VIX(:,2));

%% Factor Rotation timed on Business Cycles

