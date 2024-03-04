function analysisParameters(parameterAnalisis)

exps_to_load = parameterAnalisis.exps_to_load;
convert_unit = parameterAnalisis.convert_unit;

condition_ylabel = parameterAnalisis.condition_ylabel;
parameter_to_plot = parameterAnalisis.parameter_to_plot;
condition_names = parameterAnalisis.condition_names;
condition_value = parameterAnalisis.condition_value;

name_condition = parameterAnalisis.name_condition;
inputs_folderData = parameterAnalisis.inputs_folderData;

%% analysis
datasetsAnalysis(inputs_folderData,exps_to_load,name_condition,convert_unit)

%% load and plot%
% parameters0 = [1 klag,2 tlag*,3 q,4 mu,5 tswitch*,6 kswitch,7 ks--,8 t--,9 k--,10 tdeath*,11 kdeath,12 m, 13 x0*, 14 k*, 15 k2*, 16 k3*]; time in cycles

% condition_ylabel = 'Growth rate';
% parameter_to_plot = 4;
% condition_names = {'0','1.5','30'};
% condition_value = [0,1.5,30];

[~,~,~,~] = loadandplotDataset(inputs_folderData,name_condition,parameter_to_plot,condition_names,condition_ylabel,convert_unit,condition_value);


end