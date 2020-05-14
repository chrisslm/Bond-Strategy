function f = rolloverFutures(frontPrices, backPrices, tickers)

% Computes the returns on the front-month futures contracts rolling over 
% on the day preceding expiration. Each row represents a trading day, and 
% each column an asset.
% The return matrix will be of the same size as the incoming price matrices
% with zeros on the first row.

nDays = size(frontPrices, 1);
nAssets = size(frontPrices, 2);
dailyXsReturns = zeros(nDays, nAssets);

% Rollover days vary by asset so we need to find them separately for each.
rolloverDates = 1 - strcmp(tickers(1 : end - 1, :), tickers(2 : end, :));
% If there is no rollover, the return is based on the front-month prices.
% If there is one, the contract changed from back-month to front-month, so 
% we need to use the back-month contract in the denominator.
frontPriceReturns = frontPrices(2 : end, :) ./ frontPrices(1 : end  - 1, :) - 1;
frontBackReturns = frontPrices(2 : end, :) ./ backPrices(1 : end  - 1, :) - 1;

dailyXsReturns(2 : end, :) = frontPriceReturns .* (1 - rolloverDates) + frontBackReturns .* rolloverDates;

f = dailyXsReturns;