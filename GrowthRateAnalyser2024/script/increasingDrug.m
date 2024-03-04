function [Data,parameters] = increasingDrug(filename,Data_bkg,tin,tfin)

minut = 1;
smoothstrength = [];

Data = struct();
parameters = struct();

% %% ba
% WellsPlate = [2:5];
% databkgm = Data_bkg.ba;
% [Data.ba] = SubstractBackground(filename,databkgm.Xmean,WellsPlate,smoothstrength,minut,tin,tfin);
% 
% %to fit
% mu0 = 0.05;
% Tdata = Data.ba.XmeanSmooth;
% x0 = Tdata(1);%min(Tdata(Tdata>0));
% k = max(Tdata);
% q0 = 1e-5;
% kdeath = 1e-3;
% tswitch = 30;
% kswitch = 1e-4;
% tdeath = [];
% 
% [Data.ba,parameters.ba] = fitNoDrugSD3(Data.ba,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.ba,parameters.ba] = fitNoDrugLSD3(Data.ba,q0,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% 
% %%[Data.ba,parameters.ba] = fitNoDrugSDexp(Data.ba,mu0,x0,q0,k,kdeath,tin,tswitch,tfin,parameters);
% %[Data.ba,parameters.ba] = fitNoDrugSD(Data.ba,mu0,x0,k,kdeath,tin,tswitch,tfin,parameters);
% %[Data.ba,parameters.ba] = fitNoDrugLSD(Data.ba,mu0,x0,q0,k,kdeath,tin,tswitch,tfin,parameters);

% %% bb
% WellsPlate = [2:5]+12;
% databkgm = Data_bkg.bb;
% [Data.bb] = SubstractBackground(filename,databkgm.Xmean,WellsPlate,smoothstrength,minut,tin,tfin);
% 
% %to fit
% mu0 = 0.05;
% Tdata = Data.bb.XmeanSmooth;
% x0 = Tdata(1);%min(Tdata(Tdata>0));
% k = max(Tdata);
% q0 = 1e-3;
% kdeath = 1e-3;
% tswitch = [];
% kswitch = 1e-4;
% tdeath = [];
% 
% [Data.bb,parameters.bb] = fitNoDrugSD3(Data.bb,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.bb,parameters.bb] = fitNoDrugLSD3(Data.bb,q0,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);


% %% bc
% WellsPlate = [2:5]+2*12;
% databkgm = Data_bkg.bc;
% [Data.bc] = SubstractBackground(filename,databkgm.Xmean,WellsPlate,smoothstrength,minut,tin,tfin);
% 
% %to fit
% mu0 = 0.005;
% Tdata = Data.bc.XmeanSmooth;
% x0 = min(Tdata(Tdata>0));
% k = max(Tdata);
% q0 = 1e-3;
% kdeath = 1e-4;
% tswitch = [];
% kswitch = 5e-4;
% tdeath = [];
% klag = 1e-4;
% tlag = [];
% 
% %[Data.bc,parameters.bc] = fitNoDrugSD3(Data.bc,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.bc,parameters.bc] = fitNoDrugLSD3(Data.bc,q0,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.bc,parameters.bc] = fitNoDrugLexpSD3(Data.bc,klag,mu0,x0,k,kdeath,tin,tlag,tdeath,tswitch,tfin,kswitch,parameters);
% [Data.bc,parameters.bc] = fitNoDrugLlinearSD3(Data.bc,klag,mu0,x0,k,kdeath,tin,tlag,tdeath,tswitch,tfin,kswitch,parameters);

% %% bd
% WellsPlate = [2:5]+3*12;
% databkgm = Data_bkg.bd;
% [Data.bd] = SubstractBackground(filename,databkgm.Xmean,WellsPlate,smoothstrength,minut,tin,tfin);
% 
% %to fit
% mu0 = 0.005;
% Tdata = Data.bd.XmeanSmooth;
% x0 = min(Tdata(Tdata>0));
% k = max(Tdata);
% q0 = 1e-3;
% kdeath = 1e-4;
% tswitch = [];
% kswitch = 5e-4;
% tdeath = [];
% klag = 1e-4;
% tlag = [];
% 
% %[Data.bd,parameters.bd] = fitNoDrugSD3(Data.bd,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.bd,parameters.bd] = fitNoDrugLSD3(Data.bd,q0,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.bd,parameters.bd] = fitNoDrugLlinearSD3(Data.bd,klag,mu0,x0,k,kdeath,tin,tlag,tdeath,tswitch,tfin,kswitch,parameters);
% [Data.bd,parameters.bd] = fitNoDrugLlinearS(Data.bd,klag,mu0,x0,k,tin,tfin,tlag,parameters);

% %% be
% WellsPlate = [2:5]+4*12;
% databkgm = Data_bkg.be;
% [Data.be] = SubstractBackground(filename,databkgm.Xmean,WellsPlate,smoothstrength,minut,tin,tfin);
% 
% %to fit
% mu0 = 0.01;
% Tdata = Data.be.XmeanSmooth;
% x0 = min(Tdata(Tdata>0));
% k = max(Tdata);
% q0 = 1e-3;
% kdeath = 1e-4;
% tswitch = [];
% kswitch = 5e-4;
% tdeath = [];
% klag = 1e-4;
% tlag = 200;
% 
% %[Data.be,parameters.be] = fitNoDrugSD3(Data.be,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.be,parameters.be] = fitNoDrugLSD3(Data.be,q0,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.be,parameters.be] = fitNoDrugLlinearSD3(Data.be,klag,mu0,x0,k,kdeath,tin,tlag,tdeath,tswitch,tfin,kswitch,parameters);
% %[Data.be,parameters.be] = fitNoDrugLlinearS(Data.be,klag,mu0,x0,k,tin,tfin,tlag,parameters);
% %[Data.be,parameters.be] = fitNoDrugLlinearLS(Data.be,klag,mu0,x0,k,tin,tfin,tlag,q0,parameters);
% [Data.be,parameters.be] = fitNoDrugLlinearLexp(Data.be,klag,mu0,x0,tin,tfin,tlag,q0,parameters);

%% bf
WellsPlate = [2:5]+5*12;
databkgm = Data_bkg.bf;
[Data.bf] = SubstractBackground(filename,databkgm.Xmean,WellsPlate,smoothstrength,minut,tin,tfin);

%to fit
mu0 = 0.01;
Tdata = Data.bf.XmeanSmooth;
x0 = min(Tdata(Tdata>0));
k = max(Tdata);
q0 = 1e-3;
kdeath = 1e-4;
tswitch = [];
kswitch = 5e-4;
tdeath = [];
klag = 1e-4;
tlag = 200;

%[Data.bf,parameters.bf] = fitNoDrugSD3(Data.bf,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
%[Data.bf,parameters.bf] = fitNoDrugLSD3(Data.bf,q0,mu0,x0,k,kdeath,tin,tdeath,tswitch,tfin,kswitch,parameters);
%[Data.bf,parameters.bf] = fitNoDrugLlinearSD3(Data.bf,klag,mu0,x0,k,kdeath,tin,tlag,tdeath,tswitch,tfin,kswitch,parameters);
%[Data.bf,parameters.bf] = fitNoDrugLlinearS(Data.bf,klag,mu0,x0,k,tin,tfin,tlag,parameters);
%[Data.bf,parameters.bf] = fitNoDrugLlinearLS(Data.bf,klag,mu0,x0,k,tin,tfin,tlag,q0,parameters);
[Data.bf,parameters.bf] = fitNoDrugLlinearLexp(Data.bf,klag,mu0,x0,tin,tfin,tlag,q0,parameters);






%% plot all
plotResults(Data,parameters)

end