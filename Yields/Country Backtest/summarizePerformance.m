function summarizePerformance(xsReturns, Rf, factorXsReturns, annualizationFactor, txt)

% Computes performance statistics. Standard deviation, min, max, skewness 
% and kurtosis are reported for excess returns.
% 
% The returns provided in xsReturns should be excess returns, one column  
% per asset or strategy, one row per period. The column vector Rf should  
% contain the return on the riskless asset during each period. The factor 
% returns are used to compute factor exposures and alphas. The   
% annualization factor is used for the Sharpe ratio, it should be 12 for 
% monthly data and 252 for daily data. The text is used for labeling. 

% Compute total returns
nAssets = size(xsReturns, 2);
totalReturns = xsReturns + Rf * ones(1, nAssets);

% Compute the terminal value of the portfolios to get the geometric mean
% return per period
nPeriods = size(xsReturns, 1);
FinalPfValRf = prod(1 + Rf);
FinalPfValTotalRet = prod(1 + totalReturns);
GeomAvgRf = 100 * (FinalPfValRf.^(1 / nPeriods) - 1);
GeomAvgTotalReturn = 100 * (FinalPfValTotalRet.^(1 / nPeriods) - 1);
GeomAvgXsReturn = GeomAvgTotalReturn - GeomAvgRf;

% Regress returns on benchmark to get alpha and factor exposures
X = [ones(nPeriods, 1) factorXsReturns];
b = inv(X' * X) * X' * xsReturns;
betas = b(2 : end, :);


% Based on the regression estimates, compute the total return on the passive 
% alternative and the annualized alpha
bmRet = factorXsReturns * betas + Rf * ones(1, nAssets);
FinalPfValBm = prod(1 + bmRet);
alphaAnnualized = 100 * ((FinalPfValTotalRet ./ FinalPfValBm).^(annualizationFactor / nPeriods) - 1);


% Rescale the returns to be in percentage points
xsReturns = 100 * xsReturns;
totalReturns = 100 * totalReturns;


% Report the statistics
disp(['Performance Statistics for ' txt]);
ArithmAvgTotalReturn = mean(totalReturns)
ArithmAvgXsReturn = mean(xsReturns)
StdXsReturns = std(xsReturns); 
SharpeArithmetic = sqrt(annualizationFactor) * ArithmAvgXsReturn ./ StdXsReturns
SharpeGeometric = sqrt(annualizationFactor) * GeomAvgXsReturn ./ StdXsReturns
StdXsReturns = std(xsReturns) * sqrt(annualizationFactor)
GeomAvgTotalReturn = ((1 + GeomAvgTotalReturn ./ 100).^annualizationFactor - 1) .* 100
GeomAvgXsReturn = ((1 + GeomAvgXsReturn  ./ 100).^annualizationFactor - 1) .* 100
MinXsReturn = min(xsReturns)
MaxXsReturn = max(xsReturns)
SkewXsReturn = skewness(xsReturns)
KurtXsReturn = kurtosis(xsReturns)
alpha = 100 * b(1, :)
alphaAnnualized
betas
% Report first three autocorrelations
AC1 = diag(corr(xsReturns(1:end-1, :), xsReturns(2:end, :)))'
AC2 = diag(corr(xsReturns(1:end-2, :), xsReturns(3:end, :)))'
AC3 = diag(corr(xsReturns(1:end-3, :), xsReturns(4:end, :)))'

