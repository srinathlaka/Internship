function [DataDrug,parametersDrug] = plateDrugAllDeath(filename,DataDrug,parametersDrug,Data_bkg_model,tin,tdrug,tfin)


%% m9

mu0 = 0.049;
q0 = 0.01;
k0 = 0.099;
d0 = 1e-4; 
dm0 = 1e-4;
WellsPlate = [1:6]; %only of the bacteria, drug wells are added +6
databkgm = Data_bkg_model.m9;

%this fucntion fit equally with and without drug, not dividing the time
%before and after 2h when te drug is added
[DataDrug.m9,DataDrug.m9cipro,parametersDrug.m9,parametersDrug.m9cipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% CA

mu0 = 0.07;
q0 = 0.0045;
k0 = 0.073;
d0 = 1e-4;
dm0 = 1e-4;
WellsPlate = [13:18];
databkgm = Data_bkg_model.m9CA;

[DataDrug.CA,DataDrug.CAcipro,parametersDrug.CA,parametersDrug.CAcipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% CDCA

mu0 = 0.074;
q0 = 0.0058;
k0 = 0.065;
d0 = 1e-4; dm0 = 1e-4;
WellsPlate = [25:30];
databkgm = Data_bkg_model.m9CDCA;

[DataDrug.CDCA,DataDrug.CDCAcipro,parametersDrug.CDCA,parametersDrug.CDCAcipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% DCA

mu0 = 0.067;
q0 = 0.0053;
k0 = 0.068;
d0 = 1e-4; 
dm0 = 1e-4;
WellsPlate = [37:42];
databkgm = Data_bkg_model.m9DCA;

[DataDrug.DCA,DataDrug.DCAcipro,parametersDrug.DCA,parametersDrug.DCAcipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% LCA

mu0 = 0.067;
q0 = 0.0053;
k0 = 0.068;
d0 = 1e-4; 
dm0 = 1e-4;
WellsPlate = [49:54];
databkgm = Data_bkg_model.m9LCA;

[DataDrug.LCA,DataDrug.LCAcipro,parametersDrug.LCA,parametersDrug.LCAcipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% UDCA

mu0 = 0.099;
q0 = 0.0011;
k0 = 0.066;
d0 = 1e-4; 
dm0 = 1e-4;
WellsPlate = [61:66];
databkgm = Data_bkg_model.m9UDCA;

[DataDrug.UDCA,DataDrug.UDCAcipro,parametersDrug.UDCA,parametersDrug.UDCAcipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% CBG

mu0 = 0.081;
q0 = 0.0054;
k0 = 0.097;
d0 = 1e-4; 
dm0 = 1e-4;
WellsPlate = [72:77];
databkgm = Data_bkg_model.m9CBG;

[DataDrug.CBG,DataDrug.CBGcipro,parametersDrug.CBG,parametersDrug.CBGcipro] = fitDataGrowthAllDrugDeath(WellsPlate,filename,databkgm,parametersDrug,mu0,q0,k0,d0,dm0,tin,tdrug,tfin);

%% plot all

figure
%m9
plot(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.m9.time,DataDrug.m9.XmeanSmooth,DataDrug.m9.Xstd);

plot(DataDrug.m9cipro.time,DataDrug.m9cipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.m9cipro.time,DataDrug.m9cipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.m9cipro.time,DataDrug.m9cipro.XmeanSmooth,DataDrug.m9.Xstd);

plot(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,10,'k','filled');

%CA
plot(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CA.time,DataDrug.CA.XmeanSmooth,DataDrug.CA.Xstd);

plot(DataDrug.CAcipro.time,DataDrug.CAcipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.CAcipro.time,DataDrug.CAcipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CAcipro.time,DataDrug.CAcipro.XmeanSmooth,DataDrug.CAcipro.Xstd);

plot(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),10,'k','filled');

%CDCA
plot(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CDCA.time,DataDrug.CDCA.XmeanSmooth,DataDrug.CDCA.Xstd);

plot(DataDrug.CDCAcipro.time,DataDrug.CDCAcipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.CDCAcipro.time,DataDrug.CDCAcipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CDCAcipro.time,DataDrug.CDCAcipro.XmeanSmooth,DataDrug.CDCAcipro.Xstd);

plot(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),10,'k','filled');

%DCA
plot(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.DCA.time,DataDrug.DCA.XmeanSmooth,DataDrug.DCA.Xstd);

plot(DataDrug.DCAcipro.time,DataDrug.DCAcipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.DCAcipro.time,DataDrug.DCAcipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.DCAcipro.time,DataDrug.DCAcipro.XmeanSmooth,DataDrug.DCAcipro.Xstd);

plot(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),10,'k','filled');

%LCA
plot(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.LCA.time,DataDrug.LCA.XmeanSmooth,DataDrug.DCA.Xstd);

plot(DataDrug.LCAcipro.time,DataDrug.LCAcipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.LCAcipro.time,DataDrug.LCAcipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.LCAcipro.time,DataDrug.LCAcipro.XmeanSmooth,DataDrug.LCAcipro.Xstd);

plot(DataDrug.LCA.time(1:size(DataDrug.LCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.LCA.time(1:size(DataDrug.LCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),10,'k','filled');

%UDCA
plot(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.UDCA.time,DataDrug.UDCA.XmeanSmooth,DataDrug.UDCA.Xstd);

plot(DataDrug.UDCAcipro.time,DataDrug.UDCAcipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.UDCAcipro.time,DataDrug.UDCAcipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.UDCAcipro.time,DataDrug.UDCAcipro.XmeanSmooth,DataDrug.UDCAcipro.Xstd);

plot(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),10,'k','filled');

%CBG
plot(DataDrug.CBG.time,DataDrug.CBG.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.CBG.time,DataDrug.CBG.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CBG.time,DataDrug.CBG.XmeanSmooth,DataDrug.CBG.Xstd);

plot(DataDrug.CBGcipro.time,DataDrug.CBGcipro.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(DataDrug.CBGcipro.time,DataDrug.CBGcipro.XmeanSmooth,10,'k','filled');
errorbar(DataDrug.CBGcipro.time,DataDrug.CBGcipro.XmeanSmooth,DataDrug.CBGcipro.Xstd);

plot(DataDrug.CBG.time(1:size(DataDrug.CBG.Xfit,1)),DataDrug.CBG.Xfit(:,1),'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.CBG.time(1:size(DataDrug.CBG.Xfit,1)),DataDrug.CBG.Xfit(:,1),10,'k','filled');

xline(DataDrug.CBG.time(tdrug))

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

%% plot fit

figure
%m9
plot(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,'-','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.m9.time(1:size(DataDrug.m9.Xfit,1)),DataDrug.m9.Xfit,10,'k','filled');
text(DataDrug.m9.time(end),DataDrug.m9.Xfit(end),"m9",'Color','r');

%m9 drug
plot(DataDrug.m9cipro.time(1:size(DataDrug.m9cipro.Xfit,1)),DataDrug.m9cipro.Xfit,'--','LineWidth',2,'Color','r');
hold on
scatter(DataDrug.m9cipro.time(1:size(DataDrug.m9cipro.Xfit,1)),DataDrug.m9cipro.Xfit,10,'k','filled');
text(DataDrug.m9cipro.time(end),DataDrug.m9cipro.Xfit(end),"m9D",'Color','r');

%CA
plot(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),'-','LineWidth',2,'Color','g');
hold on
scatter(DataDrug.CA.time(1:size(DataDrug.CA.Xfit,1)),DataDrug.CA.Xfit(:,1),10,'k','filled');
text(DataDrug.CA.time(end),DataDrug.CA.Xfit(end),"CA",'Color','g');

%CA cipro
plot(DataDrug.CAcipro.time(1:size(DataDrug.CAcipro.Xfit,1)),DataDrug.CAcipro.Xfit(:,1),'--','LineWidth',2,'Color','g');
hold on
scatter(DataDrug.CAcipro.time(1:size(DataDrug.CAcipro.Xfit,1)),DataDrug.CAcipro.Xfit(:,1),10,'k','filled');
text(DataDrug.CAcipro.time(end),DataDrug.CAcipro.Xfit(end),"CAcipro",'Color','g');

%CDCA
plot(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),'-','LineWidth',2,'Color','b');
hold on
scatter(DataDrug.CDCA.time(1:size(DataDrug.CDCA.Xfit,1)),DataDrug.CDCA.Xfit(:,1),10,'k','filled');
text(DataDrug.CDCA.time(end),DataDrug.CDCA.Xfit(end),"CDCA",'Color','b');

%CDCA cipro
plot(DataDrug.CDCAcipro.time(1:size(DataDrug.CDCAcipro.Xfit,1)),DataDrug.CDCAcipro.Xfit(:,1),'--','LineWidth',2,'Color','b');
hold on
scatter(DataDrug.CDCAcipro.time(1:size(DataDrug.CDCAcipro.Xfit,1)),DataDrug.CDCAcipro.Xfit(:,1),10,'k','filled');
text(DataDrug.CDCAcipro.time(end),DataDrug.CDCAcipro.Xfit(end),"CDCAcipro",'Color','b');

%DCA
plot(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),'-','LineWidth',2,'Color','c');
hold on
scatter(DataDrug.DCA.time(1:size(DataDrug.DCA.Xfit,1)),DataDrug.DCA.Xfit(:,1),10,'k','filled');
text(DataDrug.DCA.time(end),DataDrug.DCA.Xfit(end),"DCA",'Color','c');

%DCA cipro
plot(DataDrug.DCAcipro.time(1:size(DataDrug.DCAcipro.Xfit,1)),DataDrug.DCAcipro.Xfit(:,1),'--','LineWidth',2,'Color','c');
hold on
scatter(DataDrug.DCAcipro.time(1:size(DataDrug.DCAcipro.Xfit,1)),DataDrug.DCAcipro.Xfit(:,1),10,'k','filled');
text(DataDrug.DCAcipro.time(end),DataDrug.DCAcipro.Xfit(end),"DCAcipro",'Color','c');

%LCA
plot(DataDrug.LCA.time(1:size(DataDrug.LCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),'-','LineWidth',2,'Color','m');
hold on
scatter(DataDrug.LCA.time(1:size(DataDrug.LCA.Xfit,1)),DataDrug.LCA.Xfit(:,1),10,'k','filled');
text(DataDrug.LCA.time(end),DataDrug.LCA.Xfit(end),"LCA",'Color','k');

%LCA cipro
plot(DataDrug.LCAcipro.time(1:size(DataDrug.LCAcipro.Xfit,1)),DataDrug.LCAcipro.Xfit(:,1),'--','LineWidth',2,'Color','m');
hold on
scatter(DataDrug.LCAcipro.time(1:size(DataDrug.LCAcipro.Xfit,1)),DataDrug.LCAcipro.Xfit(:,1),10,'k','filled');
text(DataDrug.LCAcipro.time(end),DataDrug.LCAcipro.Xfit(end),"LCAcipro",'Color','m');

%UDCA
plot(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),'-','LineWidth',2,'Color','y');
hold on
scatter(DataDrug.UDCA.time(1:size(DataDrug.UDCA.Xfit,1)),DataDrug.UDCA.Xfit(:,1),10,'k','filled');
text(DataDrug.UDCA.time(end),DataDrug.UDCA.Xfit(end),"UDCA",'Color','y');

%UDCA cipro
plot(DataDrug.UDCAcipro.time(1:size(DataDrug.UDCAcipro.Xfit,1)),DataDrug.UDCAcipro.Xfit(:,1),'--','LineWidth',2,'Color','y');
hold on
scatter(DataDrug.UDCAcipro.time(1:size(DataDrug.UDCAcipro.Xfit,1)),DataDrug.UDCAcipro.Xfit(:,1),10,'k','filled');
text(DataDrug.UDCAcipro.time(end),DataDrug.UDCAcipro.Xfit(end),"UDCAcipro",'Color','y');

%CBG
plot(DataDrug.CBG.time(1:size(DataDrug.CBG.Xfit,1)),DataDrug.CBG.Xfit(:,1),'-','LineWidth',2,'Color','k');
hold on
scatter(DataDrug.CBG.time(1:size(DataDrug.CBG.Xfit,1)),DataDrug.CBG.Xfit(:,1),10,'k','filled');
text(DataDrug.CBG.time(end),DataDrug.CBG.Xfit(end),"CBG",'Color','k');

%CBG
plot(DataDrug.CBGcipro.time(1:size(DataDrug.CBGcipro.Xfit,1)),DataDrug.CBGcipro.Xfit(:,1),'--','LineWidth',2,'Color','k');
hold on
scatter(DataDrug.CBGcipro.time(1:size(DataDrug.CBGcipro.Xfit,1)),DataDrug.CBGcipro.Xfit(:,1),10,'k','filled');
text(DataDrug.CBGcipro.time(end),DataDrug.CBGcipro.Xfit(end),"CBGcipro",'Color','k');

xline(DataDrug.CBG.time(tdrug))

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

%%q
Q = [parametersDrug.CA.q0,parametersDrug.CBG.q0,parametersDrug.CDCA.q0,parametersDrug.DCA.q0,parametersDrug.LCA.q0,parametersDrug.m9.q0,parametersDrug.UDCA.q0];
%mu
M = [parametersDrug.CA.mu0,parametersDrug.CBG.mu0,parametersDrug.CDCA.mu0,parametersDrug.DCA.mu0,parametersDrug.LCA.mu0,parametersDrug.m9.mu0,parametersDrug.UDCA.mu0];

Qd = [parametersDrug.CAcipro.q0,parametersDrug.CBGcipro.q0,parametersDrug.CDCAcipro.q0,parametersDrug.DCAcipro.q0,parametersDrug.LCAcipro.q0,parametersDrug.m9cipro.q0,parametersDrug.UDCAcipro.q0];
Md = [parametersDrug.CAcipro.mu0,parametersDrug.CBGcipro.mu0,parametersDrug.CDCAcipro.mu0,parametersDrug.DCAcipro.mu0,parametersDrug.LCA.mu0,parametersDrug.m9cipro.mu0,parametersDrug.UDCAcipro.mu0];
%kd drug
Dd = [parametersDrug.CAcipro.d0,parametersDrug.CBGcipro.d0,parametersDrug.CDCAcipro.d0,parametersDrug.DCAcipro.d0,parametersDrug.LCAcipro.d0,parametersDrug.m9cipro.d0,parametersDrug.UDCAcipro.d0];

%%

figure
scatter(Q,Qd,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[Q,Qdrug]')
text(Q,Qd,["CA","CBG","CDCA","DCA","LCA","m9","UDCA"],'Color','k');

figure
scatter(M,Md,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[mu, muDrug]')
text(M,Md,["CA","CBG","CDCA","DCA","LCA","m9","UDCA"],'Color','k');

figure
scatter(Qd,Dd,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[Qdrug, kdDrug]')
text(Qd,Dd,["CA","CBG","CDCA","DCA","LCA","m9","UDCA"],'Color','k');

figure
scatter(M,Dd,50,'r','filled');
hold on
plot(xlim,ylim,'-b')
title('[mu, kdDrug]')
text(M,Dd,["CA","CBG","CDCA","DCA","LCA","m9","UDCA"],'Color','k');

end