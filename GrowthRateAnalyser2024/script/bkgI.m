function [Data_bkg_model,parameters_bkg_model] = bkgI(Data_bkg_model,parameters_bkg_model,filename0,tin,tfin,minut,nshift)


%minut = 1; %1 convert sec to min, 2 sec to hours, 0 keep seconds
% Data_bkg_model = struct();
% parameters_bkg_model = struct();

%% ba
WellsPlate = [1,6,7,12];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.p{1},parameters_bkg_model.p{1}] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift);

%% bb
WellsPlate = [13,18,19,24];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.p{2},parameters_bkg_model.p{2}] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift);

%% bc
WellsPlate = [25,30,31,36];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.p{3},parameters_bkg_model.p{3}] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift);

%% bd
WellsPlate = [37,42,43,48];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.p{4},parameters_bkg_model.p{4}] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift);

%% be
WellsPlate = [49,54,55,60];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.p{5},parameters_bkg_model.p{5}] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift);

%% bf
WellsPlate = [61,66,67,72];
a0 = 1e-8;
k0 = [];
n = 2;
[Data_bkg_model.p{6},parameters_bkg_model.p{6}] = finerBaselineFlexyShift(filename0,tin,tfin,WellsPlate,minut,a0,k0,n,nshift);


end