function [Data,parameters] = fitFIcurve(Data,parameters)

%choose the Data
tin = Data.tin;
tfin = Data.tfin;
X = Data.rawconverted(:,2);
Data.X = X(tin:tfin);
time = Data.rawconverted(tin:tfin,1);

%initial guess
T1 = parameters.p(3);
T2 = parameters.p(5);

%find T2
if isnan(T2)
    [~,in] = max(X);
    T2 = in;
    if T2>tfin
        T2=tfin;
    end
else
    T2 = findTimeDeath(X,T2,tfin);
end
parameters.p(5) = time(round(T2));

%find T1
if isnan(T1)
    T1 = round(tin+(T2-tin)/2);
    if T1>T2
        T1=T2;
    end
    parameters.p(3) = (round(tin+(T2-tin)/2));
else
    parameters.p(3) = T1;
end
parameters.p(3) = time(round(T1));

%define the model
if parameters.model==1
    blackboxmodel = @FIlinear3;
elseif parameters.model==2
    blackboxmodel = @FIlinear2;
elseif parameters.model==3
    blackboxmodel = @FInonlin3;
end

% find the best fit
%options for fminsearchbnd
options = optimset('TolFun',1e-6,'TolX',1e-6,'MaxIter',500,'Display','off');
%initial guess
P0 = parameters.p;
%eventual boundaries
if parameters.model==1
    lb = [0,-inf,time(tin),-inf,time(T1),-inf];
    ub = [0,inf,time(T2),inf,time(tfin),inf];
    %model chi square
    modelChi = @(P) minimizeFIlinear3(P,blackboxmodel,time,parameters,Data);
elseif parameters.model==2
    lb = [0,-inf,time(tin),-inf];
    ub = [0,inf,time(T2),inf];
    %model chi square
    modelChi = @(P) minimizeFIlinear2(P,blackboxmodel,time,parameters,Data);
elseif parameters.model==3
    lb = [0,-inf,time(tin),-inf,time(T1),-inf,-inf];
    ub = [0,inf,time(T2),inf,time(tfin),inf,inf];
    %model chi square
    modelChi = @(P) minimizeFInonlinear3(P,blackboxmodel,time,parameters,Data);
end

%minimize chi square
[fittedparameters,~] = fminsearchbnd(modelChi,P0,lb,ub,options);

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
for k=1:length(fittedparameters)
    parameters.p(k)  = fittedparameters(k);
    parameters.s(k)  = fittedparametersStd(k);
end

%data fit
Xfit = blackboxmodel(time,parameters);
Data.Xfit= Xfit;

%compute p value
DOF = size(Data.X,1) - size(fittedparameters,2); %degree of freedom
chisq = sum( ((Xfit-X).^2)./Xfit );
p = chi2cdf(chisq,DOF);
%[h,p] = chi2gof(Data.X,'cdf',@(fval)chi2cdf(fval,size(Data.X,1) - size(fittedparameters,2))); %alternative

%compute confidence interval CI for new generated data
alpha = parameters.alpha; %1-alpha is the %CI
sigmaSq = sum(((Xfit-X).^2))/DOF;
SEy = SEciFI(U,time,blackboxmodel,fittedparameters,sigmaSq,parameters.model,parameters.confidenceprediction);
CI = tinv(1-alpha/2,DOF).*SEy;
Data.XfitStd= CI;

%export
parameters.pval = p;
parameters.residualDOF = sigmaSq;

%print
display(parameters.p)

%plot
figure
%plot(time,Data.X,'-','LineWidth',1,'Color','r');
scatter(time,Data.X,10,'r','filled');
hold on
%shadedErrorBar(time,Data.X,Data.Xstd(tin:tfin),'lineProps','r');
plot(time,Xfit,'-','LineWidth',2,'Color','g');
hold on
%scatter(time,Xfit,5,'g','filled');
shadedErrorBar(time,Xfit,CI,'lineProps','g');
xlabel('Indentation')
ylabel('Force')
set(gca,'FontSize',15)
grid on
box on
axis tight

%save
save(strcat(parameters.folderName,'/',parameters.savename,'_Data.mat'),'Data')
save(strcat(parameters.folderName,'/',parameters.savename,'_parameters.mat'),'parameters')



end


