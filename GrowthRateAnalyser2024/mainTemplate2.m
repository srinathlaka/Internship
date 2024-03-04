% main file for growth-data fit - plate reader

%% add script and data folders
addpath(genpath('script'));

%% analysis for each data file
inputs = struct();
inputs.folderData = 'dataRebecca'; %folder

file_inpunt = 'a1'; %parameter file
run(strcat(inputs.folderData,'/',file_inpunt,'.m'))
analysisFit(inputs)

%%



%% load and plot several datasets + analysis parameters
parameterAnalisis = struct();
parameterAnalisis.inputs_folderData = 'dataAriane'; %folder
parameterAnalisis.name_condition = 'xylMIN65'; %parameter file

run(strcat(parameterAnalisis.inputs_folderData,'/',parameterAnalisis.name_condition,'.m'))
analysisParameters(parameterAnalisis)
%analysisParametersRescale(parameterAnalisis)












