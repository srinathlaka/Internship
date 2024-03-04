function [Data,parameters] = fitNoDrugLSD(Data,mu,x0,q,k,kdeath,tin,tswitch,tfin,parameters)

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%initial guess
parameters.mu = mu;
parameters.x0 = x0;
parameters.q0 = q;
parameters.k = k;
parameters.kdeath = kdeath;

%find time of death phase
if isempty(tswitch)
    [~,i] = max(X);
    tswitch = i;
else
    i = findTimeDeath(X,tswitch,tfin);
end
parameters.tdeath = time(i);

%define the model
blackboxmodel = @ModelLagSaturationDeath;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = [parameters.mu,parameters.x0,parameters.q0,parameters.k,parameters.kdeath,parameters.tdeath];
%eventual boundaries
xBoundaries = X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
Kmin = min(X);
Kmax = max(X);
lb = [-inf,Xmin,0,Kmin,-inf,time(tswitch)];
ub = [inf,Xmax,inf,Kmax,inf,time(tfin)];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareLSD(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, q0 = %f, k = %f, kdeath = %f, Tdeath = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fittedParameters(4),fittedParameters(5),fittedParameters(6),fval,p)

% best fit
parameters.mu = fittedParameters(1);
parameters.x0 = fittedParameters(2);
parameters.q0 = fittedParameters(3);
parameters.k = fittedParameters(4);
parameters.kdeath = fittedParameters(5);
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