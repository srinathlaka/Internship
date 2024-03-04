inputs.expN = 24; %a number for your reference
inputs.fileDataBkg = '6_20230915_arranged_high pH_glyMIN and glyRDM different Mecillinam concentrations'; %bkg file(s)
inputs.bkgWells = {[13,18,25,30]}; % {[14,15,26,27];[3,4]}
inputs.fileDataExp = '6_20230915_arranged_high pH_glyMIN and glyRDM different Mecillinam concentrations'; %exp file(s)
inputs.expWells = {[14:17,26:29]}; % {[14,15,26,27];[3,4]}
inputs.tinFit = {[]};
inputs.tfinFit = {[238]};
inputs.modelN = 14;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
