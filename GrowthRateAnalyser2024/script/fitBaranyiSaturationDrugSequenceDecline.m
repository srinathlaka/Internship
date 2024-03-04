function [Data,parameters] = fitBaranyiSaturationDrugSequenceDecline(Data,x0,k0,g,d0,tin,tdrug,tfin,parameters)

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
parameters.g = g;
parameters.d0 = d0;

%find time of death phase
%[~,i] = max(X);
%[~,i] = max(X(tdrug:round((tfin-tdrug)/2) ));
i = findTimeDeath(X,tdrug,tfin);
parameters.tdeath = time(i);

%define the model
blackboxmodel = @ModelBaranyiSaturationDrugSequenceDecline;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = [parameters.x0,parameters.k0,parameters.g,parameters.d0,parameters.tdeath];
%eventual boundaries
xBoundaries = X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
Kmin = min(X);
Kmax = max(X);
lb = [Xmin,Kmin,-inf,-inf,time(tdrug)];
ub = [Xmax,Kmax,inf,inf,time(tfin)];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareSaturationSDecline(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, q0 = %f, k0 = %f, g = %f, d0 = %f, Tdeath = %f, residual chi2 = %f, p = %f \n',parameters.mu0,fittedParameters(1),parameters.q0,fittedParameters(2),fittedParameters(3),fittedParameters(4),fittedParameters(5),fval,p)

% best fit
parameters.x0 = fittedParameters(1);
parameters.k0 = fittedParameters(2);
parameters.g = fittedParameters(3);
parameters.d0 = fittedParameters(4);
parameters.tdeath = fittedParameters(5);
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