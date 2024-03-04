function [Data,parameters] = fitBaranyiSaturationDecline(Data,mu0,x0,q0,k0,g,tin,tdrug,tfin,parameters)

%%absence of drug

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%create structure of eventual parameters
%parameters = struct();

%initial guess
parameters.mu0 = mu0;
parameters.x0 = x0;
parameters.q0 = q0;
parameters.k0 = k0;
parameters.g = g;

%find time of death phase
%[~,i] = max(X);
%[~,i] = max(X(tdrug:round((tfin-tdrug)/2) ));
i = findTimeDeath(X,tdrug,tfin);
parameters.tdeath = time(i);

%define the model
blackboxmodel = @ModelBaranyiSaturationDecline;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = [parameters.mu0,parameters.x0,parameters.q0,parameters.k0,parameters.g,parameters.tdeath];
%eventual boundaries
xBoundaries = X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
Kmin = min(X);
Kmax = max(X);
lb = [-inf,Xmin,0,Kmin,-inf,time(tdrug)];
ub = [inf,Xmax,inf,Kmax,inf,time(tfin)];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareSaturationDecline(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, q0 = %f, k0 = %f, g = %f, Tdeath = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fittedParameters(4),fittedParameters(5),fittedParameters(6),fval,p)

% best fit
parameters.mu0 = fittedParameters(1);
parameters.x0 = fittedParameters(2);
parameters.q0 = fittedParameters(3);
parameters.k0 = fittedParameters(4);
parameters.g = fittedParameters(5);
parameters.tdeath = fittedParameters(6);
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