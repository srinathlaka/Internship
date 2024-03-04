function [Data,parametersD] = ModelDrugSubpopX0(filename,d0,f0,q01,mu01,d01,Data0,parameters,parameters0)


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
parametersD = struct();
%initial guess
parametersD.d0 = d0;
parametersD.f0 = f0;
parametersD.q01 = q01;
parametersD.mu01 = mu01;
parametersD.d01 = d01;
parametersD.x0 = Xmean(1);

%define the model
blackboxmodel = @ModelBaranyiDrugSubpopX0;

% find the best fit

%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',200,'Display','off');
%initial guess
P0 = [parametersD.d0,parametersD.f0,parametersD.q01,parametersD.mu01,parametersD.d01,parametersD.x0];
%eventual boundaries
lb = [-inf,0,-inf,-inf,-inf,-inf];
ub = [inf,1,inf,inf,inf,inf];

%minimize chi square
[fittedParameters,fval] = fminsearchbnd(@(P) minimizeChiSquareDrugSubpop(P,blackboxmodel,time,parametersD,Data,parameters),P0,lb,ub,options);

%compute p value
p = 1 - chi2cdf(fval,size(fittedParameters,2));
fprintf('muDrug = %f , f = %f , q2 = %f , mu2 = %f, muDrug2 = %f , x0 = %f , residual chi2 = %f, p = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3),fittedParameters(4),fittedParameters(5),fittedParameters(6),fval,p)

% best fit
parametersD.d0 = fittedParameters(1);
parametersD.f0 = fittedParameters(2);
parametersD.q01 = fittedParameters(3);
parametersD.mu01 = fittedParameters(4);
parametersD.d01 = fittedParameters(5);
parametersD.x0 = fittedParameters(6);
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



end