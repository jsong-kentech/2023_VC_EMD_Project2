clear
clc
close all

% demand to meet
P_d = 100; % demand to meet [MW] baseload role

% size your system
size_PV = 100*20; % size of PV plant [MW]
size_wind = 100*30; % size of wind plant [MW]
size_ESS = 100*50; % size of ESS [MWh]

% load the weather data
data = readtable('OBS_ASOS_TIM_20230502131624.csv','filetype','text','ReadVariableNames',0);
data.Properties.VariableNames = {'site_id','site_name','datetime','T','V','I','T_ground'};

% Replace NaN in Insolation
data.I(isnan(data.I)) = 0;


% figure(2)
% plot(data.datetime, data.I)
% ylabel('Insolation')
% return



% calculate the output of PV plant
P_pv = func_PV(data.I,data.T,size_PV); % [kW] column vector

% calculate the output of Wind plant
P_wind = func_Wind(data.V,size_wind); % [kW] column vector

% ESS operation
P_g = P_pv + P_wind;
SOC_0 = 1; % initial SOC
dt = 1; % hr
P_ess = zeros(size(P_g));
P_out = zeros(size(P_g));
SOC = zeros(size(P_g));

for i = 1:length(P_g)
    
    if i == 1
        if P_g(i)>P_d
    
            P_ess(i) = min(P_g(i)-P_d, (1-SOC_0)*size_ESS/dt);
    
        elseif P_g(i)<P_d
            P_ess(i) = max(P_g(i)-P_d, -SOC_0*size_ESS/dt);
    
        else
              P_ess(i) = 0;
    
        end
         
        SOC(i) = SOC_0 + P_ess(i)*dt/size_ESS;

    else
        if P_g(i)>P_d
    
            P_ess(i) = min(P_g(i)-P_d, (1-SOC(i-1))*size_ESS/dt);
    
        elseif P_g(i)<P_d
            P_ess(i) = max(P_g(i)-P_d, -SOC(i-1)*size_ESS/dt);
    
        else
              P_ess(i) = 0;
    
        end
         
        SOC(i) = SOC(i-1) + P_ess(i)*dt/size_ESS;

    end


    P_out(i) = P_g(i) - P_ess(i);

end

% Plot
cmat = lines(9);

figure(1)
subplot(3,1,1)
plot(data.datetime, P_pv, 'Color',cmat(1,:)); hold on
plot(data.datetime, P_wind, 'Color',cmat(2,:))
%ylim([0 200])
subplot(3,1,2)
plot(data.datetime, SOC, 'Color','black'); hold on
ylim([0 1])
subplot(3,1,3)
%plot(data.datetime, P_g, 'Color',cmat(1,:)); hold on
%plot(data.datetime, P_ess, 'Color',cmat(2,:)); hold on
plot(data.datetime, P_out, 'Color',cmat(3,:))
yline(P_d/1000)
%ylim([-100 200])
