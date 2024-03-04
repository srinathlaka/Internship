inputs.expN = 14; %a number for your reference
inputs.fileDataBkg = '3_20230726_arranged_glyMIN different concentrations and glyRDM (0µg per ml Mecillinam) and gluRDM (0µg per ml Mecillinam)'; %bkg file(s)
inputs.bkgWells = {[13,25,18,30]+6};
inputs.fileDataExp = '3_20230726_arranged_glyMIN different concentrations and glyRDM (0µg per ml Mecillinam) and gluRDM (0µg per ml Mecillinam)'; %exp file(s)
inputs.expWells = {[14:17,26:29]+6};
inputs.tinFit = {[]};
inputs.tfinFit = {[]};
inputs.modelN = 11;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
