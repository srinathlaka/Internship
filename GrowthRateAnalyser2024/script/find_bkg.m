function [bkg] = find_bkg(bkg)

if size(bkg.filenames,1) > size(bkg.tin,1)
    for l=2:size(bkg.filenames,1)
        bkg.tin{l}=bkg.tin{1};
        bkg.tfin{l}=bkg.tfin{1};
    end
end

%loop over files
for i=1:size(bkg.filenames,1)
    T0 = xlsread(bkg.filenames{i});

    %tin
    if isempty(bkg.tin{i})
        bkg.tin{i} = 1;
    end

    %tfin
    if isempty(bkg.tfin{i})
        bkg.tfin{i} = size(T0,1);
    end

    %time
    bkg.time{i} = T0(bkg.tin{i}:bkg.tfin{i},1);
    bkg.tinOld{i} = bkg.tin{i};

    %raw data
    if bkg.tin{i}>1
        bkg.time{i} = bkg.time{i}-bkg.time{i}(1);
    end
    bkg.raw{i} = T0(bkg.tin{i}:bkg.tfin{i},bkg.wells{i}+1); %+1 because the first column is the time column
end

%find minimal tfin
tfinF = min(cellfun(@numel, bkg.time));

for i=1:size(bkg.filenames,1)
    bkg.time{i} = bkg.time{i}(1:tfinF);
    bkg.raw{i} = bkg.raw{i}(1:tfinF,:);
    %bkg.tinOld{i}=bkg.tin{i};
    bkg.tin{i}=1;
    bkg.tfin{i}=tfinF;
end

%reshape vector
%val_count = sum(cellfun(@numel, bkg.wells));
% bkgR = [];%zeros(size(bkg.time{1},1),val_count);
% for i=1:size(bkg.raw,1)
%     bkgR = [bkgR,bkg.raw{i}];
% end

bkgR = cell2mat(bkg.raw);

%convert time
if bkg.minut ==1
    convert = 1/60;
elseif bkg.minut==2
    convert = 1/3600;
else
    convert = 1;
end

%plot
figure
hold on
for i=1:size(bkgR,2)
    scatter(convert.*(bkg.time{1}),bkgR(:,i),20,'filled');
end
set(gca,'YScale','log');
if bkg.minut==1
    xlabel('Time [min]')
elseif bkg.minut==2
    xlabel('Time [hours]')
else
    xlabel('Time [sec]')
end
ylabel('OD')
title('Raw background')
grid on
box on
axis tight

%
% nexp = 3;
% vectorcolor = distinguishable_colors(nexp);
%
% figure
% hold on
% for i=1:size(bkgR,2)
%     scatter(bkg.time{1},bkgR(:,i),20,vectorcolor(fix((i-1)/4)+1,:),'filled');
% end
% set(gca,'YScale','log');
% xlabel('Time')
% ylabel('OD')
% grid on
% box on
% axis tight

%mean and std
if size(bkgR,2)>1
    %[bkg.mean,bkg.std] = MeanAndPlot(bkg.time{1},bkgR);
    [bkg.mean,bkg.std] = MeanAndPlotConvert(bkg.time{1},bkgR,bkg.minut);
else
    bkg.mean = bkg.raw{1};
    bkg.std = [];

    %convert time
if bkg.minut ==1
    convert = 1/60;
elseif bkg.minut==2
    convert = 1/3600;
else
    convert = 1;
end

    %plot
    figure
    scatter(convert.*(bkg.time{1}),bkg.mean,20,'filled');
    set(gca,'YScale','log');
    if bkg.minut==1
        xlabel('Time [min]')
    elseif bkg.minut==2
        xlabel('Time [hours]')
    else
        xlabel('Time [sec]')
    end
    ylabel('OD')
    title('Mean background')
    grid on
    box on
    axis tight

end

%fit
if isempty(bkg.b0)
    bkg.b0 = bkg.mean(1);
end

parameters0 = struct();
parameters0.a0 = bkg.a0;
parameters0.b0 = bkg.b0;
parameters0.k0 = bkg.k0;
parameters0.n = bkg.n;

parameters0.Chistd = 1;

Data0 = struct();
Data0.X = bkg.mean;
Data0.Xstd = bkg.std;

if ~isempty(bkg.k0)

    if bkg.k0>0

        blackboxmodel = @ModelK2; %non polynomial
        P00 = [bkg.a0,bkg.k0,bkg.b0];

        options = optimset('MaxIter',100);
        lb = [];
        ub = [];

        %model chi square
        modelChi = @(P) minimizeChiSquareBkg1(P,blackboxmodel,bkg.time{1},parameters0,Data0);

        %minimize chi square
        %[fittedParameters0,~] = fminsearchbnd(@(P) minimizeChiSquareBkg1(P,blackboxmodel0,bkg.time{1},parameters0,Data0),P00,lb,ub,options);
        [fittedParameters,fval] = fminsearchbnd(modelChi,P00,lb,ub,options);

        %compute std of fitted parameters
        f = modelChi;
        P0 = fittedParameters;
        H = chessian(f,P0);
        U = H./2;
        S = abs(inv(U));
        fittedparametersStd = zeros(size(fittedParameters,1),size(fittedParameters,2));
        for l=1:size(fittedParameters,2)
            fittedparametersStd(l) = sqrt(S(l,l));
        end

        fprintf('a = %f, k = %f, b = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3));
        fprintf('a_std = %f, k_std = %f, b_std = %f \n',fittedparametersStd(1),fittedparametersStd(2),fittedparametersStd(3));

        bkg.a0 = fittedParameters(1);
        bkg.k0 = fittedParameters(2);
        bkg.b0 = fittedParameters(3);
        %         parameters0.a0 = fittedParameters(1);
        %         parameters0.k0 = fittedParameters(2);
        %         parameters0.b0 = fittedParameters(3);
        bkg.fit = blackboxmodel(bkg.time{1},bkg);

        bkg.a0std = fittedparametersStd(1);
        bkg.k0std = fittedparametersStd(2);
        bkg.b0std = fittedparametersStd(3);

        %compute confidence interval CI for new generated data
        alpha = 0.32; %1-alpha is the %CI
        DOF = size(bkg.mean,1) - size(fittedParameters,2); %degree of freedom
        sigmaSq = sum(((bkg.fit-bkg.mean).^2))/DOF;
        SEy = SEbkg(U,bkg.time{1},blackboxmodel,fittedParameters,sigmaSq,1);
        CI = tinv(1-alpha/2,DOF).*SEy;
        bkg.fitStd= CI;

    else
        bkg.k0 = -bkg.k0;

        blackboxmodel = @ModelK3; %non polynomial
        P00 = [bkg.a0,bkg.k0,bkg.b0];

        options = [];
        lb = [];
        ub = [];

        %model chi square
        modelChi = @(P) minimizeChiSquareBkg1(P,blackboxmodel,bkg.time{1},parameters0,Data0);

        %minimize chi square
        %[fittedParameters,~] = fminsearchbnd(@(P) minimizeChiSquareBkg1(P,blackboxmodel,bkg.time{1},parameters0,Data0),P00,lb,ub,options);
        [fittedParameters,fval] = fminsearchbnd(modelChi,P00,lb,ub,options);

        %compute std of fitted parameters
        f = modelChi;
        P0 = fittedParameters;
        H = chessian(f,P0);
        U = H./2;
        S = abs(inv(U));
        fittedparametersStd = zeros(size(fittedParameters,1),size(fittedParameters,2));
        for l=1:size(fittedParameters,2)
            fittedparametersStd(l) = sqrt(S(l,l));
        end

        fprintf('a = %f, k = %f, b = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3));
        fprintf('a_std = %f, k_std = %f, b_std = %f \n',fittedparametersStd(1),fittedparametersStd(2),fittedparametersStd(3));

        bkg.a0 = fittedParameters(1);
        bkg.k0 = fittedParameters(2);
        bkg.b0 = fittedParameters(3);
        %         parameters0.a0 = fittedParameters(1);
        %         parameters0.k0 = fittedParameters(2);
        %         parameters0.b0 = fittedParameters(3);
        bkg.fit = blackboxmodel(bkg.time{1},bkg);

        bkg.a0std = fittedparametersStd(1);
        bkg.k0std = fittedparametersStd(2);
        bkg.b0std = fittedparametersStd(3);

        %compute confidence interval CI for new generated data
        alpha = 0.32; %1-alpha is the %CI
        DOF = size(bkg.mean,1) - size(fittedParameters,2); %degree of freedom
        sigmaSq = sum(((bkg.fit-bkg.mean).^2))/DOF;
        SEy = SEbkg(U,bkg.time{1},blackboxmodel,fittedParameters,sigmaSq,2);
        CI = tinv(1-alpha/2,DOF).*SEy;
        bkg.fitStd= CI;

    end
else

    blackboxmodel = @ModelN;
    P00 = [bkg.a0,bkg.n,bkg.b0];

    options = [];
    lb = [];
    ub = [];

    %model chi square
    modelChi = @(P) minimizeChiSquareBkg2(P,blackboxmodel,bkg.time{1},parameters0,Data0);

    %minimize chi square
    %[fittedParameters,~] = fminsearchbnd(@(P) minimizeChiSquareBkg2(P,blackboxmodel,bkg.time{1},parameters0,Data0),P00,lb,ub,options);
    [fittedParameters,fval] = fminsearchbnd(modelChi,P00,lb,ub,options);

    %compute std of fitted parameters
    f = modelChi;
    P0 = fittedParameters;
    H = chessian(f,P0);
    U = H./2;
    S = abs(inv(U));
    fittedparametersStd = zeros(size(fittedParameters,1),size(fittedParameters,2));
    for l=1:size(fittedParameters,2)
        fittedparametersStd(l) = sqrt(S(l,l));
    end

    fprintf('a = %f, n = %f, b = %f \n',fittedParameters(1),fittedParameters(2),fittedParameters(3));
    fprintf('a_std = %f, k_std = %f, b_std = %f \n',fittedparametersStd(1),fittedparametersStd(2),fittedparametersStd(3));

    bkg.a0 = fittedParameters(1);
    bkg.n = fittedParameters(2);
    bkg.b0 = fittedParameters(3);
    %     parameters0.a0 = fittedParameters(1);
    %     parameters0.n = fittedParameters(2);
    %     parameters0.b0 = fittedParameters(3);
    bkg.fit = blackboxmodel(bkg.time{1},bkg);

    bkg.a0std = fittedparametersStd(1);
    bkg.k0std = fittedparametersStd(2);
    bkg.b0std = fittedparametersStd(3);

    %compute confidence interval CI for new generated data
    alpha = 0.32; %1-alpha is the %CI
    DOF = size(bkg.mean,1) - size(fittedParameters,2); %degree of freedom
    sigmaSq = sum(((bkg.fit-bkg.mean).^2))/DOF;
    SEy = SEbkg(U,bkg.time{1},blackboxmodel,fittedParameters,sigmaSq,3);
    CI = tinv(1-alpha/2,DOF).*SEy;
    bkg.fitStd= CI;

end

%convert time
if bkg.minut ==1
    convert = 1/60;
elseif bkg.minut ==2
    convert = 1/3600;
else
    convert = 1;
end

%close all

%plot
figure
plot((bkg.time{1}).*convert,bkg.fit,'-','LineWidth',1,'Color','r');
hold on
if ~isempty(bkg.std)
    shadedErrorBar((bkg.time{1}).*convert,bkg.mean,bkg.std,'lineProps','k');
    shadedErrorBar((bkg.time{1}).*convert,bkg.fit,bkg.fitStd,'lineProps','r');
end
scatter((bkg.time{1}).*convert,bkg.mean,5,'k','filled');
if bkg.minut==1
    xlabel('Time [min]')
elseif bkg.minut==2
    xlabel('Time [hours]')
else
    xlabel('Time [sec]')
end
ylabel('OD')
title('Best fit')
set(gca,'FontSize',15)
grid on
box on
axis tight

end