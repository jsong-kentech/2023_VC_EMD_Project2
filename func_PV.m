function P_pv = func_PV(I,T,size_PV)
% This function calculates the output of an PV plant, given isolation and
% temperature.

% Inputs
%   I: insolation [W/m2] column vec
%   T: air temperature [degC] column vec
%   size_PV: PV plant size [MW] positive scalar

% Output
%   P_pv: Power output of PV plant [MW] column vec

% Parameters
I_ref = 1000; % reference insolation [W/m2]
Pdc_ref = size_PV; % nominal power of PV plant [MW]
gamma = -0.5/100; % temperature coefficient [1/degC]
eta = 0.77; % system efficiency [1]
T_ref = 25; % reference temperature [degC]

unit_ratio = 277.778;

% Model (refer to the lecture note)
P_dc = ((unit_ratio*I)/I_ref*Pdc_ref).*(1+gamma*(T-T_ref)); % [MW] dc output
P_pv = eta*P_dc; %[MW] ac output to grid


end