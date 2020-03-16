function [firstDayList, lastDayList] = getFirstAndLastDayInPeriod(dateList, nDigits)

% Generate arrays listing the first and last observation in each period.
% Dates should be provided as numeric in the format YYYYMMDD, YYMMDD, or
% MMDD. The granularity of the period is defined by the number of digits  
% that are removed from the date list. 2 digits will convert daily data to 
% monthly data or monthly data to annual data. 4 digits will convert 
% daily data to annual data.

% Begin by marking the last observation in each period in the data
nObs = length(dateList);
scalingFactor = 1 / 10^nDigits;
trimmedDate = round(dateList * scalingFactor);
lastDayOfPeriod = diff(trimmedDate);
% Same as: lastDayOfPeriod = trimmedDate(1 : nObs - 1, 1) - trimmedDate(2 : nObs, 1);

% Generate a list with the last days, and use it to generate the list of
% the first days
lastDayList = find(lastDayOfPeriod);
firstDayList = lastDayList + 1;
lastDayList = [lastDayList; nObs];  % Add the last day in the sample
firstDayList = [1; firstDayList];   % Add the first day in the sample
