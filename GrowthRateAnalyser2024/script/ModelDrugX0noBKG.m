function [Data,parametersD] = ModelDrugX0noBKG(Datain,d0,x0,parameters,initial,final)

time = Datain.time(initial:final);
Xmean = Datain.X(initial:final);
Xstd = Datain.Xstd(initial:final);

Data.time = time;
Data.X = Xmean;
Data.Xstd = Xstd;

%% fit to an analytic function

%create structure of eventual parameters
parametersD = struct();
%initial guess
parametersD.d0 = d0;
parametersD.x0 = x0;

%define the model
blackboxmodel = @ModelBaranyiDrugX0;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',200,'Display','off');
%initial guess
P0 = [parametersD.d0,parametersD.x0];
%eventual boundaries
lb = [];
ub = [];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareDrugX0(P,blackboxmodel,time,parametersD,Datain,parameters),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('muDrug = %f , x0Drug = %f , residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fval,p)

% best fit
parametersD.d0 = fittedParameters(1);
parametersD.x0 = fittedParameters(2);
Xbest = blackboxmodel(time,parametersD,parameters);

%plot
figure
plot(time,Xbest,'-','LineWidth',2,'Color','r');
hold on
scatter(time,Xmean,10,'k','filled');
xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
grid on
box on
axis tight

Data.Xbest = Xbest;

end