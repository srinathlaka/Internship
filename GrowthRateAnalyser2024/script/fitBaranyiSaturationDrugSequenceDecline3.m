function [Data,parameters] = fitBaranyiSaturationDrugSequenceDecline3(Data,x0,d0,tin,tdrug,tfin,parameters)

%%absence of drug

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%create structure of eventual parameters
%parameters = struct();

%initial guess
parameters.x0 = x0;
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
P0 = [parameters.x0,parameters.d0,parameters.tdeath];
%eventual boundaries
xBoundaries = X(1:10);
Xmin = min(xBoundaries);
Xmax = max(xBoundaries);
lb = [Xmin,-inf,time(tdrug)];
ub = [Xmax,inf,time(tfin)];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareSaturationSDecline3(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('x0 = %f, d0 = %f, Tdeath = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fval,p)

% best fit
parameters.x0 = fittedParameters(1);
parameters.d0 = fittedParameters(2);
parameters.tdeath = fittedParameters(3);
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