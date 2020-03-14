clear
clc

%% Load Data

yields = readtable("Yields 1998 - 2020.xlsx");
dates = table2array(yields(:, 1));
yields = table2array(yields(:, 2 : end));
rf = yields(:, 1) / 100;
yields = yields(:, 2 : end);

returns = readtable("Bondreturns 1998 - 2020.xlsx");
monthly_returns = table2array(returns(:, 3 : end));

inflation_exp = readtable("InflationExpectation.xlsx");
inflation_exp = table2array(inflation_exp(:, 2 : end));

duration = readtable("Duration 1998 - 2020.xlsx");
duration = table2array(duration(:, 2 : end));


nLongs = 3;
nShorts = 3;
nMonths = length(dates);
nYields = length(yields(1, :));

%% Calculate Yearly Returns

bond_prices = cumprod(monthly_returns + 1);
bond_prices = [ones(1, nYields); bond_prices];
yearly_returns = bond_prices(12 : end, :) ./ bond_prices(1 : end - 11, :) - 1;

%% Calculate Factors

yield_infl = yields - inflation_exp;

% short leg value
yield_infl_min = mink(yield_infl', nShorts)';
yield_infl_min = yield_infl_min(:, end);

% long leg value
yield_infl_max = maxk(yield_infl', nLongs)';
yield_infl_max = yield_infl_max(:, end);

% value long and short
value_short_indicator = (yield_infl <= yield_infl_min) ./ nShorts;
value_long_indicator = (yield_infl >= yield_infl_max) ./ nLongs;
value_indicator = value_long_indicator - value_short_indicator;

value_long = sum(value_long_indicator(1 : end - 1, :) .* monthly_returns, 2);
value_long = cumprod(1 + value_long);

value_factor_LS = sum(value_indicator(1 : end - 1, :) .* monthly_returns, 2);
value_factor_LS = cumprod(1 + value_factor_LS);

% short leg momentum
ret_min = mink(yearly_returns', nShorts)';
ret_min = ret_min(:, end);

% long leg momentum
ret_max = maxk(yearly_returns', nLongs)';
ret_max = ret_max(:, end);

% momentum long and short
momentum_short_indicator = (yearly_returns <= ret_min) ./ nShorts;
momentum_long_indicator = (yearly_returns >= ret_max) ./ nLongs;
momentum_indicator = momentum_long_indicator - momentum_short_indicator;

momentum_long = sum(momentum_long_indicator(1 : end - 1, :) .* monthly_returns(12 : end, :), 2);
momentum_long = cumprod(1 + momentum_long);

momentum_factor_LS = sum(momentum_indicator(1 : end - 1, :) .* monthly_returns(12 : end, :), 2);
momentum_factor_LS = cumprod(1 + momentum_factor_LS);


% short leg value
yield_min = mink(yields', nShorts)';
yield_min = yield_min(:, end);

% long leg value
yield_max = maxk(yields', nLongs)';
yield_max = yield_max(:, end);

% value long and short
carry_short_indicator = (yields <= yield_min) ./ nShorts;
carry_long_indicator = (yields >= yield_max) ./ nLongs;
carry_indicator = carry_long_indicator - carry_short_indicator;

carry_long = sum(carry_long_indicator(1 : end - 1, :) .* monthly_returns, 2);
carry_long = cumprod(1 + carry_long);

carry_factor_LS = sum(carry_indicator(1 : end - 1, :) .* monthly_returns, 2);
carry_factor_LS = cumprod(1 + carry_factor_LS);

% long leg defensive
defensive_long_indicator = zeros(nMonths, nYields);
defensive_long_indicator(:, 1 : 4) = ones(nMonths, 4) / 4;
long_duration = sum((defensive_long_indicator .* duration(:, 2 : end))')';

% short leg defensive
defensive_short_indicator = zeros(nMonths, nYields);
defensive_short_indicator(:, 13 : end) = ones(nMonths, 20) / 20;
short_duration = sum((defensive_short_indicator .* duration(:, 2 : end))')';
defensive_short_adj = defensive_short_indicator .* long_duration ./ short_duration;
short_leg = sum(defensive_short_adj')';

defensive_indicator = defensive_long_indicator - defensive_short_indicator;
defensive_indicator_adj = defensive_long_indicator - defensive_short_adj;

defensive_factor_adj = sum(defensive_indicator_adj(1 : end - 1, :) .* monthly_returns, 2);
defensive_factor_adj = cumprod(1 + defensive_factor_adj);


output = [carry_long carry_factor_LS defensive_factor_adj];
writematrix(momentum_long, "output.xlsx")

