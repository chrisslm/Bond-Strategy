function [cumTR, cumXsR, cumRf] = aggregateFutXsReturns(originalReturns, Rf, dateList, nDigits)

% Aggregates daily futures returns over time, accounting for MTM. The
% function returns cumulative total returns, cumulative excess returns, and
% the cumulative return on the riskless asset.
% The original set of returns should be futures (i.e. excess) returns.
% Rf denotes the riskless rate for the futures' base currency.
% Dates should be provided as numeric in the format YYYYMMDD, YYMMDD, or
% MMDD. The desired aggregation level is defined by the number of digits  
% that are removed from the date list. 2 digits will aggregate daily returns 
% to monthly ones or monthly returns to annual ones. 4 digits will convert 
% daily returns to annual returns.

% Get the first and last day of each period
[firstDayList, lastDayList] = getFirstAndLastDayInPeriod(dateList, nDigits);

% Compute the overall returns on the riskless asset and the futures
% during the period, taking MTM on the futures into account
nPeriods = length(firstDayList);
nAssets = size(originalReturns, 2);
cumRf = zeros(nPeriods, 1);
aggregatedTotalReturns = zeros(nPeriods, nAssets);
for n = 1 : nPeriods
    first = firstDayList(n);
    last = lastDayList(n);
    nDays = last - first + 1;
    
    % Compute the cumulative return on the riskless asset over the period
    cumRf(n) = prod(1 + Rf(first : last)) - 1; 
    
    % Compute normalized futures prices
    futPrices = cumprod(1 + originalReturns(first : last, :));
    % Compute daily MTM gain/loss
    MTM = zeros(nDays, nAssets);
    MTM(1, :) = futPrices(1, :) - 1;
    MTM(2 : end, :) = diff(futPrices);
    % Compute the cash balance earning interest and add the interest accrual
    cash = ones(1, nAssets);
    for d = first : last
        cash = cash * (1 + Rf(d)) + MTM(d - first + 1, :);
    end
    % Total return on the futures is the end-of-period cash minus 1
    aggregatedTotalReturns(n, :) = cash - 1;   
end
cumTR = aggregatedTotalReturns;
% Compute the excess return as the return achieved with the futures 
% minus that without futures
cumXsR = aggregatedTotalReturns -  cumRf * ones(1, nAssets);
