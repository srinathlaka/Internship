inputs.expN = 21; %a number for your reference
inputs.fileDataBkg = '5_20230901_arranged_xylMin different Meciliinam concentrations'; %bkg file(s)
inputs.bkgWells = {[13,25]}; %{[13,20,25,32]}; % {[14,15,26,27];[3,4]}
inputs.fileDataExp = '5_20230901_arranged_xylMin different Meciliinam concentrations'; %exp file(s)
inputs.expWells = {[14:19,26:31]}; % {[14,15,26,27];[3,4]}
inputs.tinFit = {[]};
inputs.tfinFit = {[163]};
inputs.modelN = 14;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
