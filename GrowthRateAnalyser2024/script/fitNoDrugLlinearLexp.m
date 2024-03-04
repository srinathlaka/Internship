function [Data,parameters] = fitNoDrugLlinearLexp(Data,klag,mu,x0,tin,tfin,tlag,q0,parameters)

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%initial guess
parameters.mu = mu;
parameters.x0 = x0;
parameters.klag = klag;
parameters.q0 = q0;


%tlag
if isempty(tlag)
    tlag = round(tin+(tfin-tin)/2);
    parameters.tlag = time(tlag);
else
    parameters.tlag = time(tlag);
end


%define the model
blackboxmodel = @ModelLagLinearLagExp;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = [parameters.mu,parameters.x0,parameters.klag,parameters.tlag,parameters.q0];
%eventual boundaries
xBoundaries = (X(X>0));%X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
lb = [-inf,Xmin,-inf,time(tin),0];
ub = [inf,Xmax,inf,time(tfin),inf];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareLlinearLexp(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, klag = %f, tlag = %f, q0 = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fittedParameters(4),fittedParameters(5),fval,p)

% best fit
parameters.mu = fittedParameters(1);
parameters.x0 = fittedParameters(2);
parameters.klag = fittedParameters(3);
parameters.tlag = fittedParameters(4);
parameters.q0 = fittedParameters(5);
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