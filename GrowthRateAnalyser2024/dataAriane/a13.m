inputs.expN = 13; %a number for your reference
inputs.fileDataBkg = '3_20230726_arranged_glyMIN different concentrations and glyRDM (0µg per ml Mecillinam) and gluRDM (0µg per ml Mecillinam)'; %bkg file(s)
inputs.bkgWells = {[13,25,18,30]}; % {[14,15,26,27];[3,4]}
inputs.fileDataExp = '3_20230726_arranged_glyMIN different concentrations and glyRDM (0µg per ml Mecillinam) and gluRDM (0µg per ml Mecillinam)'; %exp file(s)
inputs.expWells = {[14:17,26:29]}; % {[14,15,26,27];[3,4]}
inputs.tinFit = {[]};
inputs.tfinFit = {[193]};
inputs.modelN = 14;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
