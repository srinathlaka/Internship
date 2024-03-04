inputs.expN = 20; %a number for your reference
inputs.fileDataBkg = '4_20230726_arranged_gluMIN glyCAA gluCAA each 0µg per ml Mecillinam'; %bkg file(s)
inputs.bkgWells = {[13,18,25,30]+48}; % {[14,15,26,27];[3,4]}
inputs.fileDataExp = '4_20230726_arranged_gluMIN glyCAA gluCAA each 0µg per ml Mecillinam'; %exp file(s)
inputs.expWells = {[14:17,26:29]+48};
inputs.tinFit = {[]};
inputs.tfinFit = {[]};
inputs.modelN = 11;

inputs.tin = {[]};
inputs.tfin = {[]};
inputs.averagecurves = 1; %0 no, 1 yes
inputs.reanalysis = 1; %0 do only fit, 1 analysis + fit
inputs.fitYN = 1; %fit 1 yes 0 no
