function [Data,parameters] = fitNoDrugLexpSD3(Data,klag,mu,x0,k,kdeath,tin,tlag,tdeath,tswitch,tfin,kswitch,parameters)

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%initial guess
parameters.mu = mu;
parameters.x0 = x0;
parameters.klag = klag;
parameters.k = k;
parameters.kdeath = kdeath;
parameters.kswitch = kswitch;

%find time of death phase
if isempty(tdeath)
    [~,i] = max(X);
    tdeath = i;
else
    tdeath = findTimeDeath(X,tdeath,tfin);
end
parameters.tdeath = time(tdeath);

%tswitch
if isempty(tswitch)
    parameters.tswitch = time(round(tin+(tdeath-tin)/2));
    tswitch = round(tin+(tdeath-tin)/2);
else
    parameters.tswitch = time(tswitch);
end

%tlag
if isempty(tlag)
    tlag = round(tin+(tswitch-tin)/2);
    parameters.tlag = time(tlag);
else
    parameters.tlag = time(tlag);
end


%define the model
blackboxmodel = @ModelLagExpSaturationSwitchDeath;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = [parameters.mu,parameters.x0,parameters.k,parameters.kdeath,parameters.tdeath,parameters.tswitch,parameters.kswitch,parameters.klag,parameters.tlag];
%eventual boundaries
xBoundaries = (X(X>0));%X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
Kmin = min(X);
Kmax = max(X);
lb = [-inf,Xmin,Kmin,-inf,time(tdeath),time(tin),-inf,-inf,time(tin)];
ub = [inf,Xmax,Kmax,inf,time(tfin),time(tdeath),inf,inf,time(tswitch)];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareLexpSD3(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, k = %f, kdeath = %f, Tdeath = %f, Tswitch = %f, kswitch = %f, q0 = %f, tlag = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fittedParameters(4),fittedParameters(5),fittedParameters(6),fittedParameters(7),fittedParameters(8),fittedParameters(9),fval,p)

% best fit
parameters.mu = fittedParameters(1);
parameters.x0 = fittedParameters(2);
parameters.k = fittedParameters(3);
parameters.kdeath = fittedParameters(4);
parameters.tdeath = fittedParameters(5);
parameters.tswitch = fittedParameters(6);
parameters.kswitch = fittedParameters(7);
parameters.klag = fittedParameters(8);
parameters.tlag = fittedParameters(9);
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