function [DataDrug,parametersDrug] = plateDrugAllGrowthDecline(filename,DataDrug,parametersDrug,Data_bkg_model,tin,tdrug,tfin)


%% m9

mu0 = 0.06;
q0 = 0.01;
k0 = 0.1;
d0 = 1e-4;
g = 1e-3;
WellsPlate = [1:6]; %only of the bacteria, drug wells are added +6
databkgm = Data_bkg_model.m9;

%this fucntion fit equally with and without drug, not dividing the time
%before and after 2h when te drug is added
[DataDrug.m9,DataDrug.m9drug,parametersDrug.m9,parametersDrug.m9drug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% CA

mu0 = 0.07;
q0 = 0.0045;
k0 = 0.073;
d0 = 1e-4;
g = 1e-4;
WellsPlate = [13:18];
databkgm = Data_bkg_model.m9CA;

[DataDrug.CA,DataDrug.CAdrug,parametersDrug.CA,parametersDrug.CAdrug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% CDCA

mu0 = 0.074;
q0 = 0.0058;
k0 = 0.065;
d0 = 1e-4;
g = 1e-4;
WellsPlate = [25:30];
databkgm = Data_bkg_model.m9CDCA;

[DataDrug.CDCA,DataDrug.CDCAdrug,parametersDrug.CDCA,parametersDrug.CDCAdrug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% DCA

mu0 = 0.067;
q0 = 0.0053;
k0 = 0.068;
d0 = 1e-4;
g = 1e-4;
WellsPlate = [37:42];
databkgm = Data_bkg_model.m9DCA;

[DataDrug.DCA,DataDrug.DCAdrug,parametersDrug.DCA,parametersDrug.DCAdrug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% LCA

mu0 = 0.067;
q0 = 0.0053;
k0 = 0.068;
d0 = 1e-4;
g = 1e-4;
WellsPlate = [49:54];
databkgm = Data_bkg_model.m9LCA;

[DataDrug.LCA,DataDrug.LCAdrug,parametersDrug.LCA,parametersDrug.LCAdrug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% UDCA

mu0 = 0.099;
q0 = 0.0011;
k0 = 0.066;
d0 = 1e-4;
g = 1e-4;
WellsPlate = [61:66];
databkgm = Data_bkg_model.m9UDCA;

[DataDrug.UDCA,DataDrug.UDCAdrug,parametersDrug.UDCA,parametersDrug.UDCAdrug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% CBC

mu0 = 0.081;
q0 = 0.0054;
k0 = 0.097;
d0 = 1e-4;
g = 1e-4;
WellsPlate = [72:77];
databkgm = Data_bkg_model.m9CBC;

[DataDrug.CBC,DataDrug.CBCdrug,parametersDrug.CBC,parametersDrug.CBCdrug] = fitDataGrowthAllDrugDecline(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,g,tin,tdrug,tfin);

%% plot all
plotResults(DataDrug,parametersDrug)

end