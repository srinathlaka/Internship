function [Datamedium,Datadrug,parametersmedium,parametersdrug] = fitDataGrowthAllDrug(WellsPlate,filename,Databkg,parametersmedium,mu0,q0,k0,d0,tin,tdrug,tfin)

minut = 1;
smoothstrength = 15;

%medium
[Datamedium] = SubstractBkg(filename,Databkg.Xmean,WellsPlate,smoothstrength,minut);

% medium + antibio
[Datadrug] = SubstractBkg(filename,Databkg.Xmean,WellsPlate+6,smoothstrength,minut);

% plot
figure
plot(Datamedium.time,Datamedium.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(Datamedium.time,Datamedium.XmeanSmooth,10,'k','filled');
errorbar(Datamedium.time,Datamedium.XmeanSmooth,Datamedium.Xstd);

plot(Datadrug.time,Datadrug.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(Datadrug.time,Datadrug.XmeanSmooth,10,'k','filled');
errorbar(Datadrug.time,Datadrug.XmeanSmooth,Datamedium.Xstd);

xline(Datamedium.time(tdrug))

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

%% fit

%to fit
x0 = Datamedium.XmeanSmooth(1);
parametersmedium.tdrug = Datamedium.time(tdrug);

[Datamedium,parametersmedium] = fitBaranyiSaturation(Datamedium,mu0,x0,q0,k0,tin,tfin,parametersmedium);
%[Datamedium,parametersmedium] = fitBaranyiSaturationDrug(Datamedium,mu0,x0,q0,k0,d0,tin,tfin,parametersmedium);
[Datadrug,parametersdrug] = fitBaranyiSaturationDrug(Datadrug,mu0,x0,q0,k0,d0,tin,tfin,parametersmedium);


%given
% parametersmedium.ec0 = 0.36; %mug/mL
% parametersmedium.n0 = 2;
% parametersmedium.di0 = 1;
% parametersmedium.em0 = 1; %min-1
%[Datamedium,parametersmedium] = fitBaranyi(Datamedium,mu0,x0,q0,tin,tdrug,parametersmedium);
%[Datadrug,parameters061_Cipro.m9cipro] = fitBaranyiDrug(Datadrug,d0,tdrug,tfin,parameters061_Cipro.m9cipro);
%%[Data061_Cipro,parameters061_Cipro] = fitBaranyiDrugDeg(Data061_Cipro,d0,tdrug,tfin,parameters061_Cipro);
%%[Data061_Cipro,parameters061_Cipro] = fitBaranyiSequential(Data061_Cipro,mu0,x0,q0,d0,tin,tdrug,tfin);
%%[Data061_Cipro,parameters061_Cipro] = fitBaranyiDrugDegradationAll(Data061_Cipro,mu0,x0,q0,d0,ec0,n0,di0,em0,tin,tdrug,tfin);
%[Datamedium,parametersmedium] = fitExponential(Datamedium,mu0,x0,tin,tdrug,parametersmedium);

%%plot
figure
plot(Datamedium.time,Datamedium.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(Datamedium.time,Datamedium.XmeanSmooth,10,'k','filled');
errorbar(Datamedium.time,Datamedium.XmeanSmooth,Datamedium.Xstd);

plot(Datamedium.time(1:size(Datamedium.Xfit,1)),Datamedium.Xfit,'-','LineWidth',2,'Color','r');
hold on
scatter(Datamedium.time(1:size(Datamedium.Xfit,1)),Datamedium.Xfit,10,'k','filled');

plot(Datadrug.time,Datadrug.XmeanSmooth,'-','LineWidth',2);
hold on
scatter(Datadrug.time,Datadrug.XmeanSmooth,10,'k','filled');
errorbar(Datadrug.time,Datadrug.XmeanSmooth,Datadrug.Xstd);

plot(Datadrug.time(1:size(Datadrug.Xfit,1)),Datadrug.Xfit,'-','LineWidth',2,'Color','b');
hold on
scatter(Datadrug.time(1:size(Datadrug.Xfit,1)),Datadrug.Xfit,10,'k','filled');

xline(Datadrug.time(tdrug))

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

pause(2)
close all

end