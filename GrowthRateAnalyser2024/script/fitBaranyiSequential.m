function [Data,parameters] = fitBaranyiSequential(Data,mu0,x0,q0,d0,tin,tdrug,tfin)

%%absence of drug

%choose the data
Data.X = Data.XmeanSmooth(tin:tfin);
time = Data.time(tin:tfin);

%create structure of eventual parameters
parameters = struct();

%initial guess
parameters.mu0 = mu0;
parameters.x0 = x0;
parameters.q0 = q0;
parameters.d0 = d0;
parameters.tdrug = (Data.time(tdrug)).*ones(size(time,1),size(time,2));

%define the model
blackboxmodel = @ModelBaranyiSequential;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',200,'Display','off');
%initial guess
P0 = [parameters.mu0,parameters.x0,parameters.q0,parameters.d0];
%eventual boundaries
lb = [];
ub = [];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareSequential(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, q0 = %f, d0 = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fittedParameters(4),fval,p)

% best fit
parameters.mu0 = fittedParameters(1);
parameters.x0 = fittedParameters(2);
parameters.q0 = fittedParameters(3);
parameters.d0 = fittedParameters(4);
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