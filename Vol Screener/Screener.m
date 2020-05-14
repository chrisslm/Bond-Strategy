clear
clc

%% define name list 
name_list = ["Canadian Futures.xlsx", "Australian Futs.xlsx", "FrenchFutures.xlsx", "GermanyFuts.xlsx",...
    "Italian Futures.xlsx", "Japan Futures.xlsx", "Korea Futures.xlsx", "Spain Futures.xlsx",...
    "Swiss Futures.xlsx", "UK Futures.xlsx", "USFutures.xlsx"];

%% load data
analysis = {};

for j = 1 : length(name_list)
    name            = name_list(j);
    fut_data        = readtable(name);
    fut_ticker      = readtable(name,'Sheet','Sheet2');
    fut_vol         = readtable(name,'Sheet','Sheet3');

    %% Changes To data

    dates           = datetime(table2array(fut_data(6 : end - 18, 1)));

    % make necessary adjustments
    fut_price       = str2double(table2cell(fut_data(6 : end, 2 : end)));
    fut_ticker      = table2cell(fut_ticker(6 : end, 2 : end));
    fut_vol         = str2double(table2cell(fut_vol(6 : end - 18, 2 : end)));

    %% First and last days

    [first, last]   = getFirstAndLastDayInPeriod(yyyymmdd(dates), 2);
    first_days      = dates(first);
    last_days       = dates(last);

    %% Screener

    indicator       = (fut_vol(2 : end, :) == fut_vol(1 : end - 1, :));
    indicator       = [zeros(1, length(fut_vol(1, :))); indicator];
    fut_vol(find(indicator)) = 0;
    fut_vol(isnan(fut_vol)) = 0;
    cum_vol         = cumsum(fut_vol);
    monthly_vol     = zeros(length(first), length(fut_vol(1, :)));

    for i = 1 : length(first)
        monthly_vol(i, :) = cum_vol(last(i), :) - cum_vol(first(i), :);
    end
    analysis{j} = monthly_vol;
end




