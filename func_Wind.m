function P_wind = func_Wind(V,size_wind)
% This function calculates the output of a wind turbine plant, given the
% wind speed.

% Inputs
%   V: wind speed [m/s] column vec
%   size_wind: wind turbine plant size [MW] positive scalar


% Output
%   P_wind: ac output to grid [MW] column vec

% Parameters
load("Staffell_2012_table2.mat", "table2"); %variable name: table2 (double)
    %  1st column: wind speed [m/s]
    %  8th column: power output [kW]
size_turbine = 3000; % size of a single turbine [kW]

% Interpolation
P_turbine = interp1(table2(:,1),table2(:,8),V);


% Plant output
P_wind = P_turbine*(size_wind/size_turbine); % normalize [kW] and then multiply by the size [ MW]


end