function [Data_bkg_model,parameters_bkg_model] = bkgN(Data_bkg_model,parameters_bkg_model,filename0,tin,tfin)


minut = 1; %1 convert sec to min, 2 sec to hours, 0 keep seconds
% Data_bkg_model = struct();
% parameters_bkg_model = struct();

%% ba
WellsPlate = [1,6,7,12];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.ba,parameters_bkg_model.ba] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);

%% bb
WellsPlate = [13,18,19,24];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.bb,parameters_bkg_model.bb] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);

%% bc
WellsPlate = [25,30,31,36];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.bc,parameters_bkg_model.bc] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);

%% bd
WellsPlate = [37,42,43,48];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.bd,parameters_bkg_model.bd] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);

%% be
WellsPlate = [49,54,55,60];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.be,parameters_bkg_model.be] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);

%% bf
WellsPlate = [61,66,67,72];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.bf,parameters_bkg_model.bf] = finerBaselineFlexyN(filename0,tin,tfin,WellsPlate,minut,a0,k0,n);





end