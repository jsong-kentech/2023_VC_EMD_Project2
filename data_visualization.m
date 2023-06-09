clc; clear; close all;


% Interface
fullpath_data = 'C:\Users\jsong\Documents\MATLAB\2023_VC_EMD_Project2\OBS_ASOS_TIM_20230502131624.csv';


% Load data
data = readtable(fullpath_data,'filetype','text','ReadVariableNames',0);
data.Properties.VariableNames = {'site_id','site_name','datetime','T','V','I','T_ground'};
data.Y = year(data.datetime);
data.M = month(data.datetime);
data.D = day(data.datetime);
data.H = hour(data.datetime);
data.m = minute(data.datetime);

% Replace NaN in Insolation
data.I(isnan(data.I)) = 0;

% day count
dcount = 1;
data.dcount(1) = dcount;
for i = 2:size(data,1)
    if data.D(i) ~= data.D(i-1)
        dcount = dcount +1;
    end
    data.dcount(i) = dcount; 
end

% Rearrange data into daily struct
dcount_vec = unique(data.dcount);
for j = 1:length(dcount_vec)
    
    day_range = data.dcount ==dcount_vec(j);

%     if length(day_range) ~= 24 && j ~=1
%         error('number of daily data is wrong')
%     end

    dcount_vec2 = data.dcount(day_range);
    ddata(j).dcount = dcount_vec2(1);

    month_vec = data.M(day_range);
    ddata(j).M = month_vec(1);

    day_vec = data.D(day_range);
    ddata(j).D = day_vec(1);

    ddata(j).H = data.H(day_range);
    ddata(j).T = data.T(day_range);
    ddata(j).V = data.V(day_range);
    ddata(j).I = data.I(day_range);
    ddata(j).T_ground = data.T_ground(day_range);

end


% plot

color_mat = lines(max(data.M));
alpha = 0.03;

for k = 1:length(ddata)
    
    figure(1);
    box on; hold on;
    plot(ddata(k).H,ddata(k).V,'Color',[color_mat(1,:),alpha],'linewidth',4);
    

    figure(2);
    box on; hold on;
    plot(ddata(k).H,ddata(k).I,'Color',[color_mat(2,:),alpha],'linewidth',4);
    



end


figure(1)
xlim([0 24])
xlabel('Hour of day (Hr)')
ylabel('Wind speed (m/s)')

figure(2)
xlim([0 24])
xlabel('Hour of day (Hr)')
ylabel('Insolation (MJ/m^2)')

