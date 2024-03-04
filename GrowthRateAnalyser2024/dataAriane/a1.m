inputs.expN = 1; %a number for your reference
inputs.fileDataBkg = '1_20230419_arranged_Ise_glyMIIN gluRDM glyRDM 2 Mecillinam concentrations'; %bkg file(s)
inputs.bkgWells = {[13,18,25,30]}; % {[14,15,26,27];[3,4]}
inputs.fileDataExp = '1_20230419_arranged_Ise_glyMIIN gluRDM glyRDM 2 Mecillinam concentrations'; %exp file(s)
inputs.expWells = {[14:17,26:29]}; % {[14,15,26,27];[3,4]}
inputs.tinFit = {[]};
inputs.tfinFit = {[169]};
inputs.modelN = 11;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
