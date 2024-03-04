function [Data,parameters] = fitBaranyiSaturationDrugSequence(Data,x0,k0,d0,tin,tfin,parameters)

%%absence of drug

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%create structure of eventual parameters
%parameters = struct();

%initial guess
parameters.x0 = x0;
parameters.k0 = k0;
parameters.d0 = d0;

%define the model
blackboxmodel = @ModelBaranyiSaturationDrugSequence;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',200,'Display','off');
%initial guess
P0 = [parameters.x0,parameters.k0,parameters.d0];
%eventual boundaries
xBoundaries = X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
lb = [Xmin,0,-inf];
ub = [Xmax,inf,inf];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareSaturationDrugSequence(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, q0 = %f, k0 = %f, d0 = %f, residual chi2 = %f, p = %f \n',parameters.mu0,fittedParameters(1),parameters.q0,fittedParameters(2),fittedParameters(3),fval,p)

% best fit
parameters.x0 = fittedParameters(1);
parameters.k0 = fittedParameters(2);
parameters.d0 = fittedParameters(3);
Xfit = blackboxmodel(time,parameters);
Data.Xfit= Xfit;

%plot
figure
plot(time,Data.X,'-','LineWidth',2,'Color','r');
hold on
scatter(time,Data.X,10,'k','filled');
errorbar(time,Data.X,Data.Xstd(tin:tfin));

plot(time,Xfit,'-','LineWidth',2,'Color','r');
hold on
scatter(time,Xfit,10,'k','filled');

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight



end