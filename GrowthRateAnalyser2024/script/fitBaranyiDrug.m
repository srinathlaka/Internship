function [Data,parameters] = fitBaranyiDrug(Data,d0,tdrug,tfin,parameters)

%with drugs
X = Data.XmeanSmooth;
Data.X = X(tdrug+1:tfin);
time = Data.time(tdrug+1:tfin)-Data.time(tdrug+1);

%create structure of eventual parameters
parametersD = struct();
%initial guess
parametersD.d0 = d0;

%initial value
parametersD.x0 = Data.Xfit(tdrug);

%define the model
blackboxmodel = @ModelDrug2;
%blackboxmodel = @ModelBaranyiDrugX0;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',200,'Display','off');
%initial guess
P0 = [parametersD.d0];
%eventual boundaries
lb = [];
ub = [];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareDrug(P,blackboxmodel,time,parametersD,Data,parameters),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('muDrug = %f , residual chi2 = %f, p = %f \n',fittedParameters(1),fval,p)

% best fit
parametersD.d0 = fittedParameters(1);
Xfit = blackboxmodel(time,parametersD,parameters);


Data.Xfit(tdrug+1:tfin) = Xfit;
parameters.d0 = parametersD.d0;

%plot
figure
plot(time,Data.X,'-','LineWidth',2,'Color','r');
hold on
scatter(time,Data.X,10,'k','filled');
errorbar(time,Data.X,Data.Xstd(tdrug+1:tfin));

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