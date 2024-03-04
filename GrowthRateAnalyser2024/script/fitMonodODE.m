function [Data,parameters] = fitMonodODE(Data,mu0,k0,y0,tin,tdrug,parameters)

%%absence of drug

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tdrug);
time = Data.time(tin:tdrug);

%create structure of eventual parameters
%parameters = struct();

%initial guess
parameters.mu0 = mu0;
parameters.k0 = k0;
parameters.y0 = y0;

%define the model
blackboxmodel = @ModelMonodODE;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',50,'Display','off');
%initial guess
P0 = [parameters.mu0,parameters.k0,parameters.y0];
%eventual boundaries
lb = [];
ub = [];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareMonodODE(P,blackboxmodel,time,Data,parameters),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('mu = %f, k0 = %f, y0 = %f, residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fval,p)

% best fit
parameters.mu0 = fittedParameters(1);
parameters.k0 = fittedParameters(2);
parameters.y0 = fittedParameters(3);

%Xfit = blackboxmodel(time,parameters);
s0 = parameters.x0;
odeOptions = odeset('RelTol',1e-6,'NonNegative',[1:size((s0),2)]);
[~, Xfit] = ode45(@(t, x) blackboxmodel(t,x,parameters),time,s0,odeOptions);

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