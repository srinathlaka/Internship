function [convert,convertf,units_label,units_labelf] = loadandplotDataset(inputs_folderData,name_condition,parameter_to_plot,condition_names,condition_ylabel,convert_unit,condition_value)


%% load

name_condition = strcat(inputs_folderData,'/',name_condition);
%load(strcat(name_condition,'/Dataset.mat'),'DataF')
load(strcat(name_condition,'/parametersFtest.mat'),'parametersF')

if convert_unit ==1
    convert = 1/60;
    if parameter_to_plot == 2 || parameter_to_plot == 5 || parameter_to_plot == 8 || parameter_to_plot == 10
        units_label = '[min]';
    else
        units_label = '[1/min]';
    end
    units_labelf = '[min]';
elseif convert_unit ==2
    convert = 1/3600;
    if parameter_to_plot == 2 || parameter_to_plot == 5 || parameter_to_plot == 8 || parameter_to_plot == 10
        units_label = '[h]';
    else
        units_label = '[1/h]';
    end
    units_labelf = '[h]';
else
    convert = 1;
    if parameter_to_plot == 2 || parameter_to_plot == 5 || parameter_to_plot == 8 || parameter_to_plot == 10
        units_label = '[sec]';
    else
        units_label = '[1/sec]';
    end
    units_labelf = '[sec]';
end

%% parameter

nexp = size(parametersF.p,2);
%vectorcolor = distinguishable_colors(nexp);

% parameters0 = [1 klag,2 tlag*,3 q,4 mu,5 tswitch*,6 kswitch,7 ks--,8 t--,9 k--,10 tdeath*,11 kdeath,12 m, 13 x0*, 14 k*, 15 k2*, 16 k3*]; time in cycles

%store the paremeter chosen in a vector % eg mu is in position 4
model_series = zeros(nexp,1);
model_error = zeros(nexp,1);
model_series_u = zeros(nexp,1);
model_error_u = zeros(nexp,1);
for i=1:nexp
    if parameter_to_plot == 2 || parameter_to_plot == 5 || parameter_to_plot == 8 || parameter_to_plot == 10
        model_series(i) = convert.*parametersF.p{i}(parameter_to_plot); %mean
        model_error(i) = convert.*parametersF.s{i}(parameter_to_plot);  %std
        convertf = convert;
    elseif parameter_to_plot == 1 || parameter_to_plot == 4 || parameter_to_plot == 6 || parameter_to_plot == 7 || parameter_to_plot == 9 || parameter_to_plot == 11 || parameter_to_plot == 14 || parameter_to_plot == 15 || parameter_to_plot == 16
        model_series(i) = (1./convert).*parametersF.p{i}(parameter_to_plot); %mean
        model_error(i) = (1./convert).*parametersF.s{i}(parameter_to_plot);  %std
        convertf = 1./convert;
    else
        model_series(i) = parametersF.p{i}(parameter_to_plot); %mean
        model_error(i) = parametersF.s{i}(parameter_to_plot);  %std
        convertf = 1;
    end
    model_series_u(i) = parametersF.p{i}(parameter_to_plot); %mean
    model_error_u(i) = parametersF.s{i}(parameter_to_plot);  %std
end

figure
barx = categorical(condition_names); %%%%%%%%%% name of datasets
b = bar(barx,model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',model_series,model_error,'k','linestyle','none');
xtickangle(45)
%xlabel('Condition')
ylabel([condition_ylabel,' ',units_label])
hold off

%% lag
% %% example of plotting a parameter in a barplot
%
% nexp = size(parametersF.p,2);
% %vectorcolor = distinguishable_colors(nexp);
%
% % parameters0 = [1 klag,2 tlag*,3 q,4 mu,5 tswitch*,6 kswitch,7 ks--,8 t--,9 k--,10 tdeath*,11 kdeath,12 m, 13 x0*, 14 k*, 15 k2*, 16 k3*]; time in cycles
%
% %store the paremeter chosen in a vector % eg mu is in position 4
% model_series = zeros(nexp,1);
% model_error = zeros(nexp,1);
% for i=1:nexp
%     model_series(i) = (log(1+1./parametersF.p{i}(3)))./parametersF.p{i}(4); %mean  %%%%%%%%%% 4 for mu
%     model_error(i) = model_series(i).*sqrt((parametersF.s{i}(4)./parametersF.p{i}(4)).^2+(parametersF.s{i}(3)./parametersF.p{i}(3)).^2);  %std %%%%%%%%%% 4
% end
%
% figure
% barx = categorical({'1','2'}); %%%%%%%%%% name of datasets
% b = bar(barx,model_series, 'grouped');
% hold on
% % Calculate the number of groups and number of bars in each group
% [ngroups,nbars] = size(model_series);
% % Get the x coordinate of the bars
% x = nan(nbars, ngroups);
% for i = 1:nbars
%     x(i,:) = b(i).XEndPoints;
% end
% % Plot the errorbars
% errorbar(x',model_series,model_error,'k','linestyle','none');
% xtickangle(45)
% xlabel('Dataset')
% ylabel('Lag time [h]')
% hold off

%% save to file
file_excel = strcat(name_condition,'/',condition_ylabel,'.xlsx');
a = ['mean ',condition_ylabel,' ',units_label];
b = ['std ',condition_ylabel,' ',units_label];
A = [x',condition_value',model_series,model_error];
A_u = [condition_value',model_series_u,model_error_u];
T = array2table(A,'VariableNames', {'Condition','Condition value',a,b});
writetable(T, file_excel, 'WriteVariableNames', true);
save(strcat(name_condition,'/',condition_ylabel,'.mat'),'A_u')
%writematrix(A,file_excel,'Sheet',1)


end


