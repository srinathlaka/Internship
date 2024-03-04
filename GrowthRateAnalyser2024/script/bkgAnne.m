function [Data_bkg_model,parameters_bkg_model] = bkgAnne(filename0)


minut = 1; %1 convert sec to min, 2 sec to hours, 0 keep seconds
Data_bkg_model = struct();
parameters_bkg_model = struct();

%% m9
WellsPlate = [1:6];
tin = 1;
tfin = 97;
a0 = 1e-3;
k0 = [];
[Data_bkg_model.m9,parameters_bkg_model.m9] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% m9+CA
WellsPlate = [13:18];
a0 = 5e-5;
k0 = [];
[Data_bkg_model.m9CA,parameters_bkg_model.m9CA] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% m9+CDCA
WellsPlate = [25:30];
a0 = 5e-5;
k0 = [];
[Data_bkg_model.m9CDCA,parameters_bkg_model.m9CDCA] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% m9+DCA
WellsPlate = [37:42];
a0 = 5e-5;
k0 = [];
[Data_bkg_model.m9DCA,parameters_bkg_model.m9DCA] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% m9+LCA
WellsPlate = [49:54];
a0 = 5e-5;
k0 = [];
[Data_bkg_model.m9LCA,parameters_bkg_model.m9LCA] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% m9+UDCA 
WellsPlate = [61:66];
a0 = 5e-2;
k0 = [];
[Data_bkg_model.m9UDCA,parameters_bkg_model.m9UDCA] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% m9+CBC
WellsPlate = [73:78];
a0 = 5e-5;
k0 = [];
[Data_bkg_model.m9CBC,parameters_bkg_model.m9CBC] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);

%% empty bkg
WellsPlate = [85:90];
a0 = 5e-7;
k0 = [];
[Data_bkg_model.empty,parameters_bkg_model.empty] = finerBaselineFlexy1(filename0,tin,tfin,WellsPlate,minut,a0,k0);



end