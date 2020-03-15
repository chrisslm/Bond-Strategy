function bondreturns = getbondreturns(yields, maturities, time)
    % The input yields shall be a matrix containing yields of 1 up to n
    % maturities. The maturities shall be in the columns of the matrix. The
    % yields have to have the following format, a yearly yield of 3% corresponds
    % to a 3, not 0.03. Only enter per annum yields. If yields for different 
    % maturities start at different timepoints, the
    % missing values shall be filled with NaN. The maturities vector has to
    % be a row vector with the number in years of each maturity in the
    % columns. It has to have the same column number as the yield matrix.
    % Maturities have to be in the following format: for maturities >= 1
    % year, just enter the integer value, ex. 3 years corresponds to 3 and
    % 12 years to 12. For maturities below 1 year, enter a decimal /
    % fraction, ex. 3 months corresponds to 1 / 4 and 9 months corresponds
    % to 3 / 4. Output will be a matrix of the same dimensions as the yield
    % matrix. The varibale time can either be 0, 1, or 2. 0 for daily
    % returns, 1 for monthly, 2 for yearly.
    % calculate the bond duration and convexity with the given functions 
    % and take only the relevant rows
    
    duration = getbondduration(yields, maturities);
    duration = duration(2 : end, :);
    convexity = getbondconvexity(yields, maturities);
    convexity = convexity(2 : end, :);
    yielddiff = diff(yields) / 100;
    
    % adjust the yields accordingly to calculate the respective returns
    if time == 0
        yields = (1 + yields / 100) .^ (1 / 360);
    elseif time == 1
        yields = (1 + yields / 100) .^ (1 / 12);
    else
        yields = yields / 100;
    end
    
    yields = yields(1 : end - 1, :);
    
    bondreturns = yields - duration .* yielddiff + 0.5 .* convexity .* yielddiff .^ 2 - 1;
end



