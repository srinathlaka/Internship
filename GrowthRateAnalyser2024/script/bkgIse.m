function [Data_bkg_model,parameters_bkg_model] = bkgIse(filename0,tin,tfin)


minut = 1; %1 convert sec to min, 2 sec to hours, 0 keep seconds
Data_bkg_model = struct();
parameters_bkg_model = struct();

%% ba
WellsPlate = [1,6,7,12];
a0 = 1e-5;
k0 = [];
n = 2;
[Data_bkg_model.ba,parameters_bkg_model.ba] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);



end