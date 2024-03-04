inputs.expN = 1121; %a number for your reference
inputs.fileDataBkg = '2_20230419_arranged_Ise_gluMIIN gluCAA glyCAA 2 Mecillinam concentrations'; %bkg file(s)
inputs.bkgWells = {[13,25,18,30]+48};
inputs.fileDataExp = '2_20230419_arranged_Ise_gluMIIN gluCAA glyCAA 2 Mecillinam concentrations'; %exp file(s)
inputs.expWells = {[26:29]+48}; %{[14:17,26:29]+48};
inputs.tinFit = {[328]};
inputs.tfinFit = {[]};
inputs.modelN = 14;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
