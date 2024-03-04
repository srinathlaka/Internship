function [Data,parameters] = ModelNoDrugnoBKG(Datain,mu0,x0,q0,initial,final,factor)

time = Datain.time(initial:final);
Xmean = factor.*(Datain.X(initial:final));
if ~isempty(Datain.Xstd)
    Xstd = Datain.Xstd(initial:final);
else
    Xstd = [];
end

Data.time = time;
Data.X = Xmean;
Data.Xstd = Xstd;

%% fit to an analytic function

%create structure of eventual parameters
parameters = struct();
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
Xbest = blackboxmodel(time,parameters);

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