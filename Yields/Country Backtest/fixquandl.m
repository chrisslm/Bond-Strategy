%% Fix Quandl

data = readtable("FED-SVENY.csv");
data = flipud(data);
dates = datetime(table2array(data(:, 1)));
[first, last] = getFirstAndLastDayInPeriod(yyyymmdd(dates), 2);
first_days = dates(first);
last_days   = dates(last);
yields = data(last, :);
yields = yields(225 : end - 1, :);
yields(:, 12 : 15) = [];
yields(:, 13 : 16) = [];
yields(:, 14 : 22) = [];
varNames = yields.Properties.VariableNames;
new_tab   = array2table((exp(table2array(yields(:, 2 : end)) ./ 100) - 1) * 100, 'VariableNames',varNames(2 : end));
h = yields;
yields(:, 2 : end)= new_tab;
writetable(yields, "Quandl_cleaned.xlsx")