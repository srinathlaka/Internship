function [Data,parameters] = fitLLLES(Data,tin,tfin,parameters0,i,parameters)

%choose the data
X = Data.XmeanSmooth;
Data.X = X(tin:tfin);
time = Data.time(tin:tfin);

%initial guess
param = struct();

m=parameters.m;
param.Chistd = parameters.Chistd;
confidenceprediction = parameters.confidenceprediction;

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
    if tlag>tfin
        tlag=tfin;
    end
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

%model chi square
modelChi = @(P) minimizeChiSquareLlinearLS(P,blackboxmodel,time,param,Data);

%minimize chi square
%[fittedparameters,fval] = fminsearchbnd(@(P) minimizeChiSquareLlinearLS(P,blackboxmodel,time,param,Data),P0,lb,ub,options);
[fittedparameters,fval] = fminsearchbnd(modelChi,P0,lb,ub,options);

%compute std of fitted parameters
f = modelChi;
P0 = fittedparameters;
H = chessian(f,P0);
U = H./2;
if isempty(parameters.nbootstrap) 
    S = abs(inv(U));
    fittedparametersStd = zeros(size(fittedparameters,1),size(fittedparameters,2));
    for l=1:size(fittedparameters,2)
        fittedparametersStd(l) = sqrt(S(l,l));
    end
end

% best fit
param.mu = fittedparameters(1);
param.x0 = fittedparameters(2);
param.k = fittedparameters(3);
param.klag = fittedparameters(4);
param.tlag = fittedparameters(5);
param.q0 = fittedparameters(6);
Xfit = blackboxmodel(time,param);
Data.Xfit= Xfit;

%bootsrap
if ~isempty(parameters.nbootstrap)
    %mean, std and ci of paramters (not data!) via bootstrapping
    resid = Xfit-X;
    bs = bootstrp(parameters.nbootstrap,@(bootr)bootF(param,Data,bootr,blackboxmodel,time,P0,lb,ub,options,m),resid);
    %[ci,bs] = bootci(parameters.nbootstrap,{@(bootr)boot1(param,Data,bootr,blackboxmodel,time,P0,lb,ub,options),resid},'Type','norm'); %if ci needed
    se = std(bs); %std error of fitted parameters

    for l=1:size(fittedparameters,2)
        fittedparametersStd(l) = se(l);
    end

    %if ci of parameters needed
    %normal std
    %Data.XfitStd= abs(ci(1,:)-ci(2,:))./2;
    %avg = mean(bs); %recompute best fit, not necessary

end

%compute p value
DOF = size(Data.X,1) - size(fittedparameters,2); %degree of freedom
chisq = sum( ((Xfit-X).^2)./Xfit );
p = chi2cdf(chisq,DOF);
%[h,p] = chi2gof(Data.X,'cdf',@(fval)chi2cdf(fval,size(Data.X,1) - size(fittedparameters,2))); %alternative

%compute confidence interval CI for new generated data
alpha = parameters.alpha; %1-alpha is the %CI
sigmaSq = sum(((Xfit-X).^2))/DOF;
SEy = SEci(U,time,blackboxmodel,fittedparameters,sigmaSq,m,confidenceprediction);
CI = tinv(1-alpha/2,DOF).*SEy;
Data.XfitStd= CI;

fprintf('mu = %f, x0 = %f, k = %f, klag = %f, tlag = %f, q0 = %f, residual chi2/DOF = %f, p = %f \n',fittedparameters(1),fittedparameters(2),fittedparameters(3),fittedparameters(4),fittedparameters(5),fittedparameters(6),SigmaSq,p)

%plot
figure
plot(time,Data.X,'-','LineWidth',1,'Color','r');
hold on
scatter(time,Data.X,5,'r','filled');
shadedErrorBar(time,Data.X,Data.Xstd(tin:tfin),'lineProps','r');

plot(time,Xfit,'-','LineWidth',1.5,'Color','g');
hold on
%scatter(time,Xfit,5,'g','filled');
shadedErrorBar(time,Xfit,CI,'lineProps','g');

xlabel('Time [min]')
ylabel('OD')
set(gca,'FontSize',15)
grid on
box on
axis tight

%% export
%[1 klag,2 tlag,3 q0,4 mu0,5 tswitch,6 kswitch,7 tswitch2,8 q02,9 kswitch2,10 tdeath,11 kdeath,12 m, 13 x0, 14 k]
%parameters = struct();
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

%std
parameters.s{i}(1) = fittedparametersStd(4);
parameters.s{i}(2) = fittedparametersStd(5);
parameters.s{i}(3) = fittedparametersStd(6);
parameters.s{i}(4) = fittedparametersStd(1);
parameters.s{i}(5) = NaN;
parameters.s{i}(6) = NaN;
parameters.s{i}(7) = NaN;
parameters.s{i}(8) = NaN;
parameters.s{i}(9) = NaN;
parameters.s{i}(10) = NaN;
parameters.s{i}(11) = NaN;
parameters.s{i}(12) = NaN;
parameters.s{i}(13) = fittedparametersStd(2);
parameters.s{i}(14) = fittedparametersStd(3);

parameters.pval{i}(1) = p;
parameters.residualDOF{i}(1) = sigmaSq;


end