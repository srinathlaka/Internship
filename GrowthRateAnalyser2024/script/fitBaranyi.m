function [Data,parameters] = fitBaranyi(Data,mu0,x0,q0,tin,tdrug,parameters)

%%absence of drug

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tdrug);
time = Data.time(tin:tdrug);

%create structure of eventual parameters
%parameters = struct();

%initial guess
parameters.mu0 = mu0;
parameters.x0 = x0;
parameters.q0 = q0;

%define the model
blackboxmodel = @ModelBaranyi;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',200,'Display','off');
%initial guess
P0 = [parameters.mu0,parameters.x0,parameters.q0];
%eventual boundaries
lb = [];
ub = [];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquare(P,blackboxmodel,time,parameters,Data),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, x0 = %f, q0 = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fval,p)

% best fit
parameters.mu0 = fittedParameters(1);
parameters.x0 = fittedParameters(2);
parameters.q0 = fittedParameters(3);
Xfit = blackboxmodel(time,parameters);
Data.Xfit= Xfit;

%plot
figure
plot(time,Data.X,'-','LineWidth',2,'Color','r');
hold on
scatter(time,Data.X,10,'k','filled');
errorbar(time,Data.X,Data.Xstd(tin:tdrug));

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