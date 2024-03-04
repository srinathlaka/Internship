function [Data,parameters] = ModelNoDrug(filename,mu0,x0,q0,Data0,parameters0)

%import excel file data
%filename = 'data\rif0.xlsx';
T = xlsread(filename);
time = T(:,1);
X = T(:,2:end);

%compute beaseline
X0mean = Model0(time,parameters0);
Data0.X = X0mean;
X0mean = Data0.X;

%mean and std
if size(X,2)>1
    [Xmean,Xstd] = MeanAndPlot(time,X);
else
    Xmean=X;
    Xstd = [];
end

%%
%plot
figure
scatter(time,Xmean,10,'k','filled');
hold on
scatter(time,X0mean,10,'r','filled');
scatter(time,Xmean-X0mean,10,'g','filled');
xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',20)
%set(gca,'YScale','log');
grid on
box on
axis tight

%subtract empty wells from data
Xmean = Xmean-X0mean;

%%
%remove negative data
Xmean(Xmean<0)=0;

%import and store data
Data = struct();
Data.time = time;
Data.X = Xmean;
Data.Xstd = Xstd;

%% fit to an analytic function

% mu0 = 0.0039;
% x0 = 0.0086;
% q0 = 0.0019;

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