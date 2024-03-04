function [Data,parameters] = fitLLES(Data,tin,tfin,parameters0,i)

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%initial guess
param = struct();

%[1 klag,2 tlag,3 q0,4 mu0,5 tswitch,6 kswitch,7 tswitch2,8 q02,9 kswitch2,10 tdeath,11 kdeath,12 m, 13 x0,14 k]
param.mu = parameters0(4);
param.x0 = parameters0(13);
param.k = parameters0(14);
param.klag = parameters0(1);
param.tlag = parameters0(2);
param.q0 = parameters0(3);
tlag = param.tlag;

%tlag
if isnan(tlag)
    tlag = round(tin+(tfin-tin)/2);
    param.tlag = time(tlag);
else
    param.tlag = time(tlag);
end


%define the model
blackboxmodel = @ModelLagLinearLagSaturation;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = [param.mu,param.x0,param.k,param.klag,param.tlag,param.q0];
%eventual boundaries
xBoundaries = (X(X>0));%X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
Kmin = min(X);
Kmax = max(X);
lb = [-inf,Xmin,Kmin,-inf,time(tin),0];
ub = [inf,Xmax,Kmax,inf,time(tfin),inf];

%minimize chi square
[fittedparameters,fval] = fminsearchbnd(@(P) minimizeChiSquareLlinearLS(P,blackboxmodel,time,param,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedparameters,2));
fprintf('mu = %f, x0 = %f, k = %f, klag = %f, tlag = %f, q0 = %f, residual chi2 = %f, p = %f \n',fittedparameters(1),fittedparameters(2),fittedparameters(3),fittedparameters(4),fittedparameters(5),fittedparameters(6),fval,p)

% best fit
param.mu = fittedparameters(1);
param.x0 = fittedparameters(2);
param.k = fittedparameters(3);
param.klag = fittedparameters(4);
param.tlag = fittedparameters(5);
param.q0 = fittedparameters(6);
Xfit = blackboxmodel(time,param);
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

%% export
%[1 klag,2 tlag,3 q0,4 mu0,5 tswitch,6 kswitch,7 tswitch2,8 q02,9 kswitch2,10 tdeath,11 kdeath,12 m, 13 x0, 14 k]
parameters = struct();
parameters.p{i}(1) = param.klag;
parameters.p{i}(2) = param.tlag;
parameters.p{i}(3) = param.q0;
parameters.p{i}(4) = param.mu;
parameters.p{i}(5) = NaN;
parameters.p{i}(6) = NaN;
parameters.p{i}(7) = NaN;
parameters.p{i}(8) = NaN;
parameters.p{i}(9) = NaN;
parameters.p{i}(10) = NaN;
parameters.p{i}(11) = NaN;
parameters.p{i}(12) = NaN;
parameters.p{i}(13) = param.x0;
parameters.p{i}(14) = param.k;


end