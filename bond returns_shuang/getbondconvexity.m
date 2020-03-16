function convexity = getbondconvexity(yields, maturities)
    % The input yields shall be a matrix containing yields of 1 up to n
    % maturities. The maturities shall be in the columns of the matrix. The
    % yields have to have the following format, a yearly yield of 3% corresponds
    % to a 3, not 0.03. Only input per annum yields. If yields for different maturities start at different timepoints, the
    % missing values shall be filled with NaN. The maturities vector has to
    % be a row vector with the number in years of each maturity in the
    % columns. It has to have the same column number as the yield matrix.
    % Maturities have to be in the following format: for maturities >= 1
    % year, just enter the integer value, ex. 3 years corresponds to 3 and
    % 12 years to 12. For maturities below 1 year, enter a decimal /
    % fraction, ex. 3 months corresponds to 1 / 4 and 9 months corresponds
    % to 3 / 4. Output will be a matrix of the same dimensions as the yield
    % matrix.
    obs = length(yields(:, 1));
    maturities = ones(obs, 1) * maturities;
    convexity = (2 ./ (yields ./ 100) .^ 2) .* (1 - (1 ./ (1 + yields ./ 200) .^ (2 .* maturities))) - 2 * maturities ./ ((yields / 100) .* (1 + yields / 200) .^ (2 * maturities + 1));
end